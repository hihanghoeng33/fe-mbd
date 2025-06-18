<script setup>
console.log('Main component loaded');
import Navbar from './Navbar.vue';
import Sidebar from './Sidebar.vue';

console.log('Halo dari main');

</script>

<template>
  <div class="min-h-screen min-w-screen bg-gray-100">
    <Navbar />
    <div class="h-8"></div>
    <div class="mt-8 flex flex-1 m-5 pt-16">
      <Sidebar class=" w-64 " />
      <main class="flex-1 p-8 overflow-hidden">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<style scoped>

</style>