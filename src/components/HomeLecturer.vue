<script setup>
import Hero from './Hero.vue';
import ProjectCardMain from './ProjectCardMain.vue';
import { projectService } from '@/services/projectService';
import { authService } from '@/services/authService';
import { ref, onMounted, onBeforeUnmount } from 'vue';

const scrollContainer = ref(null);
const projects = ref([]);
const loading = ref(false);
const errorMessage = ref('');
const username = ref('');

function handleWheelScroll(e) {
  if (e.deltaY !== 0) {
    e.preventDefault();
    scrollContainer.value.scrollLeft += e.deltaY;
  }
}

onMounted(async () => {
  const el = scrollContainer.value;
  el.addEventListener('wheel', handleWheelScroll, { passive: false });
  //load user data
  await loadUserData();
  // Load lecturer's projects
  await loadLecturerProjects();
});


// Fetch user data
const loadUserData = async () => {
  try {
    const user = authService.getCurrentUser();
    if (user) {
      username.value = user.name || 'dosen';
    } else if (authService.isAuthenticated()) {
      const userData = await authService.getCurrentUserProfile();
      username.value = userData.name || 'dosen';
    }
  } catch (error) {
    console.error('Error loading user data:', error);
    username.value = 'dosen';
  }
};

// Fetch lecturer's projects
const loadLecturerProjects = async () => {
  loading.value = true;
  errorMessage.value = '';
  try {
    // Ganti dengan API yang sesuai untuk mengambil proyek milik dosen
    let lecturerProjects = await projectService.getProjectsByUserId();
    projects.value = lecturerProjects;
  } catch (error) {
    console.error('Error loading lecturer projects:', error);
    errorMessage.value = 'Gagal memuat proyek Anda';
    // Fallback mock data jika perlu
    projects.value = [
      {
        title: "Penelitian interaksi manusia dan komputer",
        author: username.value,
        filled: 4,
        total: 8,
        categories: "AI, IoT",
        description: "Penelitian tentang interaksi manusia dan komputer."
      }
    ];
  } finally {
    loading.value = false;
  }
};

const refreshProjects = async () => {
  await loadLecturerProjects();
};

onBeforeUnmount(() => {
  scrollContainer.value?.removeEventListener('wheel', handleWheelScroll);
});

const handleCreateProject = () => {
  isCreateModelOpen.value = true;
};
</script>

<template>
  <div class="gap-8 mt-8">
    <!-- Hero Section -->
    <Hero :nama="username" />

    <!-- Proyek Saya -->
    <h2 class="text-xl be-vietnam-pro-semibold text-gray-800 pb-4 pt-8">Proyek Saya</h2>
    <div ref="scrollContainer" class="overflow-x-auto relative scroll-smooth">
      <div class="flex gap-4 w-max">
        <!-- Create New Project Card -->
        <div
          @click="handleCreateProject"
          class="bg-[#E8EDF2] shadow-md hover:shadow-lg transition-all duration-300 overflow-hidden rounded-lg w-96 cursor-pointer border-2 border-dashed border-gray-400 hover:border-blue-500 hover:bg-blue-50 flex items-center justify-center min-h-[400px]"
        >
          <div class="text-center text-gray-500 hover:text-blue-600 transition-colors">
            <div class="mb-4 flex justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24">
                <path fill="currentColor" d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
            </div>
            <p class="text-lg font-medium">Buat Proyek Baru</p>
            <p class="text-sm">Klik untuk membuat proyek baru</p>
          </div>
        </div>

        <!-- Existing Projects -->
        <ProjectCardMain
            v-for="(project, index) in projects"
            :key="project.project_id || index"
            :title="project.title"
            :author="project.author"
            :filled="project.filled"
            :total="project.total"
            :categories="project.categories"
            :description="project.description"
        >
          <template #actions>
              <button class="bg-gray-100 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-800 h-10 w-22 hover:bg-gray-200 transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                  <path fill="currentColor" d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                </svg>
                <span class="text-sm">Edit</span>
              </button>
              <button class="bg-red-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22 hover:bg-red-600 transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                  <path fill="currentColor" d="M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21H7ZM17 6H7v13h10V6ZM9 17h2V8H9v9Zm4 0h2V8h-2v9ZM7 6v13V6Z"/>
                </svg>
                <span class="text-sm">Hapus</span>
              </button>
            </template>
        </ProjectCardMain>
        <div v-if="loading" class="text-center py-8">Memuat proyek...</div>
      </div>
    </div>
  </div>
</template>

<style scoped>
</style>