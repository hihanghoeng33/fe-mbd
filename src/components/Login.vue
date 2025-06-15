<template>
    <div class="container flex flex-col items-center justify-center min-h-screen min-w-screen bg-gradient-to-l from-cyan-500 to-blue-500">
        <div class="bg-black/70 p-8 rounded-lg shadow-md w-full max-w-sm gap-y-4 backdrop-blur-md text-white flex flex-col">
            <h1 class="text-xl font-bold mb-6 text-white">Login sesuai email dan password anda</h1>
            <form class="flex flex-col gap-y-4">
                <div class="mb-4">
                    <label for="email" class="block text-sm font-medium">Email</label>
                    <input type="email" id="email" placeholder="5025231234@student.its.ac.id" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                </div>
                <div class="mb-6">
                    <label for="password" class="block text-sm font-medium">Password</label>
                    <input type="password" id="password" placeholder="password123" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
                </div>
                <button type="submit" class="w-full bg-blue-600 text-white font-semibold py-2 px-4 rounded hover:shadow-sm hover:shadow-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition-all duration-300">Login</button>
            </form>
        </div>

    </div>
</template>
<script>
    export default{
        name: 'Login'
    }
</script>
<style scoped>

</style>