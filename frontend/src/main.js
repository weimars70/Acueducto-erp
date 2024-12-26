import { createApp } from 'vue';
import { createPinia } from 'pinia';
import { Quasar, Notify } from 'quasar';
import router from './router';
import App from './App.vue';
import { useAuthStore } from './stores/auth';

// Import Quasar css
import '@quasar/extras/material-icons/material-icons.css';
import 'quasar/src/css/index.sass';

const app = createApp(App);
const pinia = createPinia();

app.use(pinia);
app.use(Quasar, {
  plugins: { Notify },
  config: { notify: {} }
});

// Initialize auth store before setting up router
const authStore = useAuthStore();
authStore.initialize();

app.use(router);
app.mount('#app');