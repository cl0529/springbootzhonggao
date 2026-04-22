package com.project.demo.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.project.demo.constant.FindConfig;
import com.project.demo.entity.Order;
import com.project.demo.service.OrderService;

import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.persistence.Query;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 订单：(Order)表控制层
 *
 */
@RestController
@RequestMapping("order")
public class OrderController extends BaseController<Order, OrderService> {
    /**
     * 服务对象
     */
    @Autowired
    public OrderController(OrderService service) {
        setService(service);
    }
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/add")
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> body = service.readBody(request.getReader());
        String goodsId = String.valueOf(body.get("goods_id"));
        String norms = String.valueOf(body.get("norms"));
        int buyNum = parseInt(body.get("num"), 1);
        int currentStock = resolveSpecStock(goodsId, norms);
        if (buyNum > currentStock) {
            return error(30000, "规格库存不足");
        }
        boolean updated = reduceStock(goodsId, norms, buyNum);
        if (!updated) {
            return error(30000, "库存扣减失败，请重试");
        }
        service.insert(body);
        return success(1);
    }

    @RequestMapping("/get_business_order_list")
    public Map<String, Object> getBusinessOrderList(HttpServletRequest request) {
        Map<String,String> query =  service.readQuery(request);
        String sql = "SELECT\n" +
                "\tt1.* \n" +
                "FROM\n" +
                "\t`order` t1\n" +
                "\tLEFT JOIN goods t2 ON t1.goods_id = t2.goods_id \n" +
                "WHERE\n" +
                "\tt2.user_id = "+ query.get("user_id");
        String countSql = "SELECT\n" +
                "\tcount(t1.order_id) \n" +
                "FROM\n" +
                "\t`order` t1\n" +
                "\tLEFT JOIN goods t2 ON t1.goods_id = t2.goods_id \n" +
                "WHERE\n" +
                "\tt2.user_id = "+ query.get("user_id");
        if (!StringUtils.isEmpty(query.get("order_number"))){
            sql = sql + " and t1.order_number like '%"+query.get("order_number")+"%'";
            countSql = countSql + " and t1.order_number like '%"+query.get("order_number")+"%'";
        }
        if (!StringUtils.isEmpty(query.get("title"))){
            sql = sql + " and t1.title like '%"+query.get("title")+"%'";
            countSql = countSql + " and t1.title like '%"+query.get("title")+"%'";
        }
        if (!StringUtils.isEmpty(query.get("contact_name"))){
            sql = sql + " and t1.contact_name like '%"+query.get("contact_name")+"%'";
            countSql = countSql + " and t1.contact_name like '%"+query.get("contact_name")+"%'";
        }
        if (!StringUtils.isEmpty(query.get("state"))){
            sql = sql + " and t1.state = '"+query.get("state")+"'";
            countSql = countSql + " and t1.state = '"+query.get("state")+"'";
        }
        Map<String,String> config =  service.readConfig(request);

        if (!StringUtils.isEmpty(config.get(FindConfig.PAGE))){
            int page = config.get(FindConfig.PAGE) != null && !"".equals(config.get(FindConfig.PAGE)) ? Integer.parseInt(config.get(FindConfig.PAGE)) : 1;
            int limit = config.get(FindConfig.SIZE) != null && !"".equals(config.get(FindConfig.SIZE)) ? Integer.parseInt(config.get(FindConfig.SIZE)) : 10;
            sql = sql + " limit "+(page-1)*limit+" , "+limit;
        }
        Map<String,Object> map = new HashMap<>();
        map.put("list",service.selectBaseList(sql));
        map.put("count",service.selectBaseCount(countSql));
        return success(map);
    }

    private Integer parseInt(Object raw, int defaultValue) {
        try {
            if (raw == null) {
                return defaultValue;
            }
            return Integer.parseInt(String.valueOf(raw));
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private int resolveSpecStock(String goodsId, String norms) {
        String sql = "SELECT inventory, customize_field FROM goods WHERE goods_id = ?";
        Map<String, Object> row = jdbcTemplate.queryForMap(sql, Integer.parseInt(goodsId));
        int fallbackInventory = parseInt(row.get("inventory"), 0);
        Object customizeField = row.get("customize_field");
        if (customizeField == null) {
            return fallbackInventory;
        }
        try {
            JSONArray fields = JSONArray.parseArray(String.valueOf(customizeField));
            for (int i = 0; i < fields.size(); i++) {
                JSONObject item = fields.getJSONObject(i);
                if (!"商品规格".equals(item.getString("field_name"))) {
                    continue;
                }
                JSONArray groups = JSONArray.parseArray(item.getString("field_value"));
                int minStock = Integer.MAX_VALUE;
                for (int j = 0; j < groups.size(); j++) {
                    JSONObject group = groups.getJSONObject(j);
                    String groupName = group.getString("name");
                    String selected = extractSelectedValue(norms, groupName);
                    JSONArray options = group.getJSONArray("options");
                    int currentGroupStock = fallbackInventory;
                    for (int k = 0; k < options.size(); k++) {
                        JSONObject option = options.getJSONObject(k);
                        if (selected.equals(option.getString("value"))) {
                            currentGroupStock = parseInt(option.get("stock"), fallbackInventory);
                            break;
                        }
                    }
                    minStock = Math.min(minStock, currentGroupStock);
                }
                return minStock == Integer.MAX_VALUE ? fallbackInventory : minStock;
            }
        } catch (Exception ignored) {
        }
        return fallbackInventory;
    }

    private boolean reduceStock(String goodsId, String norms, int buyNum) {
        String sql = "SELECT inventory, customize_field FROM goods WHERE goods_id = ?";
        Map<String, Object> row = jdbcTemplate.queryForMap(sql, Integer.parseInt(goodsId));
        int inventory = parseInt(row.get("inventory"), 0);
        Object customizeField = row.get("customize_field");
        if (inventory < buyNum) {
            return false;
        }
        int newInventory = inventory - buyNum;
        if (customizeField == null) {
            jdbcTemplate.update("UPDATE goods SET inventory = ? WHERE goods_id = ?", newInventory, Integer.parseInt(goodsId));
            return true;
        }
        try {
            JSONArray fields = JSONArray.parseArray(String.valueOf(customizeField));
            for (int i = 0; i < fields.size(); i++) {
                JSONObject item = fields.getJSONObject(i);
                if (!"商品规格".equals(item.getString("field_name"))) {
                    continue;
                }
                JSONArray groups = JSONArray.parseArray(item.getString("field_value"));
                for (int j = 0; j < groups.size(); j++) {
                    JSONObject group = groups.getJSONObject(j);
                    String selected = extractSelectedValue(norms, group.getString("name"));
                    JSONArray options = group.getJSONArray("options");
                    for (int k = 0; k < options.size(); k++) {
                        JSONObject option = options.getJSONObject(k);
                        if (selected.equals(option.getString("value"))) {
                            int stock = parseInt(option.get("stock"), inventory);
                            if (stock < buyNum) {
                                return false;
                            }
                            option.put("stock", stock - buyNum);
                        }
                    }
                }
                item.put("field_value", groups.toJSONString());
                jdbcTemplate.update(
                        "UPDATE goods SET inventory = ?, customize_field = ? WHERE goods_id = ?",
                        newInventory, fields.toJSONString(), Integer.parseInt(goodsId)
                );
                return true;
            }
        } catch (Exception ignored) {
        }
        jdbcTemplate.update("UPDATE goods SET inventory = ? WHERE goods_id = ?", newInventory, Integer.parseInt(goodsId));
        return true;
    }

    private String extractSelectedValue(String norms, String groupName) {
        if (norms == null || groupName == null) {
            return "";
        }
        String[] segments = norms.split("；");
        for (String segment : segments) {
            String[] pair = segment.split(":");
            if (pair.length == 2 && groupName.equals(pair[0])) {
                return pair[1];
            }
        }
        return "";
    }

}


