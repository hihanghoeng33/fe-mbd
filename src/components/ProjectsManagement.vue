<script setup>
import { ref } from 'vue';
import ProjectCardMain from './ProjectCardMain.vue';
import { projectService } from '@/services/projectService';

const projects = ref([]);
const showForm = ref(false);
const loading = ref(false);
const errorMessage = ref('');
const successMessage = ref('');

// Form state
const newProject = ref({
  title: '',
  author: '',
  filled: 0,
  total: 1,
  categories: '',
  description: ''
});

// Fetch projects from API (opsional, jika ingin fetch ulang setelah tambah)
const fetchProjects = async () => {
  loading.value = true;
  errorMessage.value = '';
  try {
    const result = await projectService.getProjectsByUserId();
    projects.value = result;
  } catch (e) {
    console.log(e);
    errorMessage.value = 'Gagal memuat proyek.';
  } finally {
    loading.value = false;
  }
};

// Submit new project
const handleAddProject = async () => {
  loading.value = true;
  errorMessage.value = '';
  successMessage.value = '';
  try {
    // Kirim ke API
    await projectService.createProject({
      ...newProject.value,
    });
    showForm.value = false;
    // Reset form
    newProject.value = { title: '', author: '', filled: 0, total: 1, categories: '', description: '' };
    // Fetch ulang daftar proyek
    await fetchProjects();
    successMessage.value = 'Proyek berhasil ditambahkan!';
  } catch (e) {
    errorMessage.value = 'Gagal menambah proyek.';
  } finally {
    loading.value = false;
  }
};
</script>

<template>
  <div class="space-y-8">
    <h1 class="text-2xl be-vietnam-pro-semibold text-gray-800 pb-2">Kelola Proyek</h1>

    <div v-if="projects.length === 0" class="flex flex-col items-center justify-center py-16">
      <div class="text-gray-500 text-lg pb-8 text-center">
        Belum ada proyek untuk dikelola, tambahkan proyek di bawah
      </div>
      <button
        @click="showForm = !showForm"
        class="flex flex-col items-center justify-center text-blue-700 bg-blue-100 hover:bg-blue-200 border-2 border-dashed border-blue-400 rounded-lg p-8 transition-all"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24">
                <path fill="currentColor" d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
        <span class="mt-2  font-medium">Tambah Proyek</span>
      </button>
      <div class="h-6"></div>
      <!-- Form tambah proyek -->
      <div v-if="showForm" class="mt-8 w-full max-w-md bg-white rounded-lg shadow p-6 text-gray-900">
        <h2 class="text-lg font-semibold mb-8">Tambah Proyek Baru</h2>
        <form @submit.prevent="handleAddProject" class="flex flex-col gap-y-4">
          <input v-model="newProject.title" type="text" placeholder="Judul Proyek" class="w-full border rounded px-3 py-2" required />
          <input v-model="newProject.author" type="text" placeholder="Penulis" class="w-full border rounded px-3 py-2" required />
          <input v-model.number="newProject.total" type="number" min="1" placeholder="Total Slot" class="w-full border rounded px-3 py-2" required />
          <input v-model="newProject.categories" type="text" placeholder="Kategori (pisahkan dengan koma)" class="w-full border rounded px-3 py-2" required />
          <textarea v-model="newProject.description" placeholder="Deskripsi" class="w-full border rounded px-3 py-2" required></textarea>
          <div class="flex gap-2">
            <button type="submit" :disabled="loading" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Simpan</button>
            <button type="button" @click="showForm = false" class="bg-yellow-400 px-4 text-white py-2 rounded hover:bg-yellow-500">Batal</button>
          </div>
        </form>
      </div>
      <div v-if="errorMessage" class="text-red-600 mt-2">{{ errorMessage }}</div>
      <div v-if="successMessage" class="text-green-600 mt-2">{{ successMessage }}</div>
    </div>

    <!-- Jika sudah ada proyek, tampilkan daftar proyek -->
    <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-8">
      <ProjectCardMain
        v-for="(project, index) in projects"
        :key="index"
        :title="project.title"
        :author="project.author"
        :filled="project.filled"
        :total="project.total"
        :categories="project.categories"
        :image="project.image"
        :description="project.description"
      />
    </div>
  </div>
</template>

<style scoped>
.be-vietnam-pro-semibold {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 600;
}
</style>