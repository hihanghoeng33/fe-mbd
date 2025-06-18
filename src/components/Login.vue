<template>
    <div class="container flex flex-col items-center justify-center min-h-screen min-w-screen bg-gradient-to-l from-cyan-500 to-blue-500">
        <div class="bg-black/70 p-8 rounded-lg shadow-md w-full max-w-sm gap-y-4 backdrop-blur-md text-white flex flex-col">
            <h1 class="text-xl font-bold mb-6 text-white">Login sesuai email dan password anda</h1>
            
            <!-- Error message -->
            <div v-if="errorMessage" class="bg-red-500 text-white p-3 rounded mb-4 text-sm">
                {{ errorMessage }}
            </div>
            
            <form @submit.prevent="handleLogin" class="flex flex-col gap-y-4">
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
                    {{ loading ? 'Logging in...' : 'Login' }}
                </button>
            </form>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '../services/authService.js'

const router = useRouter()

const formData = ref({
  email: '',
  password: ''
})

const loading = ref(false)
const errorMessage = ref('')

const handleLogin = async () => {
  loading.value = true
  errorMessage.value = ''
  
  try {
    console.log('Attempting login...');
    const response = await authService.login(formData.value.email, formData.value.password)
    console.log('Login response received:', response);
    
    // Wait a bit for user data to be stored
    await new Promise(resolve => setTimeout(resolve, 100));
    
    const userData = authService.getCurrentUser()
    console.log('User data after login:', userData);
    
    if (userData) {
      if (userData.role === 'dosen') {
        console.log('Redirecting to lecturer home');
        router.push('/lecturerhome')
      } else {
        console.log('Redirecting to dashboard');
        router.push('/dashboard')
      }
    } else {
      console.error('No user data available after login');
      errorMessage.value = 'Login successful but failed to load user data. Please refresh the page.';
    }
  } catch (error) {
    console.error('Login error:', error);
    errorMessage.value = error.message || 'Login failed. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
</style>