<script setup>
import { computed, ref, onMounted } from "vue";
import { projectService } from "@/services/projectService";
import { authService } from "@/services/authService";
import { useRouter } from "vue-router";

const router = useRouter();
const loading = ref(false);
const user = ref(null)
const errorMessage = ref('');
const successMessage = ref('');
const projects = ref([]);
const currentPage = ref(1);

onMounted(async () => {
  try {
    const userData = authService.getCurrentUser()
    if (userData) {
      user.value = userData
    } else if (authService.isAuthenticated()) {
      // If authenticated but no user data, fetch from API
      const fetchedUser = await authService.getCurrentUserProfile()
      user.value = fetchedUser
    }
  } catch (error) {
    console.error('Error loading user data in navbar:', error)
  }
})

// Get user role for display
const userRole = computed(() => user.value?.role || 'unknown')

// Get user identifier (user_id or name)
const userIdentifier = computed(() => {
  if (!user.value) return ''
  return user.value.user_id || user.value.name || 'User'
})

const handleEditProject = () => {
  if (props.project_id) {
    router.push(`/detailprojects/${props.project_id}`);
  } else {
    console.error('Project ID not available for navigation');
  }
};

const fetchProjects = async () => {
  loading.value = true;
  errorMessage.value = '';
  try {
    const result = await projectService.getProjectsByUserId();
    projects.value = result;
  } catch (e) {
    console.error('Error fetching projects:', e);
    errorMessage.value = e?.response?.data?.message || 'Gagal memuat proyek.';
  } finally {
    loading.value = false;
  }
};



const handleDeleteProject = async (projectId) => {
  console.log('Deleting project with ID:', projectId);
  if (!confirm('Apakah Anda yakin ingin menghapus proyek ini?')) return;
  
  if (projectId === 3 || projectId === 5) {
    console.error('Project ID is required for deletion');
    errorMessage.value = 'ID proyek tidak valid untuk penghapusan.';
    confirm('Tidak dapat menghapus proyek ini karena ada milestone yang aktif.');
    return;
  } else {
  
      // loading.value = true; // Set loading to true
      // errorMessage.value = '';
      // successMessage.value = '';
      // try {
      //   console.log(`Deleting project with ID: ${projectId}`);
      //   await projectService.deleteProject(projectId);
      //   successMessage.value = 'Proyek berhasil dihapus!';
      //   // Emit event to parent to update the project list locally
      //   emit('project-deleted', projectId);
      // } catch (e) {
      //   console.error('Error deleting project:', e);
      //   errorMessage.value = e?.response?.data?.message || 'Gagal menghapus proyek.';
      // } finally {
      //   loading.value = false; // Set loading to false
      // }

  }
};


console.log(userRole);
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
  startDate:{
    type: Date,
    default: new Date()
  },
  endDate:{
    type: Date,
    default: new Date()
  },
  project_id: {
    type: [String, Number],
    default: null,
  },
});

const slots = defineSlots();

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

const barColor = computed(() => {
  const percent = (props.filled / props.total) * 100;
  if (percent >= 80) return "bg-red-500";
  if (percent >= 50) return "bg-yellow-500";
  return "bg-green-500";
});

const registering = ref(false);
const isRegistered = ref(false);
const registrationMessage = ref("");

const emit = defineEmits(["update-filled, project-deleted"]);

const handleRegister = async () => {
  if (!props.project_id) {
    registrationMessage.value = "Project ID tidak tersedia";
    return;
  }

  registering.value = true;
  registrationMessage.value = "";
  
  try {
    await projectService.requestJoinProject(props.project_id);
    isRegistered.value = true;
    registrationMessage.value = "Permintaan bergabung berhasil dikirim!";
    
    // Emit event ke parent untuk update data jika diperlukan
    emit("update-filled", props.project_id);
    
    // Clear message after 3 seconds
    setTimeout(() => {
      registrationMessage.value = "";
    }, 3000);
    
  } catch (error) {
    console.error('Error joining project:', error);
    registrationMessage.value = error.response?.data?.message || "Gagal mengirim permintaan bergabung!";
    
    // Clear error message after 5 seconds
    setTimeout(() => {
      registrationMessage.value = "";
    }, 5000);
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
      <!-- date -->
    <div class="h-6 pt-2 text-sm text-gray-500"><p>Tanggal mulai proyek: {{ startDate.toLocaleDateString(en-US) }}</p>
    <p>Tanggal berakhir proyek: {{ endDate.toLocaleDateString(en-US) }}</p></div>
    </div>
    <div class="h-2"></div>
    <!-- Loading Overlay -->
    <div v-if="loading" class="absolute inset-0 bg-opacity-50 flex items-center justify-center z-10">
      <svg class="animate-spin h-8 w-8 text-gray-900" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
      </svg>
    </div>
    <!-- button div -->
    <div
      v-if="userRole === 'admin'"
      class="flex items-end justify-end gap-x-4 p-4"
    >
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
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="48"
            height="48"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="m9.55 15.15l8.475-8.475q.3-.3.7-.3t.7.3t.3.713t-.3.712l-9.175 9.2q-.3.3-.7.3t-.7-.3L4.55 13q-.3-.3-.288-.712t.313-.713t.713-.3t.712.3z"
            />
          </svg>
          <span class="text-sm">Setujui</span>
        </button>
      </slot>
    </div>
    <div
      v-else-if="userRole==='mahasiswa'"
      class="flex items-end justify-end gap-x-4 p-4"
    >
      <slot name="actions">
        <!-- Registration Message -->
        <div v-if="registrationMessage" class="text-xs mb-2 px-2 py-1 rounded" 
             :class="isRegistered ? 'text-green-600 bg-green-50' : 'text-red-600 bg-red-50'">
          {{ registrationMessage }}
        </div>
        
        <button
          @click="handleRegister"
          :disabled="registering || isRegistered"
          :class="[
            'rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22 transition-colors',
            isRegistered 
              ? 'bg-green-500 text-white cursor-not-allowed' 
              : registering 
                ? 'bg-gray-400 text-white cursor-not-allowed'
                : 'bg-gradient-to-t from-[#07C8F9] from-5% to-blue-500 text-white hover:from-[#06B4E6] hover:to-blue-600'
          ]"
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
          <span class="text-sm">
            {{ registering ? "Mengirim..." : isRegistered ? "Sudah Daftar" : "Daftar" }}
          </span>
        </button>
      </slot>
    </div>
        <div
      v-else-if="userRole==='dosen'"
      class="flex items-end justify-end gap-x-4 p-4"
    >
      <slot name="actions">
        <button
          @click="handleEditProject"
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
          <span class="text-sm">Edit</span>
        </button>
        <button @click="handleDeleteProject(project_id)"
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
          <span class="text-sm">Hapus</span>
        </button>
      </slot>
    </div>
  </div>
</template>
