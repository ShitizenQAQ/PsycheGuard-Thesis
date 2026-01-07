-- 1. 清理旧数据（防止主键冲突）
TRUNCATE TABLE assess_record RESTART IDENTITY CASCADE;
TRUNCATE TABLE scale_question RESTART IDENTITY CASCADE;
TRUNCATE TABLE psych_scale RESTART IDENTITY CASCADE;
TRUNCATE TABLE sys_user RESTART IDENTITY CASCADE;

-- 2. 插入量表 (PCL-R)
INSERT INTO psych_scale (id, name, description, danger_threshold, max_score) VALUES (1, 'PCL-R', '精神病态评估量表 (Hare Psychopathy Checklist-Revised)', 20, 40);

-- 3. 插入题目 (PCL-R 20道题，满分40分)
INSERT INTO scale_question (scale_id, content, options) VALUES
(1, '维度:人际操控 表面迷人，健谈', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:人际操控 自大、自我中心', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:人际操控 病态撒谎', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:人际操控 狡猾、操纵他人', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 缺乏悔意或罪恶感', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 情感肤浅', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 冷酷无情、缺乏共情', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 不愿为自己行为负责', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:感觉寻求 极度讨厌无聊', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:感觉寻求 寄生生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:感觉寻求 缺乏现实长期目标', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:冲动控制 容易冲动行事', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:冲动控制 不负责任', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:认知扭曲 认为受害者是自找的', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:反社会 早期行为问题', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:反社会 青少年犯罪', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 短暂婚姻关系', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 混乱性关系', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 多种犯罪类型', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 违反假释或监管', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb);

-- 4. 插入咨询师 (账号: doctor / 密码: 123456)
INSERT INTO sys_user (id, username, real_name, password, role, tags)
VALUES (1, 'doctor', '张咨询师', '123456', 'ROLE_COUNSELOR', NULL);

-- 5. 插入来访者 (18人：包含高/中/低风险)
INSERT INTO sys_user (id, username, real_name, password, role, tags) VALUES
(2,  'liqiang',      '李强',     '123456', 'ROLE_CLIENT', ARRAY['重点关注', '暴力倾向']),
(3,  'wangjianguo',  '王建国',    '123456', 'ROLE_CLIENT', ARRAY['重点关注']),
(4,  'chenzhiyuan',  '陈志远',    '123456', 'ROLE_CLIENT', NULL),
(5,  'liuhaifeng',   '刘海峰',    '123456', 'ROLE_CLIENT', NULL),
(6,  'zhangweimin',  '张伟民',    '123456', 'ROLE_CLIENT', NULL),
(7,  'zhoumingyu',   '周明宇',    '123456', 'ROLE_CLIENT', NULL),
(8,  'zhaoxinyu',    '赵新宇',    '123456', 'ROLE_CLIENT', NULL),
(9,  'sunlina',      '孙丽娜',    '123456', 'ROLE_CLIENT', NULL),
(10, 'zhengkai',     '郑凯',      '123456', 'ROLE_CLIENT', NULL),
(11, 'yanglei',      '杨磊',      '123456', 'ROLE_CLIENT', NULL),
(12, 'hujunjie',     '胡俊杰',    '123456', 'ROLE_CLIENT', NULL),
(13, 'guozihao',     '郭子豪',    '123456', 'ROLE_CLIENT', NULL),
(14, 'hetingting',   '何婷婷',    '123456', 'ROLE_CLIENT', NULL),
(15, 'luozhicheng',  '罗志诚',    '123456', 'ROLE_CLIENT', NULL),
(16, 'gaoxiang',     '高翔',      '123456', 'ROLE_CLIENT', NULL),
(17, 'linchen',      '林晨',      '123456', 'ROLE_CLIENT', NULL),
(18, 'xieyutong',    '谢雨桐',    '123456', 'ROLE_CLIENT', NULL),
(19, 'tangsiyuan',   '唐思远',    '123456', 'ROLE_CLIENT', NULL);

-- 6. 插入测评记录 (制造漂亮的图表数据)
-- 李强 (重点关注, 教学案例)
INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time)
VALUES (2, 1, 36, 'HIGH', '{}'::jsonb, '{"情感冷漠":6,"冲动控制":6,"反社会":6,"认知扭曲":5,"生活方式":5,"人际操控":5}'::jsonb, TRUE, '该来访者缺乏共情能力，具有典型反社会人格障碍特征，建议安排专业咨询师进行深度访谈。', 'PENDING', NOW() - INTERVAL '1 HOUR');

-- 王建国 (重点关注)
INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time)
VALUES (3, 1, 34, 'HIGH', '{}'::jsonb, '{"情感冷漠":6,"冲动控制":5,"反社会":6,"认知扭曲":4,"生活方式":4,"人际操控":5}'::jsonb, FALSE, '多次访谈显示对规则漠视，冲动性强。', 'PROCESSING', NOW() - INTERVAL '1 DAY');

-- 一般关注数据 (填充图表)
INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time) VALUES
(4, 1, 26, 'MEDIUM', '{}'::jsonb, '{"情感冷漠":4,"冲动控制":4,"认知扭曲":3,"人际操控":3,"反社会":3,"生活方式":3}'::jsonb, FALSE, NULL, 'PENDING', NOW() - INTERVAL '2 DAY'),
(5, 1, 24, 'MEDIUM', '{}'::jsonb, '{"情感冷漠":3,"冲动控制":4,"认知扭曲":3,"人际操控":3,"反社会":3,"生活方式":3}'::jsonb, FALSE, NULL, 'PENDING', NOW() - INTERVAL '3 DAY'),
(6, 1, 22, 'MEDIUM', '{}'::jsonb, '{"情感冷漠":3,"冲动控制":3,"认知扭曲":3,"人际操控":3,"反社会":2,"生活方式":3}'::jsonb, FALSE, NULL, 'PENDING', NOW() - INTERVAL '4 DAY'),
(7, 1, 20, 'MEDIUM', '{}'::jsonb, '{"情感冷漠":3,"冲动控制":3,"认知扭曲":2,"人际操控":3,"反社会":2,"生活方式":2}'::jsonb, FALSE, NULL, 'PENDING', NOW() - INTERVAL '5 DAY'),
(8, 1, 18, 'MEDIUM', '{}'::jsonb, '{"情感冷漠":2,"冲动控制":3,"认知扭曲":2,"人际操控":2,"反社会":2,"生活方式":2}'::jsonb, FALSE, NULL, 'PENDING', NOW() - INTERVAL '6 DAY');

-- 安心状态数据 (填充图表)
INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time) VALUES
(9,  1, 12, 'LOW', '{}'::jsonb, '{"情感冷漠":2,"冲动控制":2,"认知扭曲":1,"人际操控":2,"反社会":1,"生活方式":2}'::jsonb, FALSE, NULL, 'ARCHIVED', NOW() - INTERVAL '7 DAY'),
(10, 1, 10, 'LOW', '{}'::jsonb, '{"情感冷漠":1,"冲动控制":2,"认知扭曲":1,"人际操控":1,"反社会":1,"生活方式":2}'::jsonb, FALSE, NULL, 'PENDING',  NOW() - INTERVAL '3 DAY'),
(11, 1, 9,  'LOW', '{}'::jsonb, '{"情感冷漠":1,"冲动控制":2,"认知扭曲":1,"人际操控":1,"反社会":1,"生活方式":1}'::jsonb, FALSE, NULL, 'PENDING',  NOW() - INTERVAL '2 DAY'),
(12, 1, 8,  'LOW', '{}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"认知扭曲":1,"人际操控":1,"反社会":1,"生活方式":1}'::jsonb, FALSE, NULL, 'PENDING',  NOW() - INTERVAL '1 DAY');

-- 7. 修复自增序列 (最关键的一步，防止后续报错)
SELECT setval(pg_get_serial_sequence('sys_user','id'), (SELECT MAX(id) FROM sys_user));
SELECT setval(pg_get_serial_sequence('assess_record','id'), (SELECT MAX(id) FROM assess_record));
SELECT setval(pg_get_serial_sequence('psych_scale','id'), (SELECT MAX(id) FROM psych_scale));
SELECT setval(pg_get_serial_sequence('scale_question','id'), (SELECT MAX(id) FROM scale_question));

-- =====================================================
-- === 追加：SAS (焦虑自评量表) 数据 ===
-- =====================================================
-- 插入量表定义 (使用 NOT EXISTS 确保幂等性)
INSERT INTO psych_scale (name, description, danger_threshold, max_score, is_enabled) 
SELECT 'SAS', '焦虑自评量表 (Self-Rating Anxiety Scale)', 50, 80, TRUE
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SAS');

-- 插入 SAS 题目 (使用 WITH 子查询动态获取 scale_id)
WITH scale_info AS (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1)
INSERT INTO scale_question (scale_id, content, options) 
SELECT id, '维度:躯体性 我觉得比平常容易紧张和着急', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%容易紧张和着急%')
UNION ALL
SELECT id, '维度:躯体性 我无缘无故地感到害怕', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%无缘无故地感到害怕%')
UNION ALL
SELECT id, '维度:精神性 我容易心里烦乱或觉得惊恐', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%心里烦乱或觉得惊恐%')
UNION ALL
SELECT id, '维度:精神性 我觉得可能将要发疯', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%可能将要发疯%')
UNION ALL
SELECT id, '维度:躯体性 我觉得手脚发抖打颤', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%手脚发抖打颤%');

-- =====================================================
-- === 追加：SDS (抑郁自评量表) 数据 ===
-- =====================================================
-- 插入量表定义
INSERT INTO psych_scale (name, description, danger_threshold, max_score, is_enabled) 
SELECT 'SDS', '抑郁自评量表 (Self-Rating Depression Scale)', 53, 80, TRUE
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SDS');

-- 插入 SDS 题目
WITH scale_info AS (SELECT id FROM psych_scale WHERE name = 'SDS' LIMIT 1)
INSERT INTO scale_question (scale_id, content, options) 
SELECT id, '维度:核心抑郁 我觉得闷闷不乐，情绪低沉', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%闷闷不乐，情绪低沉%')
UNION ALL
SELECT id, '维度:核心抑郁 我觉得一天之中早晨最好', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%一天之中早晨最好%')
UNION ALL
SELECT id, '维度:生理机能 我吃饭象平时一样香', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%吃饭象平时一样香%')
UNION ALL
SELECT id, '维度:生理机能 我睡眠不佳', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%睡眠不佳%');

-- 修复自增序列 (确保新增数据后序列正确)
SELECT setval(pg_get_serial_sequence('psych_scale','id'), (SELECT MAX(id) FROM psych_scale));
SELECT setval(pg_get_serial_sequence('scale_question','id'), (SELECT MAX(id) FROM scale_question));