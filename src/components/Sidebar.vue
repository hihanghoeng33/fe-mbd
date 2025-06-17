<script setup>
import { useRoute } from "vue-router";
import NavItem from "./NavItem.vue";
const route = useRoute();
const navigateTo = (path) => {
  route.push(path);
};
const user = JSON.parse(localStorage.getItem("user"));

let navItems = [];
// const sideBarCondition = () => {
//   if (user.role === "mahasiswa") {
//     navItems = [
//       { icon: "/home.png", label: "Beranda", to: "/dashboard" },
//       { icon: "/briefcase.png", label: "Daftar Proyek", to: "/projects" },
//       { icon: "/Arsip.png", label: "Arsip", to: "/arsip" },
//     ];
//   } else if (user.role === "dosen") {
//     navItems = [
//       { icon: "/home.png", label: "Beranda", to: "/dashboard" },
//       { icon: "/kelola-proyek.png", label: "Daftar Proyek", to: "/projectsmanagement" },
//       { icon: "/Arsip.png", label: "Arsip", to: "/arsipdosen" },
//     ];
//   } else if (user.role === "admin") {
//     navItems = [
//       { icon: "/home.png", label: "Beranda", to: "/admin-dashboard" },
//       { icon: "/list.png", label: "Daftar Proyek", to: "/listofproject" },
//     ];
//   } else {
//     window.location.href = "/login";
//   }
  
// };

// sideBarCondition();
  navItems = [
      { icon: "/home.png", label: "Beranda", to: "/dashboard" },
      { icon: "/briefcase.png", label: "Daftar Proyek", to: "/projects" },
      { icon: "/Arsip.png", label: "Arsip", to: "/arsip" },
    ];
</script>

<template>
  <aside class="lg:w-64 md:w-32 sm:w-0 gap-4 min-h-screen px-6 py-4">
    <!-- Menu navigasi -->
    <nav class="gap-y-6 flex flex-col">
      <NavItem
        @click="navigateTo(item.to)"
        v-for="(item, index) in navItems"
        :key="index"
        :icon="item.icon"
        :label="item.label"
        :to="item.to"
        :active="item.to === $route.path"
        class="flex gap-2"
      />
    </nav>
  </aside>
</template>
