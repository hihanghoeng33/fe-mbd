<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { authService } from '../services/authService.js';
import { projectService } from '../services/projectService.js';
import Hero from './Hero.vue';
import ProjectCardMain from './ProjectCardMain.vue';

const scrollContainer = ref(null);
const projects = ref([]);
const loading = ref(false);
const errorMessage = ref('');
const userName = ref('');

function handleWheelScroll(e) {
  if (e.deltaY !== 0) {
    e.preventDefault();
    scrollContainer.value.scrollLeft += e.deltaY;
  }
}

onMounted(async () => {
  const el = scrollContainer.value;
  el.addEventListener('wheel', handleWheelScroll, { passive: false });
  
  // Load user data
  await loadUserData();
  
  // Load recommended projects
  await loadRecommendedProjects();
});

onBeforeUnmount(() => {
  scrollContainer.value?.removeEventListener('wheel', handleWheelScroll);
});

const loadUserData = async () => {
  try {
    const user = authService.getCurrentUser();
    if (user) {
      userName.value = user.name || 'Mahasiswa';
    } else if (authService.isAuthenticated()) {
      const userData = await authService.getCurrentUserProfile();
      userName.value = userData.name || 'Mahasiswa';
    }
  } catch (error) {
    console.error('Error loading user data:', error);
    userName.value = 'Mahasiswa';
  }
};

const loadRecommendedProjects = async () => {
  loading.value = true;
  errorMessage.value = '';
  
  try {
    console.log('Loading recommended projects...');
    
    // Try the improved method first, fallback to advanced method if needed
    let recommendedProjects = await projectService.getRecommendedProjects(6);
    
    // If no projects found with regular method, try advanced method
    if (recommendedProjects.length === 0) {
      console.log('No projects found with regular method, trying advanced method...');
      recommendedProjects = await projectService.getRecommendedProjectsAdvanced(6);
    }
    
    // Transform the data to match our component props
    projects.value = recommendedProjects.map(project => 
      projectService.transformProjectData(project)
    );
    
    console.log('Loaded projects:', projects.value);
    
    // Show info message if using completed projects
    if (recommendedProjects.length > 0 && recommendedProjects.every(p => p.status === 'COMPLETED')) {
      errorMessage.value = 'Menampilkan proyek yang sudah selesai karena tidak ada proyek aktif tersedia';
    }
    
  } catch (error) {
    console.error('Error loading recommended projects:', error);
    errorMessage.value = 'Failed to load recommended projects';
    
    // Fallback to mock data if API fails
    projects.value = [
      {
        title: "Sistem Rekomendasi Film Berbasis AI",
        author: "Prof. Dr. Amritzal Jago Banget",
        filled: 4,
        total: 8,
        description: "Rekomendasi film personalisasi menggunakan AI.",
        categories: "AI"
      },
      {
        title: "Aplikasi Manajemen Acara Kampus",
        author: "Prof. Dr. Arya Jago Banget",
        filled: 6,
        total: 10,
        description: "Mempermudah pengelolaan dan pendaftaran acara di kampus.",
        categories: "Event Management"
      },
      {
        title: "Kampanye Lingkungan Hidup Berbasis Digital",
        author: "Prof.Dr.(Eng). Ir. Ironi",
        filled: 3,
        total: 4,
        description: "Mengelola acara kampanye lingkungan secara daring.",
        categories: "Sustainability"
      }
    ];
  } finally {
    loading.value = false;
  }
};

const refreshProjects = async () => {
  await loadRecommendedProjects();
};
</script>

<template>
  <div class="gap-8 mt-8">
    <!-- Hero Section -->
    <Hero :nama="userName" />

    <!-- Rekomendasi Proyek -->
    <div class="pt-8">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl be-vietnam-pro-semibold text-gray-800">Rekomendasi Proyek</h2>
        <button 
          @click="refreshProjects"
          :disabled="loading"
          class="flex items-center gap-2 px-3 py-1 text-sm text-blue-600 hover:text-blue-700 hover:bg-blue-50 rounded-md transition-colors disabled:opacity-50"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" :class="{ 'animate-spin': loading }">
            <path fill="currentColor" d="M12 20q-3.35 0-5.675-2.325T4 12t2.325-5.675T12 4q1.725 0 3.3.712T18 6.75V4h2v7h-7V9h4.2q-.8-1.4-2.187-2.2T12 6Q9.5 6 7.75 7.75T6 12t1.75 4.25T12 18q1.925 0 3.475-1.1T17.65 14h2.1q-.7 3.25-3.25 5.125T12 20"/>
          </svg>
          Muat Ulang
        </button>
      </div>
      
      <!-- Error/Info Message -->
      <div v-if="errorMessage" class="p-3 rounded-lg mb-4 text-sm" :class="errorMessage.includes('selesai') ? 'bg-yellow-50 border border-yellow-200 text-yellow-700' : 'bg-red-50 border border-red-200 text-red-700'">
        {{ errorMessage }}
      </div>
      
      <!-- Loading State -->
      <div v-if="loading" class="mb-4">
        <div class="flex gap-4 overflow-x-auto">
          <div v-for="i in 3" :key="i" class="bg-gray-200 rounded-lg w-96 h-64 animate-pulse flex-shrink-0"></div>
        </div>
      </div>
      
      <!-- Projects Container -->
      <div v-else ref="scrollContainer" class="overflow-x-auto relative scroll-smooth">
        <div class="flex gap-4 w-max pb-4">
          <ProjectCardMain
            v-for="(project, index) in projects"
            :key="project.project_id || index"
            :title="project.title"
            :author="project.author"
            :filled="project.filled"
            :total="project.total"
            :description="project.description"
            :categories="project.categories"
          />
          
          <!-- Show message if no projects -->
          <div v-if="projects.length === 0" class="w-96 bg-gray-100 rounded-lg p-6 flex items-center justify-center">
            <div class="text-center text-gray-500">
              <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" class="mx-auto mb-2 text-gray-400">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M7 13.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5"/>
              </svg>
              <p>Tidak ada proyek yang tersedia</p>
              <button @click="refreshProjects" class="mt-2 text-blue-600 hover:text-blue-700 text-sm">
                Coba lagi
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.be-vietnam-pro-thin {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 100;
  font-style: normal;
}

.be-vietnam-pro-extralight {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 200;
  font-style: normal;
}

.be-vietnam-pro-light {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 300;
  font-style: normal;
}

.be-vietnam-pro-regular {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 400;
  font-style: normal;
}

.be-vietnam-pro-medium {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 500;
  font-style: normal;
}

.be-vietnam-pro-semibold {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 600;
  font-style: normal;
}

.be-vietnam-pro-bold {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 700;
  font-style: normal;
}

.be-vietnam-pro-extrabold {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 800;
  font-style: normal;
}

.be-vietnam-pro-black {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 900;
  font-style: normal;
}

.be-vietnam-pro-thin-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 100;
  font-style: italic;
}

.be-vietnam-pro-extralight-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 200;
  font-style: italic;
}

.be-vietnam-pro-light-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 300;
  font-style: italic;
}

.be-vietnam-pro-regular-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 400;
  font-style: italic;
}

.be-vietnam-pro-medium-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 500;
  font-style: italic;
}

.be-vietnam-pro-semibold-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 600;
  font-style: italic;
}

.be-vietnam-pro-bold-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 700;
  font-style: italic;
}

.be-vietnam-pro-extrabold-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 800;
  font-style: italic;
}

.be-vietnam-pro-black-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 900;
  font-style: italic;
}
</style>