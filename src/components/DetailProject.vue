<script setup></script>

<script setup>
import { ref } from "vue";

const activeTab = ref("deskripsi");

const tabs = [
  { name: "Deskripsi", value: "deskripsi" },
  { name: "Milestones", value: "milestones" },
  { name: "Dokumen", value: "dokumen" },
  { name: "Peserta", value: "peserta" },
];
</script>

<template>
  <div class="flex">
    <!-- Tabs -->
    <div class="flex flex-col w-48 bg-gray-200 p-4 gap-y-2 rounded-l-lg">
      <button
        v-for="tab in tabs"
        :key="tab.value"
        @click="activeTab = tab.value"
        :class="[
          'relative block w-full text-left px-4 py-2 rounded-lg font-medium transition',
          activeTab === tab.value
            ? 'bg-blue-500 text-white'
            : 'hover:bg-gray-300 text-gray-700',
        ]"
      >
        {{ tab.name }}
      </button>
    </div>

    <!-- Content -->
    <div class="flex-1 p-6 bg-gray-200">
      <div class="text-gray-700" v-if="activeTab === 'deskripsi'">
        <h2 class="text-xl font-bold mb-2">Deskripsi Proyek</h2>
        <p>
          Peningkatan fitur dan antarmuka aplikasi belanja.
        </p>
      </div>

      <div class="text-gray-700" v-else-if="activeTab === 'dokumen'">
        <h2 class="text-xl font-bold mb-2">Dokumen Proyek</h2>
        <p>Daftar file atau tautan dokumen proyek...</p>
      </div>
      <div class="text-gray-700" v-else-if="activeTab === 'milestones'">
        <h2 class="text-xl font-bold mb-2">Milestones Proyek</h2>
        <table
          class="table-auto w-full border border-gray-300 text-sm text-left mt-6"
        >
          <thead class="bg-gray-100 text-gray-700">
            <tr>
              <th class="px-4 py-2 border">No</th>
              <th class="px-4 py-2 border">Milestone</th>
              <th class="px-4 py-2 border">Deskripsi</th>
              <th class="px-4 py-2 border">Target Waktu</th>
            </tr>
          </thead>
          <tbody class="text-gray-800">
            <tr>
              <td class="px-4 py-2 border">1</td>
              <td class="px-4 py-2 border">Proposal</td>
              <td class="px-4 py-2 border">
                Penyusunan dan pengajuan proposal penelitian
              </td>
              <td class="px-4 py-2 border">Minggu ke-1</td>
            </tr>
            <tr class="bg-gray-50">
              <td class="px-4 py-2 border">2</td>
              <td class="px-4 py-2 border">Studi Pustaka</td>
              <td class="px-4 py-2 border">
                Pengumpulan referensi jurnal/literatur terkait
              </td>
              <td class="px-4 py-2 border">Minggu ke-2 sampai ke-3</td>
            </tr>
            <tr>
              <td class="px-4 py-2 border">3</td>
              <td class="px-4 py-2 border">Perancangan</td>
              <td class="px-4 py-2 border">
                Pembuatan desain metodologi atau sistem
              </td>
              <td class="px-4 py-2 border">Minggu ke-4</td>
            </tr>
            <tr class="bg-gray-50">
              <td class="px-4 py-2 border">4</td>
              <td class="px-4 py-2 border">Implementasi</td>
              <td class="px-4 py-2 border">
                Pengembangan dan pengujian sistem atau eksperimen
              </td>
              <td class="px-4 py-2 border">Minggu ke-5 sampai ke-8</td>
            </tr>
            <tr>
              <td class="px-4 py-2 border">5</td>
              <td class="px-4 py-2 border">Analisis Data</td>
              <td class="px-4 py-2 border">
                Analisis hasil pengujian atau eksperimen
              </td>
              <td class="px-4 py-2 border">Minggu ke-9</td>
            </tr>
            <tr class="bg-gray-50">
              <td class="px-4 py-2 border">6</td>
              <td class="px-4 py-2 border">Penulisan Laporan</td>
              <td class="px-4 py-2 border">
                Penyusunan laporan akhir penelitian
              </td>
              <td class="px-4 py-2 border">Minggu ke-10 sampai ke-11</td>
            </tr>
            <tr>
              <td class="px-4 py-2 border">7</td>
              <td class="px-4 py-2 border">Presentasi</td>
              <td class="px-4 py-2 border">
                Persiapan dan penyampaian presentasi hasil
              </td>
              <td class="px-4 py-2 border">Minggu ke-12</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="text-gray-700" v-else-if="activeTab === 'peserta'">
        <h2 class="text-xl font-bold mb-2">Peserta Terdaftar</h2>
        <ul class="list-disc pl-5">
          <li>Amtsal A.</li>
          <li>Wowo B.</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
