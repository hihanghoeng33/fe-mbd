import { defineStore } from "pinia";
import { ref } from "vue";

const userStore = defineStore('user', () => {
    const user = ref(null)
    const loadUser = () => {
        const u = localStorage.getItem('user')
        if(u) user.value = JSON.parse(u);
    }
    return {user, loadUser};
})