<script setup>
import Navbar from './Navbar.vue';
import { RouterView } from 'vue-router';
import Sidebar from './Sidebar.vue';
</script>

<template>
    <div class="flex min-w-screen min-h-screen bg-gray-100">
        <Navbar />
        <Sidebar />
        <div class="flex-1 p-6">
            <RouterView />
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