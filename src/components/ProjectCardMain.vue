<script setup>
import { computed, ref } from "vue";
import { projectService } from "@/services/projectService";
import { authService } from "@/services/authService";

let userRole = '';
const user = authService.getCurrentUser();
if (user && user.type) {
  userRole = user.type; // misal: 'admin', 'lecturer', 'student'
}

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
  filled: {
    type: Number,
    default: 0,
  },
  total: {
    type: Number,
    default: 1,
  },
  description: {
    type: String,
    default:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Ducimus deleniti saepe vel quasi quaerat voluptate magnam, laboriosam, id esse dolor, earum rerum pariatur. Exercitationem rem voluptas deserunt ipsa illo expedita.",
  },
  project_id: {
    type: [String, Number],
    default: null
  }
});

const slots = defineSlots();

const categoriesArray = computed(() => {
  if (!props.categories || props.categories.length==0) return [];
  return props.categories.split(',').map(category => category.trim()).filter(category => category);
});

const barColor = computed(() => {
  const percent = (props.filled / props.total) * 100;
  if (percent >= 80) return "bg-red-500";
  if (percent >= 50) return "bg-yellow-500";
  return "bg-green-500";
});

const registering = ref(false);
const isRegistered = ref(false); // opsional, jika ingin cek sudah daftar

const emit = defineEmits(['update-filled']);

const handleRegister = async () => {
  registering.value = true;
  try {
    await projectService.registerToProject(props.project_id, userStore.user.user_id);
    // Emit event ke parent agar parent update data project
    emit('update-filled', props.project_id);
    isRegistered.value = true;
  } catch (e) {
    alert('Gagal mendaftar!');
  } finally {
    registering.value = false;
  }
};
</script>

<template>
  <div
    class="bg-[#E8EDF2] shadow-md hover:shadow-lg transition-shadow overflow-hidden rounded-lg w-96"
  >
    <div class="p-4">
      <div class="h-16">
        <h3 class="text-lg font-semibold text-gray-800 mb-1 line-clamp-2">
          {{ title }}
        </h3>
      </div>
      <p class="text-sm text-gray-500">Oleh {{ author }}</p>
      <p class="text-sm text-gray-400 line-clamp-3 h-16">{{ description }}</p>
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
      <!-- Quota -->
      <div class="container pt-4">
        <p class="text-xs font-semibold text-gray-600">
          {{ filled }}/{{ total }} Pendaftar
        </p>

        <div class="bg-gray-300 rounded-full h-2 mt-1 max-w-60">
          <div
            :class="[barColor, 'h-2 rounded-full', 'max-w-full']"
            :style="{ width: (filled / total) * 100 + '%' }"
          ></div>
        </div>
      </div>
    </div>

    <!-- button div -->
    <div v-if="userRole='admin'" class="flex items-end justify-end gap-x-4 p-4">
      <slot name="actions">
<button
              class="bg-gray-100 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-800 h-10 w-22 hover:bg-gray-200 transition-colors"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                viewBox="0 0 24 24"
              >
                <path
                  fill="currentColor"
                  d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
                />
              </svg>
              <span class="text-sm">Tinjau</span>
            </button>
            <button
              class="bg-red-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22 hover:bg-red-600 transition-colors"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                viewBox="0 0 24 24"
              >
                <path
                  fill="currentColor"
                  d="M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21H7ZM17 6H7v13h10V6ZM9 17h2V8H9v9Zm4 0h2V8h-2v9ZM7 6v13V6Z"
                />
              </svg>
              <span class="text-sm">Tolak</span>
            </button>
            <button
              class="bg-blue-400 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-100 h-10 w-22 hover:bg-gray-200 transition-colors"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24"><path fill="currentColor" d="m9.55 15.15l8.475-8.475q.3-.3.7-.3t.7.3t.3.713t-.3.712l-9.175 9.2q-.3.3-.7.3t-.7-.3L4.55 13q-.3-.3-.288-.712t.313-.713t.713-.3t.712.3z"/></svg>
              <span class="text-sm">Setujui</span>
            </button>
      </slot>
    </div>
    <div v-else class="flex items-end justify-end gap-x-4 p-4">
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
        <button  @click="handleRegister" :disabled="registering || isRegistered"
          class="bg-gradient-to-t from-[#07C8F9] from-5% to-blue-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
            <path fill="currentColor" d="M11 17h2v-6h-2zm1-8q.425 0 .713-.288T13 8t-.288-.712T12 7t-.712.288T11 8t.288.713T12 9m0 13q-2.075 0-3.9-.788t-3.175-2.137T2.788 15.9T2 12t.788-3.9t2.137-3.175T8.1 2.788T12 2t3.9.788t3.175 2.137T21.213 8.1T22 12t-.788 3.9t-2.137 3.175t-3.175 2.138T12 22"/>
          </svg>
          <span class="text-sm">{{ isRegistered ? 'Sudah Terdaftar' : 'Daftar' }}</span>
        </button>
      </slot>
    </div>
  </div>
</template>