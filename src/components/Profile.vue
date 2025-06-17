<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const formData = ref({
  name: '',
  email: '',
  contact_info: '',
  role: ''
})

const isEditing = ref(false)
const originalData = ref({})

onMounted(() => {
  const mockUserData = {
    name: 'Prof. Dr. Amtsal Jago Banget',
    email: '6010000001@student.its.ac.id',
    contact_info: '001-503-915-0536',
    role: 'dosen'
  }
  
  formData.value = { ...mockUserData }
  originalData.value = { ...mockUserData }
})

const toggleEdit = () => {
  if (isEditing.value) {
    formData.value = { ...originalData.value }
  }
  isEditing.value = !isEditing.value
}

const saveProfile = () => {
  console.log('Saving profile:', formData.value)
  
  originalData.value = { ...formData.value }
  isEditing.value = false
  
  alert('Profil berhasil diperbarui!')
}

const navigateToDashboard = () => {
  router.push('/dashboard')
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
        
        <h1 class="text-2xl be-vietnam-pro-semibold text-[#202326] pb-1">Profil Pengguna</h1>
        <hr class="border-gray-300" />
      </div>

      <!-- Profile Card -->
      <div class="bg-white shadow-sm rounded-lg overflow-hidden">
        <!-- Profile Header -->
        <div class="bg-gradient-to-r from-cyan-500 to-blue-500 p-6 text-white">
          <div class="flex items-center gap-4">
            <div class="w-20 h-20 rounded-full bg-white/20 flex items-center justify-center">
              <img src="/profile-picture.png" alt="Profile Picture" class="w-16 h-16 rounded-full">
            </div>
            <div>
              <h2 class="text-xl font-semibold">{{ formData.name }}</h2>
              <p class="text-blue-100 capitalize">{{ formData.role }}</p>
            </div>
          </div>
        </div>

        <!-- Profile Form -->
        <div class="p-6">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg be-vietnam-pro-medium text-gray-800">Informasi Pribadi</h3>
            <button
              @click="toggleEdit"
              :class="[
                'px-4 py-2 rounded-md text-sm font-medium transition-colors',
                isEditing ? 'bg-gray-500 hover:bg-gray-600 text-white' : 'bg-blue-600 hover:bg-blue-700 text-white'
              ]"
            >
              {{ isEditing ? 'Batal' : 'Edit Profil' }}
            </button>
          </div>

          <form @submit.prevent="saveProfile" class="space-y-6">
            <!-- Name Field -->
            <div>
              <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
                Nama Lengkap
              </label>
              <input
                type="text"
                id="name"
                v-model="formData.name"
                :disabled="!isEditing"
                :class="[
                  'w-full px-3 py-2 border rounded-md shadow-sm text-sm',
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
                :disabled="!isEditing"
                :class="[
                  'w-full px-3 py-2 border rounded-md shadow-sm text-sm',
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
                :disabled="!isEditing"
                :class="[
                  'w-full px-3 py-2 border rounded-md shadow-sm text-sm',
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
                class="w-full px-3 py-2 border border-gray-200 bg-gray-50 text-gray-600 rounded-md shadow-sm text-sm capitalize"
              >
              <p class="text-xs text-gray-500 mt-1">Peran tidak dapat diubah</p>
            </div>

            <!-- Save Button -->
            <div v-if="isEditing" class="flex gap-3 pt-4">
              <button
                type="submit"
                class="flex-1 bg-blue-600 text-white font-semibold py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition-all duration-300"
              >
                Simpan Perubahan
              </button>
            </div>
          </form>
        </div>
      </div>
      <div class="h-8"></div>
      <!-- Additional Information Card -->
      <div class="bg-white shadow-sm rounded-lg mt-6 p-6">
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
.be-vietnam-pro-thin {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 100;
  font-style: normal;
}

.be-vietnam-pro-extralight {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 200;
  font-style: normal;
}

.be-vietnam-pro-light {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 300;
  font-style: normal;
}

.be-vietnam-pro-regular {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 400;
  font-style: normal;
}

.be-vietnam-pro-medium {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 500;
  font-style: normal;
}

.be-vietnam-pro-semibold {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 600;
  font-style: normal;
}

.be-vietnam-pro-bold {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 700;
  font-style: normal;
}

.be-vietnam-pro-extrabold {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 800;
  font-style: normal;
}

.be-vietnam-pro-black {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 900;
  font-style: normal;
}
</style>