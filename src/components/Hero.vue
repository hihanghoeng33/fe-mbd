<script setup>
import { defineProps } from "vue";

defineProps({
  nama: {
    type: String,
    default: "Nama Pengguna",
  },
});
</script>

<template>
  <div class="gap-y-8">
    <div class="pb-8">
      <h1 class="pb-4 text-2xl text-[#202326] be-vietnam-pro-semibold">Selamat Datang, {{ nama }}</h1>  <!-- Nanti perlu diganti pake $user.name -->
      <hr class=" border-gray-300" />
    </div>
    <div class="bg-white shadow-sm rounded-lg p-5">
      <h2 class="text-xl be-vietnam-pro-medium text-gray-800 pb-4">Pengumuman Terbaru</h2>
      <div class="flex items-center gap-x-4">
        <img src="/pengumuman.png" class="w-6 h-6" alt="icon" />
        <div>
          <p class="text-gray-700 font-medium">
            Timeline pendaftaran proyek "Penelitian interaksi manusia dan
            komputer"
          </p>
          <p class="text-sm text-gray-500">
            Deadline pendaftaran proyek "Penelitian interaksi manusia dan
            komputer" untuk gelombang 1: 21 Juni 2025
          </p>
        </div>
      </div>
      <div class="flex justify-end gap-x-3 mt-4">
        <button class="text-gray-500 hover:text-black transform -scale-x-100">
          <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 15 15"><path fill="currentColor" d="M8.293 2.293a1 1 0 0 1 1.414 0l4.5 4.5a1 1 0 0 1 0 1.414l-4.5 4.5a1 1 0 0 1-1.414-1.414L11 8.5H1.5a1 1 0 0 1 0-2H11L8.293 3.707a1 1 0 0 1 0-1.414"/></svg>
        </button>
        <button class="text-gray-500 hover:text-black">
          <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 15 15"><path fill="currentColor" d="M8.293 2.293a1 1 0 0 1 1.414 0l4.5 4.5a1 1 0 0 1 0 1.414l-4.5 4.5a1 1 0 0 1-1.414-1.414L11 8.5H1.5a1 1 0 0 1 0-2H11L8.293 3.707a1 1 0 0 1 0-1.414"/></svg>
        </button>
      </div>
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
