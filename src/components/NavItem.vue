<template>
  <router-link
    :to="to"
    class="flex items-center space-x-3 px-3 py-2 rounded-md text-gray-700 hover:bg-blue-100 transition-colors"
    :class="{ 'bg-blue-50 font-semibold text-blue-600': active }"
  >
    <i :class="`fas fa-${icon}`"></i>
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
