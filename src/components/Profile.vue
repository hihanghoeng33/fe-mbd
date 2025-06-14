<script setup>
</script>

<template>
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
        <div class="bg-white shadow-md rounded-lg p-6 w-full max-w-md">
        <h1 class="text-2xl font-semibold mb-4">Profile</h1>
        <p class="text-gray-600 mb-6">Welcome to your profile page!</p>
        <button
            @click="$router.push('/dashboard')"
            class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700 transition-colors"
        >
            Go to Dashboard
        </button>
        </div>
    </div>
</template>

<style>
</style>