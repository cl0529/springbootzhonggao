package com.project.demo.controller;

import com.project.demo.entity.Cart;
import com.project.demo.service.CartService;

import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;

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

    /**
     * 加购兜底：同一用户+同一商品合并数量，避免重复行或错误覆盖。
     */
    @PostMapping("/add")
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> body = service.readBody(request.getReader());
        String userId = String.valueOf(body.get("user_id"));
        String goodsId = String.valueOf(body.get("goods_id"));

        if (userId == null || "null".equals(userId) || userId.trim().isEmpty()
                || goodsId == null || "null".equals(goodsId) || goodsId.trim().isEmpty()) {
            return error(30000, "加购参数缺失");
        }

        Map<String, String> query = new HashMap<>();
        query.put("user_id", userId);
        query.put("goods_id", goodsId);
        List<Cart> list = service.selectBaseList(service.select(query, new HashMap<>()));
        if (list != null && !list.isEmpty()) {
            Cart existed = list.get(0);
            Integer oldNum = existed.getNum() == null ? 0 : existed.getNum();
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
            form.put("num", oldNum + 1);
            form.put("price", existed.getPrice() == null ? addPrice : existed.getPrice());
            form.put("price_count", oldPriceCount + addPrice);

            Map<String, String> updateQuery = new HashMap<>();
            updateQuery.put("cart_id", String.valueOf(existed.getCartId()));
            service.update(updateQuery, new HashMap<>(), form);
            return success(1);
        }

        service.insert(body);
        return success(1);
    }
}


