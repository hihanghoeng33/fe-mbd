<script setup>
import { ref, onMounted, computed } from "vue";
import { projectService } from "../services/projectService.js";
import ProjectCardMain from "./ProjectCardMain.vue";

const projects = ref([]);
const loading = ref(false);
const errorMessage = ref("");
const currentPage = ref(1);
const maxPage = ref(1);
const perPage = ref(10);
const totalCount = ref(0);
const jumpToPage = ref(null);
const searchQuery = ref("");


onMounted(async () => {
  await loadProjects();
});

const loadProjects = async (page = 1) => {
  loading.value = true;
  errorMessage.value = "";

  try {
    console.log(`Loading projects page ${page}...`);
    const result = await projectService.getProjects(page);
    const projectsData = result.data;
    const meta = result.meta;

    // Update pagination info from meta
    currentPage.value = meta.page || page;
    maxPage.value = meta.max_page || 1;
    perPage.value = meta.per_page || 10;
    totalCount.value = meta.count || 0;

    console.log(`Page ${currentPage.value} of ${maxPage.value}`);
    console.log(`Per page: ${perPage.value}, Total count: ${totalCount.value}`);

    // Transform the data to match our component props
    const transformedProjects = projectsData.map((project) =>
      projectService.transformProjectData(project)
    );

    // Replace projects instead of appending
    projects.value = transformedProjects;

    console.log(
      `Loaded ${transformedProjects.length} projects for page ${page}`
    );
  } catch (error) {
    console.error("Error loading projects:", error);
    errorMessage.value = "Failed to load projects";

    // Fallback to mock data if API fails and it's the first page
    if (page === 1) {
      projects.value = [
        {
          title: "Dompet Digital Aman Berbasis Blockchain",
          author: "Prof.Dr.(ENG).IR. Benjamin Bryant",
          filled: 5,
          total: 6,
          categories: "Blockchain, LLM",
          description: "Aplikasi dompet digital dengan keamanan terjamin.",
        },
        {
          title: "Pengembangan Sistem Pembayaran Wajah",
          author: "Danny Mason S.Kom., M.Kom.",
          filled: 5,
          total: 8,
          categories: "LLM, Sustainability",
          description:
            "Inovasi pembayaran menggunakan teknologi pengenalan wajah.",
        },
        {
          title: "Monitoring Kesehatan IoT untuk Lansia",
          author: "Heather King S.Kom., M.Kom., Ph.D.",
          filled: 4,
          total: 7,
          categories: "IoT, Sustainability",
          description:
            "Perangkat IoT untuk memantau kesehatan lansia dari jarak jauh.",
        },
      ];
      maxPage.value = 1;
      totalCount.value = 3;
      currentPage.value = 1;
    }
  } finally {
    loading.value = false;
  }
};

// const fetchProjects = async () => {
//   loading.value = true;
//   errorMessage.value = '';
//   try {
//     const result = await projectService.getAllProjects();
//     projects.value = result.map(projectService.transformProjectData);
//   } catch (e) {
//     errorMessage.value = 'Gagal memuat proyek.';
//   } finally {
//     loading.value = false;
//   }
// };

// onMounted(fetchProjects);

const goToPage = async (page) => {
  if (
    page >= 1 &&
    page <= maxPage.value &&
    page !== currentPage.value &&
    !loading.value
  ) {
    await loadProjects(page);
    jumpToPage.value = null; // Clear the jump input
  }
};

const goToPreviousPage = async () => {
  if (currentPage.value > 1) {
    await goToPage(currentPage.value - 1);
  }
};

const goToNextPage = async () => {
  if (currentPage.value < maxPage.value) {
    await goToPage(currentPage.value + 1);
  }
};

const goToFirstPage = async () => {
  if (currentPage.value !== 1) {
    await goToPage(1);
  }
};

const goToLastPage = async () => {
  if (currentPage.value !== maxPage.value) {
    await goToPage(maxPage.value);
  }
};

// Generate page numbers for pagination display
const getPageNumbers = () => {
  const pages = [];
  const showPages = 5; // Show 5 page numbers at most

  if (maxPage.value <= showPages) {
    // If total pages <= showPages, show all pages
    for (let i = 1; i <= maxPage.value; i++) {
      pages.push(i);
    }
  } else {
    // Show pages around current page
    let start = Math.max(1, currentPage.value - 2);
    let end = Math.min(maxPage.value, currentPage.value + 2);

    // Adjust if we're near the beginning or end
    if (currentPage.value <= 3) {
      end = Math.min(maxPage.value, 5);
    } else if (currentPage.value >= maxPage.value - 2) {
      start = Math.max(1, maxPage.value - 4);
    }

    for (let i = start; i <= end; i++) {
      pages.push(i);
    }
  }

  return pages;
};

const filteredProjects = computed(() => {
  if (!searchQuery.value) return projects.value;
  const q = searchQuery.value.toLowerCase();
  return projects.value.filter(
    (p) =>
      p.title?.toLowerCase().includes(q) ||
      p.author?.toLowerCase().includes(q) ||
      p.categories?.toLowerCase().includes(q) ||
      p.description?.toLowerCase().includes(q)
  );
});

const refreshFilled = async (projectId) => {
  // Ambil ulang data project tertentu dari API, atau cukup tambah filled di frontend:
  const idx = projects.value.findIndex(p => p.project_id === projectId);
  if (idx !== -1) {
    projects.value[idx].filled += 1;
  }
};

</script>

<template>
  <div class="gap-y-6 pr-2">
    <!-- Judul -->
    <h1 class="text-2xl be-vietnam-pro-semibold text-gray-800 pb-4">
      Daftar Proyek
    </h1>

    <!-- Input Pencarian + Filter -->
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
            d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5A6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5S14 7.01 14 9.5S11.99 14 9.5 14z"
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

    <!-- Error Message -->
    <div
      v-if="errorMessage"
      class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg mb-6"
    >
      {{ errorMessage }}
    </div>
    <div class="h-3"></div>
    <!-- Pagination Info -->
    <div
      v-if="totalCount >= 0"
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

    <!-- Loading State -->
    <div
      v-if="loading"
      class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-y-10"
    >
      <div
        v-for="i in perPage"
        :key="`loading-${i}`"
        class="bg-gray-200 rounded-lg w-96 h-64 animate-pulse"
      ></div>
    </div>

    <!-- Daftar Proyek -->
    <div
      v-else
      class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-y-10"
    >
      <ProjectCardMain
        v-for="(project, index) in filteredProjects"
        :key="project.project_id || index"
        :title="project.title"
        :author="project.author"
        :filled="project.filled"
        :total="project.total"
        :categories="project.categories"
        :description="project.description"
        @update-filled="refreshFilled"
      />
    </div>
    <div class="h-12"></div>
    <!-- Pagination Controls -->
    <div v-if="maxPage > 1" class="flex justify-center items-center mt-8 gap-2">
      <!-- First Page Button -->
      <button
        @click="goToFirstPage"
        :disabled="currentPage === 1 || loading"
        class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        title="Halaman pertama"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          viewBox="0 0 24 24"
        >
          <path
            fill="currentColor"
            d="M18.41 16.59L13.82 12l4.59-4.59L17 6l-6 6l6 6zM6 6h2v12H6z"
          />
        </svg>
      </button>

      <!-- Previous Page Button -->
      <button
        @click="goToPreviousPage"
        :disabled="currentPage === 1 || loading"
        class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        title="Halaman sebelumnya"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          viewBox="0 0 24 24"
        >
          <path
            fill="currentColor"
            d="M15.41 16.59L10.83 12l4.58-4.59L14 6l-6 6l6 6z"
          />
        </svg>
      </button>

      <!-- Page Numbers -->
      <div class="flex gap-1">
        <!-- Show first page if not in visible range -->
        <template v-if="getPageNumbers()[0] > 1">
          <button
            @click="goToPage(1)"
            :disabled="loading"
            class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50"
          >
            1
          </button>
          <span
            v-if="getPageNumbers()[0] > 2"
            class="px-2 py-2 text-sm text-gray-500"
            >...</span
          >
        </template>

        <!-- Visible page numbers -->
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

        <!-- Show last page if not in visible range -->
        <template
          v-if="getPageNumbers()[getPageNumbers().length - 1] < maxPage"
        >
          <span
            v-if="getPageNumbers()[getPageNumbers().length - 1] < maxPage - 1"
            class="px-2 py-2 text-sm text-gray-500"
            >...</span
          >
          <button
            @click="goToPage(maxPage)"
            :disabled="loading"
            class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50"
          >
            {{ maxPage }}
          </button>
        </template>
      </div>

      <!-- Next Page Button -->
      <button
        @click="goToNextPage"
        :disabled="currentPage === maxPage || loading"
        class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        title="Halaman selanjutnya"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          viewBox="0 0 24 24"
        >
          <path
            fill="currentColor"
            d="M8.59 16.59L13.17 12L8.59 7.41L10 6l6 6l-6 6z"
          />
        </svg>
      </button>

      <!-- Last Page Button -->
      <button
        @click="goToLastPage"
        :disabled="currentPage === maxPage || loading"
        class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
        title="Halaman terakhir"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          viewBox="0 0 24 24"
        >
          <path
            fill="currentColor"
            d="M5.59 7.41L10.18 12l-4.59 4.59L7 18l6-6l-6-6zM16 6v12h2V6z"
          />
        </svg>
      </button>
    </div>

    <!-- Page Jump Input (for large datasets) -->
    <div
      v-if="maxPage > 10"
      class="flex justify-center items-center mt-4 gap-2 text-sm"
    >
      <span class="text-gray-600">Langsung ke halaman:</span>
      <input
        v-model.number="jumpToPage"
        @keyup.enter="goToPage(jumpToPage)"
        type="number"
        :min="1"
        :max="maxPage"
        class="w-16 px-2 py-1 text-center border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        :disabled="loading"
      />
      <button
        @click="goToPage(jumpToPage)"
        :disabled="
          loading || !jumpToPage || jumpToPage < 1 || jumpToPage > maxPage
        "
        class="px-3 py-1 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
      >
        Pergi
      </button>
    </div>

    <!-- No projects message -->
    <div v-if="projects.length === 0 && !loading" class="text-center py-12">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="64"
        height="64"
        viewBox="0 0 24 24"
        class="mx-auto mb-4 text-gray-400"
      >
        <path
          fill="currentColor"
          d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M7 13.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5"
        />
      </svg>
      <h3 class="text-lg font-medium text-gray-900 mb-2">Tidak ada proyek</h3>
      <p class="text-gray-500">Belum ada proyek yang tersedia saat ini.</p>
    </div>
  </div>
</template>

<style scoped>

</style>
