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
</script>
<template>
  <div class="gap-8 mt-8">
    <!-- Hero Section -->
    <Hero nama="Amtsal" />

    <!-- Rekomendasi Proyek -->
    <h2 class="text-xl be-vietnam-pro-semibold text-gray-800 pb-4 pt-8">Rekomendasi proyek</h2>
    <div ref="scrollContainer" class="overflow-x-auto relative scroll-smooth">
      <div class=" flex gap-4 border-4 w-max">
        <ProjectCardMain
          title="Penelitian interaksi manusia dan komputer"
          author="Prof. Dr. Amritzal Jago Banget"
          filled="4"
          total="8"
        />
        <ProjectCardMain
          title="Robot Berkaki 4 untuk Lost & Found"
          author="Prof. Dr. Arya Jago Banget"
          filled="16"
          total="10"
        />
        <ProjectCardMain 
          title="Aksi kontol kontolan"
          author="Ambasing"
          filled="3"
          total="4"
        />
        <ProjectCardMain 
          title="Aksi kontol kontolan"
          author="Ambasing"
          filled="3"
          total="2"
        />
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