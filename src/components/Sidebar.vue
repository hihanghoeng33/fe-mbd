<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from "vue-router";
import NavItem from "./NavItem.vue";
import { authService } from '../services/authService.js';

console.log('Sidebar component is loading...');

const route = useRoute();
const router = useRouter();
const user = ref(null);
const navItems = ref([]);
const loading = ref(true);

const navigateTo = (path) => {
  console.log('Navigating to:', path);
  router.push(path);
};

// Fetch user data on component mount
onMounted(async () => {
  console.log('Sidebar onMounted triggered');
  
  try {
    // Check if user is authenticated first
    const isAuth = authService.isAuthenticated();
    console.log('Is authenticated:', isAuth);
    
    if (!isAuth) {
      console.log('Not authenticated, redirecting to login');
      window.location.href = '/login';
      return;
    }

    // First try to get user from localStorage
    const storedUser = authService.getCurrentUser();
    console.log('Stored user from localStorage:', storedUser);
    
    if (storedUser) {
      user.value = storedUser;
      console.log('User data loaded from localStorage:', user.value);
    } else {
      // If authenticated but no user data, fetch from API
      console.log('Fetching user data from API...');
      const userData = await authService.getCurrentUserProfile();
      user.value = userData;
      console.log('User data loaded from API:', user.value);
    }
  } catch (error) {
    console.error('Error loading user data in sidebar:', error);
  } finally {
    loading.value = false;
    console.log('Sidebar loading finished, loading state:', loading.value);
  }
});

const sideBarCondition = () => {
  console.log('Setting up sidebar condition for user:', user.value);
  
  if (!user.value) {
    console.log('No user data available for sidebar condition');
    return;
  }
  
  console.log('User role:', user.value.role);
  
  if (user.value.role === "mahasiswa") {
    navItems.value = [
      { icon: "/home.png", label: "Beranda", to: "/dashboard" },
      { icon: "/briefcase.png", label: "Daftar Proyek", to: "/projects" },
      { icon: "/Arsip.png", label: "Arsip", to: "/archive" },
    ];
  }else if (user.value.role === "dosen") {
    navItems.value = [
      { icon: "/home.png", label: "Beranda", to: "/lecturerhome" },
      { icon: "/kelola-proyek.png", label: "Kelola Proyek", to: "/projectsmanagement" },
      { icon: "/Arsip.png", label: "Arsip", to: "/lecturerarchive" },
    ];
    console.log('Set dosen nav items:', navItems.value);
  } else if (user.value.role === "admin") {
    navItems.value = [
      { icon: "/home.png", label: "Beranda", to: "/adminhome" },
      { icon: "/list.png", label: "Daftar Proyek", to: "/listofproject" },
    ];
    console.log('Set admin nav items:', navItems.value);
  } else {
    console.log('Unknown user role:', user.value.role);
  }
};

// Watch for user data changes and update nav items
watch(user, (newUser) => {
  console.log('User data changed, new user:', newUser);
  sideBarCondition();
}, { immediate: true });

// Debug navItems changes
watch(navItems, (newNavItems) => {
  console.log('Nav items changed:', newNavItems);
}, { deep: true });
</script>

<template>
  <!-- Main Sidebar -->
  <aside v-if="!loading && user" class="lg:w-64 md:w-32 sm:w-0 gap-4 min-h-screen px-6 py-4">
    <!-- Menu navigasi -->
    <nav class="gap-y-6 flex flex-col">
      <NavItem
        v-for="(item, index) in navItems"
        :key="index"
        @click="navigateTo(item.to)"
        :icon="item.icon"
        :label="item.label"
        :to="item.to"
        :active="item.to === $route.path"
        class="flex gap-2"
      />
    </nav>
  </aside>
</template>