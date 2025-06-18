import apiService from './api.js';

export const projectService = {
  async getProjects(page = 1) {
    try {
      const response = await apiService.getProjects(page);
      console.log('Projects response:', response);
      
      // Extract projects from response.data
      if (response.data && Array.isArray(response.data)) {
        return response.data;
      }
      
      return [];
    } catch (error) {
      console.error('Error fetching projects:', error);
      throw error;
    }
  },

  async getRecommendedProjects(maxProjects = 6) {
    try {
      const activeProjects = [];
      let currentPage = 1;
      let maxPagesToCheck = 10; // Limit to prevent infinite loops
      let consecutiveEmptyPages = 0;
      
      console.log('Starting to fetch recommended projects...');
      
      // Keep fetching pages until we have enough active projects or reach limits
      while (activeProjects.length < maxProjects && currentPage <= maxPagesToCheck) {
        try {
          console.log(`Fetching page ${currentPage}...`);
          const pageProjects = await this.getProjects(currentPage);
          
          // If page is empty, increment counter
          if (pageProjects.length === 0) {
            consecutiveEmptyPages++;
            // If we get 2 consecutive empty pages, assume no more data
            if (consecutiveEmptyPages >= 2) {
              console.log('No more pages available, stopping fetch');
              break;
            }
          } else {
            consecutiveEmptyPages = 0; // Reset counter
            
            // Filter non-completed projects from this page
            const pageActiveProjects = pageProjects.filter(project => 
              project.status && project.status.toUpperCase() !== 'COMPLETED'
            );
            
            console.log(`Page ${currentPage}: Found ${pageActiveProjects.length} active projects out of ${pageProjects.length}`);
            
            // Add to our collection
            activeProjects.push(...pageActiveProjects);
          }
          
          currentPage++;
        } catch (pageError) {
          console.error(`Error fetching page ${currentPage}:`, pageError);
          currentPage++;
        }
      }
      
      console.log(`Total active projects found: ${activeProjects.length}`);
      
      // If we still don't have any active projects, try to get some completed ones as fallback
      if (activeProjects.length === 0) {
        console.log('No active projects found, falling back to completed projects...');
        
        try {
          const fallbackProjects = await this.getProjects(1);
          const completedProjects = fallbackProjects.filter(project => 
            project.status && project.status.toUpperCase() === 'COMPLETED'
          );
          
          if (completedProjects.length > 0) {
            console.log(`Using ${completedProjects.length} completed projects as fallback`);
            // Randomly select from completed projects
            const shuffled = completedProjects.sort(() => 0.5 - Math.random());
            return shuffled.slice(0, maxProjects);
          }
        } catch (fallbackError) {
          console.error('Error fetching fallback projects:', fallbackError);
        }
        
        // If still no projects, return empty array
        return [];
      }
      
      // Randomly shuffle and select the requested number of projects
      const shuffled = activeProjects.sort(() => 0.5 - Math.random());
      const selectedProjects = shuffled.slice(0, maxProjects);
      
      console.log(`Selected ${selectedProjects.length} projects for recommendations`);
      return selectedProjects;
      
    } catch (error) {
      console.error('Error fetching recommended projects:', error);
      return [];
    }
  },

  // Alternative method for truly random selection
  async getRecommendedProjectsAdvanced(maxProjects = 6) {
    try {
      // First, get a sample of projects to understand the data
      const sampleSize = 5; // Number of pages to sample
      const allProjects = [];
      
      // Fetch multiple pages in parallel for better performance
      const pagePromises = [];
      for (let i = 1; i <= sampleSize; i++) {
        pagePromises.push(
          this.getProjects(i).catch(error => {
            console.error(`Error fetching page ${i}:`, error);
            return []; // Return empty array on error
          })
        );
      }
      
      const pageResults = await Promise.all(pagePromises);
      
      // Flatten all results
      pageResults.forEach(pageProjects => {
        allProjects.push(...pageProjects);
      });
      
      // Filter active projects
      const activeProjects = allProjects.filter(project => 
        project.status && project.status.toUpperCase() !== 'COMPLETED'
      );
      
      console.log(`Advanced method: Found ${activeProjects.length} active projects from ${allProjects.length} total`);
      
      // If no active projects, use completed ones
      if (activeProjects.length === 0) {
        console.log('No active projects, using completed projects');
        const completedProjects = allProjects.filter(project => 
          project.status && project.status.toUpperCase() === 'COMPLETED'
        );
        
        if (completedProjects.length === 0) {
          return []; // No projects at all
        }
        
        // Use Fisher-Yates shuffle for better randomness
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
      const response = await apiService.put(`/api/project/${projectId}`, projectData);
      return response.data;
    } catch (error) {
      console.error('Error updating project:', error);
      throw error;
    }
  },

  async deleteProject(projectId) {
    try {
      const response = await apiService.delete(`/api/project/${projectId}`);
      return response.data;
    } catch (error) {
      console.error('Error deleting project:', error);
      throw error;
    }
  },

  async getProjectsByStatus(status, page = 1) {
    try {
      const response = await apiService.get(`/api/project?status=${status}&page=${page}`);
      if (response.data && Array.isArray(response.data)) {
        return response.data;
      }
      return [];
    } catch (error) {
      console.error('Error fetching projects by status:', error);
      throw error;
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