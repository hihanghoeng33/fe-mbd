<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { projectService } from '../services/projectService.js';

const route = useRoute();
const activeTab = ref("deskripsi");
const project = ref(null);
const milestones = ref([]);
const milestonesLoading = ref(false);
const milestonesError = ref('');
const loading = ref(false);
const error = ref('');

const tabs = [
  { name: "Deskripsi", value: "deskripsi" },
  { name: "Milestones", value: "milestones" },
  { name: "Dokumen", value: "dokumen" },
  { name: "Peserta", value: "peserta" },
];

const loadProjectDetails = async () => {
  loading.value = true;
  error.value = '';
  
  try {
    const projectId = route.params.id || route.query.id;
    if (!projectId) {
      error.value = 'Project ID tidak ditemukan';
      return;
    }
    
    console.log('Loading project details for ID:', projectId);
    const projectData = await projectService.getProjectById(projectId);
    project.value = projectData;
    console.log('Loaded project:', projectData);
    
  } catch (err) {
    console.error('Error loading project details:', err);
    error.value = 'Gagal memuat detail proyek';
  } finally {
    loading.value = false;
  }
};

const loadProjectMilestones = async () => {
  if (!route.params.id) return;
  
  milestonesLoading.value = true;
  milestonesError.value = '';
  
  try {
    console.log('Loading milestones for project ID:', route.params.id);
    const milestonesData = await projectService.getProjectMilestones(route.params.id);
    milestones.value = milestonesData;
    console.log('Loaded milestones:', milestonesData);
  } catch (err) {
    console.error('Error loading milestones:', err);
    milestonesError.value = 'Gagal memuat milestones proyek';
  } finally {
    milestonesLoading.value = false;
  }
};

const formatDate = (dateString) => {
  if (!dateString) return '-';
  return new Date(dateString).toLocaleDateString('id-ID', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
};

const getStatusColor = (status) => {
  if (!status) return 'bg-gray-500';
  const statusUpper = status.toUpperCase();
  if (statusUpper === 'COMPLETED') return 'bg-green-500';
  if (statusUpper === 'ONGOING') return 'bg-blue-500';
  if (statusUpper === 'PLANNING') return 'bg-yellow-500';
  return 'bg-gray-500';
};

const getStatusText = (status) => {
  if (!status) return 'Tidak Diketahui';
  const statusUpper = status.toUpperCase();
  if (statusUpper === 'COMPLETED') return 'Selesai';
  if (statusUpper === 'ONGOING') return 'Sedang Berjalan';
  if (statusUpper === 'PLANNING') return 'Perencanaan';
  return status;
};

const getCategoriesArray = (categories) => {
  if (!categories) return [];
  return categories.split(',').map(cat => cat.trim()).filter(cat => cat);
};

const formatDateTime = (dateTimeString) => {
  if (!dateTimeString) return '-';
  return new Date(dateTimeString).toLocaleDateString('id-ID', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const getMilestoneStatusColor = (status) => {
  if (!status) return 'bg-gray-500';
  const statusUpper = status.toUpperCase();
  if (statusUpper === 'COMPLETED') return 'bg-green-500';
  if (statusUpper === 'IN_PROGRESS') return 'bg-blue-500';
  if (statusUpper === 'PLANNED') return 'bg-yellow-500';
  return 'bg-gray-500';
};

const getMilestoneStatusText = (status) => {
  if (!status) return 'Tidak Diketahui';
  const statusUpper = status.toUpperCase();
  if (statusUpper === 'COMPLETED') return 'Selesai';
  if (statusUpper === 'IN_PROGRESS') return 'Sedang Dikerjakan';
  if (statusUpper === 'PLANNED') return 'Direncanakan';
  return status;
};

const getMilestoneProgress = () => {
  if (milestones.value.length === 0) return { completed: 0, total: 0, percentage: 0 };
  
  const completed = milestones.value.filter(m => m.status.toUpperCase() === 'COMPLETED').length;
  const total = milestones.value.length;
  const percentage = Math.round((completed / total) * 100);
  
  return { completed, total, percentage };
};

onMounted(async () => {
  await loadProjectDetails();
  await loadProjectMilestones();
});
</script>

<template>
  <div class="flex">
    <!-- Tabs -->
    <div class="flex flex-col w-48 bg-gray-200 p-4 gap-y-2 rounded-l-lg">
      <button
        v-for="tab in tabs"
        :key="tab.value"
        @click="activeTab = tab.value"
        :class="[
          'relative block w-full text-left px-4 py-2 rounded-lg font-medium transition',
          activeTab === tab.value
            ? 'bg-blue-500 text-white'
            : 'hover:bg-gray-300 text-gray-700',
        ]"
      >
        {{ tab.name }}
      </button>
    </div>

    <!-- Content -->
    <div class="flex-1 p-6 bg-gray-200">
      <!-- Loading State -->
      <div v-if="loading" class="flex items-center justify-center h-64">
        <div class="text-center">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p class="text-gray-600">Memuat detail proyek...</p>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg">
        <div class="flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" class="mr-2">
            <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"/>
          </svg>
          {{ error }}
        </div>
      </div>

      <!-- Project Content -->
      <div v-else-if="project">
        <!-- Description Tab -->
        <div class="text-gray-700" v-if="activeTab === 'deskripsi'">
          <div class="bg-white rounded-lg p-6 mb-6">
            <h1 class="text-2xl font-bold text-gray-800 mb-4">{{ project.title }}</h1>
            
            <!-- Status Badge -->
            <div class="flex items-center gap-2 mb-4">
              <div :class="['w-3 h-3 rounded-full', getStatusColor(project.status)]"></div>
              <span class="text-sm font-medium">{{ getStatusText(project.status) }}</span>
            </div>

            <!-- Categories -->
            <div v-if="getCategoriesArray(project.categories).length > 0" class="mb-4">
              <h3 class="text-sm font-medium text-gray-600 mb-2">Kategori:</h3>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="category in getCategoriesArray(project.categories)"
                  :key="category"
                  class="bg-blue-200 text-gray-700 text-xs font-medium px-2.5 py-0.5 rounded"
                >
                  {{ category }}
                </span>
              </div>
            </div>

            <!-- Project Timeline -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <div>
                <h3 class="text-sm font-medium text-gray-600 mb-1">Tanggal Mulai:</h3>
                <p class="text-gray-800">{{ formatDate(project.start_date) }}</p>
              </div>
              <div>
                <h3 class="text-sm font-medium text-gray-600 mb-1">Tanggal Selesai:</h3>
                <p class="text-gray-800">{{ formatDate(project.end_date) }}</p>
              </div>
            </div>

            <!-- Description -->
            <div>
              <h3 class="text-lg font-semibold text-gray-800 mb-2">Deskripsi Proyek</h3>
              <div class="text-gray-700 leading-relaxed">
                <p v-if="project.description">{{ project.description }}</p>
                <p v-else class="text-gray-500 italic">Tidak ada deskripsi tersedia.</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Milestones Tab -->
        <div class="text-gray-700" v-else-if="activeTab === 'milestones'">
          <div class="bg-white rounded-lg p-6">
            <div class="flex justify-between items-center mb-6">
              <h2 class="text-xl font-bold">Milestones Proyek</h2>
              <div v-if="milestones.length > 0" class="text-sm text-gray-600">
                {{ getMilestoneProgress().completed }}/{{ getMilestoneProgress().total }} selesai ({{ getMilestoneProgress().percentage }}%)
              </div>
            </div>

            <!-- Progress Bar -->
            <div v-if="milestones.length > 0" class="mb-6">
              <div class="bg-gray-200 rounded-full h-3">
                <div 
                  class="bg-green-500 h-3 rounded-full transition-all duration-300"
                  :style="{ width: getMilestoneProgress().percentage + '%' }"
                ></div>
              </div>
            </div>

            <!-- Loading State -->
            <div v-if="milestonesLoading" class="flex items-center justify-center py-8">
              <div class="text-center">
                <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"></div>
                <p class="text-gray-600">Memuat milestones...</p>
              </div>
            </div>

            <!-- Error State -->
            <div v-else-if="milestonesError" class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg">
              <div class="flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" class="mr-2">
                  <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
                {{ milestonesError }}
              </div>
            </div>

            <!-- Milestones List -->
            <div v-else-if="milestones.length > 0" class="space-y-4">
              <div 
                v-for="milestone in milestones" 
                :key="milestone.milestone_id"
                class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
              >
                <div class="flex items-start justify-between mb-3">
                  <div class="flex-1">
                    <h3 class="text-lg font-semibold text-gray-800 mb-1">{{ milestone.title }}</h3>
                    <div class="flex items-center gap-2 mb-2">
                      <div :class="['w-3 h-3 rounded-full', getMilestoneStatusColor(milestone.status)]"></div>
                      <span class="text-sm font-medium">{{ getMilestoneStatusText(milestone.status) }}</span>
                    </div>
                  </div>
                  <div class="text-right text-sm text-gray-500">
                    <div v-if="milestone.due_date">
                      <strong>Deadline:</strong><br>
                      {{ formatDate(milestone.due_date) }}
                    </div>
                  </div>
                </div>

                <div v-if="milestone.description" class="mb-3">
                  <p class="text-gray-700 text-sm leading-relaxed">{{ milestone.description }}</p>
                </div>

                <div class="flex justify-between items-center text-xs text-gray-500">
                  <span>Dibuat: {{ formatDateTime(milestone.created_at) }}</span>
                  <span v-if="milestone.due_date" 
                    :class="[
                      new Date(milestone.due_date) < new Date() && milestone.status.toUpperCase() !== 'COMPLETED' 
                        ? 'text-red-600 font-medium' 
                        : 'text-gray-500'
                    ]"
                  >
                    {{ new Date(milestone.due_date) < new Date() && milestone.status.toUpperCase() !== 'COMPLETED' ? 'Terlambat' : '' }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Empty State -->
            <div v-else class="text-center py-12">
              <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" class="mx-auto mb-4 text-gray-400">
                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M7 13.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5"/>
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Belum Ada Milestones</h3>
              <p class="text-gray-500">Proyek ini belum memiliki milestones yang didefinisikan.</p>
            </div>
          </div>
        </div>

        <!-- Documents Tab -->
        <div class="text-gray-700" v-else-if="activeTab === 'dokumen'">
          <div class="bg-white rounded-lg p-6">
            <h2 class="text-xl font-bold mb-4">Dokumen Proyek</h2>
            <div class="bg-yellow-50 border border-yellow-200 p-4 rounded-lg">
              <p class="text-yellow-800">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" class="inline mr-2">
                  <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
                Fitur dokumen sedang dalam pengembangan.
              </p>
            </div>
          </div>
        </div>

        <!-- Participants Tab -->
        <div class="text-gray-700" v-else-if="activeTab === 'peserta'">
          <div class="bg-white rounded-lg p-6">
            <h2 class="text-xl font-bold mb-4">Peserta Proyek</h2>
            <div class="bg-yellow-50 border border-yellow-200 p-4 rounded-lg">
              <p class="text-yellow-800">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" class="inline mr-2">
                  <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
                Fitur peserta sedang dalam pengembangan.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>