<script setup>
import Hero from './Hero.vue';
import ProjectCardMain from './ProjectCardMain.vue';
import { ref, onMounted, onBeforeUnmount } from 'vue';

const scrollContainer = ref(null);

function handleWheelScroll(e) {
  if (e.deltaY !== 0) {
    e.preventDefault();
    scrollContainer.value.scrollLeft += e.deltaY;
  }
}

onMounted(() => {
  const el = scrollContainer.value;
  el.addEventListener('wheel', handleWheelScroll, { passive: false });
});

onBeforeUnmount(() => {
  scrollContainer.value?.removeEventListener('wheel', handleWheelScroll);
});

const handleCreateProject = () => {
  console.log('Create new project');
};
</script>

<template>
  <div class="gap-8 mt-8">
    <!-- Hero Section -->
    <Hero nama="Prof. Dr. Amtsal" />

    <!-- Proyek Saya -->
    <h2 class="text-xl be-vietnam-pro-semibold text-gray-800 pb-4 pt-8">Proyek Saya</h2>
    <div ref="scrollContainer" class="overflow-x-auto relative scroll-smooth">
      <div class="flex gap-4 w-max">
        <!-- Create New Project Card -->
        <div
          @click="handleCreateProject"
          class="bg-[#E8EDF2] shadow-md hover:shadow-lg transition-all duration-300 overflow-hidden rounded-lg w-96 cursor-pointer border-2 border-dashed border-gray-400 hover:border-blue-500 hover:bg-blue-50 flex items-center justify-center min-h-[400px]"
        >
          <div class="text-center text-gray-500 hover:text-blue-600 transition-colors">
            <div class="mb-4 flex justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24">
                <path fill="currentColor" d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
              </svg>
            </div>
            <p class="text-lg font-medium">Buat Proyek Baru</p>
            <p class="text-sm">Klik untuk membuat proyek baru</p>
          </div>
        </div>

        <!-- Existing Projects -->
        <ProjectCardMain
          title="Penelitian interaksi manusia dan komputer"
          author="Prof. Dr. Amtsal Jago Banget"
          :filled="4"
          :total="8"
          category="AI"
        >
          <template #actions>
            <button class="bg-gray-100 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-800 h-10 w-22 hover:bg-gray-200 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
              </svg>
              <span class="text-sm">Edit</span>
            </button>
            <button class="bg-red-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22 hover:bg-red-600 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21H7ZM17 6H7v13h10V6ZM9 17h2V8H9v9Zm4 0h2V8h-2v9ZM7 6v13V6Z"/>
              </svg>
              <span class="text-sm">Hapus</span>
            </button>
          </template>
        </ProjectCardMain>

        <ProjectCardMain
          title="Robot Berkaki 4 untuk Lost & Found"
          author="Prof. Dr. Amtsal Jago Banget"
          :filled="2"
          :total="6"
          category="Robotics"
        >
          <template #actions>
            <button class="bg-gray-100 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-800 h-10 w-22 hover:bg-gray-200 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
              </svg>
              <span class="text-sm">Edit</span>
            </button>
            <button class="bg-red-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22 hover:bg-red-600 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21H7ZM17 6H7v13h10V6ZM9 17h2V8H9v9Zm4 0h2V8h-2v9ZM7 6v13V6Z"/>
              </svg>
              <span class="text-sm">Hapus</span>
            </button>
          </template>
        </ProjectCardMain>

        <ProjectCardMain
          title="Sistem Manajemen Database Terdistribusi"
          author="Prof. Dr. Amtsal Jago Banget"
          :filled="6"
          :total="6"
          category="Database"
        >
          <template #actions>
            <button class="bg-gray-100 items-center flex justify-center rounded-3xl gap-x-2 py-2 px-3 text-gray-800 h-10 w-22 hover:bg-gray-200 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
              </svg>
              <span class="text-sm">Edit</span>
            </button>
            <button class="bg-red-500 text-white rounded-3xl items-center flex justify-center gap-x-2 py-2 px-3 h-10 w-22 hover:bg-red-600 transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M7 21q-.825 0-1.412-.587T5 19V6H4V4h5V3h6v1h5v2h-1v13q0 .825-.587 1.413T17 21H7ZM17 6H7v13h10V6ZM9 17h2V8H9v9Zm4 0h2V8h-2v9ZM7 6v13V6Z"/>
              </svg>
              <span class="text-sm">Hapus</span>
            </button>
          </template>
        </ProjectCardMain>
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