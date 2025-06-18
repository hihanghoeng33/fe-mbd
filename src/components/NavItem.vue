<template>
  <RouterLink
    :to="to"
    class="flex items-center space-x-3 px-3 py-2 rounded-md text-gray-700 hover:bg-black/10 transition-colors"
    :class="{ 'bg-blue-200 font-semibold text-blue-600': active }"
  >
    <img :src="icon" alt="" class="w-auto h-auto" />
    <span>{{ label }}</span>
  </RouterLink>
</template>

<script setup>
import { RouterLink } from 'vue-router';

defineProps({
  icon: {
    type: String,
    default:null
  },
  label: {
    type: String,
    default:null
  },
  to: {
    type: String,
    default:null
  },
  active: Boolean
})
</script>
