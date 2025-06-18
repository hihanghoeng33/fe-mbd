<script setup>
import { ref, onMounted, computed } from "vue";
import { projectService } from "../services/projectService.js";
import ProjectCardArchive from "./ProjectCardArchive.vue";

const projects = ref([]);
const loading = ref(false);
const errorMessage = ref("");
const searchQuery = ref("");
const currentPage = ref(1);
const maxPage = ref(1);
const perPage = ref(10);
const totalCount = ref(0);
const jumpToPage = ref(null);
// Fetch all projects on mount
onMounted(async () => {
  loading.value = true;
  try {
    const result = await projectService.getProjects(); // Adjust if you need pagination
    // If your API returns an array directly:
    // projects.value = result.data;
    // If you need to transform:
    projects.value = result.data.map(projectService.transformProjectData);
  } catch (error) {
    errorMessage.value = "Failed to load projects";
  } finally {
    loading.value = false;
  }
});

// Filter for only "On Going" and "Finished" projects
const archiveProjects = computed(() =>
  projects.value.filter(
    (p) =>
      p.stats?.toLowerCase() === "ongoing" ||
      p.stats?.toLowerCase() === "completed" ||
      p.status?.toLowerCase() === "ongoing" ||
      p.status?.toLowerCase() === "completed"
  )
);

// Search within the filtered archive projects
const filteredProjects = computed(() => {
  if (!searchQuery.value) return archiveProjects.value;
  const q = searchQuery.value.toLowerCase();
  return archiveProjects.value.filter(
    (p) =>
      p.title?.toLowerCase().includes(q) ||
      p.author?.toLowerCase().includes(q) ||
      p.categories?.toLowerCase().includes(q) ||
      p.description?.toLowerCase().includes(q)
  );
});
</script>

<template>
  <div class="space-y-6">
    <h1 class="text-2xl be-vietnam-pro-semibold text-gray-800 pb-4">
      Arsip Proyek
    </h1>
    <div class="flex gap-x-16 gap-y-4">
      <div
        class="flex items-center bg-[#E8EDF2] rounded-xl justify-center h-12 mb-4 lg: w-[700px] md:w-[] text-gray-700 p-3"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="20"
          height="20"
          viewBox="0 0 24 24"
        >
          <path
            fill="currentColor"
            d="M9.5 16q-2.725 0-4.612-1.888T3 9.5t1.888-4.612T9.5 3t4.613 1.888T16 9.5q0 1.1-.35 2.075T14.7 13.3l5.6 5.6q.275.275.275.7t-.275.7t-.7.275t-.7-.275l-5.6-5.6q-.75.6-1.725.95T9.5 16m0-2q1.875 0 3.188-1.312T14 9.5t-1.312-3.187T9.5 5T6.313 6.313T5 9.5t1.313 3.188T9.5 14"
          />
        </svg>
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Cari judul proyek"
          class="outline-none h-12 w-full text-sm p-3"
        />
      </div>
      <button
        class="flex items-center gap-x-2 text-gray-600 hover:text-gray-800"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
        >
          <path
            fill="currentColor"
            stroke="currentColor"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="1.5"
            d="M4 3h16a1 1 0 0 1 1 1v1.586a1 1 0 0 1-.293.707l-6.414 6.414a1 1 0 0 0-.293.707v6.305a1 1 0 0 1-1.242.97l-2-.5a1 1 0 0 1-.758-.97v-5.805a1 1 0 0 0-.293-.707L3.293 6.293A1 1 0 0 1 3 5.586V4a1 1 0 0 1 1-1"
          />
        </svg>
        <span class="mr-1 text-sm">Filter</span>
      </button>
    </div>
    <div class="h-3"></div>
    <div
      v-if="totalCount > 0"
      class="text-sm text-gray-600 mb-4 flex justify-between items-center pr-16"
    >
      <div>
        Menampilkan {{ (currentPage - 1) * perPage + 1 }}-{{
          Math.min(currentPage * perPage, totalCount)
        }}
        dari {{ totalCount }} proyek
        <span v-if="maxPage > 1"
          >(Halaman {{ currentPage }} dari {{ maxPage }})</span
        >
      </div>
      <div v-if="perPage > 0" class="text-xs text-gray-500">
        {{ perPage }} proyek per halaman
      </div>
    </div>
    <div class="h-8"></div>
    <div v-if="loading" class="text-center py-12">Loading...</div>
    <div
      v-else
      class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-y-10"
    >
      <ProjectCardArchive
        v-for="(project, index) in filteredProjects"
        :key="project.project_id || index"
        :to="project.to"
        :title="project.title"
        :author="project.author"
        :categories="project.categories"
        :stats="project.stats || project.status"
        :description="project.description"
      />
    </div>
    <div
      v-if="!loading && filteredProjects.length === 0"
      class="text-center text-gray-500 py-8"
    >
      Tidak ada proyek arsip yang ditemukan.
    </div>
  </div>
  <div v-if="maxPage > 1" class="flex justify-center items-center mt-8 gap-2">
    <button
      @click="goToFirstPage"
      :disabled="currentPage === 1 || loading"
      class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
      title="Halaman pertama"
    >
      &laquo;
    </button>
    <button
      @click="goToPreviousPage"
      :disabled="currentPage === 1 || loading"
      class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
      title="Halaman sebelumnya"
    >
      &lsaquo;
    </button>
    <div class="flex gap-1">
      <button
        v-for="page in getPageNumbers()"
        :key="page"
        @click="goToPage(page)"
        :disabled="loading"
        :class="[
          'px-3 py-2 text-sm font-medium rounded-md disabled:opacity-50',
          page === currentPage
            ? 'text-white bg-blue-600 border border-blue-600'
            : 'text-gray-500 bg-white border border-gray-300 hover:bg-gray-50 hover:text-gray-700',
        ]"
      >
        {{ page }}
      </button>
    </div>
    <button
      @click="goToNextPage"
      :disabled="currentPage === maxPage || loading"
      class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
      title="Halaman selanjutnya"
    >
      &rsaquo;
    </button>
    <button
      @click="goToLastPage"
      :disabled="currentPage === maxPage || loading"
      class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
      title="Halaman terakhir"
    >
      &raquo;
    </button>
  </div>
</template>

<style scoped>

</style>