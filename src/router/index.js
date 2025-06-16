import { createRouter, createWebHistory } from 'vue-router';
import Main from '@/components/Main.vue';
import Login from '@/components/Login.vue';
import Register from '@/components/Register.vue';
import Index from '@/components/Index.vue';
import Home from '@/components/Home.vue';
import Projects from '@/components/Projects.vue';
import Archive from '@/components/Archive.vue';
import DetailProject from '@/components/DetailProject.vue';

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
            path: '/detailprojects',
            name: 'detailprojects',
            component: DetailProject
        }, 
        {
            path: '/archive',
            name: 'archive',
            component: Archive
        }
        ]
    }]
})

console.log('Router initialized');
console.log('Routes:', router.getRoutes());
// router.beforeEach((to, from, next) => {
//     next();
//   const isAuthenticated = localStorage.getItem('token')

//   const publicPages = ['login', 'register', 'index', 'dashboard']
//   const authRequired = !publicPages.includes(to.name)
//     console.log('Navigating to:', to.name, 'Auth Required:', authRequired, 'Is Authenticated:', isAuthenticated)
//   if (authRequired && !isAuthenticated) {
//     next({ name: 'index' }) // redirect ke halaman home
//   } else {
//     next()
//   }
// })

export default router;