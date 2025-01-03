<script lang="ts" setup>

import type {DailyPlanStatusEnum} from "~/types/DailyPlanStatus";

interface Plan {
  PlanId: string;
  ExecutionId: string;
  OperationId: string;
  ClientName: string;
  AtributionNumber: string;
  Status: DailyPlanStatusEnum;
  PlannedStart: string;
  PlannedEnd: string;
  StartDate: string;
  EndDate: string;
  Equipments: Equipment[];
  Operators: Operator[];
}

interface Equipment {
  Code: string;
  Category: string;
}

interface Operator {
  name: string;
}

useHead({
  title: 'Plano Diario',
});

const plans = ref<Plan[]>([]);

const updatePlans = async () => {
  await $fetch('https://fluxos.sonils.co.ao/webhook/daily-plan').then((data) => {
    plans.value = data as Plan[];
  });
};

onMounted(async () => {
  await updatePlans();

  setInterval(async () => {
    await updatePlans();
  }, 60 * 1000);
});

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

const rowBgColor = (status: string) => {
  switch (status) {
    case 'Finalizada':
      return 'bg-green-100';
    case 'Pendente':
      return 'bg-yellow-100';
    case 'Em Curso':
      return 'bg-blue-100';
    case 'Pendente (Atrasada)':
      return 'bg-red-100';
  }
}

</script>

<template>
<div class="container mx-auto w-full" ></div>
  <div class="bg-white rounded-lg shadow-lg border-slate-400 overflow-x-auto">
    <table class="table-auto w-full table-pin-rows">
      <thead class="bg-blue-500 text-white shadow-lg">
      <tr>
        <th class="py-3 px-4 text-left">Cliente</th>
        <th class="py-3 px-4 text-left">Atribuição</th>
        <th class="py-3 px-4 text-left">Estado</th>
        <th class="py-3 px-4 text-left">Data Planeada de Inicio</th>
        <th class="py-3 px-4 text-left">Data Planeada de Termino</th>
        <th class="py-3 px-4 text-left">Data de Inicio</th>
        <th class="py-3 px-4 text-left">Data de Termino</th>
        <th class="py-3 px-4 text-left">Operadores</th>
        <th class="py-3 px-4 text-left">Equipamentos</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="plan in plans" :class="rowBgColor(plan.Status)" class="border-b border-2 border-black">
        <td class="px-4 py-3">
          {{plan.ClientName}}
        </td>
        <td class="px-4 py-3">
          {{plan.AtributionNumber}}
        </td>
        <td class="px-4 py-3">
          <DailyPlanStatus :status="plan.Status"/>
        </td>
        <td class="px-4 py-3">
          <NuxtTime :datetime="plan.PlannedStart" day="2-digit" month="2-digit" year="numeric" hour="2-digit" minute="2-digit" hour-cycle="h23"/>
<!--          {{plan.PlannedStart}}-->
        </td>
        <td class="px-4 py-3">
          <NuxtTime :datetime="plan.PlannedEnd" day="2-digit" month="2-digit" year="numeric" hour="2-digit" minute="2-digit"  hour-cycle="h23"/>
        </td>
        <td class="px-4 py-3">
<!--          {{plan.StartDate}}-->
          <NuxtTime v-if="plan.StartDate" :datetime="plan.StartDate" day="2-digit" month="2-digit" year="numeric" hour="2-digit" minute="2-digit"  hour-cycle="h23"/>
        </td>
        <td class="px-4 py-3">
<!--          {{plan.EndDate}}-->
          <NuxtTime v-if="plan.EndDate" :datetime="plan.EndDate" day="2-digit" month="2-digit" year="numeric" hour="2-digit" minute="2-digit"  hour-cycle="h23"/>
        </td>
        <td class="px-4 py-3">
          <ul class="list-disc list-inside">
            <li v-for="operator in plan.Operators">{{operator.name}}</li>
          </ul>
        </td>
        <td class="px-4 py-3">
          <ul class="list-disc list-inside">
            <li v-for="equipment in plan.Equipments">
              {{equipment.Code}} - {{equipment.Category}}
            </li>
          </ul>
        </td>


      </tr>
      </tbody>
    </table>
  </div>


<!--  <pre>{{ plans }}</pre>-->
</template>

<style scoped>

</style>