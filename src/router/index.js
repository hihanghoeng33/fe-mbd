import { createRouter, createWebHistory } from 'vue-router';
import { authService } from '@/services/authService';
import Main from '@/components/Main.vue';
import Login from '@/components/Login.vue';
import Register from '@/components/Register.vue';
import Index from '@/components/Index.vue';
import Home from '@/components/Home.vue';
import Projects from '@/components/Projects.vue';
import Archive from '@/components/Archive.vue';
import DetailProject from '@/components/DetailProject.vue';
import HomeLecturer from '@/components/HomeLecturer.vue';
import Profile from '@/components/Profile.vue';
import ProjectsManagement from '@/components/ProjectsManagement.vue';
import HomeAdmin from '@/components/HomeAdmin.vue';
import ListofProject from '@/components/ListofProject.vue';
import LecturerArchive from '@/components/LecturerArchive.vue';

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
    {
        path: '/',
        name: 'index',
        component: Index
    }, {
        path: '/login',
        name: 'login',
        component: Login
    }, {
        path: '/register',
        name: 'register',
        component: Register
    }, {
        path: '/dashboard',
        component: Main, 
        children: [
        {
            path: '',
            name: 'home',
            component: Home
        },
        {
          path: '/projects',
          name: 'projects',
          component: Projects
        },
        {
            path: '/detailprojects/:id',
            name: 'detailprojects',
            component: DetailProject
        }, 
        {
            path: '/archive',
            name: 'archive',
            component: Archive
        },
        {
            path: '/lecturerhome',
            name: 'lecturerhome',
            component: HomeLecturer
        },
        {
            path: '/profile',
            name: 'profile',
            component: Profile
        }, 
        {
            path: '/projectsmanagement',
            name: 'projectsmanagement',
            component: ProjectsManagement
        }, 
        {
            path: '/adminhome',
            name: 'adminhome',
            component: HomeAdmin
        },
        {
            path: '/listofproject',
            name: 'listofprojectadmin',
            component: ListofProject
        },
        {
            path: '/lecturerarchive',
            name: 'lecturerarchive',
            component: LecturerArchive
        }
        ]
    }]
})

console.log('Router initialized');
console.log('Routes:', router.getRoutes());
router.beforeEach((to, from, next) => {
  const isAuthenticated = authService.isAuthenticated();
  const publicPages = ['login', 'register', 'index'];
  const authRequired = !publicPages.includes(to.name);

    console.log(authService.isAuthenticated());
  if (authRequired && !isAuthenticated) {
    next({ name: 'login' }); // redirect to login page
  } else {
    console.log('Apakah baik?')
    next();
  }
});

export default router;