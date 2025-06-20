<script setup>
import { ref, onMounted, computed } from "vue";
import { projectService } from "../services/projectService.js";
import ProjectCardMain from "./ProjectCardMain.vue";

const projects = ref([]);
const loading = ref(false);
const errorMessage = ref("");
const currentPage = ref(1);
const maxPage = ref(1);
const perPage = ref(10);
const totalCount = ref(0);
const jumpToPage = ref(null);
const searchQuery = ref("");

// SQL View functionality
const showSqlView = ref(false);
const sqlViewData = ref([]);
const sqlViewLoading = ref(false);
const sqlViewError = ref("");
const sqlSearchQuery = ref("");

// User Projects Modal functionality
const showUserProjectsModal = ref(false);
const selectedUserId = ref("");
const userProjects = ref([]);
const userProjectsLoading = ref(false);
const userProjectsError = ref("");

// Project Stats View functionality
const showProjectStatsView = ref(false);
const projectStatsData = ref([]);
const projectStatsLoading = ref(false);
const projectStatsError = ref("");
const projectStatsSearchQuery = ref("");

onMounted(async () => {
  await loadProjects();
});

const loadProjects = async (page = 1) => {
  loading.value = true;
  errorMessage.value = "";

  try {
    console.log(`Loading projects page ${page}...`);
    const result = await projectService.getProjects(page);
    const projectsData = result.data;
    const meta = result.meta;

    // Update pagination info from meta
    currentPage.value = meta.page || page;
    maxPage.value = meta.max_page || 1;
    perPage.value = meta.per_page || 10;
    totalCount.value = meta.count || 0;

    console.log(`Page ${currentPage.value} of ${maxPage.value}`);
    console.log(`Per page: ${perPage.value}, Total count: ${totalCount.value}`);

    // Transform the data to match our component props
    const transformedProjects = projectsData.map((project) =>
      projectService.transformProjectData(project)
    );

    // Replace projects instead of appending
    projects.value = transformedProjects;

    console.log(
      `Loaded ${transformedProjects.length} projects for page ${page}`
    );
  } catch (error) {
    console.error("Error loading projects:", error);
    errorMessage.value = "Failed to load projects";

    // Fallback to mock data if API fails and it's the first page
    if (page === 1) {
      projects.value = [
        {
          title: "Dompet Digital Aman Berbasis Blockchain",
          author: "Prof.Dr.(ENG).IR. Benjamin Bryant",
          filled: 5,
          total: 6,
          categories: "Blockchain, LLM",
          description: "Aplikasi dompet digital dengan keamanan terjamin.",
        },
        {
          title: "Pengembangan Sistem Pembayaran Wajah",
          author: "Danny Mason S.Kom., M.Kom.",
          filled: 5,
          total: 8,
          categories: "LLM, Sustainability",
          description:
            "Inovasi pembayaran menggunakan teknologi pengenalan wajah.",
        },
        {
          title: "Monitoring Kesehatan IoT untuk Lansia",
          author: "Heather King S.Kom., M.Kom., Ph.D.",
          filled: 4,
          total: 7,
          categories: "IoT, Sustainability",
          description:
            "Perangkat IoT untuk memantau kesehatan lansia dari jarak jauh.",
        },
      ];
      maxPage.value = 1;
      totalCount.value = 3;
      currentPage.value = 1;
    }
  } finally {
    loading.value = false;
  }
};

// Load SQL View Data
const loadSqlViewData = async () => {
  sqlViewLoading.value = true;
  sqlViewError.value = "";
  
  try {
    console.log('Loading SQL view data...');
    
    // Get all projects (we'll need to fetch all pages)
    const firstPageResult = await projectService.getProjects(1);
    const maxPageCount = firstPageResult.meta.max_page || 1;
    const allProjects = [...firstPageResult.data];
    
    // Fetch remaining pages if there are any
    if (maxPageCount > 1) {
      const remainingPagePromises = [];
      for (let i = 2; i <= maxPageCount; i++) {
        remainingPagePromises.push(
          projectService.getProjects(i).catch(error => {
            console.error(`Error fetching page ${i}:`, error);
            return { data: [] };
          })
        );
      }
      
      const remainingPageResults = await Promise.all(remainingPagePromises);
      remainingPageResults.forEach(result => {
        allProjects.push(...result.data);
      });
    }
    
    console.log(`Loaded ${allProjects.length} total projects`);
    
    // Now get members for each project
    const sqlRows = [];
    
    for (const project of allProjects) {
      try {
        const members = await projectService.getProjectMembers(project.project_id);
        
        if (members && members.length > 0) {
          // Create rows for each member
          members.forEach(member => {
            sqlRows.push({
              project_id: project.project_id,
              project_title: project.title,
              project_status: project.status,
              project_categories: project.categories,
              project_start_date: project.start_date,
              project_end_date: project.end_date,
              user_id: member.user_id,
              user_name: member.name || 'N/A',
              user_role: member.role_project,
              user_active: member.is_active,
              joined_at: member.joined_at,
              project_member_id: member.project_member_id
            });
          });
        } else {
          // Project with no members
          sqlRows.push({
            project_id: project.project_id,
            project_title: project.title,
            project_status: project.status,
            project_categories: project.categories,
            project_start_date: project.start_date,
            project_end_date: project.end_date,
            user_id: null,
            user_name: 'No Members',
            user_role: null,
            user_active: null,
            joined_at: null,
            project_member_id: null
          });
        }
      } catch (error) {
        console.error(`Error loading members for project ${project.project_id}:`, error);
        // Add row for project with error
        sqlRows.push({
          project_id: project.project_id,
          project_title: project.title,
          project_status: project.status,
          project_categories: project.categories,
          project_start_date: project.start_date,
          project_end_date: project.end_date,
          user_id: null,
          user_name: 'Error Loading Members',
          user_role: null,
          user_active: null,
          joined_at: null,
          project_member_id: null
        });
      }
    }
    
    // Sort by project_id, then by user_id
    sqlRows.sort((a, b) => {
      if (a.project_id !== b.project_id) {
        return a.project_id - b.project_id;
      }
      return (a.user_id || '').localeCompare(b.user_id || '');
    });
    
    sqlViewData.value = sqlRows;
    console.log(`Generated ${sqlRows.length} SQL view rows`);
    
  } catch (error) {
    console.error('Error loading SQL view data:', error);
    sqlViewError.value = 'Gagal memuat data SQL view';
  } finally {
    sqlViewLoading.value = false;
  }
};

// Load User Projects
const loadUserProjects = async (userId) => {
  userProjectsLoading.value = true;
  userProjectsError.value = "";
  
  try {
    console.log(`Loading projects for user: ${userId}`);
    
    // Filter projects from SQL data for this user
    const userProjectRows = sqlViewData.value.filter(row => row.user_id === userId);
    
    // Get unique projects for this user
    const uniqueProjects = [];
    const seenProjectIds = new Set();
    
    userProjectRows.forEach(row => {
      if (!seenProjectIds.has(row.project_id)) {
        uniqueProjects.push({
          project_id: row.project_id,
          title: row.project_title,
          status: row.project_status,
          categories: row.project_categories,
          start_date: row.project_start_date,
          end_date: row.project_end_date,
          user_role: row.user_role,
          user_active: row.user_active,
          joined_at: row.joined_at,
          project_member_id: row.project_member_id
        });
        seenProjectIds.add(row.project_id);
      }
    });
    
    userProjects.value = uniqueProjects;
    console.log(`Found ${uniqueProjects.length} projects for user ${userId}`);
    
  } catch (error) {
    console.error('Error loading user projects:', error);
    userProjectsError.value = 'Gagal memuat proyek pengguna';
  } finally {
    userProjectsLoading.value = false;
  }
};

// Show User Projects Modal
const showUserProjects = async (userId) => {
  if (!userId) return;
  
  selectedUserId.value = userId;
  showUserProjectsModal.value = true;
  await loadUserProjects(userId);
};

// Close User Projects Modal
const closeUserProjectsModal = () => {
  showUserProjectsModal.value = false;
  selectedUserId.value = "";
  userProjects.value = [];
  userProjectsError.value = "";
};

// Load Project Stats Data (milestones and documents count)
const loadProjectStatsData = async () => {
  projectStatsLoading.value = true;
  projectStatsError.value = "";
  
  try {
    console.log('Loading project stats data...');
    
    // Get all projects
    const firstPageResult = await projectService.getProjects(1);
    const maxPageCount = firstPageResult.meta.max_page || 1;
    const allProjects = [...firstPageResult.data];
    
    // Fetch remaining pages if there are any
    if (maxPageCount > 1) {
      const remainingPagePromises = [];
      for (let i = 2; i <= maxPageCount; i++) {
        remainingPagePromises.push(
          projectService.getProjects(i).catch(error => {
            console.error(`Error fetching page ${i}:`, error);
            return { data: [] };
          })
        );
      }
      
      const remainingPageResults = await Promise.all(remainingPagePromises);
      remainingPageResults.forEach(result => {
        allProjects.push(...result.data);
      });
    }
    
    console.log(`Loaded ${allProjects.length} total projects for stats`);
    
    // Get milestones and documents count for each project
    const statsRows = [];
    
    for (const project of allProjects) {
      let milestonesCount = 0;
      let documentsCount = 0;
      
      try {
        // Get milestones count
        const milestones = await projectService.getProjectMilestones(project.project_id);
        milestonesCount = milestones ? milestones.length : 0;
      } catch (error) {
        console.error(`Error loading milestones for project ${project.project_id}:`, error);
        milestonesCount = 0;
      }
      
      try {
        // Get documents count
        const documents = await projectService.getProjectDocuments(project.project_id);
        documentsCount = documents ? documents.length : 0;
      } catch (error) {
        console.error(`Error loading documents for project ${project.project_id}:`, error);
        documentsCount = 0;
      }
      
      statsRows.push({
        project_id: project.project_id,
        project_title: project.title,
        project_status: project.status,
        project_categories: project.categories,
        project_start_date: project.start_date,
        project_end_date: project.end_date,
        milestones_count: milestonesCount,
        documents_count: documentsCount,
        total_items: milestonesCount + documentsCount
      });
    }
    
    // Sort by project_id
    statsRows.sort((a, b) => a.project_id - b.project_id);
    
    projectStatsData.value = statsRows;
    console.log(`Generated ${statsRows.length} project stats rows`);
    
  } catch (error) {
    console.error('Error loading project stats data:', error);
    projectStatsError.value = 'Gagal memuat data statistik proyek';
  } finally {
    projectStatsLoading.value = false;
  }
};

// Toggle Project Stats View
const toggleProjectStatsView = async () => {
  if (!showProjectStatsView.value) {
    showProjectStatsView.value = true;
    await loadProjectStatsData();
  } else {
    showProjectStatsView.value = false;
  }
};

// Filtered Project Stats data for search
const filteredProjectStatsData = computed(() => {
  if (!projectStatsSearchQuery.value) return projectStatsData.value;
  const query = projectStatsSearchQuery.value.toLowerCase();
  return projectStatsData.value.filter(row =>
    row.project_title?.toLowerCase().includes(query) ||
    row.project_status?.toLowerCase().includes(query) ||
    row.project_categories?.toLowerCase().includes(query)
  );
});

// Export Project Stats data as CSV
const exportProjectStatsData = () => {
  const headers = [
    'Project ID', 'Project Title', 'Project Status', 'Project Categories',
    'Start Date', 'End Date', 'Milestones Count', 'Documents Count', 'Total Items'
  ];
  
  const csvContent = [
    headers.join(','),
    ...filteredProjectStatsData.value.map(row => [
      row.project_id,
      `"${row.project_title || ''}"`,
      row.project_status || '',
      `"${row.project_categories || ''}"`,
      row.project_start_date || '',
      row.project_end_date || '',
      row.milestones_count,
      row.documents_count,
      row.total_items
    ].join(','))
  ].join('\n');
  
  const blob = new Blob([csvContent], { type: 'text/csv' });
  const url = window.URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = 'project_stats_data.csv';
  link.click();
  window.URL.revokeObjectURL(url);
};

// Toggle SQL View
const toggleSqlView = async () => {
  if (!showSqlView.value) {
    showSqlView.value = true;
    await loadSqlViewData();
  } else {
    showSqlView.value = false;
  }
};

// Filtered SQL data for search
const filteredSqlData = computed(() => {
  if (!sqlSearchQuery.value) return sqlViewData.value;
  const query = sqlSearchQuery.value.toLowerCase();
  return sqlViewData.value.filter(row =>
    row.project_title?.toLowerCase().includes(query) ||
    row.user_id?.toLowerCase().includes(query) ||
    row.project_status?.toLowerCase().includes(query) ||
    row.user_role?.toLowerCase().includes(query) ||
    row.project_categories?.toLowerCase().includes(query)
  );
});

// Export SQL data as CSV
const exportSqlData = () => {
  const headers = [
    'Project ID', 'Project Title', 'Project Status', 'Project Categories',
    'Start Date', 'End Date', 'User ID', 
    'User Role', 'User Active', 'Joined At', 'Member ID'
  ];
  
  const csvContent = [
    headers.join(','),
    ...filteredSqlData.value.map(row => [
      row.project_id,
      `"${row.project_title || ''}"`,
      row.project_status || '',
      `"${row.project_categories || ''}"`,
      row.project_start_date || '',
      row.project_end_date || '',
      row.user_id || '',
      row.user_role || '',
      row.user_active || '',
      row.joined_at || '',
      row.project_member_id || ''
    ].join(','))
  ].join('\n');
  
  const blob = new Blob([csvContent], { type: 'text/csv' });
  const url = window.URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = 'projects_members_data.csv';
  link.click();
  window.URL.revokeObjectURL(url);
};

// Format date helper
const formatDate = (dateString) => {
  if (!dateString) return '';
  try {
    return new Date(dateString).toLocaleDateString('id-ID');
  } catch {
    return dateString;
  }
};

// Format datetime helper
const formatDateTime = (dateString) => {
  if (!dateString) return '';
  try {
    return new Date(dateString).toLocaleString('id-ID');
  } catch {
    return dateString;
  }
};

// Get status color
const getStatusColor = (status) => {
  switch (status?.toUpperCase()) {
    case 'PLANNING': return 'bg-yellow-100 text-yellow-800';
    case 'ONGOING': return 'bg-blue-100 text-blue-800';
    case 'COMPLETED': return 'bg-green-100 text-green-800';
    default: return 'bg-gray-100 text-gray-800';
  }
};

// Get role color
const getRoleColor = (role) => {
  switch (role?.toUpperCase()) {
    case 'MANAGER': return 'bg-purple-100 text-purple-800';
    case 'MEMBER': return 'bg-blue-100 text-blue-800';
    default: return 'bg-gray-100 text-gray-800';
  }
};

// Rest of the existing pagination functions
const goToPage = async (page) => {
  if (
    page >= 1 &&
    page <= maxPage.value &&
    page !== currentPage.value &&
    !loading.value
  ) {
    await loadProjects(page);
    jumpToPage.value = null;
  }
};

const goToPreviousPage = async () => {
  if (currentPage.value > 1) {
    await goToPage(currentPage.value - 1);
  }
};

const goToNextPage = async () => {
  if (currentPage.value < maxPage.value) {
    await goToPage(currentPage.value + 1);
  }
};

const goToFirstPage = async () => {
  if (currentPage.value !== 1) {
    await goToPage(1);
  }
};

const goToLastPage = async () => {
  if (currentPage.value !== maxPage.value) {
    await goToPage(maxPage.value);
  }
};

const getPageNumbers = () => {
  const pages = [];
  const showPages = 5;

  if (maxPage.value <= showPages) {
    for (let i = 1; i <= maxPage.value; i++) {
      pages.push(i);
    }
  } else {
    let start = Math.max(1, currentPage.value - 2);
    let end = Math.min(maxPage.value, currentPage.value + 2);

    if (currentPage.value <= 3) {
      end = Math.min(maxPage.value, 5);
    } else if (currentPage.value >= maxPage.value - 2) {
      start = Math.max(1, maxPage.value - 4);
    }

    for (let i = start; i <= end; i++) {
      pages.push(i);
    }
  }

  return pages;
};

const filteredProjects = computed(() => {
  if (!searchQuery.value) return projects.value;
  const q = searchQuery.value.toLowerCase();
  return projects.value.filter(
    (p) =>
      p.title?.toLowerCase().includes(q) ||
      p.author?.toLowerCase().includes(q) ||
      p.categories?.toLowerCase().includes(q) ||
      p.description?.toLowerCase().includes(q)
  );
});

const refreshFilled = async (projectId) => {
  const idx = projects.value.findIndex(p => p.project_id === projectId);
  if (idx !== -1) {
    projects.value[idx].filled += 1;
  }
};
</script>

<template>
  <div class="gap-y-6 pr-2">
    <!-- Judul dan SQL View Toggle -->
    <!-- Judul dan SQL View Toggle -->
<div class="flex justify-between items-center mb-4">
  <h1 class="text-2xl be-vietnam-pro-semibold text-gray-800">
    Daftar Proyek
  </h1>
  <div class="flex items-center gap-3">
    <!-- New button for Project Stats SQL View -->
    <button
      @click="toggleProjectStatsView"
      :disabled="projectStatsLoading"
      class="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50"
    >
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
        <path fill="currentColor" d="M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 22L12 18.77L5.82 22L7 14.14l-5-4.87l6.91-1.01L12 2z"/>
      </svg>
      {{ showProjectStatsView ? 'Tutup Stats View' : 'Project Stats View' }}
    </button>
    
    <button
      @click="toggleSqlView"
      :disabled="sqlViewLoading"
      class="flex items-center gap-2 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors disabled:opacity-50"
    >
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
        <path fill="currentColor" d="M12 3L2 12h3v8h14v-8h3L12 3zm0 2.4l6 6V18h-3v-4H9v4H6v-6.6l6-6z"/>
      </svg>
      {{ showSqlView ? 'Tutup SQL View' : 'Tampilkan SQL View' }}
    </button>
  </div>
</div>

    <!-- SQL View Modal/Overlay -->
    <div
      v-if="showSqlView"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
      @click="showSqlView = false"
    >
      <div
        class="bg-white rounded-lg shadow-xl w-full h-full m-4 flex flex-col"
        @click.stop
      >
        <!-- SQL View Header -->
        <div class="bg-gray-50 px-6 py-4 border-b border-gray-200 flex justify-between items-center">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">Projects & Members - SQL View</h3>
            <p class="text-sm text-gray-600">Menampilkan semua proyek dengan anggotanya (format seperti hasil SQL)</p>
          </div>
          <div class="flex items-center gap-3">
            <button
              @click="exportSqlData"
              :disabled="filteredSqlData.length === 0"
              class="flex items-center gap-2 px-3 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors disabled:opacity-50"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6z"/>
              </svg>
              Export CSV
            </button>
            <button
              @click="showSqlView = false"
              class="text-gray-400 hover:text-gray-600 transition-colors"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- SQL View Search -->
        <div class="p-4 bg-gray-50 border-b border-gray-200">
          <div class="flex items-center bg-white rounded-lg px-4 py-2 border border-gray-300">
            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
            <input
              v-model="sqlSearchQuery"
              type="text"
              placeholder="Cari berdasarkan nama proyek, user ID, status, role..."
              class="bg-transparent flex-1 outline-none text-gray-700"
            />
          </div>
          <div class="mt-2 text-sm text-gray-600">
            Total rows: {{ filteredSqlData.length }} | Unique projects: {{ [...new Set(filteredSqlData.map(r => r.project_id))].length }}
          </div>
        </div>

        <!-- SQL View Content -->
        <div class="flex-1 overflow-hidden">
          <!-- Loading State -->
          <div v-if="sqlViewLoading" class="flex items-center justify-center h-full">
            <div class="text-center">
              <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-purple-500 mx-auto mb-3"></div>
              <p class="text-gray-600">Memuat data SQL view...</p>
            </div>
          </div>

          <!-- Error State -->
          <div v-else-if="sqlViewError" class="flex items-center justify-center h-full">
            <div class="text-center">
              <svg class="w-12 h-12 text-red-500 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <p class="text-red-700">{{ sqlViewError }}</p>
            </div>
          </div>

          <!-- SQL Table -->
          <div v-else class="h-full overflow-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50 sticky top-0">
                <tr>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Project ID</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Project Title</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categories</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User ID</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Active</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Joined</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr 
                  v-for="(row, index) in filteredSqlData" 
                  :key="index"
                  :class="index % 2 === 0 ? 'bg-white' : 'bg-gray-50'"
                  class="hover:bg-blue-50 transition-colors"
                >
                  <td class="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    {{ row.project_id }}
                  </td>
                  <td class="px-3 py-4 text-sm text-gray-900 max-w-xs">
                    <div class="truncate" :title="row.project_title">{{ row.project_title }}</div>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-900">
                    <span :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', getStatusColor(row.project_status)]">
                      {{ row.project_status }}
                    </span>
                  </td>
                  <td class="px-3 py-4 text-sm text-gray-900 max-w-xs">
                    <div class="truncate" :title="row.project_categories">{{ row.project_categories }}</div>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-900 font-mono">
                    <!-- Clickable User ID -->
                    <button
                      v-if="row.user_id"
                      @click="showUserProjects(row.user_id)"
                      class="text-blue-600 hover:text-blue-800 hover:underline transition-colors font-medium"
                      :title="`Klik untuk melihat semua proyek ${row.user_id}`"
                    >
                      {{ row.user_id }}
                    </button>
                    <span v-else class="text-gray-400">-</span>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-900">
                    <span 
                      v-if="row.user_role"
                      :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', getRoleColor(row.user_role)]"
                    >
                      {{ row.user_role }}
                    </span>
                    <span v-else class="text-gray-400">-</span>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-900">
                    <span 
                      v-if="row.user_active !== null"
                      :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', row.user_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800']"
                    >
                      {{ row.user_active ? 'Active' : 'Inactive' }}
                    </span>
                    <span v-else class="text-gray-400">-</span>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ row.joined_at ? formatDate(row.joined_at) : '-' }}
                  </td>
                </tr>
              </tbody>
            </table>

            <!-- Empty State -->
            <div v-if="filteredSqlData.length === 0" class="text-center py-8">
              <svg class="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Tidak Ada Data</h3>
              <p class="text-gray-500">Tidak ada data yang sesuai dengan pencarian.</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Project Stats View Modal -->
    <div
      v-if="showProjectStatsView"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
      @click="showProjectStatsView = false"
    >
      <div
        class="bg-white rounded-lg shadow-xl w-full h-full m-4 flex flex-col"
        @click.stop
      >
        <!-- Project Stats Header -->
        <div class="bg-gray-50 px-6 py-4 border-b border-gray-200 flex justify-between items-center">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">Project Statistics - Milestones & Documents</h3>
            <p class="text-sm text-gray-600">Menampilkan semua proyek dengan jumlah milestone dan dokumen</p>
          </div>
          <div class="flex items-center gap-3">
            <button
              @click="exportProjectStatsData"
              :disabled="filteredProjectStatsData.length === 0"
              class="flex items-center gap-2 px-3 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors disabled:opacity-50"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
                <path fill="currentColor" d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6z"/>
              </svg>
              Export CSV
            </button>
            <button
              @click="showProjectStatsView = false"
              class="text-gray-400 hover:text-gray-600 transition-colors"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- Project Stats Search -->
        <div class="p-4 bg-gray-50 border-b border-gray-200">
          <div class="flex items-center bg-white rounded-lg px-4 py-2 border border-gray-300">
            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
            <input
              v-model="projectStatsSearchQuery"
              type="text"
              placeholder="Cari berdasarkan nama proyek, status, kategori..."
              class="bg-transparent flex-1 outline-none text-gray-700"
            />
          </div>
          <div class="mt-2 text-sm text-gray-600">
            Total projects: {{ filteredProjectStatsData.length }} | 
            Total milestones: {{ filteredProjectStatsData.reduce((sum, p) => sum + p.milestones_count, 0) }} | 
            Total documents: {{ filteredProjectStatsData.reduce((sum, p) => sum + p.documents_count, 0) }}
          </div>
        </div>

        <!-- Project Stats Content -->
        <div class="flex-1 overflow-hidden">
          <!-- Loading State -->
          <div v-if="projectStatsLoading" class="flex items-center justify-center h-full">
            <div class="text-center">
              <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-green-500 mx-auto mb-3"></div>
              <p class="text-gray-600">Memuat statistik proyek...</p>
            </div>
          </div>

          <!-- Error State -->
          <div v-else-if="projectStatsError" class="flex items-center justify-center h-full">
            <div class="text-center">
              <svg class="w-12 h-12 text-red-500 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <p class="text-red-700">{{ projectStatsError }}</p>
            </div>
          </div>

          <!-- Project Stats Table -->
          <div v-else class="h-full overflow-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50 sticky top-0">
                <tr>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Project ID</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Project Title</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categories</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Start Date</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">End Date</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Milestones</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Documents</th>
                  <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Items</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr 
                  v-for="(row, index) in filteredProjectStatsData" 
                  :key="index"
                  :class="index % 2 === 0 ? 'bg-white' : 'bg-gray-50'"
                  class="hover:bg-blue-50 transition-colors"
                >
                  <td class="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    {{ row.project_id }}
                  </td>
                  <td class="px-3 py-4 text-sm text-gray-900 max-w-xs">
                    <div class="truncate" :title="row.project_title">{{ row.project_title }}</div>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-900">
                    <span :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', getStatusColor(row.project_status)]">
                      {{ row.project_status }}
                    </span>
                  </td>
                  <td class="px-3 py-4 text-sm text-gray-900 max-w-xs">
                    <div class="truncate" :title="row.project_categories">{{ row.project_categories }}</div>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ row.project_start_date ? formatDate(row.project_start_date) : '-' }}
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ row.project_end_date ? formatDate(row.project_end_date) : '-' }}
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-center">
                    <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-blue-100 text-blue-800">
                      {{ row.milestones_count }}
                    </span>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-center">
                    <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-green-100 text-green-800">
                      {{ row.documents_count }}
                    </span>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-center">
                    <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-purple-100 text-purple-800">
                      {{ row.total_items }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>

            <!-- Empty State -->
            <div v-if="filteredProjectStatsData.length === 0" class="text-center py-8">
              <svg class="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Tidak Ada Data</h3>
              <p class="text-gray-500">Tidak ada data yang sesuai dengan pencarian.</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- User Projects Modal -->
    <div
      v-if="showUserProjectsModal"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-60"
      @click="closeUserProjectsModal"
    >
      <div
        class="bg-white rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-hidden"
        @click.stop
      >
        <!-- Modal Header -->
        <div class="bg-gray-50 px-6 py-4 border-b border-gray-200 flex justify-between items-center">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">
              Proyek untuk User: {{ selectedUserId }}
            </h3>
            <p class="text-sm text-gray-600">
              Menampilkan semua proyek yang melibatkan user ini
            </p>
          </div>
          <button
            @click="closeUserProjectsModal"
            class="text-gray-400 hover:text-gray-600 transition-colors"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <!-- Modal Body -->
        <div class="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
          <!-- Loading State -->
          <div v-if="userProjectsLoading" class="flex justify-center items-center py-8">
            <div class="text-center">
              <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"></div>
              <p class="text-gray-600">Memuat proyek pengguna...</p>
            </div>
          </div>

          <!-- Error State -->
          <div v-else-if="userProjectsError" class="bg-red-50 border border-red-200 rounded-lg p-4">
            <div class="flex items-center">
              <svg class="w-5 h-5 text-red-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <p class="text-red-700">{{ userProjectsError }}</p>
            </div>
          </div>

          <!-- No Projects -->
          <div v-else-if="userProjects.length === 0" class="text-center py-8">
            <svg class="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
            </svg>
            <h3 class="text-lg font-medium text-gray-900 mb-2">Tidak Ada Proyek</h3>
            <p class="text-gray-500">User ini tidak terlibat dalam proyek apapun.</p>
          </div>

          <!-- Projects List -->
          <div v-else class="space-y-4">
            <div class="mb-4">
              <h4 class="text-sm font-semibold text-gray-700 mb-2">
                Ringkasan: {{ userProjects.length }} proyek ditemukan
              </h4>
              <div class="grid grid-cols-3 gap-4 text-center mb-6">
                <div class="bg-blue-50 rounded-lg p-3">
                  <div class="text-2xl font-bold text-blue-600">{{ userProjects.filter(p => p.status === 'ONGOING').length }}</div>
                  <div class="text-xs text-blue-800">Sedang Berjalan</div>
                </div>
                <div class="bg-green-50 rounded-lg p-3">
                  <div class="text-2xl font-bold text-green-600">{{ userProjects.filter(p => p.status === 'COMPLETED').length }}</div>
                  <div class="text-xs text-green-800">Selesai</div>
                </div>
                <div class="bg-yellow-50 rounded-lg p-3">
                  <div class="text-2xl font-bold text-yellow-600">{{ userProjects.filter(p => p.status === 'PLANNING').length }}</div>
                  <div class="text-xs text-yellow-800">Perencanaan</div>
                </div>
              </div>
            </div>

            <div
              v-for="project in userProjects"
              :key="project.project_id"
              class="bg-gray-50 rounded-lg p-4 border border-gray-200 hover:shadow-md transition-shadow"
            >
              <div class="flex justify-between items-start mb-3">
                <div class="flex-1">
                  <div class="flex items-center gap-3 mb-2">
                    <h4 class="font-semibold text-gray-900">{{ project.title }}</h4>
                    <span class="text-sm text-gray-500">(ID: {{ project.project_id }})</span>
                  </div>
                  <div class="flex items-center gap-4 text-sm text-gray-600 mb-2">
                    <span :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', getStatusColor(project.status)]">
                      {{ project.status }}
                    </span>
                    <span :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', getRoleColor(project.user_role)]">
                      {{ project.user_role }}
                    </span>
                    <span :class="['inline-flex px-2 py-1 text-xs font-semibold rounded-full', project.user_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800']">
                      {{ project.user_active ? 'Active' : 'Inactive' }}
                    </span>
                  </div>
                </div>
              </div>
              
              <div class="grid grid-cols-2 gap-4 text-sm text-gray-600 mb-2">
                <div>
                  <span class="font-medium">Mulai:</span>
                  {{ project.start_date ? formatDate(project.start_date) : 'Belum ditentukan' }}
                </div>
                <div>
                  <span class="font-medium">Selesai:</span>
                  {{ project.end_date ? formatDate(project.end_date) : 'Belum ditentukan' }}
                </div>
              </div>
              
              <div class="text-sm text-gray-600 mb-2">
                <span class="font-medium">Bergabung:</span>
                {{ project.joined_at ? formatDateTime(project.joined_at) : 'Data tidak tersedia' }}
              </div>
              
              <div v-if="project.categories" class="mt-3">
                <div class="flex flex-wrap gap-1">
                  <span
                    v-for="category in (Array.isArray(project.categories) ? project.categories : project.categories.split(','))"
                    :key="category"
                    class="inline-flex px-2 py-1 text-xs bg-gray-200 text-gray-700 rounded"
                  >
                    {{ category.trim() }}
                  </span>
                </div>
              </div>
              
              <!-- View Project Button -->
              <div class="mt-3 pt-3 border-t border-gray-200">
                <button
                  @click="$router.push(`/detailprojects/${project.project_id}`); closeUserProjectsModal();"
                  class="text-blue-600 hover:text-blue-800 text-sm font-medium transition-colors"
                >
                  Lihat Detail Proyek →
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Regular Project List View (existing content) -->
    <div v-if="!showSqlView">
      <!-- Input Pencarian + Filter -->
      <div class="flex gap-x-16 gap-y-4">
        <div
          class="flex items-center bg-[#E8EDF2] rounded-xl justify-center h-12 mb-4 lg:w-[700px] md:w-[] text-gray-700 p-3"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5A6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5S14 7.01 14 9.5S11.99 14 9.5 14z"
            />
          </svg>
          <input
           v-model="searchQuery"
            type="text"
            placeholder="Cari judul proyek"
            class="outline-none h-12 w-full text-sm p-3"
          />
        </div>
        <button
          class="flex h-12 w-24 justify-center items-center rounded-xl text-gray-900 bg-white shadow-md hover:shadow-lg transition-shadow"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="M4 3h16a1 1 0 0 1 1 1v1.586a1 1 0 0 1-.293.707l-6.414 6.414a1 1 0 0 0-.293.707v6.305a1 1 0 0 1-1.242.97l-2-.5a1 1 0 0 1-.758-.97v-5.805a1 1 0 0 0-.293-.707L3.293 6.293A1 1 0 0 1 3 5.586V4a1 1 0 0 1 1-1"
            />
          </svg>
          <span class="mr-1 text-sm">Filter</span>
        </button>
      </div>

      <!-- Error Message -->
      <div
        v-if="errorMessage"
        class="bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg mb-6"
      >
        {{ errorMessage }}
      </div>
      <div class="h-3"></div>
      <!-- Pagination Info -->
      <div
        v-if="totalCount >= 0"
        class="text-sm text-gray-600 mb-4 flex justify-between items-center pr-16"
      >
        <div>
          Menampilkan {{ (currentPage - 1) * perPage + 1 }}-{{
            Math.min(currentPage * perPage, totalCount)
          }}
          dari {{ totalCount }} proyek
          <span v-if="maxPage > 1"
            >(Halaman {{ currentPage }} dari {{ maxPage }})</span
          >
        </div>
        <div v-if="perPage > 0" class="text-xs text-gray-500">
          {{ perPage }} proyek per halaman
        </div>
      </div>

      <div class="h-8"></div>

      <!-- Loading State -->
      <div
        v-if="loading"
        class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-y-10"
      >
        <div
          v-for="i in perPage"
          :key="`loading-${i}`"
          class="bg-gray-200 rounded-lg w-96 h-64 animate-pulse"
        ></div>
      </div>

      <!-- Daftar Proyek -->
      <div
        v-else
        class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 gap-y-10"
      >
        <ProjectCardMain
          v-for="(project, index) in filteredProjects"
          :key="project.project_id || index"
          :project_id="project.project_id"
          :title="project.title"
          :author="project.author"
          :filled="project.filled"
          :total="project.total"
          :categories="project.categories"
          :description="project.description"
          @update-filled="refreshFilled"
        />
      </div>
      <div class="h-12"></div>
      <!-- Pagination Controls -->
      <div v-if="maxPage > 1" class="flex justify-center items-center mt-8 gap-2">
        <!-- First Page Button -->
        <button
          @click="goToFirstPage"
          :disabled="currentPage === 1 || loading"
          class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          title="Halaman pertama"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="M18.41 16.59L13.82 12l4.59-4.59L17 6l-6 6l6 6zM6 6h2v12H6z"
            />
          </svg>
        </button>

        <!-- Previous Page Button -->
        <button
          @click="goToPreviousPage"
          :disabled="currentPage === 1 || loading"
          class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          title="Halaman sebelumnya"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="M15.41 16.59L10.83 12l4.58-4.59L14 6l-6 6l6 6z"
            />
          </svg>
        </button>

        <!-- Page Numbers -->
        <div class="flex gap-1">
          <!-- Show first page if not in visible range -->
          <template v-if="getPageNumbers()[0] > 1">
            <button
              @click="goToPage(1)"
              :disabled="loading"
              class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50"
            >
              1
            </button>
            <span
              v-if="getPageNumbers()[0] > 2"
              class="px-2 py-2 text-sm text-gray-500"
              >...</span
            >
          </template>

          <!-- Visible page numbers -->
          <button
            v-for="page in getPageNumbers()"
            :key="page"
            @click="goToPage(page)"
            :disabled="loading"
            :class="[
              'px-3 py-2 text-sm font-medium rounded-md disabled:opacity-50',
              page === currentPage
                ? 'text-white bg-blue-600 border border-blue-600'
                : 'text-gray-500 bg-white border border-gray-300 hover:bg-gray-50 hover:text-gray-700',
            ]"
          >
            {{ page }}
          </button>

          <!-- Show last page if not in visible range -->
          <template
            v-if="getPageNumbers()[getPageNumbers().length - 1] < maxPage"
          >
            <span
              v-if="getPageNumbers()[getPageNumbers().length - 1] < maxPage - 1"
              class="px-2 py-2 text-sm text-gray-500"
              >...</span
            >
            <button
              @click="goToPage(maxPage)"
              :disabled="loading"
              class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50"
            >
              {{ maxPage }}
            </button>
          </template>
        </div>

        <!-- Next Page Button -->
        <button
          @click="goToNextPage"
          :disabled="currentPage === maxPage || loading"
          class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          title="Halaman selanjutnya"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="M8.59 16.59L13.17 12L8.59 7.41L10 6l6 6l-6 6z"
            />
          </svg>
        </button>

        <!-- Last Page Button -->
        <button
          @click="goToLastPage"
          :disabled="currentPage === maxPage || loading"
          class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          title="Halaman terakhir"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            viewBox="0 0 24 24"
          >
            <path
              fill="currentColor"
              d="M5.59 7.41L10.18 12l-4.59 4.59L7 18l6-6l-6-6zM16 6v12h2V6z"
            />
          </svg>
        </button>
      </div>

      <!-- Page Jump Input (for large datasets) -->
      <div
        v-if="maxPage > 10"
        class="flex justify-center items-center mt-4 gap-2 text-sm"
      >
        <span class="text-gray-600">Langsung ke halaman:</span>
        <input
          v-model.number="jumpToPage"
          @keyup.enter="goToPage(jumpToPage)"
          type="number"
          :min="1"
          :max="maxPage"
          class="w-16 px-2 py-1 text-center border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          :disabled="loading"
        />
        <button
          @click="goToPage(jumpToPage)"
          :disabled="
            loading || !jumpToPage || jumpToPage < 1 || jumpToPage > maxPage
          "
          class="px-3 py-1 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Pergi
        </button>
      </div>

      <!-- No projects message -->
      <div v-if="projects.length === 0 && !loading" class="text-center py-12">
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
        <h3 class="text-lg font-medium text-gray-900 mb-2">Tidak ada proyek</h3>
        <p class="text-gray-500">Belum ada proyek yang tersedia saat ini.</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Custom scrollbar for the SQL table */
.overflow-auto::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

.overflow-auto::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.overflow-auto::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

.overflow-auto::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* Higher z-index for user projects modal */
.z-60 {
  z-index: 60;
}
</style>