<script setup>
import { computed } from "vue";
import { RouterLink } from "vue-router";
const props = defineProps({
  title: {
    type: String,
    default: "Judul Proyek",
  },
  author: {
    type: String,
    default: "Nama Dosen",
  },
  categories: {
    type: String,
    default: "",
  },
  description: {
    type: String,
    default:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Ducimus deleniti saepe vel quasi quaerat voluptate magnam, laboriosam, id esse dolor, earum rerum pariatur. Exercitationem rem voluptas deserunt ipsa illo expedita.",
  },
  stats: String,
  to: {
    type: String,
    default: '/detailprojects'
  }
});

const categoriesArray = computed(() => {
  if (!props.categories) return [];
  
  // Handle both array and string formats
  if (Array.isArray(props.categories)) {
    return props.categories.filter(category => category && category.trim());
  }
  
  // Handle comma-separated string format
  if (typeof props.categories === 'string') {
    return props.categories
      .split(',')
      .map(category => category.trim())
      .filter(category => category);
  }
  
  return [];
});

const statColor = computed(() => {
  if (props.stats.toLowerCase() === "finished") return "bg-blue-500";
  if (props.stats.toLowerCase() === "on going") return "bg-yellow-500";
  if (props.stats.toLowerCase() === "cancelled") return "bg-gray-500";
});
</script>

<template>
  <RouterLink :to="to"
    class="bg-[#E8EDF2] shadow-md hover:shadow-lg transition-shadow overflow-hidden rounded-lg w-96"
  >
    <div class="p-4">
      <div class="h-16">
        <h3 class="text-lg font-semibold text-gray-800 mb-1 line-clamp-2">
          {{ title }}
        </h3>
      </div>

      <p class="text-sm text-gray-500">Oleh {{ author }}</p>
      <p class="text-sm text-gray-400 line-clamp-3">{{ description }}</p>
      <div class="container pt-2">
        <div class="flex flex-wrap gap-2">
          <span
            v-for="(category, index) in categoriesArray"
            :key="index"
            class="bg-blue-200 text-gray-700 text-xs font-medium px-2.5 py-0.5 rounded"
          >
            {{ category }}
          </span>
        </div>
      </div>
    </div>

    <!-- stats div -->
    <div class="flex items-center gap-2 rounded-2xl p-2 text-gray-900">
      <div :class="['w-3', 'h-3', 'rounded-full', statColor]"></div>
      <span class="text-sm">{{ stats }}</span>
    </div>
  </RouterLink>
</template>
<style></style>
