-- 1. 清理旧数据（防止主键冲突）
TRUNCATE TABLE assess_record RESTART IDENTITY CASCADE;
TRUNCATE TABLE scale_question RESTART IDENTITY CASCADE;
TRUNCATE TABLE psych_scale RESTART IDENTITY CASCADE;
TRUNCATE TABLE sys_user RESTART IDENTITY CASCADE;

-- 2. 插入量表 (PCL-R - 他评量表)
INSERT INTO psych_scale (id, name, description, danger_threshold, max_score, type) VALUES (1, 'PCL-R', '精神病态评估量表 (Hare Psychopathy Checklist-Revised)', 20, 40, 'OBSERVER');

-- 3. 插入题目 (PCL-R 20道题,满分40分)
INSERT INTO scale_question (scale_id, content, dimension, options) VALUES
(1, '维度:人际操控 表面迷人,健谈', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:人际操控 自大、自我中心', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:人际操控 病态撒谎', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:人际操控 狡猾、操纵他人', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 缺乏悔意或罪恶感', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 情感肤浅', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 冷酷无情、缺乏共情', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:情感冷漠 不愿为自己行为负责', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:感觉寻求 极度讨厌无聊', '感觉寻求', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:感觉寻求 寄生生活方式', '感觉寻求', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:感觉寻求 缺乏现实长期目标', '感觉寻求', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:冲动控制 容易冲动行事', '冲动控制', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:冲动控制 不负责任', '冲动控制', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:认知扭曲 认为受害者是自找的', '认知扭曲', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:反社会 早期行为问题', '反社会', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:反社会 青少年犯罪', '反社会', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 短暂婚姻关系', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 混乱性关系', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 多种犯罪类型', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '维度:生活方式 违反假释或监管', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb);

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
-- 插入量表定义 (自评量表,使用 NOT EXISTS 确保幂等性)
INSERT INTO psych_scale (name, description, danger_threshold, max_score, is_enabled, type) 
SELECT 'SAS', '焦虑自评量表 (Self-Rating Anxiety Scale)', 50, 80, TRUE, 'SELF'
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SAS');


-- 插入 SAS 题目 (完整 20 题,满分 80 分)
WITH scale_info AS (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1)
INSERT INTO scale_question (scale_id, content, dimension, options) 
SELECT id, '我觉得比平常容易紧张和着急', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%容易紧张和着急%')
UNION ALL
SELECT id, '我无缘无故地感到害怕', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%无缘无故地感到害怕%')
UNION ALL
SELECT id, '我容易心里烦乱或觉得惊恐', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%心里烦乱或觉得惊恐%')
UNION ALL
SELECT id, '我觉得我可能将要发疯', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%可能将要发疯%')
UNION ALL
SELECT id, '我觉得一切都很好,也不会发生什么不幸', '精神症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%一切都很好%')
UNION ALL
SELECT id, '我手脚发抖打颤', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%手脚发抖打颤%')
UNION ALL
SELECT id, '我因为头痛、颈痛和背痛而苦恼', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%头痛、颈痛和背痛%')
UNION ALL
SELECT id, '我感觉容易衰弱和疲乏', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%容易衰弱和疲乏%')
UNION ALL
SELECT id, '我觉得心平气和,并且容易安静坐着', '精神症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%心平气和%')
UNION ALL
SELECT id, '我觉得心跳很快', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%心跳很快%')
UNION ALL
SELECT id, '我因为一阵阵头晕而苦恼', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%一阵阵头晕%')
UNION ALL
SELECT id, '我有晕倒发作或觉得要晕倒似的', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%晕倒发作%')
UNION ALL
SELECT id, '我呼气吸气都感到很容易', '躯体症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%呼气吸气都感到很容易%')
UNION ALL
SELECT id, '我手脚麻木和刺痛', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%手脚麻木和刺痛%')
UNION ALL
SELECT id, '我因为胃痛和消化不良而苦恼', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%胃痛和消化不良%')
UNION ALL
SELECT id, '我常常要小便', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%常常要小便%')
UNION ALL
SELECT id, '我的手常常是干燥温暖的', '躯体症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%手常常是干燥温暖%')
UNION ALL
SELECT id, '我脸红发热', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%脸红发热%')
UNION ALL
SELECT id, '我容易入睡并且一夜睡得很好', '躯体症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%容易入睡%')
UNION ALL
SELECT id, '我做恶梦', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%做恶梦%');

-- =====================================================
-- === 追加：SDS (抑郁自评量表) 数据 ===
-- =====================================================
-- 插入量表定义 (自评量表)
INSERT INTO psych_scale (name, description, danger_threshold, max_score, is_enabled, type) 
SELECT 'SDS', '抑郁自评量表 (Self-Rating Depression Scale)', 53, 80, TRUE, 'SELF'
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SDS');

-- 插入 SDS 题目 (完整 20 题,满分 80 分)
WITH scale_info AS (SELECT id FROM psych_scale WHERE name = 'SDS' LIMIT 1)
INSERT INTO scale_question (scale_id, content, dimension, options) 
SELECT id, '我感到情绪沮丧,郁闷', '核心抑郁', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%情绪沮丧,郁闷%')
UNION ALL
SELECT id, '我感到早晨心情最好', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%早晨心情最好%')
UNION ALL
SELECT id, '我要哭或想哭', '核心抑郁', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%要哭或想哭%')
UNION ALL
SELECT id, '我夜间睡眠不好', '生理机能', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%夜间睡眠不好%')
UNION ALL
SELECT id, '我吃饭像平常一样多', '生理机能', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%吃饭像平常一样多%')
UNION ALL
SELECT id, '我的性功能正常', '生理机能', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%性功能正常%')
UNION ALL
SELECT id, '我感到体重减轻', '生理机能', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%体重减轻%')
UNION ALL
SELECT id, '我为便秘烦恼', '生理机能', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%为便秘烦恼%')
UNION ALL
SELECT id, '我的心跳比平时快', '生理机能', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%心跳比平时快%')
UNION ALL
SELECT id, '我无故感到疲乏', '生理机能', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%无故感到疲乏%')
UNION ALL
SELECT id, '我的头脑像平常一样清楚', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%头脑像平常一样清楚%')
UNION ALL
SELECT id, '我做事情像平常一样不感到困难', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%做事情像平常一样不感到困难%')
UNION ALL
SELECT id, '我坐卧难安,难以保持平静', '核心抑郁', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%坐卧难安%')
UNION ALL
SELECT id, '我对将来抱有希望', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%对将来抱有希望%')
UNION ALL
SELECT id, '我比平时更容易激怒', '核心抑郁', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%更容易激怒%')
UNION ALL
SELECT id, '我觉得做出决定是容易的', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%做出决定是容易的%')
UNION ALL
SELECT id, '我觉得自己是个有用的人,有人需要我', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%有用的人%')
UNION ALL
SELECT id, '我的生活过得很有意思', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%生活过得很有意思%')
UNION ALL
SELECT id, '假若我死了,别人会过得更好', '核心抑郁', '[{"label": "从无或偶尔", "score": 1}, {"label": "有时", "score": 2}, {"label": "经常", "score": 3}, {"label": "总是如此", "score": 4}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%假若我死了%')
UNION ALL
SELECT id, '我仍旧喜欢自己平时喜欢的东西', '核心抑郁', '[{"label": "从无或偶尔", "score": 4}, {"label": "有时", "score": 3}, {"label": "经常", "score": 2}, {"label": "总是如此", "score": 1}]'::jsonb FROM scale_info
WHERE NOT EXISTS (SELECT 1 FROM scale_question sq, scale_info si WHERE sq.scale_id = si.id AND sq.content LIKE '%仍旧喜欢自己平时喜欢的东西%');

-- =====================================================
-- === 追加:其他常用量表定义 ===
-- =====================================================

-- ==========================================
-- 补录:自评量表 (Type = SELF)
-- ==========================================

-- SCL-90 (综合体检)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'SCL-90', '90项症状清单,世界上最著名的心理健康综合体检量表,涵盖思维、情感、行为、人际关系等10个维度。', 'SELF', TRUE, 160, 450
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SCL-90');

-- PHQ-9 (快速抑郁)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'PHQ-9', '病人健康问卷,国际通用的抑郁症快速筛查工具,常用于基层医疗机构。', 'SELF', TRUE, 10, 27
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'PHQ-9');

-- GAD-7 (快速焦虑)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'GAD-7', '广泛性焦虑量表,用于快速评估焦虑症状的严重程度。', 'SELF', TRUE, 10, 21
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'GAD-7');

-- EPQ (人格测试)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'EPQ', '艾森克人格问卷,用于评估内外向(E)、神经质(N)、精神质(P)及掩饰性(L)等人格特质。', 'SELF', TRUE, 60, 100
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'EPQ');


-- ==========================================
-- 补录:他评量表 (Type = OBSERVER)
-- ==========================================

-- HAMD-17 (抑郁金标准)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'HAMD-17', '汉密尔顿抑郁量表 (17项版),临床评估抑郁状态的金标准,由经过培训的专业人员进行评定。', 'OBSERVER', TRUE, 17, 52
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'HAMD-17');

-- HAMA (焦虑金标准)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'HAMA', '汉密尔顿焦虑量表,精神科临床用于评估焦虑症状严重程度的首选工具。', 'OBSERVER', TRUE, 14, 56
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'HAMA');

-- BPRS (精神病性)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'BPRS', '简明精神病评定量表,主要用于评定精神分裂症等重性精神病的症状变化。', 'OBSERVER', TRUE, 35, 126
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'BPRS');


-- 修复自增序列 (确保新增数据后序列正确)
SELECT setval(pg_get_serial_sequence('psych_scale','id'), (SELECT MAX(id) FROM psych_scale));
SELECT setval(pg_get_serial_sequence('scale_question','id'), (SELECT MAX(id) FROM scale_question));

-- =====================================================
-- === 追加:通知系统测试数据 ===
-- =====================================================
-- 为咨询师 (user_id=1) 添加不同类型的通知
INSERT INTO notifications (user_id, title, content, type, related_url, is_read, created_at) VALUES
-- 紧急通知 (URGENT - 红色)
(1, '🚨 危机干预警报', '来访者"李强"在最新评测中得分36分,已触发危机干预阈值,请立即处理!', 'URGENT', '/intervention', FALSE, NOW() - INTERVAL '10 MINUTE'),
(1, '🔴 严重预警', '来访者"王建国"连续两次评测均显示高风险,建议安排紧急面谈。', 'URGENT', '/users', FALSE, NOW() - INTERVAL '2 HOUR'),

-- 预警通知 (WARNING - 橙色)
(1, '⚠️ 中度风险提醒', '来访者"陈志远"最新评测显示中度风险,建议关注其情绪变化。', 'WARNING', '/intervention', FALSE, NOW() - INTERVAL '5 HOUR'),
(1, '📊 数据异常提醒', '本周高风险评测数量较上周增长40%,请关注整体趋势。', 'WARNING', '/dashboard', FALSE, NOW() - INTERVAL '1 DAY'),

-- 普通通知 (INFO - 灰色)
(1, '✅ 评测完成通知', '来访者"刘海峰"已完成 PCL-R 量表评测,请查看报告。', 'INFO', '/history', FALSE, NOW() - INTERVAL '3 HOUR'),
(1, '📝 系统更新', '心理评估系统已更新至 v2.5.0,新增通知中心功能。', 'INFO', '/dashboard', FALSE, NOW() - INTERVAL '2 DAY'),

-- 已读通知 (用于测试)
(1, '📋 每周报告', '上周共完成评测 12 次,其中高风险 2 例,中风险 5 例。', 'INFO', '/dashboard', TRUE, NOW() - INTERVAL '7 DAY');

-- 修复通知表自增序列
SELECT setval(pg_get_serial_sequence('notifications','id'), (SELECT MAX(id) FROM notifications));


-- ========================================================
-- 更新量表配置：设置医学标准的满分与警戒线
-- ========================================================

-- 1. PCL-R
UPDATE psych_scale SET max_score = 40, danger_threshold = 20 WHERE name = 'PCL-R';

-- 2. PHQ-9
UPDATE psych_scale SET max_score = 27, danger_threshold = 10 WHERE name = 'PHQ-9';

-- 3. GAD-7
UPDATE psych_scale SET max_score = 21, danger_threshold = 10 WHERE name = 'GAD-7';

-- 4. SAS
UPDATE psych_scale SET max_score = 80, danger_threshold = 50 WHERE name = 'SAS';

-- 5. SDS
UPDATE psych_scale SET max_score = 80, danger_threshold = 53 WHERE name = 'SDS';

-- 6. SCL-90
UPDATE psych_scale SET max_score = 450, danger_threshold = 160 WHERE name = 'SCL-90';

-- 7. EPQ
UPDATE psych_scale SET max_score = 100, danger_threshold = 60 WHERE name = 'EPQ';

-- 8. HAMD-17
UPDATE psych_scale SET max_score = 60, danger_threshold = 17 WHERE name = 'HAMD-17';

-- 9. HAMA
UPDATE psych_scale SET max_score = 56, danger_threshold = 14 WHERE name = 'HAMA';

-- 10. BPRS
UPDATE psych_scale SET max_score = 126, danger_threshold = 35 WHERE name = 'BPRS';

-- =====================================================
-- SCL-90 量表题目 (精简演示版: 10题覆盖10个因子)
-- =====================================================
DELETE FROM scale_question WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'SCL-90');

WITH scale_info AS (SELECT id FROM psych_scale WHERE name = 'SCL-90' LIMIT 1)
INSERT INTO scale_question (scale_id, content, dimension, options) 
SELECT id, '维度:躯体化 头痛', '躯体化', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:强迫症状 感到要反复确认早已做好的事情', '强迫症状', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:人际关系敏感 感到由于您的行为举止引起他人的注视或议论', '人际关系敏感', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:抑郁 感到情绪低落', '抑郁', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:焦虑 感到神经过敏，心中不踏实', '焦虑', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:敌对 容易烦恼和激动', '敌对', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:恐怖 害怕空旷的广场或街道', '恐怖', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:偏执 感到别人想占您的便宜', '偏执', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:精神病性 感到自己的头脑有毛病', '精神病性', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info
UNION ALL
SELECT id, '维度:其他 饮食或睡眠情况不好', '其他', '[{"label": "1-从无", "score": 1}, {"label": "2-轻度", "score": 2}, {"label": "3-中度", "score": 3}, {"label": "4-偏重", "score": 4}, {"label": "5-严重", "score": 5}]'::jsonb FROM scale_info;

-- =====================================================
-- 最终序列修复 (确保所有表的自增 ID 正确)
-- =====================================================
SELECT setval(pg_get_serial_sequence('sys_user','id'), COALESCE((SELECT MAX(id) FROM sys_user), 1));
SELECT setval(pg_get_serial_sequence('psych_scale','id'), COALESCE((SELECT MAX(id) FROM psych_scale), 1));
SELECT setval(pg_get_serial_sequence('scale_question','id'), COALESCE((SELECT MAX(id) FROM scale_question), 1));
SELECT setval(pg_get_serial_sequence('assess_record','id'), COALESCE((SELECT MAX(id) FROM assess_record), 1));
SELECT setval(pg_get_serial_sequence('notifications','id'), COALESCE((SELECT MAX(id) FROM notifications), 1));
