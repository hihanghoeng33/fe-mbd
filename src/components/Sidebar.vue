<template>
  <aside class="w-64 min-h-screen bg-gray-50 border-r px-4 py-6">
    <div class="mb-8 flex items-center space-x-2">
      <img src="/entypo_lab-flask.ico" alt="Logo" class="w-6 h-6" />
      <h1 class="text-lg font-semibold">ITS Research & Collaboration Center</h1>
    </div>

    <!-- Menu navigasi -->
    <nav class="space-y-2">
      <NavItem
        v-for="(item, index) in navItems"
        :key="index"
        :icon="item.icon"
        :label="item.label"
        :to="item.to"
        :active="item.to === $route.path"
      />
    </nav>
  </aside>
</template>

<script setup>
import { useRoute } from 'vue-router'
import NavItem from './NavItem.vue'

const route = useRoute()

const navItems = [
  { icon: 'home', label: 'Beranda', to: '/home' },
  { icon: 'briefcase', label: 'Daftar Proyek', to: '/projects' },
  { icon: 'archive', label: 'Arsip', to: '/arsip' }
]
</script>
