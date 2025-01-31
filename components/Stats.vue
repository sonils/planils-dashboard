<script setup lang="ts">
const props = defineProps<{
  title: string,
  value: number
}>();
</script>

<template>
  <div class="flex items-center border border-black px-3 py-1 rounded-md">
    <div class="text-3xl me-2">{{ value }}</div>
    <span class="text-2xl">{{title}}</span>
  </div>
</template>

<style scoped>

</style>