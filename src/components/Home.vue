<template>
  <div class="space-y-8">
    <!-- Hero Section -->
    <Hero nama="Amtsal" />

    <!-- Pengumuman Terbaru -->
    <div class="bg-white shadow-sm rounded-lg p-5">
      <h2 class="text-xl font-medium text-gray-800 mb-2">Pengumuman Terbaru</h2>
      <div class="flex items-start space-x-4">
        <img src="/pengumuman.png" class="w-6 h-6 mt-1" alt="icon" />
        <div>
          <p class="text-gray-700 font-medium">
            Timeline pendaftaran proyek "Penelitian interaksi manusia dan komputer"
          </p>
          <p class="text-sm text-gray-500">
            Deadline gelombang 1: 21 Juni 2025
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

    <!-- Rekomendasi Proyek -->
    <div>
      <h2 class="text-xl font-medium text-gray-800 mb-4">Rekomendasi proyek</h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <ProjectCard
          title="Penelitian interaksi manusia dan komputer"
          author="Prof. Dr. Amritzal Jago Banget"
          image="/img/project1.jpg"
        />
        <ProjectCard
          title="Robot Berkaki 4 untuk Lost & Found"
          author="Prof. Dr. Arya Jago Banget"
          image="/img/project2.jpg"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import Hero from './Hero.vue';
import ProjectCard from './ProjectCard.vue';
</script>
