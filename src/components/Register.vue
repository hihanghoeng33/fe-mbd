<template>
    <div class="container flex flex-col items-center justify-center min-h-screen min-w-screen bg-gradient-to-l from-cyan-500 to-blue-500">
        <div class="bg-black/70 p-8 rounded-lg shadow-md w-full max-w-sm gap-y-4 backdrop-blur-md text-white flex flex-col">
            <h1 class="text-xl font-bold mb-6 text-white">Daftar akun baru</h1>
            
            <!-- Error message -->
            <div v-if="errorMessage" class="bg-red-500 text-white p-3 rounded mb-4 text-sm">
                {{ errorMessage }}
            </div>
            
            <!-- Success message -->
            <div v-if="successMessage" class="bg-green-500 text-white p-3 rounded mb-4 text-sm">
                {{ successMessage }}
            </div>
            
            <form @submit.prevent="handleRegister" class="flex flex-col gap-y-4">
                <div class="mb-6">
                    <label for="name" class="block text-sm font-medium">Nama Lengkap</label>
                    <input 
                        type="text" 
                        id="name" 
                        v-model="formData.name"
                        placeholder="Amtsal Jago" 
                        required 
                        :disabled="loading"
                        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                    >
                </div>
                <div class="mb-4">
                    <label for="email" class="block text-sm font-medium">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        v-model="formData.email"
                        placeholder="5025231234@student.its.ac.id" 
                        required 
                        :disabled="loading"
                        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                    >
                </div>
                <div class="mb-6">
                    <label for="password" class="block text-sm font-medium">Password</label>
                    <input 
                        type="password" 
                        id="password" 
                        v-model="formData.password"
                        placeholder="password123" 
                        required 
                        :disabled="loading"
                        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                    >
                </div>
                <button 
                    type="submit" 
                    :disabled="loading"
                    class="w-full bg-blue-600 text-white font-semibold py-2 px-4 rounded hover:shadow-sm hover:shadow-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition-all duration-300 disabled:opacity-50"
                >
                    {{ loading ? 'Creating account...' : 'Daftar' }}
                </button>
            </form>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '../services/authService.js'

const router = useRouter()

const formData = ref({
  name: '',
  email: '',
  password: ''
})

const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

// Computed property to extract user ID from email
const userId = computed(() => {
  if (formData.value.email && formData.value.email.includes('@')) {
    return formData.value.email.split('@')[0]
  }
  return ''
})

// Email validation function
const isValidEmail = (email) => {
  return email.includes('@') && email.split('@')[0].length > 0
}

const handleRegister = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  if (!isValidEmail(formData.value.email)) {
    errorMessage.value = 'Email must contain @ symbol with a valid user ID before it.'
    loading.value = false
    return
  }
  
  try {
    const registrationData = {
      name: formData.value.name,
      email: formData.value.email,
      password: formData.value.password,
      user_id: userId.value
    }

    const response = await authService.register(registrationData)
    
    successMessage.value = 'Account created successfully! Redirecting...'
    
    // Redirect after a brief delay
    setTimeout(() => {
      if (response.role === 'dosen') {
        router.push('/lecturerhome')
      } else {
        router.push('/dashboard')
      }
    }, 1500)
    
  } catch (error) {
    errorMessage.value = error.message || 'Registration failed. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
</style>