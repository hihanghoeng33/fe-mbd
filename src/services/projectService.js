import apiService from './api.js';

export const projectService = {
  async getProjects(page = 1) {
    try {
      const response = await apiService.getProjects(page);
      console.log('Projects response:', response);

      // Return both data and meta information with proper structure
      return {
        data: response.data && Array.isArray(response.data) ? response.data : [],
        meta: {
          page: response.meta?.page || page,
          per_page: response.meta?.per_page || 10,
          max_page: response.meta?.max_page || 1,
          count: response.meta?.count || 0
        }
      };
    } catch (error) {
      console.error('Error fetching projects:', error);
      throw error;
    }
  },

  async getRecommendedProjects(maxProjects = 6) {
    try {
      console.log('Starting to fetch recommended projects...');

      // First, get the first page to understand the total number of pages
      const firstPageResult = await this.getProjects(1);
      const maxPage = firstPageResult.meta.max_page || 1;
      const totalCount = firstPageResult.meta.count || 0;
      const activeProjects = [];

      console.log(`Total pages available: ${maxPage}, Total projects: ${totalCount}`);

      // Determine how many pages to fetch based on available pages
      const pagesToFetch = Math.min(maxPage, 5); // Limit to 5 pages max for performance

      // Fetch multiple pages in parallel for better performance
      const pagePromises = [];
      for (let i = 1; i <= pagesToFetch; i++) {
        pagePromises.push(
          this.getProjects(i).catch(error => {
            console.error(`Error fetching page ${i}:`, error);
            return {
              data: [],
              meta: { page: i, per_page: 10, max_page: 1, count: 0 }
            };
          })
        );
      }

      const pageResults = await Promise.all(pagePromises);

      // Collect all projects and filter active ones
      pageResults.forEach((result, index) => {
        const pageProjects = result.data;
        const pageActiveProjects = pageProjects.filter(project =>
          project.status && project.status.toUpperCase() !== 'COMPLETED'
        );

        console.log(`Page ${index + 1}: Found ${pageActiveProjects.length} active projects out of ${pageProjects.length}`);
        activeProjects.push(...pageActiveProjects);
      });

      console.log(`Total active projects found: ${activeProjects.length}`);

      // If we still don't have enough active projects and there are more pages, try fetching more
      if (activeProjects.length < maxProjects && pagesToFetch < maxPage) {
        console.log('Not enough active projects, fetching more pages...');

        const additionalPagesToFetch = Math.min(maxPage - pagesToFetch, 3); // Fetch up to 3 more pages
        const additionalPagePromises = [];

        for (let i = pagesToFetch + 1; i <= pagesToFetch + additionalPagesToFetch; i++) {
          additionalPagePromises.push(
            this.getProjects(i).catch(error => {
              console.error(`Error fetching additional page ${i}:`, error);
              return {
                data: [],
                meta: { page: i, per_page: 10, max_page: 1, count: 0 }
              };
            })
          );
        }

        const additionalPageResults = await Promise.all(additionalPagePromises);

        additionalPageResults.forEach((result, index) => {
          const pageProjects = result.data;
          const pageActiveProjects = pageProjects.filter(project =>
            project.status && project.status.toUpperCase() !== 'COMPLETED'
          );

          console.log(`Additional page ${pagesToFetch + index + 1}: Found ${pageActiveProjects.length} active projects`);
          activeProjects.push(...pageActiveProjects);
        });
      }

      // If we still don't have any active projects, try to get some completed ones as fallback
      if (activeProjects.length === 0) {
        console.log('No active projects found, falling back to completed projects...');

        const allProjects = [];
        pageResults.forEach(result => {
          allProjects.push(...result.data);
        });

        const completedProjects = allProjects.filter(project =>
          project.status && project.status.toUpperCase() === 'COMPLETED'
        );

        if (completedProjects.length > 0) {
          console.log(`Using ${completedProjects.length} completed projects as fallback`);
          // Use Fisher-Yates shuffle for better randomness
          return this.fisherYatesShuffle([...completedProjects]).slice(0, maxProjects);
        }

        // If still no projects, return empty array
        return [];
      }

      // Use Fisher-Yates shuffle for better randomness
      const shuffledProjects = this.fisherYatesShuffle([...activeProjects]);
      const selectedProjects = shuffledProjects.slice(0, maxProjects);

      console.log(`Selected ${selectedProjects.length} projects for recommendations`);
      return selectedProjects;

    } catch (error) {
      console.error('Error fetching recommended projects:', error);
      return [];
    }
  },

  // Alternative method that uses smart page selection
  async getRecommendedProjectsAdvanced(maxProjects = 6) {
    try {
      console.log('Using advanced method for recommended projects...');

      // First, get metadata about available pages
      const firstPageResult = await this.getProjects(1);
      const maxPage = firstPageResult.meta.max_page || 1;
      const totalCount = firstPageResult.meta.count || 0;

      console.log(`Advanced method: Total pages available: ${maxPage}, Total projects: ${totalCount}`);

      // If there are many pages, randomly select which pages to fetch
      let pagesToFetch = [];
      if (maxPage <= 5) {
        // If few pages, fetch all
        pagesToFetch = Array.from({ length: maxPage }, (_, i) => i + 1);
      } else {
        // If many pages, randomly select 5 pages
        const allPages = Array.from({ length: maxPage }, (_, i) => i + 1);
        pagesToFetch = this.fisherYatesShuffle(allPages).slice(0, 5);
      }

      console.log(`Advanced method: Fetching pages: ${pagesToFetch.join(', ')}`);

      // Fetch selected pages in parallel
      const pagePromises = pagesToFetch.map(pageNum =>
        this.getProjects(pageNum).catch(error => {
          console.error(`Error fetching page ${pageNum}:`, error);
          return {
            data: [],
            meta: { page: pageNum, per_page: 10, max_page: 1, count: 0 }
          };
        })
      );

      const pageResults = await Promise.all(pagePromises);

      // Collect all projects
      const allProjects = [];
      pageResults.forEach((result, index) => {
        allProjects.push(...result.data);
        console.log(`Advanced method page ${pagesToFetch[index]}: ${result.data.length} projects`);
      });

      // Filter active projects
      const activeProjects = allProjects.filter(project =>
        project.status && project.status.toUpperCase() !== 'COMPLETED'
      );

      console.log(`Advanced method: Found ${activeProjects.length} active projects from ${allProjects.length} total`);

      // If no active projects, use completed ones
      if (activeProjects.length === 0) {
        console.log('Advanced method: No active projects, using completed projects');
        const completedProjects = allProjects.filter(project =>
          project.status && project.status.toUpperCase() === 'COMPLETED'
        );

        if (completedProjects.length === 0) {
          return []; // No projects at all
        }

        return this.fisherYatesShuffle([...completedProjects]).slice(0, maxProjects);
      }

      // Use Fisher-Yates shuffle for better randomness
      return this.fisherYatesShuffle([...activeProjects]).slice(0, maxProjects);

    } catch (error) {
      console.error('Error in advanced recommended projects:', error);
      return [];
    }
  },

  // Fisher-Yates shuffle for better randomness
  fisherYatesShuffle(array) {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    return shuffled;
  },

  async getProjectById(projectId) {
    try {
      const response = await apiService.get(`/api/project/${projectId}`);
      return response.data;
    } catch (error) {
      console.error('Error fetching project by ID:', error);
      throw error;
    }
  },

  async getProjectMilestones(projectId) {
    try {
      const response = await apiService.get(`/api/project/${projectId}/milestones`);
      console.log('Project milestones response:', response);
      return response.data && Array.isArray(response.data) ? response.data : [];
    } catch (error) {
      console.error('Error fetching project milestones:', error);
      throw error;
    }
  },

  async getProjectDocuments(projectId) {
    try {
      const response = await apiService.get(`/api/project/${projectId}/documents`);
      console.log('Project documents response:', response);
      return response.data?.documents && Array.isArray(response.data.documents) ? response.data.documents : [];
    } catch (error) {
      console.error('Error fetching project documents:', error);
      throw error;
    }
  },

  async getProjectMembers(projectId) {
    try {
      const response = await apiService.get(`/api/project/${projectId}/members`);
      console.log('Project members full response:', response);
      console.log('Response data:', response.data);
      console.log('Response data type:', typeof response.data);
      
      // Handle different response formats
      if (response.data === null || response.data === undefined) {
        console.log('Response data is null/undefined, checking response directly');
        if (Array.isArray(response)) {
          console.log('Response itself is an array');
          return response;
        }
        return [];
      }
      
      if (Array.isArray(response.data)) {
        console.log('Response.data is an array with length:', response.data.length);
        return response.data;
      }
      
      if (response.data && Array.isArray(response.data.data)) {
        console.log('Response.data.data is an array');
        return response.data.data;
      }
      
      // If response structure is different, try to find the array
      if (typeof response.data === 'object') {
        console.log('Response.data is an object, keys:', Object.keys(response.data));
        // Look for array properties
        for (const key of Object.keys(response.data)) {
          if (Array.isArray(response.data[key])) {
            console.log(`Found array in response.data.${key}`);
            return response.data[key];
          }
        }
      }
      
      console.warn('Unexpected response format for project members:', response);
      return [];
    } catch (error) {
      console.error('Error fetching project members:', error);
      console.error('Error details:', error.response?.data || error.message);
      throw error;
    }
  },

  async createProject(projectData) {
    try {
      const response = await apiService.post('/api/project', projectData);
      return response.data;
    } catch (error) {
      console.error('Error creating project:', error);
      throw error;
    }
  },

  async updateProject(projectId, projectData) {
    try {
      const response = await apiService.put(`/api/projects/${projectId}`, projectData);
      return response.data;
    } catch (error) {
      console.error('Error updating project:', error);
      throw error;
    }
  },

  async deleteProject(projectId) {
    try {
      const response = await apiService.delete(`/api/projects/${projectId}`);
      return response.data;
    } catch (error) {
      console.error('Error deleting project:', error);
      throw error;
    }
  },

  async getProjectsByUserId() {
    try {
      const response = await apiService.get('/api/user/projects');
      return response.data;
    } catch (error) {
      console.error('Error fetching projects:', error);
      throw error
    }
  },

  async getProjectsByStatus(status, page = 1) {
    try {
      const response = await apiService.get(`/api/projects?status=${status}&page=${page}`);
      return {
        data: response.data && Array.isArray(response.data) ? response.data : [],
        meta: {
          page: response.meta?.page || page,
          per_page: response.meta?.per_page || 10,
          max_page: response.meta?.max_page || 1,
          count: response.meta?.count || 0
        }
      };
    } catch (error) {
      console.error('Error fetching projects by status:', error);
      throw error;
    }
  },

  // Helper method to get all projects with pagination awareness
  async getAllActiveProjects() {
    try {
      const firstPageResult = await this.getProjects(1);
      const maxPage = firstPageResult.meta.max_page || 1;
      const totalCount = firstPageResult.meta.count || 0;
      const allActiveProjects = [];

      console.log(`Getting all active projects from ${maxPage} pages (${totalCount} total projects)`);

      // Add first page active projects
      const firstPageActive = firstPageResult.data.filter(project =>
        project.status && project.status.toUpperCase() !== 'COMPLETED'
      );
      allActiveProjects.push(...firstPageActive);

      // Fetch remaining pages if there are any
      if (maxPage > 1) {
        const remainingPagePromises = [];
        for (let i = 2; i <= maxPage; i++) {
          remainingPagePromises.push(
            this.getProjects(i).catch(error => {
              console.error(`Error fetching page ${i}:`, error);
              return {
                data: [],
                meta: { page: i, per_page: 10, max_page: 1, count: 0 }
              };
            })
          );
        }

        const remainingPageResults = await Promise.all(remainingPagePromises);

        remainingPageResults.forEach(result => {
          const pageActiveProjects = result.data.filter(project =>
            project.status && project.status.toUpperCase() !== 'COMPLETED'
          );
          allActiveProjects.push(...pageActiveProjects);
        });
      }

      console.log(`Found ${allActiveProjects.length} active projects total`);
      return allActiveProjects;
    } catch (error) {
      console.error('Error fetching all active projects:', error);
      return [];
    }
  },


  // Mock data helpers (since project members are under development)
  getMockAuthors() {
    return [
      'Prof. Dr. Amtsal Jago Banget',
      'Prof. Dr. Arya Sudewa',
      'Prof.Dr.(Eng). Ir. Benjamin Bryant',
      'Danny Mason S.Kom., M.Kom.',
      'Heather King S.Kom., M.Kom., Ph.D.',
      'Jessica Jones S.T., M.T.',
      'Victoria Baldwin S.Kom., M.Kom.',
      'Joshua Nguyen S.Kom., M.Kom., Ph.D.',
      'Amy Hernandez S.Kom., M.Kom.',
      'Bradley Jones S.Kom., M.Kom.'
    ];
  },



  getRandomStudentCount() {
    const filled = Math.floor(Math.random() * 8) + 1; // 1-8 students
    const total = filled + Math.floor(Math.random() * 4) + 1; // 1-4 more slots available
    return { filled, total };
  },

  transformProjectData(project) {
    const studentCount = this.getRandomStudentCount();
    const mockAuthors = this.getMockAuthors();
    const randomAuthor = mockAuthors[Math.floor(Math.random() * mockAuthors.length)];

    return {
      project_id: project.project_id,
      title: project.title || 'Untitled Project',
      description: project.description || 'No description available',
      categories: project.categories || 'General',
      author: randomAuthor,
      filled: studentCount.filled,
      total: studentCount.total,
      status: project.status,
      start_date: project.start_date,
      end_date: project.end_date
    };
  }
};