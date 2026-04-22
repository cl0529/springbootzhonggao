package com.project.demo.controller;

import com.project.demo.entity.Cart;
import com.project.demo.service.CartService;
import com.project.demo.controller.base.BaseController;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 购物车：(Cart)表控制层
 *
 */
@RestController
@RequestMapping("cart")
public class CartController extends BaseController<Cart, CartService> {
    /**
     * 服务对象
     */
    @Autowired
    public CartController(CartService service) {
        setService(service);
    }
    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 加购兜底：同一用户+同一商品合并数量，避免重复行或错误覆盖。
     */
    @PostMapping("/add")
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> body = service.readBody(request.getReader());
        String userId = String.valueOf(body.get("user_id"));
        String goodsId = String.valueOf(body.get("goods_id"));
        String selectedNorms = String.valueOf(body.get("norms"));
        Integer addNum = parseInt(body.get("num"), 1);

        if (userId == null || "null".equals(userId) || userId.trim().isEmpty()
                || goodsId == null || "null".equals(goodsId) || goodsId.trim().isEmpty()) {
            return error(30000, "加购参数缺失");
        }
        int specStock = resolveSpecStock(goodsId, selectedNorms);
        if (addNum > specStock) {
            return error(30000, "规格库存不足");
        }

        Map<String, String> query = new HashMap<>();
        query.put("user_id", userId);
        query.put("goods_id", goodsId);
        query.put("description", String.valueOf(body.get("description")));
        List<Cart> list = service.selectBaseList(service.select(query, new HashMap<>()));
        if (list != null && !list.isEmpty()) {
            Cart existed = list.get(0);
            Integer oldNum = existed.getNum() == null ? 0 : existed.getNum();
            if (oldNum + addNum > specStock) {
                return error(30000, "规格库存不足");
            }
            Double oldPriceCount = existed.getPriceCount() == null ? 0D : existed.getPriceCount();
            Double addPrice = null;
            Object priceObj = body.get("price");
            if (priceObj != null) {
                addPrice = Double.parseDouble(String.valueOf(priceObj));
            }
            if (addPrice == null) {
                addPrice = existed.getPrice() == null ? 0D : existed.getPrice();
            }

            Map<String, Object> form = new HashMap<>();
            form.put("num", oldNum + addNum);
            form.put("price", existed.getPrice() == null ? addPrice : existed.getPrice());
            form.put("price_count", oldPriceCount + (addPrice * addNum));

            Map<String, String> updateQuery = new HashMap<>();
            updateQuery.put("cart_id", String.valueOf(existed.getCartId()));
            service.update(updateQuery, new HashMap<>(), form);
            return success(1);
        }

        service.insert(body);
        return success(1);
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


