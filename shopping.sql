SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1) 原始商品数据暂存（仅导入，不覆盖系统 goods 结构）
DROP TABLE IF EXISTS `tmp_goods_import`;
CREATE TABLE `tmp_goods_import` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  `original_price` decimal(10,2) NOT NULL,
  `sell_price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT 0,
  `category` varchar(50) NOT NULL,
  `seller_user` varchar(100) NOT NULL,
  `staff_name` varchar(50) NOT NULL,
  `spec` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `img_urls` text NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 30款商品（分类标准化+仅前20个传承人+多规格+统一图片）
INSERT INTO `tmp_goods_import` (`title`, `description`, `original_price`, `sell_price`, `stock`, `category`, `seller_user`, `staff_name`, `spec`, `content`, `img_urls`) VALUES
-- 1 饰品
('牛郎织女传说非遗主题七夕文创礼盒', '非遗七夕伴手礼', 198.00, 158.00, 100, '饰品', '王继升-chuancheng001', '王继升', '尺寸20*15*8cm，颜色：中国红、典雅蓝、香槟金', '源自国家级非遗牛郎织女传说，和顺县非遗传承人监制。礼盒含烫金主题书签、手绘明信片、红绳手作，还原七夕民俗内核，兼具收藏与实用价值，是节日送礼、文化纪念的优选。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 2 日用品
('孟姜女传说非遗主题手绘帆布包', '非遗通勤国风帆布包', 89.00, 69.00, 150, '日用品', '王艳娥-chuancheng002', '王艳娥', '尺寸35*40cm，颜色：米白、浅灰、藏青、墨黑', '源自国家级非遗孟姜女传说，山海关非遗传承人监制，手绘还原传说经典场景。纯棉加厚帆布耐磨耐用，大容量适配通勤出行，将非遗故事融入日常，兼具实用性与文化传播价值。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 3 日用品
('四大民间传说非遗线装手账本', '国风非遗文创笔记本', 128.00, 98.00, 80, '日用品', '民文传承人-chuancheng003', '民间文学传承人', '尺寸32开，颜色：墨黑、朱红、米黄、浅绿', '收录四大民间传说非遗内容，非遗传承人监制，采用传统线装工艺，宣纸内页书写顺滑，封面烫金工艺，兼具书写、收藏、文化学习价值，是国风爱好者的专属文创。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 4 日用品
('侗族大歌非遗原声CD收藏礼盒', '原生态民族音乐藏品', 258.00, 198.00, 50, '日用品', '吴品仙-chuancheng004', '吴品仙', '尺寸18*14*3cm，款式：标准版、收藏版', '由国家级非遗侗族大歌传承人吴品仙及原生歌队录制，收录经典侗族大歌曲目，还原无伴奏多声部合唱魅力，配套双语歌词手册，是民族音乐收藏、非遗文化学习的珍贵藏品。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 5 饰品
('蒙古族长调非遗迷你马头琴摆件', '草原非遗文创桌面装饰', 168.00, 128.00, 60, '饰品', '哈扎布传人-chuancheng005', '长调传承人', '高度18cm，材质：原木色、深棕色、浅棕色', '源自国家级非遗蒙古族长调民歌文化，非遗匠人手工雕刻迷你马头琴摆件，实木材质纹理细腻，还原马头琴经典造型，可做桌面装饰、车载摆件，传递草原游牧文化的独特魅力。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 6 日用品
('非遗民乐入门款苦竹笛', '初学专用传统竹笛', 199.00, 149.00, 70, '日用品', '民乐传承人-chuancheng006', '民乐传承人', '调式：C调、D调、F调，长度45cm', '由传统民乐非遗匠人手工制作，精选深山老料苦竹，音准稳定、音色通透，适配初学者入门、日常练习，配套指法表与入门教程，让传统民乐走进日常，传承非遗音乐文化。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 7 饰品
('安塞腰鼓非遗迷你手鼓摆件', '陕北非遗文创纪念手办', 138.00, 108.00, 90, '饰品', '曹怀荣-chuancheng007', '曹怀荣', '直径10cm，颜色：原木色、复古红', '源自国家级非遗安塞腰鼓，非遗匠人手工打造迷你手鼓，实木鼓身+真牛皮鼓面，还原安塞腰鼓经典造型，可做桌面装饰、纪念收藏，传递黄土高原的阳刚文化与非遗魅力。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 8 饰品
('傣族孔雀舞非遗主题银饰手链', '民族风非遗手作银饰', 298.00, 238.00, 40, '饰品', '毛相传人-chuancheng008', '孔雀舞传承人', '材质925银，尺寸：可调节，款式：素银、做旧', '源自国家级非遗傣族孔雀舞文化，非遗银匠手工打造，还原孔雀舞经典三道弯体态造型，925银材质不易过敏，细节精致灵动，兼具佩戴装饰与非遗文化纪念价值。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 9 衣物
('非遗民族舞蹈主题国风丝巾', '桑蚕丝非遗印花大方巾', 188.00, 148.00, 60, '衣物', '民族舞传承人-chuancheng009', '民族舞传承人', '尺寸90*90cm，颜色：湖蓝、绯红、米白、墨绿', '融合安塞腰鼓、孔雀舞等非遗舞蹈元素，非遗画师手绘设计，100%桑蚕丝材质，数码印花色彩饱满，可做披肩、头巾、包包装饰，将非遗舞蹈美学融入日常穿搭。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 10 饰品
('昆曲非遗主题戏曲人物书签套装', '国风非遗金属书签', 98.00, 78.00, 120, '饰品', '王芳-chuancheng010', '王芳', '款式：4枚套装，材质：黄铜镀银、磨砂金', '源自国家级非遗昆曲，由苏州昆剧院非遗传承人监制，还原《牡丹亭》经典戏曲人物造型，黄铜镀银材质，镂空工艺精致细腻，是阅读爱好者、国风收藏者的专属非遗文创。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 11 日用品
('京剧非遗主题脸谱手绘陶瓷杯', '国潮非遗马克杯', 79.00, 59.00, 180, '日用品', '京剧传承人-chuancheng011', '京剧传承人', '容量350ml，颜色：纯白、青瓷、暖黄', '源自国家级非遗京剧文化，非遗画师手绘经典京剧脸谱造型，高温陶瓷材质安全耐用，带盖带勺适配办公、居家使用，国潮设计兼具实用性与非遗文化传播价值。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 12 饰品
('非遗戏曲主题国风折扇', '宣纸手绘戏曲人物折扇', 158.00, 118.00, 70, '饰品', '戏曲传承人-chuancheng012', '戏曲传承人', '尺寸10寸，颜色：空白、彩绘、烫金', '融合昆曲、京剧非遗戏曲元素，非遗画师手绘经典戏曲人物，宣纸扇面书写顺滑，竹制扇骨坚韧耐用，可做日常纳凉、文玩收藏、国风拍摄道具，传递传统戏曲美学。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 13 日用品
('京韵大鼓非遗主题车载香片套装', '国风非遗香薰挂件', 59.00, 39.00, 200, '日用品', '京韵大鼓传承人-chuancheng013', '京韵大鼓传承人', '款式：4枚套装，香型：檀香、白茶、柑橘、木质', '源自国家级非遗京韵大鼓文化，还原曲艺经典场景设计，天然木质香片留香持久，适配车载、衣柜、书房悬挂，将非遗曲艺文化融入日常，是小众国风文创优选。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 14 饰品
('山东快书非遗主题鸳鸯板钥匙扣', '非遗文创金属挂件', 49.00, 35.00, 160, '饰品', '山东快书传承人-chuancheng014', '山东快书传承人', '材质黄铜，颜色：亮金、做旧金、哑光银', '源自国家级非遗山东快书，还原曲艺专用鸳鸯板造型，黄铜材质质感厚重，细节精准复刻，可做钥匙扣、背包挂件，兼具日常使用与非遗曲艺文化纪念价值。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 15 日用品
('非遗曲艺主题国风明信片套装', '曲艺文化收藏纪念明信片', 39.00, 29.00, 150, '日用品', '曲艺传承人-chuancheng015', '曲艺传承人', '尺寸14*10cm，款式：12枚套装、6枚套装', '收录京韵大鼓、山东快书等非遗曲艺经典场景，非遗画师手绘创作，铜版纸覆膜防水，画面清晰色彩饱满，可做邮寄、手账装饰、收藏纪念，传播非遗曲艺文化。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 16 饰品
('少林功夫非遗主题武术文创钥匙扣', '国风禅武金属挂件', 59.00, 45.00, 180, '饰品', '释永信-chuancheng016', '释永信', '材质锌合金，颜色：亮银、古铜、黑金', '源自国家级非遗少林功夫文化，还原少林武术经典招式造型，锌合金材质耐磨防刮，细节精致，可做钥匙扣、背包挂件，传递少林禅武合一的非遗文化内核。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 17 日用品
('吴桥杂技非遗主题魔术道具礼盒', '入门款非遗魔术套装', 128.00, 98.00, 80, '日用品', '边发吉-chuancheng017', '边发吉', '款式：8件套装、12件套装，尺寸25*20*5cm', '源自国家级非遗吴桥杂技文化，非遗杂技传承人监制，精选8款经典入门魔术道具，配套详细教学手册，适配新手入门、亲子互动、才艺表演，传承非遗杂技文化。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 18 饰品
('非遗武术主题太极养生折扇', '太极功夫专用竹骨扇', 89.00, 69.00, 100, '饰品', '太极传承人-chuancheng018', '太极传承人', '尺寸10寸，颜色：黑色、白色、藏青', '融合非遗太极武术文化，加厚绸缎扇面抗风耐用，竹制扇骨手感扎实，适配太极表演、日常练习、纳凉使用，扇面印太极经典图案，传递非遗武术养生文化。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 19 装饰
('蔚县剪纸非遗主题生肖窗花套装', '非遗手工剪纸窗花', 69.00, 49.00, 120, '装饰', '王老赏传人-chuancheng019', '蔚县剪纸传承人', '尺寸20*20cm，颜色：彩色、单色、鎏金', '源自国家级非遗蔚县剪纸，非遗匠人纯手工刻制、点染套色，色彩浓烈造型生动，适配春节、节庆窗户、墙面装饰，是真正的非遗手作，兼具装饰与收藏价值。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 20 装饰
('苏绣非遗主题双面绣团扇', '手工苏绣国风汉服团扇', 398.00, 328.00, 30, '装饰', '沈寿传人-chuancheng020', '苏绣传承人', '直径20cm，图案：花卉、山水、人物', '源自国家级非遗苏绣技艺，非遗绣娘纯手工双面绣制作，真丝底料+桑蚕丝线，针脚细腻画面灵动，榉木扇柄手感温润，适配汉服搭配、国风拍摄、桌面陈设。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 21 装饰（传承人循环001）
('非遗杨柳青年画主题装饰画', '非遗木版年画复刻挂画', 168.00, 128.00, 50, '装饰', '王继升-chuancheng001', '王继升', '尺寸A3、A4，画框：原木、黑色、白色', '源自国家级非遗杨柳青年画，非遗匠人复刻经典年画造型，宣纸高清印刷还原手工质感，实木画框适配客厅、书房、民宿装饰，兼具装饰性与非遗文化收藏价值。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 22 装饰（传承人循环002）
('景德镇非遗手工青花瓷茶杯', '非遗制瓷功夫茶杯', 258.00, 198.00, 40, '装饰', '王艳娥-chuancheng002', '王艳娥', '容量100ml、150ml，款式：单杯、对杯', '源自国家级非遗景德镇手工制瓷技艺，非遗匠人手工拉坯、绘画、烧制，釉下彩青花工艺安全无铅，器型圆润手感温润，适配功夫茶使用，是真正的非遗手工瓷作。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 23 日用品（传承人循环003）
('非遗宣纸半生熟书画专用纸', '泾县古法宣纸练习纸', 128.00, 98.00, 60, '日用品', '民文传承人-chuancheng003', '民间文学传承人', '尺寸四尺对开、三尺全开，材质：生宣、半生熟', '源自国家级非遗宣纸制作技艺，非遗传承人监制，采用青檀皮+沙田稻草古法工艺制作，半生熟适配书法、国画创作，不洇墨不发脆，是书画爱好者的专业非遗宣纸。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 24 衣物（传承人循环004）
('非遗蜀锦手工织造围巾', '传统蜀锦国风保暖围巾', 368.00, 298.00, 35, '衣物', '吴品仙-chuancheng004', '吴品仙', '尺寸180*30cm，颜色：大红、藏蓝、米色、墨绿', '源自国家级非遗蜀锦织造技艺，非遗匠人手工织造，100%桑蚕丝材质柔软亲肤，经典国风纹样色彩饱满，适配日常穿搭、保暖使用，是国家级非遗手工织物珍品。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 25 医药（传承人循环005）
('同仁堂非遗艾草艾灸柱', '非遗古法三年陈艾柱', 89.00, 69.00, 150, '医药', '哈扎布传人-chuancheng005', '长调传承人', '规格：54粒/盒、108粒/盒，艾绒比例18:1', '源自国家级非遗同仁堂中医药文化，非遗传承人监制，精选三年陈蕲艾，古法石磨制绒，艾烟温和火力通透，适配家用艾灸、养生调理，恪守非遗古法制药标准，安全放心。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 26 医药（传承人循环006）
('非遗中医针灸穴位人体模型', '中医学习专用经络模型', 158.00, 128.00, 50, '医药', '民乐传承人-chuancheng006', '民乐传承人', '高度50cm、30cm，款式：男模、女模', '源自国家级非遗中医针灸文化，严格按照中医经络标准制作，穴位标注精准清晰，PVC材质防水耐用，适配中医学习、教学展示、家用养生参考，传承非遗中医文化。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 27 医药（传承人循环007）
('非遗古法草本驱蚊香包', '端午非遗中草药香囊', 39.00, 29.00, 200, '医药', '曹怀荣-chuancheng007', '曹怀荣', '尺寸8*10cm，颜色：棉麻灰、中国红、浅绿', '源自非遗中医药古法配方，非遗中医传承人监制，精选艾草、薄荷、丁香等天然草本，无化学添加，驱蚊安神，适配车载、衣柜、卧室悬挂，端午民俗与非遗中医结合。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 28 日用品（传承人循环008）
('春节非遗主题春联福字礼盒', '非遗手写体春联大礼包', 79.00, 59.00, 180, '日用品', '毛相传人-chuancheng008', '孔雀舞传承人', '尺寸1.2m、1.5m，颜色：红底黑字、红底金字', '源自国家级非遗春节民俗文化，非遗书法家手写体复刻，加厚铜版纸防水不褪色，礼盒含春联、福字、窗花、红包，全套适配春节居家装饰，还原传统年俗非遗文化。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 29 美食（传承人循环009）
('端午节非遗主题粽子礼盒', '非遗手工端午粽大礼包', 198.00, 158.00, 80, '美食', '民族舞传承人-chuancheng009', '民族舞传承人', '规格：8粽4蛋、10粽6蛋，口味：甜粽、咸粽、混合', '源自国家级非遗端午节民俗文化，汨罗非遗匠人手工制作，精选优质食材，多口味适配不同需求，礼盒配套端午香囊、五彩绳，还原端午传统民俗，是节日送礼的非遗优选。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg'),
-- 30 日用品（传承人循环010）
('非遗二十四节气主题台历', '国风非遗民俗文创日历', 89.00, 69.00, 120, '日用品', '王芳-chuancheng010', '王芳', '尺寸32开、16开，颜色：简约白、国风红', '融合国家级非遗二十四节气民俗文化，非遗画师手绘节气场景，双面印刷标注节气、农谚、民俗知识，适配桌面办公、日常记事，兼具实用性与非遗民俗文化传播价值。', 'F:\\springboot项目\\project\\target\\classes\\static\\goods.jpg,F:\\springboot项目\\project\\target\\classes\\static\\img_1.jpg');

-- 2) 按你的要求清空现有商品及分类（包含商城映射数据）
DELETE FROM `order`;
DELETE FROM `cart`;
DELETE FROM `cultural_and_creative_mall`;
DELETE FROM `goods`;
DELETE FROM `goods_type`;

-- 3) 重建商品分类
INSERT INTO `goods_type` (`father_id`,`name`,`desc`,`icon`,`source_table`,`source_field`)
VALUES
(0,'衣物','','',NULL,NULL),
(0,'饰品','','',NULL,NULL),
(0,'美食','','',NULL,NULL),
(0,'日用品','','',NULL,NULL),
(0,'家具','','',NULL,NULL),
(0,'装饰','','',NULL,NULL),
(0,'医药','','',NULL,NULL);

-- 4) 导入到系统 goods 表（结构适配）
INSERT INTO `goods`
(`title`,`img`,`description`,`price_ago`,`price`,`sales`,`inventory`,`type`,`hits`,`content`,
 `img_1`,`img_2`,`img_3`,`img_4`,`img_5`,`customize_field`,`source_table`,`source_field`,`source_id`,`user_id`)
SELECT
  t.title,
  '/upload/goods.jpg' AS img,
  t.description,
  t.original_price,
  t.sell_price,
  0 AS sales,
  t.stock AS inventory,
  t.category AS type,
  0 AS hits,
  CONCAT('<p>', t.content, '</p>') AS content,
  '/upload/img_1.jpg',
  '/upload/img_2.jpg',
  '/upload/img_3.jpg',
  '/upload/img_4.jpg',
  '/upload/img_5.jpg',
  CONCAT(
    '[{"field_name":"卖家用户","field_value":"', REPLACE(t.seller_user, '"', '\\"'),
    '"},{"field_name":"人员姓名","field_value":"', REPLACE(t.staff_name, '"', '\\"'),
    '"},{"field_name":"商品规格","field_value":"', REPLACE(t.spec, '"', '\\"'),
    '"}]'
  ) AS customize_field,
  'cultural_and_creative_mall' AS source_table,
  'cultural_and_creative_mall_id' AS source_field,
  0 AS source_id,
  COALESCE(u.user_id, 0) AS user_id
FROM `tmp_goods_import` t
LEFT JOIN `user` u ON CONVERT(u.username USING utf8mb4) COLLATE utf8mb4_general_ci = SUBSTRING_INDEX(t.seller_user, '-', -1) COLLATE utf8mb4_general_ci;

-- 5) 导入商城表（用于你现有后台商品管理页面）
INSERT INTO `cultural_and_creative_mall`
(`seller_customers`,`personnel_name`,`product_specifications`,`hits`,`praise_len`,
 `cart_title`,`cart_img`,`cart_description`,`cart_price_ago`,`cart_price`,`cart_inventory`,`cart_type`,
 `cart_content`,`cart_img_1`,`cart_img_2`,`cart_img_3`,`cart_img_4`,`cart_img_5`)
SELECT
  g.user_id,
  t.staff_name,
  LEFT(t.spec, 64),
  0,
  0,
  t.title,
  '/upload/goods.jpg',
  t.description,
  t.original_price,
  t.sell_price,
  t.stock,
  t.category,
  CONCAT('<p>', t.content, '</p>'),
  '/upload/img_1.jpg',
  '/upload/img_2.jpg',
  '/upload/img_3.jpg',
  '/upload/img_4.jpg',
  '/upload/img_5.jpg'
FROM `tmp_goods_import` t
JOIN `goods` g ON g.title COLLATE utf8mb4_general_ci = t.title COLLATE utf8mb4_general_ci;

-- 6) 回填 goods.source_id，保证 goods 与商城记录关联
UPDATE `goods` g
JOIN `cultural_and_creative_mall` c ON c.cart_title COLLATE utf8mb4_general_ci = g.title COLLATE utf8mb4_general_ci
SET g.source_id = c.cultural_and_creative_mall_id,
    g.source_table = 'cultural_and_creative_mall',
    g.source_field = 'cultural_and_creative_mall_id';

DROP TABLE `tmp_goods_import`;
SET FOREIGN_KEY_CHECKS = 1;