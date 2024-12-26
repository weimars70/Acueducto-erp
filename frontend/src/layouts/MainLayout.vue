<template>
  <q-layout view="hHh lpR fFf">
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-btn dense flat round icon="menu" @click="toggleLeftDrawer" />
        <q-toolbar-title>Consumos App</q-toolbar-title>
        <div class="row items-center">
          <span class="q-mr-sm">{{ userFullName }}</span>
          <q-btn flat round dense icon="logout" @click="logout">
            <q-tooltip>Cerrar sesión</q-tooltip>
          </q-btn>
        </div>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" bordered>
      <q-list>
        <q-item-label header>Menu Principal</q-item-label>
        
        <q-item clickable v-ripple to="/consumos">
          <q-item-section avatar>
            <q-icon name="list" />
          </q-item-section>
          <q-item-section>Listado de Consumos</q-item-section>
        </q-item>

        <q-item clickable v-ripple to="/nuevo-consumo">
          <q-item-section avatar>
            <q-icon name="add_circle" />
          </q-item-section>
          <q-item-section>Nuevo Consumo</q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from 'src/stores/auth';

const leftDrawerOpen = ref(false);
const router = useRouter();
const authStore = useAuthStore();

const userFullName = computed(() => authStore.userFullName);

const toggleLeftDrawer = () => {
  leftDrawerOpen.value = !leftDrawerOpen.value;
};

const logout = async () => {
  authStore.logout();
  router.push('/login');
};
</script>