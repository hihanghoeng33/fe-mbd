<script setup>
import { defineProps } from 'vue';
const user = JSON.parse(localStorage.getItem('user'));
if (!user) {
  window.location.href = '/login';
}
defineProps({
  nama: {
    type: String,
    default: 'Nama Pengguna',
  },
});
</script>

<template>
    <div>
        <h1 class=" text-xl text-[#202326]">Selamat Datang {{ nama }}</h1>
         <hr class="mt-2 border-gray-300" />
    </div>
    <div class="bg-white shadow-sm rounded-lg p-5">
      <h2 class="text-xl font-medium text-gray-800 mb-2">Pengumuman Terbaru</h2>
      <div class="flex items-start space-x-4">
        <img src="/pengumuman.png" class="w-6 h-6 mt-1" alt="icon" />
        <div>
          <p class="text-gray-700 font-medium">
            Timeline pendaftaran proyek "Penelitian interaksi manusia dan komputer"
          </p>
          <p class="text-sm text-gray-500">
            Deadline pendaftaran proyek "Penelitian interaksi manusia dan komputer" untuk gelombang 1: 21 Juni 2025
          </p>
        </div>
      </div>
      <div class="flex justify-end space-x-3 mt-4">
        <button class="text-gray-500 hover:text-black">
          <i class="fas fa-th"></i>
        </button>
        <button class="text-gray-500 hover:text-black">
          <i class="fas fa-arrow-right"></i>
        </button>
      </div>
    </div>
</template>

<style scoped>
</style>