<script lang="ts" setup>

enum Status {
  End = 'Finalizada',
  Pending = 'Pendente',
  OnGoing = 'Em Curso',
  PendingLate = 'Pendente (Atrasada)',
  OnGoingLate = 'Em curso (Atrasada)',
  PendingEarly = 'Antecipado',
  Canceled = 'Cancelada',
  CancelRequested = 'Cancelamento Solicitado'
}

const props = defineProps<{ status: string }>();

const bgColor = (status: string) => {
  switch (status) {
    case 'Finalizada':
      return 'bg-green-100';
    case 'Pendente':
      return 'bg-yellow-100';
    case 'Em Curso':
      return 'bg-blue-300';
    case 'Pendente (Atrasada)':
      return 'bg-red-100';
  }
}
</script>

<template>
  <div class="badge badge-outline">{{ props.status }}</div>
</template>

<style scoped>

</style>