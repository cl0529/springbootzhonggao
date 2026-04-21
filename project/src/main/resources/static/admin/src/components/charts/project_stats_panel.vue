<template>
  <div>
    <el-row style="margin-top: 10px;">
      <el-col :span="24">
        <div class="card chart toolbar-card">
          <div class="toolbar-line">
            <span>项目勾选显示：</span>
            <el-select
              v-model="pendingFilterCategory"
              filterable
              clearable
              placeholder="筛选项目类别"
              class="filter-select"
            >
              <el-option v-for="c in categoryOptions" :key="c" :label="c" :value="c"></el-option>
            </el-select>
            <el-select
              v-model="pendingFilterRegion"
              filterable
              clearable
              placeholder="筛选地区名称"
              class="filter-select"
            >
              <el-option v-for="r in regionOptions" :key="r" :label="r" :value="r"></el-option>
            </el-select>
            <el-button size="mini" type="primary" @click="applyFilters">搜索</el-button>
            <el-switch
              v-model="showTotalLine"
              active-text="显示总和"
              inactive-text="隐藏总和"
            ></el-switch>
            <el-button size="mini" type="success" @click="runStatistics">统计</el-button>
            <el-select
              v-model="selectedProjectIds"
              multiple
              filterable
              collapse-tags
              clearable
              placeholder="请选择项目名称"
              class="project-select"
            >
              <el-option v-for="p in filteredProjectOptions" :key="p.id" :label="p.name" :value="p.id"></el-option>
            </el-select>
            <el-button size="mini" type="primary" plain @click="selectAllProjects">全选</el-button>
            <el-button size="mini" type="warning" plain @click="clearProjects">清空</el-button>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row>
      <el-col :span="8">
        <div v-loading="projectReadChart.loading" class="card chart">
          <div class="export-actions">
            <downloadExcel :data="projectReadChart.exportRows" name="非遗项目阅读量明细.xls">
              <el-button size="mini" type="primary">导出明细</el-button>
            </downloadExcel>
            <downloadExcel :data="projectReadChart.exportSummaryRows" name="非遗项目阅读量汇总.xls">
              <el-button size="mini" type="success">导出汇总</el-button>
            </downloadExcel>
          </div>
          <el-date-picker v-model="projectReadChart.month" :default-time="['00:00:00', '23:59:59']"
                          align="right" end-placeholder="结束日期" start-placeholder="开始日期"
                          type="datetimerange" format="yyyy-MM-dd"
                          ></el-date-picker>
          <newLineChart v-if="projectReadChart.values.length > 0" :key="'read-'+chartRenderKey" id="project_read_chart"
                        :timeout="0" :title="'非遗项目单日总阅读量'" :vm="projectReadChart"
                        style="margin-top: 20px;height: 300px"></newLineChart>
        </div>
      </el-col>

      <el-col :span="8">
        <div v-loading="projectFavLikeChart.loading" class="card chart">
          <div class="export-actions">
            <downloadExcel :data="projectFavLikeChart.exportRows" name="非遗项目收藏点赞明细.xls">
              <el-button size="mini" type="primary">导出明细</el-button>
            </downloadExcel>
            <downloadExcel :data="projectFavLikeChart.exportSummaryRows" name="非遗项目收藏点赞汇总.xls">
              <el-button size="mini" type="success">导出汇总</el-button>
            </downloadExcel>
          </div>
          <el-date-picker v-model="projectFavLikeChart.month" :default-time="['00:00:00', '23:59:59']"
                          align="right" end-placeholder="结束日期" start-placeholder="开始日期"
                          type="datetimerange" format="yyyy-MM-dd"
                          ></el-date-picker>
          <newLineChart v-if="projectFavLikeChart.values.length > 0" :key="'fav-'+chartRenderKey" id="project_fav_like_chart"
                        :timeout="0" :title="'非遗项目收藏点赞数'" :vm="projectFavLikeChart"
                        style="margin-top: 20px;height: 300px"></newLineChart>
        </div>
      </el-col>

      <el-col :span="8">
        <div v-loading="projectCommentChart.loading" class="card chart">
          <div class="export-actions">
            <downloadExcel :data="projectCommentChart.exportRows" name="非遗项目评论明细.xls">
              <el-button size="mini" type="primary">导出明细</el-button>
            </downloadExcel>
            <downloadExcel :data="projectCommentChart.exportSummaryRows" name="非遗项目评论汇总.xls">
              <el-button size="mini" type="success">导出汇总</el-button>
            </downloadExcel>
          </div>
          <el-date-picker v-model="projectCommentChart.month" :default-time="['00:00:00', '23:59:59']"
                          align="right" end-placeholder="结束日期" start-placeholder="开始日期"
                          type="datetimerange" format="yyyy-MM-dd"
                          ></el-date-picker>
          <newLineChart v-if="projectCommentChart.values.length > 0" :key="'comment-'+chartRenderKey" id="project_comment_chart"
                        :timeout="0" :title="'非遗项目评论数'" :vm="projectCommentChart"
                        style="margin-top: 20px;height: 300px"></newLineChart>
        </div>
      </el-col>
    </el-row>

    <el-row v-if="user.user_group === '管理员'">
      <el-col :span="8">
        <div v-loading="activeUserChart.loading" class="card chart">
          <div class="export-actions">
            <downloadExcel :data="activeUserChart.exportRows" name="活跃用户统计.xls">
              <el-button size="mini" type="primary">导出明细</el-button>
            </downloadExcel>
          </div>
          <el-date-picker v-model="activeUserChart.month" :default-time="['00:00:00', '23:59:59']"
                          align="right" end-placeholder="结束日期" start-placeholder="开始日期"
                          type="datetimerange" format="yyyy-MM-dd"
                          ></el-date-picker>
          <newLineChart v-if="activeUserChart.values.length > 0" :key="'active-'+chartRenderKey" id="active_user_chart"
                        :timeout="0" :title="'活跃用户统计'" :vm="activeUserChart"
                        style="margin-top: 20px;height: 300px"></newLineChart>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import newLineChart from "@/components/charts/new_line_chart";

export default {
  name: "projectStatsPanel",
  components: { newLineChart },
  data() {
    return {
      projectOptions: [],
      categoryOptions: [],
      regionOptions: [],
      pendingFilterCategory: "",
      pendingFilterRegion: "",
      filterCategory: "",
      filterRegion: "",
      showTotalLine: true,
      chartRenderKey: 0,
      selectedProjectIds: [],
      projectReadChart: { names: [], xAxis: [], values: [], month: [], loading: false, exportRows: [], exportSummaryRows: [] },
      projectFavLikeChart: { names: [], xAxis: [], values: [], month: [], loading: false, exportRows: [], exportSummaryRows: [] },
      projectCommentChart: { names: [], xAxis: [], values: [], month: [], loading: false, exportRows: [], exportSummaryRows: [] },
      activeUserChart: { names: ["活跃用户"], xAxis: [], values: [], month: [], loading: false, exportRows: [] }
    };
  },
  computed: {
    user() {
      return this.$store.state.user || {};
    },
    filteredProjectOptions() {
      return this.projectOptions.filter((item) => {
        const categoryOk = !this.filterCategory || item.project_category === this.filterCategory;
        const regionOk = !this.filterRegion || item.regional_name === this.filterRegion;
        return categoryOk && regionOk;
      });
    }
  },
  created() {
    this.initProjectMetrics();
  },
  methods: {
    getDateRangeByMonth(model) {
      const now = new Date();
      const y = now.getFullYear();
      const m = now.getMonth();
      const d = now.getDate();
      if (!model.month || model.month.length !== 2) {
        model.month = [new Date(y, m, 1, 0, 0, 0), new Date(y, m, d, 23, 59, 59)];
      }
      const start = new Date(model.month[0]).toStr("yyyy-MM-dd");
      const end = new Date(model.month[1]).toStr("yyyy-MM-dd");
      return { start, end };
    },
    async initProjectMetrics() {
      const json = await this.$get("~/api/stats/project_options", {
        user_id: this.user.user_id,
        user_group: this.user.user_group
      });
      if (json.result && json.result.list) {
        this.projectOptions = json.result.list;
        this.categoryOptions = [...new Set(this.projectOptions.map(o => o.project_category).filter(Boolean))];
        this.regionOptions = [...new Set(this.projectOptions.map(o => o.regional_name).filter(Boolean))];
        this.pendingFilterCategory = "";
        this.pendingFilterRegion = "";
        this.filterCategory = "";
        this.filterRegion = "";
        this.selectedProjectIds = this.projectOptions.map(o => o.id);
      }
    },
    async applyFilters() {
      this.filterCategory = this.pendingFilterCategory;
      this.filterRegion = this.pendingFilterRegion;
    },
    async refreshMetric(metric, model) {
      model.loading = true;
      const { start, end } = this.getDateRangeByMonth(model);
      const json = await this.$get("~/api/stats/project_daily_metrics", {
        start_date: start,
        end_date: end,
        metric,
        project_ids: this.selectedProjectIds.join(","),
        user_id: this.user.user_id,
        user_group: this.user.user_group
      });
      if (json.result) {
        const rawNames = json.result.names || [];
        const rawValues = json.result.values || [];
        const hasTotal = rawNames.length > 0 && rawNames[0] === "总量";
        if (hasTotal && !this.showTotalLine) {
          model.names = rawNames.slice(1);
          model.values = rawValues.map(row => (Array.isArray(row) ? row.slice(1) : []));
        } else {
          model.names = rawNames;
          model.values = rawValues;
        }
        model.xAxis = json.result.xAxis || [];
        model.exportRows = json.result.export_rows || [];
        model.exportSummaryRows = json.result.export_summary_rows || [];
      } else {
        model.names = [];
        model.xAxis = [];
        model.values = [];
        model.exportRows = [];
        model.exportSummaryRows = [];
      }
      model.loading = false;
    },
    async refreshProjectMetrics() {
      await this.refreshMetric("read", this.projectReadChart);
      await this.refreshMetric("fav_like", this.projectFavLikeChart);
      await this.refreshMetric("comment", this.projectCommentChart);
    },
    async selectAllProjects() {
      this.selectedProjectIds = this.filteredProjectOptions.map(o => o.id);
    },
    async clearProjects() {
      this.selectedProjectIds = [];
    },
    async runStatistics() {
      await this.refreshProjectMetrics();
      if (this.user.user_group === "管理员") {
        await this.refreshActiveUsers();
      }
      this.chartRenderKey += 1;
    },
    async refreshActiveUsers() {
      this.activeUserChart.loading = true;
      const { start, end } = this.getDateRangeByMonth(this.activeUserChart);
      const json = await this.$get("~/api/stats/active_users_daily", { start_date: start, end_date: end });
      if (json.result) {
        this.activeUserChart.names = json.result.names || ["活跃用户"];
        this.activeUserChart.xAxis = json.result.xAxis || [];
        this.activeUserChart.values = json.result.values || [];
        this.activeUserChart.exportRows = json.result.export_rows || [];
      }
      this.activeUserChart.loading = false;
    }
  }
};
</script>

<style scoped>
.chart {
  display: block;
  width: 100%;
  height: 400px;
  padding: 1rem;
  position: relative;
}
.toolbar-card {
  height: auto;
  min-height: 90px;
}
.toolbar-line {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}
.project-select {
  min-width: 320px;
  max-width: 560px;
}
.filter-select {
  width: 180px;
}
.export-actions {
  display: flex;
  gap: 8px;
  margin-bottom: 10px;
}
.el-col {
  padding: 0.5rem;
}
.card {
  overflow: hidden;
}
</style>

