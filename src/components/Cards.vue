<script setup>
import ProjectCard from './ProjectCard.vue';
import { defineProps } from 'vue';
const props = defineProps({
  title: {
    type: String,
    default: 'Judul Proyek'
  },
  author: {
    type: String,
    default: 'Nama Dosen'
  },
  image: {
    type: String,
      default: '/img/default-project.jpg'
  },
});
</script>

<template>
    <div>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <ProjectCard
          v-for="(project, index) in projects"
          :key="index"
          :title="project.title"
          :author="project.author"
          :image="project.image"
        />
      </div>
    </div>
</template>

<style>
</style>