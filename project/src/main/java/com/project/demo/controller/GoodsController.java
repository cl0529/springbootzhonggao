package com.project.demo.controller;

import com.project.demo.entity.Goods;
import com.project.demo.service.GoodsService;
import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 商品信息：(Goods)表控制层
 *
 */
@RestController
@RequestMapping("goods")
public class GoodsController extends BaseController<Goods, GoodsService> {
    /**
     * 服务对象
     */
    @Autowired
    public GoodsController(GoodsService service) {
        setService(service);
    }
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/get_hot_list")
    public Map<String, Object> getHotList(@RequestParam(value = "size", defaultValue = "5") Integer size) {
        int limit = (size == null || size <= 0) ? 5 : Math.min(size, 20);
        String sql = "SELECT g.*, " +
                "(IFNULL(o.buy_num,0) * 10 + IFNULL(c.cart_num,0) * 6 + IFNULL(h.hit_num,0)) AS hot_score " +
                "FROM goods g " +
                "LEFT JOIN (SELECT goods_id, SUM(num) AS buy_num FROM `order` GROUP BY goods_id) o ON o.goods_id = g.goods_id " +
                "LEFT JOIN (SELECT goods_id, SUM(num) AS cart_num FROM cart GROUP BY goods_id) c ON c.goods_id = g.goods_id " +
                "LEFT JOIN (SELECT source_id AS goods_id, COUNT(1) AS hit_num FROM hits WHERE source_table = 'goods' GROUP BY source_id) h ON h.goods_id = g.goods_id " +
                "ORDER BY hot_score DESC, g.goods_id DESC LIMIT " + limit;
        List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("count", list.size());
        return success(result);
    }

}


