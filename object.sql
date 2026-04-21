-- 非遗信息表建表语句，适配你的SpringBoot非遗系统
CREATE TABLE IF NOT EXISTS `heritage` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_name` varchar(100) NOT NULL COMMENT '项目名称',
  `area_name` varchar(100) NOT NULL COMMENT '地区名称',
  `project_type` varchar(50) NOT NULL COMMENT '项目类别',
  `inheritor_name` varchar(50) NOT NULL COMMENT '传承人员',
  `staff_name` varchar(50) NOT NULL COMMENT '人员姓名',
  `publish_date` date NOT NULL COMMENT '公布日期',
  `declare_unit` varchar(100) NOT NULL COMMENT '申报单位',
  `protect_unit` varchar(100) NOT NULL COMMENT '保护单位',
  `img_url` varchar(255) DEFAULT NULL COMMENT '非遗项目图片存储路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非物质文化遗产信息表';

-- 清空原有数据（重复导入防报错）
TRUNCATE TABLE `heritage`;

-- 20条非遗全量数据插入SQL（10大类，每大类2条）
INSERT INTO `heritage` (`project_name`, `area_name`, `project_type`, `inheritor_name`, `staff_name`, `publish_date`, `declare_unit`, `protect_unit`, `img_url`) VALUES
-- 第一大类：民间文学（2条）
('牛郎织女传说', '山东省沂源县', '民间文学', '朱存跃', '朱存跃', '2008-06-07', '沂源县文化馆', '沂源县文化馆', '/img/heritage/1_niulangzhinv.jpg'),
('孟姜女传说', '河北省秦皇岛市', '民间文学', '王艳娥', '王艳娥', '2006-05-20', '秦皇岛市山海关区文化馆', '秦皇岛市山海关区文化馆', '/img/heritage/2_mengjiangnv.jpg'),

-- 第二大类：传统音乐（2条）
('侗族大歌', '贵州省黎平县', '传统音乐', '吴品仙', '吴品仙', '2006-05-20', '黎平县文化馆', '黎平县非物质文化遗产保护中心', '/img/heritage/3_dongzu_dage.jpg'),
('蒙古族长调民歌', '内蒙古自治区锡林郭勒盟', '传统音乐', '哈扎布', '哈扎布', '2006-05-20', '锡林郭勒盟文化馆', '内蒙古非物质文化遗产保护中心', '/img/heritage/4_menggu_changdiao.jpg'),

-- 第三大类：传统舞蹈（2条）
('安塞腰鼓', '陕西省延安市', '传统舞蹈', '曹怀荣', '曹怀荣', '2006-05-20', '延安市安塞区文化馆', '延安市安塞区非物质文化遗产保护中心', '/img/heritage/5_ansai_yaogu.jpg'),
('傣族孔雀舞', '云南省瑞丽市', '传统舞蹈', '毛相', '毛相', '2006-05-20', '瑞丽市文化馆', '瑞丽市非物质文化遗产保护中心', '/img/heritage/6_dai_peacock.jpg'),

-- 第四大类：传统戏剧（2条）
('昆曲', '江苏省苏州市', '传统戏剧', '王芳', '王芳', '2006-05-20', '江苏省苏州昆剧院', '江苏省苏州昆剧院', '/img/heritage/7_kunqu.jpg'),
('京剧', '北京市', '传统戏剧', '梅葆玖', '梅葆玖', '2006-05-20', '国家京剧院', '国家京剧院', '/img/heritage/8_jingju.jpg'),

-- 第五大类：曲艺（2条）
('京韵大鼓', '天津市', '曲艺', '骆玉笙', '骆玉笙', '2006-05-20', '天津市曲艺团', '天津市曲艺团', '/img/heritage/9_jingyun_dagu.jpg'),
('山东快书', '山东省济南市', '曲艺', '高元钧', '高元钧', '2006-05-20', '济南市文化馆', '济南市非物质文化遗产保护中心', '/img/heritage/10_shandong_kuaishu.jpg'),

-- 第六大类：传统体育、游艺与杂技（2条）
('少林功夫', '河南省登封市', '传统体育、游艺与杂技', '释永信', '释永信', '2006-05-20', '嵩山少林寺', '嵩山少林寺', '/img/heritage/11_shaolin_gongfu.jpg'),
('吴桥杂技', '河北省吴桥县', '传统体育、游艺与杂技', '边发吉', '边发吉', '2006-05-20', '吴桥县文化馆', '吴桥县非物质文化遗产保护中心', '/img/heritage/12_wuqiao_zaji.jpg'),

-- 第七大类：传统美术（2条）
('蔚县剪纸', '河北省蔚县', '传统美术', '王老赏', '王老赏', '2006-05-20', '蔚县文化馆', '蔚县非物质文化遗产保护中心', '/img/heritage/13_weijian_jianzhi.jpg'),
('苏绣', '江苏省苏州市', '传统美术', '沈寿', '沈寿', '2006-05-20', '苏州刺绣研究所', '苏州刺绣研究所', '/img/heritage/14_suxiu.jpg'),

-- 第八大类：传统技艺（2条）
('景德镇手工制瓷技艺', '江西省景德镇市', '传统技艺', '王锡良', '王锡良', '2006-05-20', '景德镇市文化馆', '景德镇非物质文化遗产保护中心', '/img/heritage/15_jingdezhen_ciyi.jpg'),
('宣纸制作技艺', '安徽省泾县', '传统技艺', '曹光华', '曹光华', '2006-05-20', '泾县宣纸厂', '中国宣纸股份有限公司', '/img/heritage/16_xuanzhi_zhizuo.jpg'),

-- 第九大类：传统医药（2条）
('中医针灸', '北京市', '传统医药', '王雪苔', '王雪苔', '2006-05-20', '中国中医科学院', '中国中医科学院针灸研究所', '/img/heritage/17_zhongyi_zhenjiu.jpg'),
('同仁堂中医药文化', '北京市', '传统医药', '乐家后裔', '乐家后裔', '2006-05-20', '北京同仁堂股份有限公司', '北京同仁堂有限责任公司', '/img/heritage/18_tongrentang_yaoyi.jpg'),

-- 第十大类：民俗（2条）
('春节', '北京市', '民俗', '民俗传承人', '民俗传承人', '2006-05-20', '中国民俗学会', '中国民俗学会', '/img/heritage/19_chunjie.jpg'),
('端午节', '湖南省汨罗市', '民俗', '屈氏后裔', '屈氏后裔', '2009-09-30', '汨罗市文化馆', '汨罗市非物质文化遗产保护中心', '/img/heritage/20_duanwu_jie.jpg');