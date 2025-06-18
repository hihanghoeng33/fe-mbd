<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '../services/authService.js'

const router = useRouter()

const formData = ref({
  user_id: '',
  name: '',
  email: '',
  contact_info: '',
  role: ''
})

const isEditing = ref(false)
const originalData = ref({})
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

onMounted(async () => {
  await fetchUserProfile()
})

const fetchUserProfile = async () => {
  loading.value = true
  errorMessage.value = ''
  
  try {
    const userData = await authService.getCurrentUserProfile()
    formData.value = { ...userData }
    originalData.value = { ...userData }
  } catch (error) {
    errorMessage.value = 'Failed to load profile data'
    console.error('Error fetching profile:', error)
  } finally {
    loading.value = false
  }
}

const toggleEdit = () => {
  if (isEditing.value) {
    formData.value = { ...originalData.value }
  }
  isEditing.value = !isEditing.value
}

const saveProfile = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''
  
  try {
    const updateData = {
      name: formData.value.name,
      email: formData.value.email,
      contact_info: formData.value.contact_info
    }
    
    await authService.updateProfile(updateData)
    
    originalData.value = { ...formData.value }
    isEditing.value = false
    
    successMessage.value = 'Profil berhasil diperbarui!'
    
    setTimeout(() => {
      successMessage.value = ''
    }, 3000)
    
  } catch (error) {
    errorMessage.value = error.message || 'Failed to update profile'
    console.error('Error updating profile:', error)
  } finally {
    loading.value = false
  }
}

const navigateToDashboard = () => {
  router.push('/dashboard')
}

// Add logout functionality
const handleLogout = () => {
  try {
    authService.logout()
    console.log('User logged out from profile page')
    router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
  }
}
</script>

<template>
  <div class="min-h-screen max-w-screen justify-center items-center p-6 gap-y-4">
    <div class="max-w-2xl mx-auto justify-center items-center">
      <!-- Header -->
      <div class="mb-6 pb-4">
        <button 
          @click="navigateToDashboard"
          class="pb-2 flex items-center gap-2 text-gray-600 hover:text-gray-800 mb-4 transition-colors"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
            <path fill="currentColor" d="M20 11H7.83l5.59-5.59L12 4l-8 8l8 8l1.41-1.41L7.83 13H20v-2z"/>
          </svg>
          <span class="text-sm">Kembali ke Dashboard</span>
        </button>
        <div class="flex justify-between items-center">
          <div>
            <h1 class="text-2xl be-vietnam-pro-semibold text-[#202326] pb-1">Profil Pengguna</h1>
          </div>
          <!-- Logout Button -->
          <button 
            @click="handleLogout"
            class="flex items-center gap-2 px-4 py-2 text-red-600 hover:bg-red-500 hover:text-gray-50 rounded-md transition-colors"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
              <path fill="currentColor" d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.59L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/>
            </svg>
            <span class="text-sm">Keluar</span>
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading && !formData.name" class="bg-white shadow-sm rounded-lg p-6">
        <div class="animate-pulse">
          <div class="h-4 bg-gray-200 rounded w-1/4 mb-4"></div>
          <div class="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
          <div class="h-4 bg-gray-200 rounded w-3/4"></div>
        </div>
      </div>

      <!-- Error Message -->
      <div v-if="errorMessage" class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg mb-6">
        {{ errorMessage }}
      </div>

      <!-- Success Message -->
      <div v-if="successMessage" class="bg-green-50 border border-green-200 text-green-700 p-4 rounded-lg mb-6">
        {{ successMessage }}
      </div>

      <!-- Profile Card -->
      <div v-if="formData.name" class="bg-white rounded-lg overflow-hidden">
        <!-- Profile Header -->
        <div class="bg-gradient-to-r from-cyan-500 to-blue-500 p-6 text-white">
          <div class="flex items-center gap-4">
            <div class="w-20 h-20 rounded-full bg-white/20 flex items-center justify-center">
              <img src="/profile-picture.png" alt="Profile Picture" class="w-16 h-16 rounded-full">
            </div>
            <div>
              <h2 class="text-xl font-semibold">{{ formData.name }}</h2>
              <p class="text-blue-100 capitalize">{{ formData.role === 'dosen' ? 'Dosen' : formData.role === 'mahasiswa' ? 'Mahasiswa' : 'Admin' }}</p>
              <p class="text-blue-100 text-sm">{{ formData.user_id }}</p>
            </div>
          </div>
        </div>

        <!-- Profile Form -->
        <div class="p-6">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg be-vietnam-pro-medium text-gray-800">Informasi Pribadi</h3>
            <button
              @click="toggleEdit"
              :disabled="loading"
              :class="[
                'px-4 py-2 rounded-md text-sm font-medium transition-colors disabled:opacity-50',
                isEditing ? 'bg-gray-500 hover:bg-gray-600 text-white' : 'bg-blue-600 hover:bg-blue-700 text-white'
              ]"
            >
              {{ isEditing ? 'Batal' : 'Edit Profil' }}
            </button>
          </div>

          <form @submit.prevent="saveProfile" class="space-y-6">
            <!-- User ID Field (Read-only) -->
            <div>
              <label for="user_id" class="block text-sm font-medium text-gray-700 mb-2">
                ID Pengguna
              </label>
              <input
                type="text"
                id="user_id"
                :value="formData.user_id"
                disabled
                class="w-full px-3 py-2 border border-gray-200 bg-gray-50 text-gray-600 rounded-md text-sm"
              >
              <p class="text-xs text-gray-500 mt-1">ID pengguna tidak dapat diubah</p>
            </div>

            <!-- Name Field -->
            <div>
              <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
                Nama Lengkap
              </label>
              <input
                type="text"
                id="name"
                v-model="formData.name"
                :disabled="!isEditing || loading"
                :class="[
                  'w-full px-3 py-2 border rounded-md text-sm',
                  isEditing 
                    ? 'border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500' 
                    : 'border-gray-200 bg-gray-50 text-gray-600'
                ]"
                required
              >
            </div>

            <!-- Email Field -->
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                Email
              </label>
              <input
                type="email"
                id="email"
                v-model="formData.email"
                :disabled="!isEditing || loading"
                :class="[
                  'w-full px-3 py-2 border rounded-md text-sm',
                  isEditing 
                    ? 'border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500' 
                    : 'border-gray-200 bg-gray-50 text-gray-600'
                ]"
                required
              >
            </div>  

            <!-- Contact Info Field -->
            <div>
              <label for="contact_info" class="block text-sm font-medium text-gray-700 mb-2">
                Informasi Kontak
              </label>
              <input
                type="text"
                id="contact_info"
                v-model="formData.contact_info"
                :disabled="!isEditing || loading"
                :class="[
                  'w-full px-3 py-2 border rounded-md text-sm',
                  isEditing 
                    ? 'border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500' 
                    : 'border-gray-200 bg-gray-50 text-gray-600'
                ]"
                placeholder="Nomor telepon atau informasi kontak lainnya"
                required
              >
            </div>

            <!-- Role Field (Read-only) -->
            <div>
              <label for="role" class="block text-sm font-medium text-gray-700 mb-2">
                Peran
              </label>
              <input
                type="text"
                id="role"
                :value="formData.role === 'dosen' ? 'Dosen' : formData.role === 'mahasiswa' ? 'Mahasiswa' : 'Admin'"
                disabled
                class="w-full px-3 py-2 border border-gray-200 bg-gray-50 text-gray-600 rounded-md text-sm capitalize"
              >
              <p class="text-xs text-gray-500 mt-1">Peran tidak dapat diubah</p>
            </div>

            <!-- Save Button -->
            <div v-if="isEditing" class="flex gap-3 pt-4">
              <button
                type="submit"
                :disabled="loading"
                class="flex-1 bg-blue-600 text-white font-semibold py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition-all duration-300 disabled:opacity-50"
              >
                {{ loading ? 'Menyimpan...' : 'Simpan Perubahan' }}
              </button>
            </div>
          </form>
        </div>
      </div>
      <div class="h-8"></div>
      <!-- Additional Information Card -->
      <div v-if="formData.name" class="bg-white rounded-lg mt-6 p-6">
        <h3 class="text-lg be-vietnam-pro-medium text-gray-800 mb-4">Informasi Akun</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
          <div>
            <span class="text-gray-500">Status Akun:</span>
            <span class="ml-2 text-green-600 font-medium">Aktif</span>
          </div>
          <div>
            <span class="text-gray-500">Bergabung:</span>
            <span class="ml-2 text-gray-800">Januari 2024</span>
          </div>
          <div>
            <span class="text-gray-500">Terakhir Login:</span>
            <span class="ml-2 text-gray-800">Hari ini</span>
          </div>
          <div>
            <span class="text-gray-500">Proyek Aktif:</span>
            <span class="ml-2 text-gray-800">3 proyek</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* ...existing styles... */
</style>