SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TEMPORARY TABLE IF EXISTS tmp_seq_1_10;
CREATE TEMPORARY TABLE tmp_seq_1_10 (n INT PRIMARY KEY);
INSERT INTO tmp_seq_1_10(n) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

DROP TEMPORARY TABLE IF EXISTS tmp_seq_1_9;
CREATE TEMPORARY TABLE tmp_seq_1_9 (n INT PRIMARY KEY);
INSERT INTO tmp_seq_1_9(n) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9);

DROP TEMPORARY TABLE IF EXISTS tmp_seq_1_4;
CREATE TEMPORARY TABLE tmp_seq_1_4 (n INT PRIMARY KEY);
INSERT INTO tmp_seq_1_4(n) VALUES (1),(2),(3),(4);

DROP TEMPORARY TABLE IF EXISTS tmp_users;
CREATE TEMPORARY TABLE tmp_users AS
SELECT user_id, nickname, avatar, ROW_NUMBER() OVER (ORDER BY user_id) AS rn
FROM `user`
WHERE user_group <> '管理员';

DROP TEMPORARY TABLE IF EXISTS tmp_goods;
CREATE TEMPORARY TABLE tmp_goods AS
SELECT goods_id, title, img, price, price_ago, type, description, user_id, ROW_NUMBER() OVER (ORDER BY goods_id) AS rn
FROM goods;

DROP TEMPORARY TABLE IF EXISTS tmp_articles;
CREATE TEMPORARY TABLE tmp_articles AS
SELECT article_id, title, img, ROW_NUMBER() OVER (ORDER BY article_id) AS rn
FROM article;

SET @user_cnt = (SELECT COUNT(*) FROM tmp_users);

-- 1) 阅读记录（hits）100+
INSERT INTO hits(user_id, source_table, source_field, source_id)
SELECT u.user_id, 'goods', 'goods_id', g.goods_id
FROM tmp_goods g
JOIN tmp_seq_1_4 s ON 1=1
JOIN tmp_users u ON u.rn = ((g.rn + s.n - 2) % @user_cnt) + 1;

INSERT INTO hits(user_id, source_table, source_field, source_id)
SELECT u.user_id, 'article', 'article_id', a.article_id
FROM tmp_articles a
JOIN tmp_seq_1_4 s ON 1=1
JOIN tmp_users u ON u.rn = ((a.rn + s.n + 3) % @user_cnt) + 1;

-- 2) 收藏记录 100+
INSERT INTO collect(user_id, source_table, source_field, source_id, title, img)
SELECT u.user_id, 'goods', 'goods_id', g.goods_id, g.title, g.img
FROM tmp_goods g
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3) s ON 1=1
JOIN tmp_users u ON u.rn = ((g.rn + s.n + 5) % @user_cnt) + 1;

INSERT INTO collect(user_id, source_table, source_field, source_id, title, img)
SELECT u.user_id, 'article', 'article_id', a.article_id, a.title, a.img
FROM tmp_articles a
JOIN (SELECT 1 AS n UNION ALL SELECT 2) s ON 1=1
JOIN tmp_users u ON u.rn = ((a.rn + s.n + 7) % @user_cnt) + 1;

-- 3) 50+ 互动记录（点赞）
INSERT INTO praise(user_id, source_table, source_field, source_id, status)
SELECT u.user_id, 'goods', 'goods_id', g.goods_id, 1
FROM tmp_goods g
JOIN (SELECT 1 AS n UNION ALL SELECT 2) s ON 1=1
JOIN tmp_users u ON u.rn = ((g.rn + s.n + 11) % @user_cnt) + 1;

-- 4) 平均每个商品 10 条购物车记录
INSERT INTO cart(title, img, user_id, price, price_ago, price_count, num, goods_id, type, description)
SELECT
  g.title,
  g.img,
  u.user_id,
  g.price,
  g.price_ago,
  g.price * 1,
  1,
  g.goods_id,
  g.type,
  CONCAT('自动加购记录-', s.n)
FROM tmp_goods g
JOIN tmp_seq_1_10 s ON 1=1
JOIN tmp_users u ON u.rn = ((g.rn + s.n + 13) % @user_cnt) + 1;

-- 5) 每个商品增加 4 条已购买订单（用于评论资格与热度）
INSERT INTO `order`(
  order_number, goods_id, title, img, price, price_ago, num, price_count, norms, type,
  contact_name, contact_phone, contact_address, postal_code, user_id, merchant_id, description, state, delivery_state
)
SELECT
  CONCAT('AUTO', g.goods_id, LPAD(s.n, 2, '0'), REPLACE(UUID(), '-', '')),
  g.goods_id,
  g.title,
  g.img,
  g.price,
  g.price_ago,
  1,
  g.price * 1,
  CONCAT('自动规格-', s.n),
  g.type,
  CONCAT('测试用户', u.user_id),
  CONCAT('1380000', LPAD(u.user_id, 4, '0')),
  '自动地址',
  '510000',
  u.user_id,
  IFNULL(g.user_id, 0),
  g.description,
  '已付款',
  '未配送'
FROM tmp_goods g
JOIN tmp_seq_1_4 s ON 1=1
JOIN tmp_users u ON u.rn = ((g.rn + s.n + 17) % @user_cnt) + 1;

-- 6) 商品评论：每个商品 3~9 条，且评论者都来自已购买用户
DROP TEMPORARY TABLE IF EXISTS tmp_good_buyers;
CREATE TEMPORARY TABLE tmp_good_buyers AS
SELECT
  o.goods_id,
  o.user_id,
  ROW_NUMBER() OVER (PARTITION BY o.goods_id ORDER BY o.user_id) AS rn
FROM (
  SELECT DISTINCT goods_id, user_id
  FROM `order`
  WHERE state = '已付款'
) o;

DROP TEMPORARY TABLE IF EXISTS tmp_good_buyer_cnt;
CREATE TEMPORARY TABLE tmp_good_buyer_cnt AS
SELECT goods_id, COUNT(*) AS cnt
FROM tmp_good_buyers
GROUP BY goods_id;

INSERT INTO comment(user_id, reply_to_id, content, nickname, avatar, source_table, source_field, source_id)
SELECT
  b.user_id,
  0,
  CONCAT('商品体验评论-', g.goods_id, '-', s.n),
  u.nickname,
  u.avatar,
  'goods',
  'goods_id',
  g.goods_id
FROM tmp_goods g
JOIN tmp_seq_1_9 s ON s.n <= (3 + (g.goods_id % 7))
JOIN tmp_good_buyer_cnt c ON c.goods_id = g.goods_id
JOIN tmp_good_buyers b ON b.goods_id = g.goods_id AND b.rn = ((s.n - 1) % c.cnt) + 1
JOIN `user` u ON u.user_id = b.user_id;

-- 7) 非遗项目（文章）评论：每篇 3~9 条
INSERT INTO comment(user_id, reply_to_id, content, nickname, avatar, source_table, source_field, source_id)
SELECT
  u.user_id,
  0,
  CONCAT('项目阅读评论-', a.article_id, '-', s.n),
  u.nickname,
  u.avatar,
  'article',
  'article_id',
  a.article_id
FROM tmp_articles a
JOIN tmp_seq_1_9 s ON s.n <= (3 + (a.article_id % 7))
JOIN tmp_users u ON u.rn = ((a.rn + s.n + 19) % @user_cnt) + 1;

SET FOREIGN_KEY_CHECKS = 1;
