import apiService from './api.js';

export const authService = {
  async login(email, password) {
    const response = await apiService.post('/api/login', {
      email,
      password,
    });
    
    console.log('Login response:', response);
    console.log('Access token:', response.data?.access_token);
    
    if (response.data && response.data.access_token) {
      localStorage.setItem('token', response.data.access_token);
      console.log('Token stored successfully:', response.data.access_token);

      try {
        console.log('Fetching user profile...');
        const userData = await this.getCurrentUserProfile();
        console.log('User data fetched:', userData);
        return { ...response, user: userData };
      } catch (error) {
        console.error('Failed to fetch user profile after login:', error);
        // Still return the response even if user fetch fails
        return response;
      }
    } else {
      console.error('No access token in login response');
    }
    
    return response;
  },

  async register(userData) {
    const response = await apiService.post('/api/register', userData);
    
    console.log('Register response:', response);
    console.log('Access token:', response.data?.access_token);
    
    if (response.data && response.data.access_token) {
      localStorage.setItem('token', response.data.access_token);
      console.log('Token stored successfully:', response.data.access_token);

      try {
        console.log('Fetching user profile...');
        const userDataResponse = await this.getCurrentUserProfile();
        console.log('User data fetched:', userDataResponse);
        return { ...response, user: userDataResponse };
      } catch (error) {
        console.error('Failed to fetch user profile after register:', error);
        // Still return the response even if user fetch fails
        return response;
      }
    } else {
      console.error('No access token in register response');
    }
    
    return response;
  },

  async getCurrentUserProfile() {
    const token = localStorage.getItem('token');
    console.log('Getting user profile with token:', token);
    
    if (!token) {
      throw new Error('No token available');
    }
    
    const response = await apiService.get('/api/me');
    console.log('/api/me full response:', response);
    console.log('/api/me user data:', response.data);
    
    // Fix: Extract user data from response.data instead of response directly
    const userData = {
      user_id: response.data.user_id,
      name: response.data.name,
      email: response.data.email,
      contact_info: response.data.contact_info,
      role: response.data.role
    };
    
    console.log('Extracted user data:', userData);
    
    if (userData) {
      localStorage.setItem('user', JSON.stringify(userData));
      console.log('User data stored in localStorage:', userData);
    }
    
    return userData;
  },

  async updateProfile(userData) {
    const response = await apiService.put('/api/me', userData);
    
    // Fix: Extract user data from response.data
    if (response.data) {
      const updatedUserData = {
        user_id: response.data.user_id,
        name: response.data.name,
        email: response.data.email,
        contact_info: response.data.contact_info,
        role: response.data.role
      };
      localStorage.setItem('user', JSON.stringify(updatedUserData));
      return updatedUserData;
    }
    
    return response;
  },

  logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    console.log('User logged out, tokens cleared');
  },

  getCurrentUser() {
    const user = localStorage.getItem('user');
    console.log('Getting current user from localStorage:', user);
    return user ? JSON.parse(user) : null;
  },

  isAuthenticated() {
    const token = localStorage.getItem('token');
    console.log('Checking authentication, token exists:', !!token);
    return !!token;
  },
};