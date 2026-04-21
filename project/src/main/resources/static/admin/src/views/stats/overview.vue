<template>
  <div class="page_root">
    <div class="warp">
      <div class="container-fluid">
        <projectStatsPanel v-if="canViewProjectStats" />
      </div>
    </div>
  </div>
</template>

<script>
import projectStatsPanel from "@/components/charts/project_stats_panel.vue";

export default {
  name: "StatsOverview",
  components: { projectStatsPanel },
  computed: {
    canViewProjectStats() {
      const group = (this.$store.state.user || {}).user_group;
      return group === "管理员" || group === "传承用户";
    }
  }
};
</script>

