<template>
  <div class="bg-white shadow-md hover:shadow-lg transition-shadow rounded-lg overflow-hidden">
    <img
      :src="image"
      :alt="title"
      class="w-full h-48 object-cover"
    />
    <div class="p-4">
      <h3 class="text-lg font-semibold text-gray-800 mb-1">
        {{ title }}
      </h3>
      <p class="text-sm text-gray-500">Oleh {{ author }}</p>
    </div>
  </div>
</template>

<script setup>
defineProps({
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
  }
})
</script>
