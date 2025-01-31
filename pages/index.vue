<script lang="ts" setup>

import {DailyPlanStatusEnum} from "~/types/DailyPlanStatus";
import Stats from "~/components/Stats.vue";

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

const countDown = ref(60);

const loading = ref(true);

const updatePlans = async () => {
  await $fetch('https://fluxos.sonils.co.ao/webhook/daily-plan').then((data) => {
    plans.value = data as Plan[];
    loading.value = false;
  });
};


onMounted(async () => {

  await updatePlans();

  //loading.value = false;

  setInterval(async () => {
    location.reload();
  }, 60 * 1000);

  setInterval( () => {

    countDown.value = countDown.value - 1;

    console.log(countDown.value);
    if (countDown.value <= 0) {
      location.reload();
    }

  }, 1000);
});


/*onMounted(async () => {

  await $fetch('https://fluxos.sonils.co.ao/webhook/daily-plan')
      .then((data) => {
        //loading.value = true;
        plans.value = data as Plan[];
      })
      .finally(() => {
        loading.value = false;
      });

  setInterval( () => {

    countDown.value = countDown.value - 1;

    console.log(countDown.value);
    if (countDown.value <= 0) {
      location.reload();
    }

  }, 1000);


});*/

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
    case 'Cancelada':
      return 'bg-red-200';
  }
}

const totalPendents = computed(() => {
  return plans.value.filter((plan) => plan.Status === DailyPlanStatusEnum.Pending).length;
})

const totalEnd = computed(() => {
  return plans.value.filter((plan) => plan.Status === DailyPlanStatusEnum.End).length;
})

const totalCancelado = computed(() => {
  return plans.value.filter((plan) => plan.Status === DailyPlanStatusEnum.Canceled).length;
})

const totalOnGoing = computed(() => {
  return plans.value.filter((plan) => plan.Status === DailyPlanStatusEnum.OnGoing).length;
})


</script>

<template>
  <!--  <div class="w-full h-full border-blue-500 flex justify-center items-center" v-if="loading">
      <div class="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-gray-900"></div>
    </div>-->

  <div v-if="loading" class="flex justify-center items-center h-screen">
    <!--  <div class="animate-spin rounded-full h-32 w-32 border-t-4 border-b-4 border-gray-900"></div>-->
    <img class="animate-pulse" src="/logo.png" alt="logo"/>

  </div>

  <div v-else class="bg-white rounded-lg shadow-lg border-slate-400 text-xs">
    <div class="flex justify-between  p-4">
      <div class="flex justify-start gap-5">
        <Stats :value="totalPendents" title="Pendentes"/>
        <Stats :value="totalOnGoing" title="Em Curso"/>
        <Stats :value="totalEnd" title="Finalizados"/>
        <Stats :value="totalCancelado" title="Cancelados"/>
        <Stats :value="plans.length" title="Total"/>
      </div>

      <span class="countdown font-mono text-6xl">
        <span :style="{'--value': countDown}"></span>
      </span>
    </div>
    <table class="table-auto w-full table-pin-rows table-lg">
      <thead class="bg-blue-500 text-white shadow-lg ">
      <tr>
        <th class="py-3 px-4 text-left">Cliente</th>
        <th class="py-3 px-4 text-left">Atribuição</th>
        <th class="py-3 px-4 text-left">Estado</th>
        <th class="py-3 px-4 text-left">Inicio Planeado</th>
        <th class="py-3 px-4 text-left">Termino Planeado</th>
        <th class="py-3 px-4 text-left">Inicio</th>
        <th class="py-3 px-4 text-left">Fim</th>
        <th class="py-3 px-4 text-left">Operadores</th>
        <th class="py-3 px-4 text-left">Equipamentos</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="plan in plans" :class="rowBgColor(plan.Status)" class="border-b border-2 border-black p-1">
        <td class="p-1">
          {{ plan.ClientName }}
        </td>
        <td class="p-1">
          {{ plan.AtributionNumber }}
        </td>
        <td class="p-1">
          <DailyPlanStatus :status="plan.Status"/>
        </td>
        <td class="p-1">
          <NuxtTime :class="{'late': plan.PlannedStart && plan.Status === DailyPlanStatusEnum.Pending && new Date(plan.PlannedStart).getTime() - new Date().getTime() < 600000}" :datetime="plan.PlannedStart" day="2-digit" hour="2-digit" hour-cycle="h23" minute="2-digit"
                    month="2-digit" time-zone="UTC"/>
        </td>
        <td class="p-1">
          <NuxtTime :datetime="plan.PlannedEnd" day="2-digit" hour="2-digit" hour-cycle="h23" minute="2-digit"
                    month="2-digit" time-zone="UTC"/>
        </td>
        <td class="p-1">
          <!--          {{plan.StartDate}}-->
          <NuxtTime v-if="plan.StartDate" :datetime="plan.StartDate" day="2-digit" hour="2-digit" hour-cycle="h23"
                    minute="2-digit" month="2-digit" time-zone="UTC"/>
        </td>
        <td class="p-1">
          <!--                    {{plan.EndDate}}-->
          <NuxtTime v-if="plan.EndDate" :datetime="plan.EndDate" day="2-digit" hour="2-digit" hour-cycle="h23"
                    minute="2-digit" month="2-digit" time-zone="UTC"/>
        </td>
        <td class="p-1">
          <ul class="list-disc list-inside">
            <li v-for="operator in plan.Operators">{{ operator.name }}</li>
          </ul>
        </td>
        <td class="p-1">
          <ul v-if="plan.Equipments.length > 0" class="list-disc list-inside">
            <li v-for="equipment in plan.Equipments">
              {{ equipment.Code }}
            </li>
          </ul>
          <span v-else>Sem equipamentos</span>
        </td>


      </tr>
      </tbody>
    </table>
  </div>

</template>

<style scoped>

.late{
  color: red;

  animation: pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite;

  @keyframes pulse {
    0%, 100% {
      opacity: 1;
    }
    50% {
      opacity: .5;
    }
  }
}
</style>