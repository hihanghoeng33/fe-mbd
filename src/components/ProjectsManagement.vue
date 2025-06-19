<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import ProjectCardMain from './ProjectCardMain.vue';
import { projectService } from '@/services/projectService';

/* -------------------- State -------------------- */
const projects = ref([]);
const loading = ref(false);
const errorMessage = ref('');
const successMessage = ref('');
const showForm = ref(false);
const searchQuery = ref('');

const currentPage = ref(1);
const itemsPerPage = 10;

const newProject = ref({
  title: '',
  description: '',
  total: 10,
  filled: 0,
  categories: '',
  startDate: '',
  endDate: ''
});

/* -------------------- Computed -------------------- */
const filteredProjects = computed(() => {
   if (!projects.value) return [];
  if (!searchQuery.value) return projects.value;
  const q = searchQuery.value.toLowerCase();
  return projects.value.filter(p =>
    p.title?.toLowerCase().includes(q) ||
    p.description?.toLowerCase().includes(q) ||
    p.categories?.toString().toLowerCase().includes(q)
  );
});

const paginatedProjects = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredProjects.value.slice(start, start + itemsPerPage);
});

const totalPages = computed(() => 
  Math.ceil(filteredProjects.value.length / itemsPerPage)
);

/* -------------------- Watch -------------------- */
// Reset ke halaman pertama saat pencarian berubah
watch(searchQuery, () => {
  currentPage.value = 1;
});

/* -------------------- Methods -------------------- */
const resetForm = () => {
  newProject.value = {
    title: '',
    author: '',
    total: 10,
    filled:1,
    description: '',
    categories: '',
    startDate: '',
    endDate: ''
  };
};

const fetchProjects = async () => {
  loading.value = true;
  errorMessage.value = '';
  try {
    const result = await projectService.getProjectsByUserId();
    projects.value = result;
  } catch (e) {
    console.log(e);
    errorMessage.value = e?.response?.data?.message || 'Gagal memuat proyek.';
  } finally {
    loading.value = false;
  }
};

const handleAddProject = async () => {
  loading.value = true;
  errorMessage.value = '';
  successMessage.value = '';
  try {
    const payload = {
      ...newProject.value,
      categories: newProject.value.categories.split(',').map(s => s.trim())
    };
    console.log('Payload:', payload);

    console.log('Payload JSON:', JSON.stringify(payload));

    await projectService.createProject(payload);
    newProject.value = { title: '', filled: 1, total: 10, categories: '', description: '', startDate:'', endDate: ''};
    successMessage.value = 'Proyek berhasil ditambahkan!';
    showForm.value = false;
    resetForm();
    await fetchProjects();
    currentPage.value = 1; // tampilkan halaman pertama setelah tambah
  } catch (e) {
    errorMessage.value = e?.response?.data?.message || 'Gagal menambah proyek.';
  } finally {
    loading.value = false;
  }
};

/* -------------------- Pagination -------------------- */
const nextPage = () => currentPage.value < totalPages.value && currentPage.value++;
const prevPage = () => currentPage.value >= 1 && currentPage.value--;
const goToPage = (page) => currentPage.value = page;

/* -------------------- Lifecycle -------------------- */
onMounted(fetchProjects);
</script>

<template>
  <div class="space-y-8 relative">

    <!-- Heading -->
    <div class="flex justify-between items-center pr-12">
      <h1 class="text-2xl be-vietnam-pro-semibold text-gray-800 pb-2">Kelola Proyek</h1>
      <!-- Tombol tambah kecil di pojok kanan -->
      <button 
        @click="showForm = true"
        class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1.5 rounded-lg text-sm flex items-center gap-1"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24">
          <path fill="currentColor" d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
        </svg>
        Tambah
      </button>
    </div>
    <div class=" h-4"></div>
    <!-- Search Bar -->
     <div class="flex justify-between pr-12">
      <div class="flex items-center bg-[#E8EDF2] rounded-xl h-12 lg:w-[700px] md:w-[512px] text-gray-700 px-3">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24">
        <path fill="currentColor" d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5A6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5S14 7.01 14 9.5S11.99 14 9.5 14z"/>
      </svg>
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Cari proyek..."
        class="outline-none h-12 w-full bg-transparent px-2"
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
    
    
    <div class=" h-4"></div>
    <!-- Form tambah proyek -->
    <transition name="fade">
      <div v-if="showForm" class="w-full max-w-md bg-white rounded-lg shadow p-6 text-gray-900 mx-auto">
        <h2 class="text-lg font-semibold mb-8">Tambah Proyek Baru</h2>
        <form @submit.prevent="handleAddProject" class="flex flex-col gap-y-4">
          <input v-model="newProject.title" type="text" placeholder="Judul Proyek" class="w-full border rounded px-3 py-2" required />
          <input v-model.number="newProject.total" type="number" min="1" placeholder="Total Slot" class="w-full border rounded px-3 py-2" required />
          <input v-model="newProject.categories" type="text" placeholder="Kategori (pisahkan dengan koma)" class="w-full border rounded px-3 py-2" required />
          <textarea v-model="newProject.description" placeholder="Deskripsi" class="w-full border rounded px-3 py-2" required></textarea>
          <input v-model="newProject.startDate" type="date" placeholder="Penulis" class="w-full border rounded px-3 py-2" required />
          <input v-model="newProject.endDate" type="date" placeholder="Penulis" class="w-full border rounded px-3 py-2" required />
          <div class="flex gap-2">
            <button type="submit" :disabled="loading" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
              {{ loading ? 'Menyimpan...' : 'Simpan' }}
            </button>
            <button type="button" @click="showForm = false" class="bg-yellow-400 px-4 text-white py-2 rounded hover:bg-yellow-500">
              Batal
            </button>
          </div>
        </form>
        <div v-if="errorMessage" class="text-red-600 mt-2">{{ errorMessage }}</div>
        <div v-if="successMessage" class="text-green-600 mt-2">{{ successMessage }}</div>
      </div>
    </transition>
<div class=" h-4"></div>  
    <!-- Grid Proyek -->
    <div v-if="paginatedProjects.length > 0" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-8">
      <ProjectCardMain
        v-for="project in paginatedProjects"
        :key="project.project_id"
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
    </div>

    <!-- Placeholder saat loading -->
    <div v-else-if="loading" class="text-center py-8 animate-pulse text-gray-400">
      <div class="h-6 w-1/2 mx-auto bg-gray-200 rounded"></div>
    </div>

    <!-- Jika tidak ada proyek -->
    <div v-else class="text-center text-gray-500 py-8">
      Tidak ada proyek yang ditemukan.
    </div>

    <!-- Pagination -->
    <div v-if="totalPages >= 1" class="text-gray-900 flex justify-center items-center gap-2 py-4">
      
      <button 
        @click="prevPage" 
        :disabled="currentPage === 1"
        class="px-3 py-1 rounded bg-gray-100 disabled:opacity-50"
      >
        Previous
      </button>
      <button
        v-for="page in totalPages"
        :key="page"
        @click="goToPage(page)"
        :class="[
          'px-3 py-1 rounded',
          currentPage === page 
            ? 'bg-blue-600 text-white' 
            : 'bg-gray-100 hover:bg-gray-200'
        ]"
      >
        {{ page }}
      </button>
      <button 
        @click="nextPage" 
        :disabled="currentPage === totalPages"
        class="px-3 py-1 rounded bg-gray-100 disabled:opacity-50"
      >
        Next
      </button>
    </div>
  </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>