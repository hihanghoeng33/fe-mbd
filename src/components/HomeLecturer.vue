<script setup>
import Hero from "./Hero.vue";
import ProjectCardMain from "./ProjectCardMain.vue";
import { projectService } from "@/services/projectService";
import { authService } from "@/services/authService";
import { ref, onMounted, onBeforeUnmount } from "vue";
import { useRouter } from "vue-router";

const router = useRouter()

const navigate = () => {
  router.push('/projectsmanagement');
}

const scrollContainer = ref(null);
const projects = ref([]);
const loading = ref(false);
const errorMessage = ref("");
const userName = ref("");

function handleWheelScroll(e) {
  if (e.deltaY !== 0) {
    e.preventDefault();
    scrollContainer.value.scrollLeft += e.deltaY;
  }
}

onMounted(async () => {
  const el = scrollContainer.value;
  el.addEventListener("wheel", handleWheelScroll, { passive: false });
  //load user data
  await loadUserData();
  // Load lecturer's projects
  await loadLecturerProjects();
});

const loadUserData = async () => {
  try {
    const user = authService.getCurrentUser();
    if (user) {
      userName.value = user.name || "dosen";
    } else if (authService.isAuthenticated()) {
      const userData = await authService.getCurrentUserProfile();
      userName.value = userData.name || "dosen";
    }
  } catch (error) {
    console.error("Error loading user data:", error);
    userName.value = "dosen";
  }
};

// Fetch lecturer's projects
// const loadLecturerProjects = async () => {
//   loading.value = true;
//   errorMessage.value = '';
//   try {
//     // Ganti dengan API yang sesuai untuk mengambil proyek milik dosen
//     let lecturerProjects = await projectService.getProjects();
//     projects.value = lecturerProjects.map(projectService.transformProjectData);
//   } catch (error) {
//     console.error('Error loading lecturer projects:', error);
//     errorMessage.value = 'Gagal memuat proyek Anda';
//     // Fallback mock data jika perlu
//     projects.value = [
//       {
//         title: "Penelitian interaksi manusia dan komputer",
//         author: username.value,
//         filled: 4,
//         total: 8,
//         categories: "AI, IoT",
//         description: "Penelitian tentang interaksi manusia dan komputer."
//       }
//     ];
//   } finally {
//     loading.value = false;
//   }
// };

const loadRecommendedProjects = async () => {
  loading.value = true;
  errorMessage.value = "";

  try {
    console.log("Loading recommended projects...");

    // Try the improved method first, fallback to advanced method if needed
    let recommendedProjects = await projectService.getRecommendedProjects(6);

    // If no projects found with regular method, try advanced method
    if (recommendedProjects.length === 0) {
      console.log(
        "No projects found with regular method, trying advanced method..."
      );
      recommendedProjects = await projectService.getRecommendedProjectsAdvanced(
        6
      );
    }

    // Transform the data to match our component props
    projects.value = recommendedProjects.map((project) =>
      projectService.transformProjectData(project)
    );

    console.log("Loaded projects:", projects.value);

    // Show info message if using completed projects
    if (
      recommendedProjects.length > 0 &&
      recommendedProjects.every((p) => p.status === "COMPLETED")
    ) {
      errorMessage.value =
        "Menampilkan proyek yang sudah selesai karena tidak ada proyek aktif tersedia";
    }
  } catch (error) {
    console.error("Error loading recommended projects:", error);
    errorMessage.value = "Failed to load recommended projects";

    // Fallback to mock data if API fails
    projects.value = [
      {
        title: "Sistem Rekomendasi Film Berbasis AI",
        author: "Prof. Dr. Amritzal Jago Banget",
        filled: 4,
        total: 8,
        description: "Rekomendasi film personalisasi menggunakan AI.",
        categories: "AI",
      },
      {
        title: "Aplikasi Manajemen Acara Kampus",
        author: "Prof. Dr. Arya Jago Banget",
        filled: 6,
        total: 10,
        description: "Mempermudah pengelolaan dan pendaftaran acara di kampus.",
        categories: "Event Management",
      },
      {
        title: "Kampanye Lingkungan Hidup Berbasis Digital",
        author: "Prof.Dr.(Eng). Ir. Ironi",
        filled: 3,
        total: 4,
        description: "Mengelola acara kampanye lingkungan secara daring.",
        categories: "Sustainability",
      },
    ];
  } finally {
    loading.value = false;
  }
};

const refreshProjects = async () => {
  await loadRecommendedProjects();
};

onBeforeUnmount(() => {
  scrollContainer.value?.removeEventListener("wheel", handleWheelScroll);
});

</script>

<template>
  <div class="gap-8 mt-8">
    <!-- Hero Section -->
    <Hero :nama="userName" />

    <!-- Proyek Saya -->
    <h2 class="text-xl be-vietnam-pro-semibold text-gray-800 pb-4 pt-8">
      Proyek Saya
    </h2>
    <div ref="scrollContainer" class="overflow-x-auto relative scroll-smooth">
      <div class="flex gap-4 w-max">
        <!-- Create New Project Card -->
        <div
          @click="navigate"
          class="bg-[#E8EDF2] shadow-md hover:shadow-lg transition-all duration-300 overflow-hidden rounded-lg w-96 h-48 cursor-pointer border-2 border-dashed border-gray-400 hover:border-blue-500 hover:bg-blue-50 flex items-center justify-center"
        >
          <div 
            class="text-center text-gray-500 hover:text-blue-600 transition-colors"
          >
            <div  class="mb-4 flex justify-center">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="64"
                height="64"
                viewBox="0 0 24 24"
              >
                <path
                  fill="currentColor"
                  d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"
                />
              </svg>
            </div>
            <p class="text-lg font-medium">Buat Proyek Baru</p>
            <p class="text-sm">Klik untuk membuat proyek baru</p>
          </div>
        </div>

        <!-- Existing Projects -->
        <ProjectCardMain
          v-for="project in projects"
          :key="project.project_id"
          :project_id="project.project_id"
          :title="project.title"
          :author="project.author"
          :filled="project.filled"
          :total="project.total"
          :categories="project.categories"
          :image="project.image"
          :description="project.description"
          :start-date="project.startDate"
          :end-date="project.endDate"
        />
        <div v-if="loading" class="text-center py-8">Memuat proyek...</div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
