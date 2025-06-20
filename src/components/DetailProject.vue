<script setup>
import { ref, onMounted, computed } from "vue";
import { useRoute } from "vue-router";
import { projectService } from "../services/projectService.js";
import { authService } from "../services/authService.js";

const route = useRoute();
const activeTab = ref("deskripsi");
const project = ref(null);
const milestones = ref([]);
const milestonesLoading = ref(false);
const milestonesError = ref("");
const documents = ref([]);
const documentsLoading = ref(false);
const documentsError = ref("");
const members = ref([]);
const membersLoading = ref(false);
const membersError = ref("");
const joinRequests = ref([]);
const joinRequestsLoading = ref(false);
const joinRequestsError = ref("");
const loading = ref(false);
const error = ref("");
const user = ref(null);
const newMilestone = ref({
  title: "",
  description: "",
  due_date: "",
  status: "PLANNING",
});

const addMilestoneError = ref("");
// Get current user
onMounted(async () => {
  try {
    const userData = authService.getCurrentUser();
    if (userData) {
      user.value = userData;
    } else if (authService.isAuthenticated()) {
      const fetchedUser = await authService.getCurrentUserProfile();
      user.value = fetchedUser;
    }
  } catch (error) {
    console.error("Error loading user data:", error);
  }
});

// Check if current user is a lecturer
const isLecturer = computed(() => user.value?.role === "dosen");

const tabs = [
  { name: "Deskripsi", value: "deskripsi" },
  { name: "Milestones", value: "milestones" },
  { name: "Dokumen", value: "dokumen" },
  { name: "Anggota", value: "anggota" },
];

function completeMilestone(milestoneId) {
  const milestone = milestones.value.find(
    (m) => m.milestone_id === milestoneId
  );
  if (milestone && milestone.status.toUpperCase() !== "COMPLETED") {
    milestone.status = "COMPLETED";
    checkProjectCompletion();
  }
}

function checkProjectCompletion() {
  const allCompleted =
    milestones.value.length > 0 &&
    milestones.value.every((m) => m.status.toUpperCase() === "COMPLETED");
  if (allCompleted) {
    project.value.status = "COMPLETED";
    project.value.end_date = new Date().toISOString();
  }
}

// Add join requests tab for lecturers
const tabsForLecturer = computed(() => {
  if (isLecturer.value) {
    return [...tabs, { name: "Permintaan Bergabung", value: "join-requests" }];
  }
  return tabs;
});

const loadProjectDetails = async () => {
  loading.value = true;
  error.value = "";

  try {
    const projectId = route.params.id || route.query.id;
    if (!projectId) {
      error.value = "Project ID tidak ditemukan";
      return;
    }

    console.log("Loading project details for ID:", projectId);
    const projectData = await projectService.getProjectById(projectId);
    project.value = projectData;
    console.log("Loaded project:", projectData);
  } catch (err) {
    console.error("Error loading project details:", err);
    error.value = "Gagal memuat detail proyek";
  } finally {
    loading.value = false;
  }
};

const loadProjectMilestones = async () => {
  if (!route.params.id) return;

  milestonesLoading.value = true;
  milestonesError.value = "";

  try {
    console.log("Loading milestones for project ID:", route.params.id);
    const milestonesData = await projectService.getProjectMilestones(
      route.params.id
    );
    milestones.value = milestonesData;
    console.log("Loaded milestones:", milestonesData);
  } catch (err) {
    console.error("Error loading milestones:", err);
    milestonesError.value = "Gagal memuat milestones proyek";
  } finally {
    milestonesLoading.value = false;
  }
};

const currentFilter = ref("all");

const filteredMilestones = computed(() => {
  if (currentFilter.value === "all") {
    return milestones.value;
  } else if (currentFilter.value === "ongoing") {
    // Tampilkan semua milestone yang statusnya belum selesai (bukan COMPLETED)
    return milestones.value.filter(
      (milestone) =>
        (milestone.status && milestone.status.toUpperCase()) !== "COMPLETED"
    );
  }
  // Jika ingin menambah filter lain, tambahkan else if di sini
  return [];
});

// Method untuk mengubah filter
const filterMilestones = (filterType) => {
  currentFilter.value = filterType;
};

const loadProjectDocuments = async () => {
  if (!route.params.id) return;

  documentsLoading.value = true;
  documentsError.value = "";

  try {
    console.log("Loading documents for project ID:", route.params.id);
    const documentsData = await projectService.getProjectDocuments(
      route.params.id
    );
    documents.value = documentsData;
    console.log("Loaded documents:", documentsData);
  } catch (err) {
    console.error("Error loading documents:", err);
    documentsError.value = "Gagal memuat dokumen proyek";
  } finally {
    documentsLoading.value = false;
  }
};

const loadProjectMembers = async () => {
  if (!route.params.id) return;

  membersLoading.value = true;
  membersError.value = "";

  try {
    console.log("Loading members for project ID:", route.params.id);
    const membersData = await projectService.getProjectMembers(route.params.id);
    members.value = membersData || []; // Ensure it's always an array
    console.log("Loaded members:", membersData);
  } catch (err) {
    console.error("Error loading members:", err);
    // Always just set empty array, never show error
    members.value = [];
  } finally {
    membersLoading.value = false;
  }
};

const loadProjectJoinRequests = async () => {
  if (!route.params.id || !isLecturer.value) return;

  joinRequestsLoading.value = true;
  joinRequestsError.value = "";

  try {
    console.log("Loading join requests for project ID:", route.params.id);
    const joinRequestsData = await projectService.getProjectJoinRequests(
      route.params.id
    );
    console.log("Raw join requests data:", joinRequestsData);
    console.log("Join requests data type:", typeof joinRequestsData);
    console.log("Is array:", Array.isArray(joinRequestsData));

    if (Array.isArray(joinRequestsData)) {
      // Filter for inactive requests (pending requests)
      const pendingRequests = joinRequestsData.filter(
        (request) => !request.is_active
      );
      joinRequests.value = pendingRequests;
      console.log("Filtered pending requests:", pendingRequests);
    } else {
      console.warn("Join requests data is not an array:", joinRequestsData);
      joinRequests.value = [];
    }
  } catch (err) {
    console.error("Error loading join requests:", err);
    console.error("Error details:", err.response?.data || err.message);
    joinRequestsError.value = "Gagal memuat permintaan bergabung";
  } finally {
    joinRequestsLoading.value = false;
  }
};

const approveJoinRequest = async (projectMemberId) => {
  try {
    console.log(
      "Approving join request for project_member_id:",
      projectMemberId,
      "project:",
      route.params.id
    );
    await projectService.approveJoinRequest(route.params.id, projectMemberId);

    // Remove the approved request from the list
    joinRequests.value = joinRequests.value.filter(
      (request) => request.project_member_id !== projectMemberId
    );
    console.log(
      "Removed approved request, remaining requests:",
      joinRequests.value.length
    );

    // Reload members to show the newly approved member
    await loadProjectMembers();

    // Show success message
    alert("Permintaan bergabung berhasil disetujui!");
  } catch (error) {
    console.error("Error approving join request:", error);
    console.error("Error response:", error.response?.data);
    alert(
      "Gagal menyetujui permintaan bergabung: " +
        (error.response?.data?.message || error.message)
    );
  }
};

const formatDateTime = (dateString) => {
  if (!dateString) return "Tanggal tidak tersedia";
  try {
    return new Date(dateString).toLocaleString("id-ID", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  } catch (error) {
    return "Format tanggal tidak valid";
  }
};

const formatDate = (dateString) => {
  if (!dateString) return "-";
  return new Date(dateString).toLocaleDateString("id-ID", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
};

const getStatusColor = (status) => {
  if (!status) return "bg-gray-500";
  const statusUpper = status.toUpperCase();
  if (statusUpper === "COMPLETED") return "bg-green-500";
  if (statusUpper === "ONGOING") return "bg-blue-500";
  if (statusUpper === "PLANNING") return "bg-yellow-500";
  return "bg-gray-500";
};

const getStatusText = (status) => {
  if (!status) return "Tidak Diketahui";
  const statusUpper = status.toUpperCase();
  if (statusUpper === "COMPLETED") return "Selesai";
  if (statusUpper === "ONGOING") return "Sedang Berjalan";
  if (statusUpper === "PLANNING") return "Perencanaan";
  return status;
};

const getCategoriesArray = (categories) => {
  if (!categories) return [];

  // Handle both array and string formats
  if (Array.isArray(categories)) {
    return categories.filter((category) => category && category.trim());
  }

  // Handle comma-separated string format
  if (typeof categories === "string") {
    return categories
      .split(",")
      .map((cat) => cat.trim())
      .filter((cat) => cat);
  }

  return [];
};

const getMilestoneStatusColor = (status) => {
  if (!status) return "bg-gray-500";
  const statusUpper = status.toUpperCase();
  if (statusUpper === "COMPLETED") return "bg-green-500";
  if (statusUpper === "IN_PROGRESS") return "bg-blue-500";
  if (statusUpper === "PLANNED") return "bg-yellow-500";
  return "bg-gray-500";
};

const getMilestoneStatusText = (status) => {
  if (!status) return "Tidak Diketahui";
  const statusUpper = status.toUpperCase();
  if (statusUpper === "COMPLETED") return "Selesai";
  if (statusUpper === "IN_PROGRESS") return "Sedang Dikerjakan";
  if (statusUpper === "PLANNED") return "Direncanakan";
  return status;
};

const getMilestoneProgress = () => {
  if (milestones.value.length === 0)
    return { completed: 0, total: 0, percentage: 0 };

  const completed = milestones.value.filter(
    (m) => m.status.toUpperCase() === "COMPLETED"
  ).length;
  const total = milestones.value.length;
  const percentage = Math.round((completed / total) * 100);

  return { completed, total, percentage };
};

function handleAddMilestone() {
  addMilestoneError.value = "";
  if (!newMilestone.value.title || !newMilestone.value.due_date) {
    addMilestoneError.value = "Judul dan tanggal wajib diisi!";
    return;
  }
  // Generate milestone_id otomatis
  const nextId =
    milestones.value.length > 0
      ? Math.max(...milestones.value.map((m) => m.milestone_id)) + 1
      : 1;
  milestones.value.push({
    milestone_id: nextId,
    title: newMilestone.value.title,
    description: newMilestone.value.description,
    due_date: newMilestone.value.due_date,
    status: newMilestone.value.status,
    created_at: new Date().toISOString(),
  });
  // Reset form
  newMilestone.value = {
    title: "",
    description: "",
    due_date: "",
    status: "PLANNING",
  };
}

const getDocumentIcon = (documentType) => {
  if (!documentType) return "📄";
  const type = documentType.toLowerCase();
  if (type.includes("pdf")) return "📄";
  if (type.includes("word") || type.includes("doc")) return "📝";
  if (type.includes("excel") || type.includes("sheet")) return "📊";
  if (type.includes("powerpoint") || type.includes("presentation")) return "📑";
  if (
    type.includes("image") ||
    type.includes("png") ||
    type.includes("jpg") ||
    type.includes("jpeg")
  )
    return "🖼️";
  if (type.includes("video") || type.includes("mp4") || type.includes("avi"))
    return "🎥";
  return "📄";
};

const getDocumentTypeText = (documentType) => {
  if (!documentType) return "Dokumen";
  const type = documentType.toLowerCase();
  if (type.includes("pdf")) return "PDF";
  if (type.includes("word") || type.includes("doc")) return "Word Document";
  if (type.includes("excel") || type.includes("sheet"))
    return "Excel Spreadsheet";
  if (type.includes("powerpoint") || type.includes("presentation"))
    return "PowerPoint";
  if (type.includes("image")) return "Gambar";
  if (type.includes("video")) return "Video";
  return documentType;
};

const downloadDocument = (document) => {
  if (document.file_url) {
    window.open(document.file_url, "_blank");
  }
};

const getRoleText = (role) => {
  if (!role) return "Anggota";
  const roleUpper = role.toUpperCase();
  if (roleUpper === "MANAGER") return "Manajer";
  if (roleUpper === "MEMBER") return "Anggota";
  return role;
};

const getRoleColor = (role) => {
  if (!role) return "bg-gray-500";
  const roleUpper = role.toUpperCase();
  if (roleUpper === "MANAGER") return "bg-purple-500";
  if (roleUpper === "MEMBER") return "bg-blue-500";
  return "bg-gray-500";
};

const getMemberStatusText = (isActive) => {
  return isActive ? "Aktif" : "Tidak Aktif";
};

const getMemberStatusColor = (isActive) => {
  return isActive ? "bg-green-500" : "bg-red-500";
};

const getManagersAndMembers = () => {
  const managers = members.value.filter(
    (m) => m.role_project?.toUpperCase() === "MANAGER"
  );
  const membersList = members.value.filter(
    (m) => m.role_project?.toUpperCase() === "MEMBER"
  );
  return { managers, membersList };
};

onMounted(async () => {
  await loadProjectDetails();
  await loadProjectMilestones();
  await loadProjectDocuments();
  await loadProjectMembers();
  if (isLecturer.value) {
    await loadProjectJoinRequests();
  }
});
</script>

<template>
  <div class="flex">
    <!-- Tabs -->
    <div class="flex flex-col w-48 bg-gray-200 p-4 gap-y-2 rounded-l-lg">
      <button
        v-for="tab in tabsForLecturer"
        :key="tab.value"
        @click="activeTab = tab.value"
        :class="[
          'text-left px-4 py-2 rounded transition-colors',
          activeTab === tab.value
            ? 'bg-blue-500 text-white'
            : 'text-gray-700 hover:bg-gray-300',
        ]"
      >
        {{ tab.name }}
      </button>
    </div>

    <!-- Content -->
    <div class="flex-1 p-6 bg-gray-200">
      <!-- Loading State -->
      <div v-if="loading" class="flex items-center justify-center h-64">
        <div class="text-center">
          <div
            class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"
          ></div>
          <p class="text-gray-600">Memuat detail proyek...</p>
        </div>
      </div>

      <!-- Error State -->
      <div
        v-else-if="error"
        class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg"
      >
        <div class="flex items-center">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            viewBox="0 0 24 24"
            class="mr-2"
          >
            <path
              fill="currentColor"
              d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"
            />
          </svg>
          {{ error }}
        </div>
      </div>

      <!-- Project Content -->
      <div v-else-if="project">
        <!-- Description Tab -->
        <div class="text-gray-700" v-if="activeTab === 'deskripsi'">
          <div class="bg-white rounded-lg p-6 mb-6">
            <h1 class="text-2xl font-bold text-gray-800 mb-4">
              {{ project.title }}
            </h1>

            <!-- Status Badge -->
            <div class="flex items-center gap-2 mb-4">
              <div
                :class="[
                  'w-3 h-3 rounded-full',
                  getStatusColor(project.status),
                ]"
              ></div>
              <span class="text-sm font-medium">{{
                getStatusText(project.status)
              }}</span>
            </div>

            <!-- Categories -->
            <div
              v-if="getCategoriesArray(project.categories).length > 0"
              class="mb-4"
            >
              <h3 class="text-sm font-medium text-gray-600 mb-2">Kategori:</h3>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="category in getCategoriesArray(project.categories)"
                  :key="category"
                  class="bg-blue-200 text-gray-700 text-xs font-medium px-2.5 py-0.5 rounded"
                >
                  {{ category }}
                </span>
              </div>
            </div>

            <!-- Project Timeline -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <div>
                <h3 class="text-sm font-medium text-gray-600 mb-1">
                  Tanggal Mulai:
                </h3>
                <p class="text-gray-800">
                  {{ formatDate(project.start_date) }}
                </p>
              </div>
              <div>
                <h3 class="text-sm font-medium text-gray-600 mb-1">
                  Tanggal Selesai:
                </h3>
                <p class="text-gray-800">{{ formatDate(project.end_date) }}</p>
              </div>
            </div>

            <!-- Description -->
            <div>
              <h3 class="text-lg font-semibold text-gray-800 mb-2">
                Deskripsi Proyek
              </h3>
              <div class="text-gray-700 leading-relaxed">
                <p v-if="project.description">{{ project.description }}</p>
                <p v-else class="text-gray-500 italic">
                  Tidak ada deskripsi tersedia.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Milestones Tab -->
        <div class="text-gray-700" v-else-if="activeTab === 'milestones'">
          <div class="bg-white rounded-lg p-6">
            <!-- Form tambah milestone -->
            <form
              @submit.prevent="handleAddMilestone"
              class="flex flex-row gap-2 mb-4 items-center"
              style="max-width: 100%"
            >
              <input
                v-model="newMilestone.title"
                type="text"
                placeholder="Judul"
                class="border rounded px-2 py-1 text-xs w-28"
                required
              />
              <input
                v-model="newMilestone.due_date"
                type="date"
                class="border rounded px-2 py-1 text-xs w-28"
                required
              />
              <input
                v-model="newMilestone.description"
                type="text"
                placeholder="Deskripsi"
                class="border rounded px-2 py-1 text-xs w-32"
              />
              <select
                v-model="newMilestone.status"
                class="border rounded px-2 py-1 text-xs w-24"
              >
                <option value="PLANNING">PLANNING</option>
                <option value="ONGOING">ONGOING</option>
                <option value="COMPLETED">COMPLETED</option>
              </select>
              <button
                type="submit"
                class="bg-blue-600 text-white px-3 py-1 rounded text-xs hover:bg-blue-700"
                style="min-width: 70px"
              >
                Tambah
              </button>
            </form>
            <div v-if="addMilestoneError" class="text-red-600 mb-2 text-xs">
              {{ addMilestoneError }}
            </div>
            <div class="h-4"></div>
            <div class="flex justify-between items-center mb-6">
              
              <h2 class="text-xl font-bold">Milestones Proyek</h2>
              <div v-if="milestones.length > 0" class="text-sm text-gray-600">
                {{ getMilestoneProgress().completed }}/{{
                  getMilestoneProgress().total
                }}
                selesai ({{ getMilestoneProgress().percentage }}%)
              </div>
            </div>
            <div class="h-4"></div>
            <!-- Progress Bar -->
            <div v-if="milestones.length > 0" class="mb-6">
              <div class="bg-gray-200 rounded-full h-3">
                <div
                  class="bg-green-500 h-3 rounded-full transition-all duration-300"
                  :style="{ width: getMilestoneProgress().percentage + '%' }"
                ></div>
              </div>
            </div>
            <!-- Filter Buttons -->
             <div class="h-4"></div>
            <div class="filter-controls mb-6 flex items-center gap-4">
              <label
                for="milestone-filter"
                class="text-sm font-medium text-gray-700"
                >Filter Status:</label
              >
              <select
                id="milestone-filter"
                v-model="currentFilter"
                class="block w-auto py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
              >
                <option value="all">Semua Milestones</option>
                <option value="ongoing">Belum Selesai</option>
              </select>
            </div>
            <div class="h-4"></div>
            <!-- Loading State -->
            <div
              v-if="milestonesLoading"
              class="flex items-center justify-center py-8"
            >
              <div class="text-center">
                <div
                  class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"
                ></div>
                <p class="text-gray-600">Memuat milestones...</p>
              </div>
            </div>

            <!-- Error State -->
            <div
              v-else-if="milestonesError"
              class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg"
            >
              <div class="flex items-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  class="mr-2"
                >
                  <path
                    fill="currentColor"
                    d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"
                  />
                </svg>
                {{ milestonesError }}
              </div>
            </div>
            
            <!-- Milestones List -->
            <div v-else-if="filteredMilestones.length > 0" class="flex flex-col space-y-4 gap-y-4">
              <div
                v-for="milestone in filteredMilestones"
                :key="milestone.milestone_id"
                class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
              >
                <div class="flex items-start justify-between mb-3">
                  <div class="flex-1">
                    <h3 class="text-lg font-semibold text-gray-800 mb-1">
                      {{ milestone.title }}
                    </h3>
                    <div class="flex items-center gap-2 mb-2">
                      <div
                        :class="[
                          'w-3 h-3 rounded-full',
                          getMilestoneStatusColor(milestone.status),
                        ]"
                      ></div>
                      <span class="text-sm font-medium">{{
                        getMilestoneStatusText(milestone.status)
                      }}</span>
                    </div>
                  </div>
                  <div class="text-right text-sm text-gray-500">
                    <div v-if="milestone.due_date">
                      <strong>Deadline:</strong><br />
                      {{ formatDate(milestone.due_date) }}
                    </div>
                    <!-- Tombol Complete -->
                    <button
                      v-if="milestone.status.toUpperCase() !== 'COMPLETED'"
                      @click="completeMilestone(milestone.milestone_id)"
                      class="ml-4 bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600"
                    >
                      Tandai Selesai
                    </button>
                    <span v-else class="ml-4 text-green-600 font-bold">✔</span>
                  </div>
                </div>

                <div v-if="milestone.description" class="mb-3">
                  <p class="text-gray-700 text-sm leading-relaxed">
                    {{ milestone.description }}
                  </p>
                </div>

                <div
                  class="flex justify-between items-center text-xs text-gray-500"
                >
                  <span
                    >Dibuat: {{ formatDateTime(milestone.created_at) }}</span
                  >
                  <span
                    v-if="milestone.due_date"
                    :class="[
                      new Date(milestone.due_date) < new Date() &&
                      milestone.status.toUpperCase() !== 'COMPLETED'
                        ? 'text-red-600 font-medium'
                        : 'text-gray-500',
                    ]"
                  >
                    {{
                      new Date(milestone.due_date) < new Date() &&
                      milestone.status.toUpperCase() !== "COMPLETED"
                        ? "Terlambat"
                        : ""
                    }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Empty State -->
            <div v-else class="text-center py-12">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="64"
                height="64"
                viewBox="0 0 24 24"
                class="mx-auto mb-4 text-gray-400"
              >
                <path
                  fill="currentColor"
                  d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M7 13.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5"
                />
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">
                Belum Ada Milestones
              </h3>
              <p class="text-gray-500">
                Proyek ini belum memiliki milestones yang didefinisikan.
              </p>
            </div>
          </div>
        </div>

        <!-- Join Requests Tab (Only for Lecturers) -->
        <div
          v-if="activeTab === 'join-requests' && isLecturer"
          class="text-gray-700"
        >
          <div class="bg-white rounded-lg p-6">
            <div class="flex justify-between items-center mb-6">
              <h2 class="text-xl font-bold">Permintaan Bergabung</h2>
              <div v-if="joinRequests.length > 0" class="text-sm text-gray-600">
                {{ joinRequests.length }} permintaan menunggu
              </div>
            </div>

            <!-- Loading State -->
            <div
              v-if="joinRequestsLoading"
              class="flex justify-center items-center py-8"
            >
              <div class="text-center">
                <div
                  class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"
                ></div>
                <span class="text-gray-600"
                  >Memuat permintaan bergabung...</span
                >
              </div>
            </div>

            <!-- Error State -->
            <div
              v-else-if="joinRequestsError"
              class="bg-red-50 border border-red-200 rounded-lg p-4"
            >
              <div class="flex items-center">
                <svg
                  class="w-5 h-5 text-red-500 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                <p class="text-red-700">{{ joinRequestsError }}</p>
              </div>
            </div>

            <!-- No Join Requests -->
            <div
              v-else-if="joinRequests.length === 0"
              class="text-center py-12"
            >
              <svg
                class="mx-auto h-16 w-16 text-gray-400 mb-4"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                />
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">
                Tidak Ada Permintaan Bergabung
              </h3>
              <p class="text-gray-500">
                Belum ada mahasiswa yang mengajukan permintaan untuk bergabung
                dengan proyek ini.
              </p>
            </div>

            <!-- Join Requests List -->
            <div v-else class="space-y-4">
              <div
                v-for="request in joinRequests"
                :key="request.project_member_id"
                class="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow"
              >
                <div class="flex items-center justify-between">
                  <div class="flex items-center space-x-4">
                    <div class="flex-shrink-0">
                      <div
                        class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center"
                      >
                        <svg
                          class="w-6 h-6 text-blue-600"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                          />
                        </svg>
                      </div>
                    </div>
                    <div>
                      <h3 class="text-lg font-medium text-gray-900">
                        {{ request.user_id }}
                      </h3>
                      <div
                        class="flex items-center space-x-4 text-sm text-gray-500 mt-1"
                      >
                        <span class="flex items-center gap-1">
                          <div class="w-2 h-2 rounded-full bg-yellow-500"></div>
                          {{ request.role_project || "Member" }}
                        </span>
                        <span
                          >Mengajukan:
                          {{ formatDateTime(request.joined_at) }}</span
                        >
                      </div>
                    </div>
                  </div>

                  <div class="flex items-center space-x-3">
                    <button
                      @click="approveJoinRequest(request.project_member_id)"
                      class="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 transition-colors flex items-center gap-2"
                    >
                      <svg
                        class="w-4 h-4"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                      Setujui
                    </button>
                    <button
                      class="bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600 transition-colors flex items-center gap-2"
                    >
                      <svg
                        class="w-4 h-4"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M6 18L18 6M6 6l12 12"
                        />
                      </svg>
                      Tolak
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Summary Stats -->
            <div
              v-if="joinRequests.length > 0"
              class="bg-gray-50 rounded-lg p-4 mt-6"
            >
              <h3 class="text-sm font-semibold text-gray-700 mb-3">
                Ringkasan Permintaan
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-center">
                <div class="bg-white rounded-lg p-3">
                  <div class="text-2xl font-bold text-blue-600">
                    {{ joinRequests.length }}
                  </div>
                  <div class="text-xs text-gray-500">Total Permintaan</div>
                </div>
                <div class="bg-white rounded-lg p-3">
                  <div class="text-2xl font-bold text-yellow-600">
                    {{ joinRequests.length }}
                  </div>
                  <div class="text-xs text-gray-500">Menunggu Persetujuan</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Documents Tab -->
        <div class="text-gray-700" v-else-if="activeTab === 'dokumen'">
          <div class="bg-white rounded-lg p-6">
            <div class="flex justify-between items-center mb-6">
              <h2 class="text-xl font-bold">Dokumen Proyek</h2>
              <div v-if="documents.length > 0" class="text-sm text-gray-600">
                {{ documents.length }} dokumen tersedia
              </div>
            </div>

            <!-- Loading State -->
            <div
              v-if="documentsLoading"
              class="flex items-center justify-center py-8"
            >
              <div class="text-center">
                <div
                  class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"
                ></div>
                <p class="text-gray-600">Memuat dokumen...</p>
              </div>
            </div>

            <!-- Error State -->
            <div
              v-else-if="documentsError"
              class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg"
            >
              <div class="flex items-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  class="mr-2"
                >
                  <path
                    fill="currentColor"
                    d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"
                  />
                </svg>
                {{ documentsError }}
              </div>
            </div>

            <!-- Documents List -->
            <div v-else-if="documents.length > 0" class="space-y-4">
              <div
                v-for="document in documents"
                :key="document.document_id"
                class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
              >
                <div class="flex items-start justify-between">
                  <div class="flex items-start gap-4 flex-1">
                    <!-- Document Icon -->
                    <div class="text-3xl">
                      {{ getDocumentIcon(document.document_type) }}
                    </div>

                    <!-- Document Info -->
                    <div class="flex-1 min-w-0">
                      <h3
                        class="text-lg font-semibold text-gray-800 mb-1 truncate"
                      >
                        {{ document.title }}
                      </h3>

                      <div
                        class="flex flex-wrap items-center gap-4 text-sm text-gray-600 mb-2"
                      >
                        <span class="flex items-center gap-1">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="16"
                            height="16"
                            viewBox="0 0 24 24"
                          >
                            <path
                              fill="currentColor"
                              d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6z"
                            />
                          </svg>
                          {{ getDocumentTypeText(document.document_type) }}
                        </span>
                      </div>

                      <div class="text-xs text-gray-500">
                        Diunggah: {{ formatDateTime(document.created_at) }}
                      </div>
                    </div>
                  </div>

                  <!-- Actions -->
                  <div class="flex items-center gap-2 ml-4">
                    <button
                      @click="downloadDocument(document)"
                      class="flex items-center gap-2 px-3 py-2 text-sm font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors"
                      title="Unduh dokumen"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="16"
                        height="16"
                        viewBox="0 0 24 24"
                      >
                        <path
                          fill="currentColor"
                          d="M5 20h14v-2H5v2zM19 9h-4V3H9v6H5l7 7l7-7z"
                        />
                      </svg>
                      Unduh
                    </button>

                    <button
                      @click="window.open(document.file_url, '_blank')"
                      class="flex items-center gap-2 px-3 py-2 text-sm font-medium text-gray-600 bg-gray-50 rounded-md hover:bg-gray-100 transition-colors"
                      title="Lihat dokumen"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="16"
                        height="16"
                        viewBox="0 0 24 24"
                      >
                        <path
                          fill="currentColor"
                          d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5s5 2.24 5 5s-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3s3-1.34 3-3s-1.34-3-3-3z"
                        />
                      </svg>
                      Lihat
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Empty State -->
            <div v-else class="text-center py-12">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="64"
                height="64"
                viewBox="0 0 24 24"
                class="mx-auto mb-4 text-gray-400"
              >
                <path
                  fill="currentColor"
                  d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zm4 18H6V4h7v5h5v11z"
                />
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">
                Belum Ada Dokumen
              </h3>
              <p class="text-gray-500">
                Proyek ini belum memiliki dokumen yang diunggah.
              </p>
            </div>
          </div>
        </div>

        <!-- Participants Tab -->
        <div class="text-gray-700" v-else-if="activeTab === 'anggota'">
          <div class="bg-white rounded-lg p-6">
            <div class="flex justify-between items-center mb-6">
              <h2 class="text-xl font-bold">Anggota Proyek</h2>
              <div v-if="members.length > 0" class="text-sm text-gray-600">
                {{ members.length }} anggota
              </div>
            </div>

            <!-- Loading State -->
            <div
              v-if="membersLoading"
              class="flex items-center justify-center py-8"
            >
              <div class="text-center">
                <div
                  class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"
                ></div>
                <p class="text-gray-600">Memuat anggota...</p>
              </div>
            </div>

            <!-- Error State -->
            <div
              v-else-if="membersError"
              class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg"
            >
              <div class="flex items-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  class="mr-2"
                >
                  <path
                    fill="currentColor"
                    d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2M13 17h-2v-2h2v2zm0-4h-2V7h2v6z"
                  />
                </svg>
                {{ membersError }}
              </div>
            </div>

            <!-- Members List -->
            <div v-else-if="members.length > 0" class="space-y-6">
              <!-- Project Managers Section -->
              <div
                v-if="getManagersAndMembers().managers.length > 0"
                class="mb-8"
              >
                <h3
                  class="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="20"
                    height="20"
                    viewBox="0 0 24 24"
                  >
                    <path
                      fill="currentColor"
                      d="M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 22L12 18.77L5.82 22L7 14.14l-5-4.87l6.91-1.01L12 2z"
                    />
                  </svg>
                  {{
                    getManagersAndMembers().managers.length === 1
                      ? "Manajer Proyek"
                      : `Manajer Proyek (${
                          getManagersAndMembers().managers.length
                        })`
                  }}
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div
                    v-for="manager in getManagersAndMembers().managers"
                    :key="manager.project_member_id"
                    class="border border-purple-200 rounded-lg p-4 bg-purple-50"
                  >
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-4">
                        <div
                          class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center overflow-hidden"
                        >
                          <img
                            src="/profile-picture.png"
                            alt="Manager Profile"
                            class="w-10 h-10 rounded-full"
                          />
                        </div>
                        <div>
                          <h4 class="font-semibold text-gray-800">
                            ID: {{ manager.user_id }}
                          </h4>
                          <span
                            v-if="manager.name"
                            class="ml-2 text-gray-600 font-normal"
                            >({{ manager.name }})</span
                          >
                          <div
                            class="flex items-center gap-3 text-sm text-gray-600 mt-1"
                          >
                            <span class="flex items-center gap-1">
                              <div
                                :class="[
                                  'w-2 h-2 rounded-full',
                                  getRoleColor(manager.role_project),
                                ]"
                              ></div>
                              {{ getRoleText(manager.role_project) }}
                            </span>
                            <span class="flex items-center gap-1">
                              <div
                                :class="[
                                  'w-2 h-2 rounded-full',
                                  getMemberStatusColor(manager.is_active),
                                ]"
                              ></div>
                              {{ getMemberStatusText(manager.is_active) }}
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="text-xs text-gray-500 mt-3">
                      Bergabung: {{ formatDateTime(manager.joined_at) }}
                    </div>
                  </div>
                </div>
              </div>

              <!-- Team Members Section -->
              <div v-if="getManagersAndMembers().membersList.length > 0">
                <h3
                  class="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="20"
                    height="20"
                    viewBox="0 0 24 24"
                  >
                    <path
                      fill="currentColor"
                      d="M16 4c0-1.11.89-2 2-2s2 .89 2 2s-.89 2-2 2s-2-.89-2-2M21 16v-2c0-1.1-.9-2-2-2h-2v7h2v-2.5l1.8 3H23l-1.8-3zM12.5 11.5c.83 0 1.5-.67 1.5-1.5s-.67-1.5-1.5-1.5S11 9.17 11 10s.67 1.5 1.5 1.5M5.5 6c1.11 0 2-.89 2-2s-.89-2-2-2s-2 .89-2 2s.89 2 2 2M7.5 22v-7H9V9c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v6h1.5v7h4zm6.5-7v7h1.5v-7h-1.5z"
                    />
                  </svg>
                  Anggota Tim ({{ getManagersAndMembers().membersList.length }})
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div
                    v-for="member in getManagersAndMembers().membersList"
                    :key="member.project_member_id"
                    class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
                  >
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-3">
                        <div
                          class="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center overflow-hidden"
                        >
                          <img
                            src="/profile-picture.png"
                            alt="Member Profile"
                            class="w-8 h-8 rounded-full"
                          />
                        </div>
                        <div>
                          <h4 class="font-semibold text-gray-800">
                            ID: {{ member.user_id }}
                          </h4>
                          <div
                            class="flex items-center gap-3 text-sm text-gray-600 mt-1"
                          >
                            <span class="flex items-center gap-1">
                              <div
                                :class="[
                                  'w-2 h-2 rounded-full',
                                  getRoleColor(member.role_project),
                                ]"
                              ></div>
                              {{ getRoleText(member.role_project) }}
                            </span>
                            <span class="flex items-center gap-1">
                              <div
                                :class="[
                                  'w-2 h-2 rounded-full',
                                  getMemberStatusColor(member.is_active),
                                ]"
                              ></div>
                              {{ getMemberStatusText(member.is_active) }}
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="text-xs text-gray-500 mt-3">
                      Bergabung: {{ formatDateTime(member.joined_at) }}
                    </div>
                  </div>
                </div>
              </div>

              <!-- All Members as One List (if no role separation needed) -->
              <div
                v-if="
                  getManagersAndMembers().managers.length === 0 &&
                  getManagersAndMembers().membersList.length === 0
                "
                class="mb-8"
              >
                <h3
                  class="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="20"
                    height="20"
                    viewBox="0 0 24 24"
                  >
                    <path
                      fill="currentColor"
                      d="M16 4c0-1.11.89-2 2-2s2 .89 2 2s-.89 2-2 2s-2-.89-2-2M21 16v-2c0-1.1-.9-2-2-2h-2v7h2v-2.5l1.8 3H23l-1.8-3zM12.5 11.5c.83 0 1.5-.67 1.5-1.5s-.67-1.5-1.5-1.5S11 9.17 11 10s.67 1.5 1.5 1.5M5.5 6c1.11 0 2-.89 2-2s-.89-2-2-2s-2 .89-2 2s.89 2 2 2M7.5 22v-7H9V9c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v6h1.5v7h4zm6.5-7v7h1.5v-7h-1.5z"
                    />
                  </svg>
                  Semua Anggota ({{ members.length }})
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div
                    v-for="member in members"
                    :key="member.project_member_id"
                    class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
                  >
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-3">
                        <div
                          :class="[
                            'w-10 h-10 rounded-full flex items-center justify-center text-white font-bold',
                            member.role_project?.toUpperCase() === 'MANAGER'
                              ? 'bg-purple-500'
                              : 'bg-blue-500',
                          ]"
                        >
                          {{ member.user_id?.toString().slice(-2) || "A" }}
                        </div>
                        <div>
                          <h4 class="font-semibold text-gray-800">
                            ID: {{ member.user_id }}
                          </h4>
                          <div
                            class="flex items-center gap-3 text-sm text-gray-600 mt-1"
                          >
                            <span class="flex items-center gap-1">
                              <div
                                :class="[
                                  'w-2 h-2 rounded-full',
                                  getRoleColor(member.role_project),
                                ]"
                              ></div>
                              {{ getRoleText(member.role_project) }}
                            </span>
                            <span class="flex items-center gap-1">
                              <div
                                :class="[
                                  'w-2 h-2 rounded-full',
                                  getMemberStatusColor(member.is_active),
                                ]"
                              ></div>
                              {{ getMemberStatusText(member.is_active) }}
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="text-xs text-gray-500 mt-3">
                      Bergabung: {{ formatDateTime(member.joined_at) }}
                    </div>
                  </div>
                </div>
              </div>

              <!-- Summary Stats -->
              <div class="bg-gray-50 rounded-lg p-4 mt-6">
                <h3 class="text-sm font-semibold text-gray-700 mb-3">
                  Ringkasan Anggota
                </h3>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                  <div class="bg-white rounded-lg p-3">
                    <div class="text-2xl font-bold text-blue-600">
                      {{ members.length }}
                    </div>
                    <div class="text-xs text-gray-600">Total Anggota</div>
                  </div>
                  <div class="bg-white rounded-lg p-3">
                    <div class="text-2xl font-bold text-purple-600">
                      {{ getManagersAndMembers().managers.length }}
                    </div>
                    <div class="text-xs text-gray-600">Manajer</div>
                  </div>
                  <div class="bg-white rounded-lg p-3">
                    <div class="text-2xl font-bold text-green-600">
                      {{ getManagersAndMembers().membersList.length }}
                    </div>
                    <div class="text-xs text-gray-600">Anggota Tim</div>
                  </div>
                  <div class="bg-white rounded-lg p-3">
                    <div class="text-2xl font-bold text-emerald-600">
                      {{ members.filter((m) => m.is_active).length }}
                    </div>
                    <div class="text-xs text-gray-600">Aktif</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Empty State -->
            <div v-else class="text-center py-12">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="64"
                height="64"
                viewBox="0 0 24 24"
                class="mx-auto mb-4 text-gray-400"
              >
                <path
                  fill="currentColor"
                  d="M16 4c0-1.11.89-2 2-2s2 .89 2 2s-.89 2-2 2s-2-.89-2-2M21 16v-2c0-1.1-.9-2-2-2h-2v7h2v-2.5l1.8 3H23l-1.8-3zM12.5 11.5c.83 0 1.5-.67 1.5-1.5s-.67-1.5-1.5-1.5S11 9.17 11 10s.67 1.5 1.5 1.5M5.5 6c1.11 0 2-.89 2-2s-.89-2-2-2s-2 .89-2 2s.89 2 2 2M7.5 22v-7H9V9c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v6h1.5v7h4zm6.5-7v7h1.5v-7h-1.5z"
                />
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">
                Belum Ada Anggota
              </h3>
              <p class="text-gray-500">
                Proyek ini belum memiliki anggota yang terdaftar.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
