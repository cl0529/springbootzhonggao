package com.project.demo.controller;

import com.project.demo.entity.Comment;
import com.project.demo.service.CommentService;
import com.project.demo.controller.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 评论：(Comment)表控制层
 *
 */
@RestController
@RequestMapping("comment")
public class CommentController extends BaseController<Comment, CommentService> {
    /**
     * 服务对象
     */
    @Autowired
    public CommentController(CommentService service) {
        setService(service);
    }
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/add")
    public Map<String, Object> add(HttpServletRequest request) throws IOException {
        Map<String, Object> body = service.readBody(request.getReader());
        String sourceTable = String.valueOf(body.get("source_table"));
        Integer sourceId = parseInt(body.get("source_id"));
        Integer userId = parseInt(body.get("user_id"));
        if ("goods".equals(sourceTable) && sourceId != null && userId != null) {
            if (!canCommentGoods(userId, sourceId)) {
                return error(30000, "仅管理员、商品发布者或已购买用户可以评论");
            }
        }
        service.insert(body);
        return success(1);
    }

    private boolean canCommentGoods(Integer userId, Integer goodsId) {
        String roleSql = "SELECT user_group FROM user WHERE user_id = ?";
        List<String> role = jdbcTemplate.query(roleSql, (rs, rowNum) -> rs.getString("user_group"), userId);
        if (!role.isEmpty() && ("管理员".equals(role.get(0)) || "传承用户".equals(role.get(0)))) {
            return true;
        }
        String publisherSql = "SELECT COUNT(1) FROM goods WHERE goods_id = ? AND user_id = ?";
        Integer isPublisher = jdbcTemplate.queryForObject(publisherSql, Integer.class, goodsId, userId);
        if (isPublisher != null && isPublisher > 0) {
            return true;
        }
        String buySql = "SELECT COUNT(1) FROM `order` WHERE goods_id = ? AND user_id = ?";
        Integer bought = jdbcTemplate.queryForObject(buySql, Integer.class, goodsId, userId);
        return bought != null && bought > 0;
    }

    private Integer parseInt(Object val) {
        if (val == null) {
            return null;
        }
        try {
            return Integer.parseInt(String.valueOf(val));
        } catch (Exception e) {
            return null;
        }
    }

}


