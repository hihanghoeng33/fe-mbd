<script setup>
import { computed } from 'vue';

const props = defineProps({
  title: {
    type: String,
    default: "Judul Proyek",
  },
  author: {
    type: String,
    default: "Nama Dosen",
  },
  image: {
    type: String,
    default: "/default-project.png",
  },
  category: {
    type: String,
    default: "",
  },
  filled: {
    type: Number,
    default: 0,
  },
  total: {
    type: Number,
    default: 1,
  }
});

const slots = defineSlots();

const barColor = computed(() => {
  const percent = (props.filled/props.total) * 100;
  if(percent>=80) return 'bg-red-500'
  if(percent>=50) return 'bg-yellow-500'
  return 'bg-green-500'
})
</script>

<template>
  <div
    class="bg-[#E8EDF2] shadow-md hover:shadow-lg transition-shadow overflow-hidden rounded-lg w-96"
  >
    <img :src="image" :alt="title" class="w-96 h-48 object-cover" />
    <div class="p-4">
      <h3 class="text-lg font-semibold text-gray-800 mb-1">
        {{ title }}
      </h3>
      <p class="text-sm text-gray-500">Oleh {{ author }}</p>
      <div class="container pt-2">
        <div class="flex flex-wrap gap-2">
          <span
            v-if="category"
            class="bg-blue-200 text-gray-700 text-xs font-medium px-2.5 py-0.5 rounded"
          >
            {{ category }}
          </span>
        </div>
      </div>
      <!-- Quota -->
      <div class="container pt-4">
        <p class="text-xs font-semibold text-gray-600">
          {{ filled }}/{{ total }} Pendaftar
        </p>

        <div class=" bg-gray-300 rounded-full h-2 mt-1 max-w-60">
          <div
            :class="[barColor, 'h-2 rounded-full', 'max-w-full']"
            :style="{ width: (filled / total) * 100 + '%' }"
          ></div>
        </div>
      </div>
    </div>

    <!-- button div -->
    <div class="flex items-end justify-end gap-x-4 p-4">
      <slot name="actions">
        <button
          class="bg-gray-100 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-800 h-10 w-22"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            viewBox="0 0 1024 1024"
          >
            <path
              d="M104.704 338.752a64 64 0 0 1 90.496 0l316.8 316.8l316.8-316.8a64 64 0 0 1 90.496 90.496L557.248 791.296a64 64 0 0 1-90.496 0L104.704 429.248a64 64 0 0 1 0-90.496"
            />
          </svg>
          <span class="text-sm">Role</span>
        </button>
        <button
          class="bg-gradient-to-t from-[#07C8F9] from-5% to-blue-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="M11 17h2v-6h-2zm1-8q.425 0 .713-.288T13 8t-.288-.712T12 7t-.712.288T11 8t.288.713T12 9m0 13q-2.075 0-3.9-.788t-3.175-2.137T2.788 15.9T2 12t.788-3.9t2.137-3.175T8.1 2.788T12 2t3.9.788t3.175 2.137T21.213 8.1T22 12t-.788 3.9t-2.137 3.175t-3.175 2.138T12 22"
            />
          </svg>
          <span class="text-sm">Daftar</span>
        </button>
      </slot>
    </div>
  </div>
</template>