<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '../services/authService.js'

const router = useRouter()
const user = ref(null)
const showDropdown = ref(false)

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
const akses = computed(() => user.value?.role || 'unknown')

// Get user identifier (user_id or name)
const userIdentifier = computed(() => {
  if (!user.value) return ''
  return user.value.user_id || user.value.name || 'User'
})

// Navigation functions
const navigate = () => {
  router.push('/profile')
}

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value
}

const handleLogout = () => {
  try {
    authService.logout()
    console.log('User logged out successfully')
    // Redirect to login page
    router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
  }
}

// Close dropdown when clicking outside
const closeDropdown = () => {
  showDropdown.value = false
}
</script>

<template>
  <nav class="bg-white shadow-sm fixed top-0 left-0 right-0 z-20 px-6 py-4 flex items-center justify-between gap-x-4">
    <div class="flex items-center gap-x-4">
      <img src="/entypo_lab-flask.ico" alt="ITS Logo" class="h-8 w-8 mr-3">
      <div class="text-lg be-vietnam-pro-bold text-gray-800 max-w-64">
        ITS Research & Collaboration Center
      </div>
    </div>
    <div class="flex items-center gap-x-8">
      <div class="flex items-center gap-x-2 border border-[#0066FF] text-[#0066FF] px-4 py-2 rounded-md text-sm be-vietnam-pro-regular mr-8">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
          <path fill="currentColor"
            d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3s1.34 3 3 3m-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5S5 6.34 5 8s1.34 3 3 3m0 2c-2.33 0-7 1.17-7 3.5V18c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-1.5c0-2.33-4.67-3.5-7-3.5m8 0c-.29 0-.62.02-.97.05c.02.01.03.03.04.04c1.14.83 1.93 1.94 1.93 3.41V18c0 .35-.07.69-.18 1H22c.55 0 1-.45 1-1v-1.5c0-2.33-4.67-3.5-7-3.5" />
        </svg>
        <span v-if="akses === 'mahasiswa'">Hak Akses: Mahasiswa</span>
        <span v-else-if="akses === 'dosen'">Hak Akses: Dosen</span>
        <span v-else-if="akses === 'admin'">Hak Akses: Admin</span>
        <span v-else>Loading...</span>
      </div>
      
      <!-- User Profile Dropdown -->
      <div class="relative">
        <div 
          @click="toggleDropdown"
          class="w-8 h-8 rounded-full bg-gray-300 flex items-center justify-center cursor-pointer select-none hover:bg-gray-400 transition-colors"
        >
          <img src="/profile-picture.png" alt="Profile Picture" class="w-auto h-auto rounded-full">
        </div>
        
        <!-- Dropdown Menu -->
        <div 
          v-if="showDropdown" 
          @click="closeDropdown"
          class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-30 border border-gray-200"
        >
          <!-- User Info -->
          <div class="px-4 py-2 text-sm text-gray-700 border-b border-gray-100">
            <div class="font-medium">{{ user?.name || 'Loading...' }}</div>
            <div class="text-xs text-gray-500">{{ userIdentifier }}</div>
          </div>
          
          <!-- Profile Link -->
          <button 
            @click="navigate"
            class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 flex items-center gap-2"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
              <path fill="currentColor" d="M12 2A10 10 0 0 0 2 12a10 10 0 0 0 10 10a10 10 0 0 0 10-10A10 10 0 0 0 12 2M7.07 18.28c.43-.9 3.05-1.78 4.93-1.78s4.51.88 4.93 1.78A7.893 7.893 0 0 1 12 20c-1.86 0-3.57-.64-4.93-1.72m11.29-1.45c-1.43-1.74-4.9-2.33-6.36-2.33s-4.93.59-6.36 2.33A7.928 7.928 0 0 1 4 12c0-4.41 3.59-8 8-8s8 3.59 8 8c0 1.82-.62 3.5-1.64 4.83M12 6c-1.94 0-3.5 1.56-3.5 3.5S10.06 13 12 13s3.5-1.56 3.5-3.5S13.94 6 12 6m0 5c-.83 0-1.5-.67-1.5-1.5S11.17 8 12 8s1.5.67 1.5 1.5S12.83 11 12 11Z"/>
            </svg>
            Lihat Profil
          </button>
          
          <!-- Logout Button -->
          <button 
            @click="handleLogout"
            class="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
              <path fill="currentColor" d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.59L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/>
            </svg>
            Keluar
          </button>
        </div>
      </div>
    </div>
    
    <!-- Backdrop for closing dropdown -->
    <div 
      v-if="showDropdown" 
      @click="closeDropdown"
      class="fixed inset-0 z-20"
    ></div>
  </nav>
</template>