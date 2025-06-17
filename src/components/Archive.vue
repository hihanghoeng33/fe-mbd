<script setup>
import ProjectCardArchive from './ProjectCardArchive.vue';
const projects = [
  {
    title: 'Aplikasi Belanja Online Ramah Pengguna',
    author: 'Victoria Baldwin S.Kom., M.Kom.,',
    categories: 'Mobile, LLM',
    // image: '/project1.jpg'
    stats: 'On Going',
    description: 'Aplikasi untuk memantau aktivitas fisik dan kesehatan.'
  },
  {
    title: 'Monitoring Kesehatan IoT untuk Lansia',
    author: 'Joshua Nguyen S.Kom., M.Kom., Ph.D.',
    categories: 'IoT, Web',
    // image: '/project2.jpg'
    stats: 'finished',
    description: 'Perangkat IoT untuk memantau kesehatan lansia dari jarak jauh.'
  },
  {
    title: 'Analisis Tren Pasar Kripto',
    author: 'Amy Hernandez, S.Kom., M.Kom.',
    categories: 'Web, LLM',
    // image: '/project1.jpg'
    stats: 'On going',
    description: 'Analisis data untuk memprediksi pergerakan pasar kripto.'
  },
  {
    title: 'Riset Daur Ulang Limbah Plastik',
    author: 'Bradley Jones S.Kom., M.Kom.',
    categories: 'IoT, Web',
    // image: '/project2.jpg'
    stats: 'finished',
    description: 'Studi dan pengembangan metode daur ulang yang efektif.'
  },
]
</script>

<template>
<div class="space-y-6">
    <!-- Judul -->
    <h1 class="text-2xl be-vietnam-pro-semibold text-gray-800 pb-4">Arsip Proyek</h1>

    <!-- Input Pencarian + Filter -->
    <div class="flex gap-x-16 gap-y-4">
        <div class="flex items-center bg-[#E8EDF2] rounded-xl justify-center h-12 mb-4 px-4 w-full max-w-4xl text-gray-700">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path fill="currentColor" d="M9.5 16q-2.725 0-4.612-1.888T3 9.5t1.888-4.612T9.5 3t4.613 1.888T16 9.5q0 1.1-.35 2.075T14.7 13.3l5.6 5.6q.275.275.275.7t-.275.7t-.7.275t-.7-.275l-5.6-5.6q-.75.6-1.725.95T9.5 16m0-2q1.875 0 3.188-1.312T14 9.5t-1.312-3.187T9.5 5T6.313 6.313T5 9.5t1.313 3.188T9.5 14"/></svg>
        <input
          type="text"
          placeholder="Cari judul proyek"
          class=" outline-none h-12 w-full text-sm p-3"
        />
      </div>
      <button class="flex items-center gap-x-2 text-gray-600 hover:text-gray-800">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path fill="currentColor" d="M20.62 3.89a1.74 1.74 0 0 1-.19.86v.07l-5.07 7.86a1.06 1.06 0 0 0-.17.57v4.79a2 2 0 0 1-1.09 1.76l-3.66 1.83a1 1 0 0 1-.51.12a1.1 1.1 0 0 1-.55-.16a1.05 1.05 0 0 1-.4-.41a1.1 1.1 0 0 1-.13-.57v-7.35c0-.209-.06-.413-.17-.59L3.6 4.82a1.84 1.84 0 0 1-.22-.93c.016-.3.113-.59.28-.84a1.75 1.75 0 0 1 .64-.6a1.85 1.85 0 0 1 .87-.2h13.75c.29-.006.575.062.83.2c.268.136.493.344.65.6c.146.256.221.545.22.84"/></svg>
        <span class="mr-1 text-sm">Filter</span>
      </button>
    </div>
    <div class="h-8"></div>
    <!-- Daftar Proyek -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-y-10">
      <ProjectCardArchive 
        v-for="(project, index) in projects"
        :key="index"
        :to="project.to"
        :title="project.title"
        :author="project.author"
        :categories="project.categories"
        :image="project.image"
        :stats="project.stats"
        :description="project.description"
      />
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

.be-vietnam-pro-thin-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 100;
  font-style: italic;
}

.be-vietnam-pro-extralight-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 200;
  font-style: italic;
}

.be-vietnam-pro-light-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 300;
  font-style: italic;
}

.be-vietnam-pro-regular-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 400;
  font-style: italic;
}

.be-vietnam-pro-medium-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 500;
  font-style: italic;
}

.be-vietnam-pro-semibold-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 600;
  font-style: italic;
}

.be-vietnam-pro-bold-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 700;
  font-style: italic;
}

.be-vietnam-pro-extrabold-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 800;
  font-style: italic;
}

.be-vietnam-pro-black-italic {
  font-family: "Be Vietnam Pro", sans-serif;
  font-weight: 900;
  font-style: italic;
}
</style>