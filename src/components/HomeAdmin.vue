<script setup>
import Hero from "./Hero.vue";
import ProjectCardMain from "./ProjectCardMain.vue";
import { projectService } from "@/services/projectService";
import { authService } from "@/services/authService";
import { ref, onMounted, onBeforeUnmount } from "vue";

const scrollContainer = ref(null);
const projects = ref([]);
const loading = ref(false);
const errorMessage = ref("");
const username = ref("");

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

// Fetch user data
const loadUserData = async () => {
  try {
    const user = authService.getCurrentUser();
    if (user) {
      username.value = user.name || "dosen";
    } else if (authService.isAuthenticated()) {
      const userData = await authService.getCurrentUserProfile();
      username.value = userData.name || "dosen";
    }
  } catch (error) {
    console.error("Error loading user data:", error);
    username.value = "dosen";
  }
};

// Fetch lecturer's projects
const loadLecturerProjects = async () => {
  loading.value = true;
  errorMessage.value = "";
  try {
    // Ganti dengan API yang sesuai untuk mengambil proyek milik dosen
    let lecturerProjects = await projectService.getProjectsByLecturer();
    projects.value = lecturerProjects.map(projectService.transformProjectData);
  } catch (error) {
    console.error("Error loading lecturer projects:", error);
    errorMessage.value = "Gagal memuat proyek Anda";
    // Fallback mock data jika perlu
    projects.value = [
      {
        title: "Penelitian interaksi manusia dan komputer",
        author: username.value,
        filled: 4,
        total: 8,
        categories: "AI, IoT",
        description: "Penelitian tentang interaksi manusia dan komputer.",
      },
    ];
  } finally {
    loading.value = false;
  }
};

const refreshProjects = async () => {
  await loadLecturerProjects();
};

onBeforeUnmount(() => {
  scrollContainer.value?.removeEventListener("wheel", handleWheelScroll);
});

const handleCreateProject = () => {
  console.log("Create new project");
};
</script>

<template>
  <div class="gap-8 mt-8">
    <!-- Hero Section -->
    <Hero :nama="username" />

    <!-- Tinjau Proyek -->
    <h2 class="text-xl be-vietnam-pro-semibold text-gray-800 pb-4 pt-8">
      Tinjau Saya
    </h2>
    <div ref="scrollContainer" class="overflow-x-auto relative scroll-smooth">
      <div class="flex gap-4 w-max">
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
            <button
              class="bg-gray-100 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-800 h-10 w-22 hover:bg-gray-200 transition-colors"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                viewBox="0 0 24 24"
              >
                <path
                  fill="currentColor"
                  d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
                />
              </svg>
              <span class="text-sm">Tinjau</span>
            </button>
            <button
              class="bg-red-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22 hover:bg-red-600 transition-colors"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                viewBox="0 0 24 24"
              >
                <path
                  fill="currentColor"
                  d="M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21H7ZM17 6H7v13h10V6ZM9 17h2V8H9v9Zm4 0h2V8h-2v9ZM7 6v13V6Z"
                />
              </svg>
              <span class="text-sm">Tolak</span>
            </button>
            <button
              class="bg-blue-400 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-100 h-10 w-22 hover:bg-gray-200 transition-colors"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24"><path fill="currentColor" d="m9.55 15.15l8.475-8.475q.3-.3.7-.3t.7.3t.3.713t-.3.712l-9.175 9.2q-.3.3-.7.3t-.7-.3L4.55 13q-.3-.3-.288-.712t.313-.713t.713-.3t.712.3z"/></svg>
              <span class="text-sm">Setujui</span>
            </button>
          </template>
        </ProjectCardMain>
        <div v-if="loading" class="text-center py-8">Memuat proyek...</div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
