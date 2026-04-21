package com.project.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/stats")
public class StatsController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @GetMapping("/project_options")
    public Map<String, Object> projectOptions(
            @RequestParam(value = "user_id", required = false, defaultValue = "0") Integer userId,
            @RequestParam(value = "user_group", required = false, defaultValue = "") String userGroup
    ) {
        String sql = "SELECT intangible_cultural_heritage_projects_id AS id, entry_name AS name, project_category, regional_name " +
                "FROM `intangible_cultural_heritage_projects`";
        if ("传承用户".equals(userGroup)) {
            sql += " WHERE inheritance_personnel = " + userId;
        }
        sql += " ORDER BY intangible_cultural_heritage_projects_id";

        List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        return success(result);
    }

    @GetMapping("/project_daily_metrics")
    public Map<String, Object> projectDailyMetrics(
            @RequestParam("start_date") String startDate,
            @RequestParam("end_date") String endDate,
            @RequestParam("metric") String metric,
            @RequestParam(value = "project_ids", required = false, defaultValue = "") String projectIds,
            @RequestParam(value = "user_id", required = false, defaultValue = "0") Integer userId,
            @RequestParam(value = "user_group", required = false, defaultValue = "") String userGroup
    ) {
        LocalDate start = LocalDate.parse(startDate, DATE_FMT);
        LocalDate end = LocalDate.parse(endDate, DATE_FMT);
        if (end.isBefore(start)) {
            LocalDate tmp = start;
            start = end;
            end = tmp;
        }

        Set<Integer> selectedIds = parseIds(projectIds);
        if (selectedIds.isEmpty()) {
            Map<String, Object> empty = new HashMap<>();
            empty.put("xAxis", new ArrayList<>());
            empty.put("names", new ArrayList<>());
            empty.put("values", new ArrayList<>());
            empty.put("export_rows", new ArrayList<>());
            empty.put("export_summary_rows", new ArrayList<>());
            return success(empty);
        }

        String nameSql = "SELECT intangible_cultural_heritage_projects_id, entry_name FROM `intangible_cultural_heritage_projects` " +
                "WHERE intangible_cultural_heritage_projects_id IN (" + joinIds(selectedIds) + ") ORDER BY intangible_cultural_heritage_projects_id";
        List<Map<String, Object>> projectRows = jdbcTemplate.queryForList(nameSql);
        Map<Integer, String> idNameMap = new LinkedHashMap<>();
        for (Map<String, Object> row : projectRows) {
            Integer id = Integer.parseInt(String.valueOf(row.get("intangible_cultural_heritage_projects_id")));
            idNameMap.put(id, String.valueOf(row.get("entry_name")));
        }

        List<String> xAxis = new ArrayList<>();
        List<String> names = new ArrayList<>();
        names.add("总量");
        names.addAll(idNameMap.values());

        List<Map<String, Object>> exportRows = new ArrayList<>();
        Map<String, Integer> projectSummary = new LinkedHashMap<>();
        projectSummary.put("总量", 0);
        for (String n : idNameMap.values()) {
            projectSummary.put(n, 0);
        }
        List<List<Integer>> values = new ArrayList<>();
        for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
            String day = d.format(DATE_FMT);
            xAxis.add(day);

            List<Integer> oneRow = new ArrayList<>();
            int total = 0;
            oneRow.add(0); // total placeholder

            Map<String, Object> exportRow = new LinkedHashMap<>();
            exportRow.put("日期", day);

            for (Map.Entry<Integer, String> entry : idNameMap.entrySet()) {
                Integer pid = entry.getKey();
                int count = countMetricByProjectDay(metric, pid, day);
                total += count;
                oneRow.add(count);
                exportRow.put(entry.getValue(), count);
            }
            oneRow.set(0, total);
            exportRow.put("总量", total);
            exportRows.add(exportRow);
            values.add(oneRow);
            projectSummary.put("总量", projectSummary.get("总量") + total);
            for (Map.Entry<Integer, String> entry : idNameMap.entrySet()) {
                String name = entry.getValue();
                Object v = exportRow.get(name);
                int cv = v == null ? 0 : Integer.parseInt(String.valueOf(v));
                projectSummary.put(name, projectSummary.get(name) + cv);
            }
        }

        List<Map<String, Object>> exportSummaryRows = new ArrayList<>();
        for (Map.Entry<String, Integer> item : projectSummary.entrySet()) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("项目", item.getKey());
            row.put("统计值", item.getValue());
            exportSummaryRows.add(row);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("xAxis", xAxis);
        result.put("names", names);
        result.put("values", values);
        result.put("export_rows", exportRows);
        result.put("export_summary_rows", exportSummaryRows);
        return success(result);
    }

    @GetMapping("/active_users_daily")
    public Map<String, Object> activeUsersDaily(
            @RequestParam("start_date") String startDate,
            @RequestParam("end_date") String endDate
    ) {
        LocalDate start = LocalDate.parse(startDate, DATE_FMT);
        LocalDate end = LocalDate.parse(endDate, DATE_FMT);
        if (end.isBefore(start)) {
            LocalDate tmp = start;
            start = end;
            end = tmp;
        }

        List<String> xAxis = new ArrayList<>();
        List<String> names = new ArrayList<>();
        names.add("活跃用户");
        List<List<Integer>> values = new ArrayList<>();
        List<Map<String, Object>> exportRows = new ArrayList<>();

        for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
            String day = d.format(DATE_FMT);
            xAxis.add(day);
            String sql = "SELECT COUNT(DISTINCT user_id) FROM `hits` " +
                    "WHERE user_id > 0 AND DATE(create_time) = '" + day + "'";
            Integer c = jdbcTemplate.queryForObject(sql, Integer.class);
            int count = c == null ? 0 : c;

            List<Integer> one = new ArrayList<>();
            one.add(count);
            values.add(one);

            Map<String, Object> row = new LinkedHashMap<>();
            row.put("日期", day);
            row.put("活跃用户", count);
            exportRows.add(row);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("xAxis", xAxis);
        result.put("names", names);
        result.put("values", values);
        result.put("export_rows", exportRows);
        return success(result);
    }

    private int countMetricByProjectDay(String metric, Integer projectId, String day) {
        String projectSource = "source_table = 'intangible_cultural_heritage_projects' AND source_id = " + projectId;
        String whereDay;
        String sql;
        switch (metric) {
            case "read":
                whereDay = "DATE(create_time) = '" + day + "' AND " + projectSource;
                sql = "SELECT COUNT(*) FROM `hits` WHERE " + whereDay;
                break;
            case "fav_like":
                whereDay = "DATE(create_time) = '" + day + "' AND " + projectSource;
                String collectSql = "SELECT COUNT(*) FROM `collect` WHERE " + whereDay;
                String praiseSql = "SELECT COUNT(*) FROM `praise` WHERE " + whereDay;
                Integer collectCount = jdbcTemplate.queryForObject(collectSql, Integer.class);
                Integer praiseCount = jdbcTemplate.queryForObject(praiseSql, Integer.class);
                return (collectCount == null ? 0 : collectCount) + (praiseCount == null ? 0 : praiseCount);
            case "comment":
                whereDay = "DATE(create_time) = '" + day + "' AND " + projectSource;
                sql = "SELECT COUNT(*) FROM `comment` WHERE " + whereDay;
                break;
            default:
                return 0;
        }
        Integer c = jdbcTemplate.queryForObject(sql, Integer.class);
        return c == null ? 0 : c;
    }

    private Set<Integer> parseIds(String ids) {
        Set<Integer> result = new LinkedHashSet<>();
        if (ids == null || ids.trim().isEmpty()) {
            return result;
        }
        String[] arr = ids.split(",");
        for (String raw : arr) {
            String s = raw.trim();
            if (!s.matches("\\d+")) {
                continue;
            }
            result.add(Integer.parseInt(s));
        }
        return result;
    }

    private String joinIds(Set<Integer> ids) {
        StringBuilder sb = new StringBuilder();
        int i = 0;
        for (Integer id : ids) {
            if (i++ > 0) sb.append(",");
            sb.append(id);
        }
        return sb.toString();
    }

    private Map<String, Object> success(Object o) {
        Map<String, Object> map = new HashMap<>();
        map.put("result", o);
        return map;
    }
}

