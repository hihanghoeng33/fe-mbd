<template>
  <router-link
    :to="to"
    class="flex items-center space-x-3 px-3 py-2 rounded-md text-gray-700 hover:bg-black/10 transition-colors"
    :class="{ 'bg-blue-200 font-semibold text-blue-600': active }"
  >
    <img :src="icon" alt="" class="w-5 h-5" />
    <span>{{ label }}</span>
  </router-link>
</template>

<script setup>
defineProps({
  icon: String,
  label: String,
  to: String,
  active: Boolean
})
</script>
