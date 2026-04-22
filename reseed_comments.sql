SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 清空商品与非遗项目评论
DELETE FROM comment WHERE source_table IN ('goods', 'intangible_cultural_heritage_projects');

DROP TEMPORARY TABLE IF EXISTS tmp_seq_1_6;
CREATE TEMPORARY TABLE tmp_seq_1_6 (n INT PRIMARY KEY);
INSERT INTO tmp_seq_1_6(n) VALUES (1),(2),(3),(4),(5),(6);

DROP TEMPORARY TABLE IF EXISTS tmp_goods;
CREATE TEMPORARY TABLE tmp_goods AS
SELECT goods_id, title, user_id AS publisher_user_id, ROW_NUMBER() OVER (ORDER BY goods_id) AS rn
FROM goods;

DROP TEMPORARY TABLE IF EXISTS tmp_projects;
CREATE TEMPORARY TABLE tmp_projects AS
SELECT intangible_cultural_heritage_projects_id AS project_id, ROW_NUMBER() OVER (ORDER BY intangible_cultural_heritage_projects_id) AS rn
FROM intangible_cultural_heritage_projects;

DROP TEMPORARY TABLE IF EXISTS tmp_users;
CREATE TEMPORARY TABLE tmp_users AS
SELECT user_id, user_group, nickname, avatar, ROW_NUMBER() OVER (ORDER BY user_id) AS rn
FROM `user`;

SET @user_cnt = (SELECT COUNT(*) FROM tmp_users);

-- 商品评论候选用户池：管理员 + 传承用户 + 发布者 + 已购买用户
DROP TEMPORARY TABLE IF EXISTS tmp_goods_comment_candidates;
CREATE TEMPORARY TABLE tmp_goods_comment_candidates AS
SELECT DISTINCT g.goods_id, u.user_id
FROM goods g
JOIN tmp_users u ON u.user_group IN ('管理员', '传承用户')
UNION
SELECT DISTINCT g.goods_id, g.user_id
FROM goods g
WHERE g.user_id IS NOT NULL
UNION
SELECT DISTINCT o.goods_id, o.user_id
FROM `order` o
WHERE o.goods_id IS NOT NULL;

DROP TEMPORARY TABLE IF EXISTS tmp_goods_candidates_ranked;
CREATE TEMPORARY TABLE tmp_goods_candidates_ranked AS
SELECT
  c.goods_id,
  c.user_id,
  ROW_NUMBER() OVER (PARTITION BY c.goods_id ORDER BY c.user_id) AS rn
FROM tmp_goods_comment_candidates c;

DROP TEMPORARY TABLE IF EXISTS tmp_goods_candidates_cnt;
CREATE TEMPORARY TABLE tmp_goods_candidates_cnt AS
SELECT goods_id, COUNT(*) AS cnt
FROM tmp_goods_candidates_ranked
GROUP BY goods_id;

-- 每个商品 2~3 条评论（错落）
INSERT INTO comment(user_id, reply_to_id, content, nickname, avatar, source_table, source_field, source_id)
SELECT
  r.user_id,
  0,
  CONCAT('商品评论-', g.goods_id, '-', s.n),
  u.nickname,
  u.avatar,
  'goods',
  'goods_id',
  g.goods_id
FROM tmp_goods g
JOIN tmp_goods_candidates_cnt cc ON cc.goods_id = g.goods_id
JOIN tmp_seq_1_6 s ON s.n <= (2 + (g.goods_id % 2))
JOIN tmp_goods_candidates_ranked r ON r.goods_id = g.goods_id AND r.rn = ((s.n - 1) % cc.cnt) + 1
JOIN tmp_users u ON u.user_id = r.user_id;

-- 非遗项目评论：每项目 5~6 条，谁都能评论
INSERT INTO comment(user_id, reply_to_id, content, nickname, avatar, source_table, source_field, source_id)
SELECT
  u.user_id,
  0,
  CONCAT('非遗项目评论-', p.project_id, '-', s.n),
  u.nickname,
  u.avatar,
  'intangible_cultural_heritage_projects',
  'intangible_cultural_heritage_projects_id',
  p.project_id
FROM tmp_projects p
JOIN tmp_seq_1_6 s ON s.n <= (5 + (p.project_id % 2))
JOIN tmp_users u ON u.rn = ((p.rn + s.n - 1) % @user_cnt) + 1;

SET FOREIGN_KEY_CHECKS = 1;
