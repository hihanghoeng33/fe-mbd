<script setup>
import ProjectCardMain from './ProjectCardMain.vue';
import ProjectCard from './ProjectCardMain.vue';
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
      default: '/default-project.jpg'
  },
});
</script>

<template>
    <div>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <ProjectCardMain
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