-- 1. 清理旧数据（防止主键冲突，重新初始化）
TRUNCATE TABLE assess_record RESTART IDENTITY CASCADE;
TRUNCATE TABLE scale_question RESTART IDENTITY CASCADE;
TRUNCATE TABLE psych_scale RESTART IDENTITY CASCADE;
TRUNCATE TABLE sys_user RESTART IDENTITY CASCADE;
TRUNCATE TABLE notifications RESTART IDENTITY CASCADE;

-- =====================================================
-- (A) 系统用户初始化 (所有密码已加密为 123456)
-- Hash: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa
-- =====================================================

-- 咨询师 (Counselors)
INSERT INTO sys_user (id, username, real_name, password, role, tags) VALUES
(1, 'doctor', '系统管理员', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_COUNSELOR', NULL);

-- 来访者 (Clients)
INSERT INTO sys_user (id, username, real_name, password, role, tags) VALUES
(2,  'visitor_01', 'Case-2401', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', ARRAY['重点关注', '高危样本']),
(3,  'visitor_02', 'Case-2402', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', ARRAY['重点关注']),
(4,  'visitor_03', 'Case-2403', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL),
(5,  'visitor_04', 'Case-2404', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL),
(6,  'visitor_05', 'Case-2405', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL),
(7,  'visitor_06', 'Case-2406', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL),
(8,  'visitor_07', 'Case-2407', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL),
(9,  'visitor_08', 'Case-2408', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL),
(10, 'visitor_09', 'Case-2409', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL),
(11, 'visitor_10', 'Case-2410', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n1J7BNQ9VgSz0J/UYmKHa', 'ROLE_CLIENT', NULL);


-- =====================================================
-- (B) 心理量表定义
-- =====================================================

-- 1. PCL-R (他评)
INSERT INTO psych_scale (id, name, description, danger_threshold, max_score, type) 
VALUES (1, 'PCL-R', '精神病态评估量表 (Hare Psychopathy Checklist-Revised)', 20, 40, 'OBSERVER');

-- 2. SAS (自评)
INSERT INTO psych_scale (id, name, description, danger_threshold, max_score, type) 
VALUES (2, 'SAS', '焦虑自评量表 (Self-Rating Anxiety Scale)', 50, 80, 'SELF');


-- =====================================================
-- (C) 量表题目 (已清洗维度信息)
-- =====================================================

-- PCL-R 题目 (注意 content 不再包含 "维度:xxx")
INSERT INTO scale_question (scale_id, content, dimension, options) VALUES
(1, '表面迷人,健谈', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '自大、自我中心', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '病态撒谎', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '狡猾、操纵他人', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '缺乏悔意或罪恶感', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '情感肤浅', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '冷酷无情、缺乏共情', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '不愿为自己行为负责', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '极度讨厌无聊', '感觉寻求', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '寄生生活方式', '感觉寻求', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '缺乏现实长期目标', '感觉寻求', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '容易冲动行事', '冲动控制', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '不负责任', '冲动控制', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '认为受害者是自找的', '认知扭曲', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '早期行为问题', '反社会', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '青少年犯罪', '反社会', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '短暂婚姻关系', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '混乱性关系', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '多种犯罪类型', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
(1, '违反假释或监管', '生活方式', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb);

-- SAS 题目
INSERT INTO scale_question (scale_id, content, dimension, options) VALUES
(2, '我觉得比平常容易紧张和着急', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb),
(2, '我无缘无故地感到害怕', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb),
(2, '我容易心里烦乱或觉得惊恐', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb),
(2, '我觉得我可能将要发疯', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb),
(2, '我觉得一切都很好，也不会发生什么不幸', '精神症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb),
(2, '我手脚颤抖打颤', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb),
(2, '我因为头痛、颈痛和背痛而苦恼', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb),
(2, '我觉得容易衰弱和疲乏', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb);


-- =====================================================
-- (D) 测评记录预埋 (用于 Dashboard 展示)
-- =====================================================
INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time) VALUES
(2, 1, 36, 'HIGH', '{}'::jsonb, '{"情感冷漠":6,"冲动控制":6,"反社会":6,"认知扭曲":5,"生活方式":5,"人际操控":5}'::jsonb, TRUE, '该档案缺乏共情能力，具有典型反社会人格障碍特征。', 'PENDING', NOW() - INTERVAL '1 HOUR'),
(3, 1, 34, 'HIGH', '{}'::jsonb, '{"情感冷漠":6,"冲动控制":5,"反社会":6,"认知扭曲":4,"生活方式":4,"人际操控":5}'::jsonb, FALSE, '多次访谈显示对规则漠视，冲动性强。', 'PROCESSING', NOW() - INTERVAL '1 DAY'),
(4, 1, 26, 'MEDIUM', '{}'::jsonb, '{"情感冷漠":4,"冲动控制":4,"认知扭曲":3,"人际操控":3,"反社会":3,"生活方式":3}'::jsonb, FALSE, NULL, 'PENDING', NOW() - INTERVAL '2 DAY'),
(5, 1, 24, 'MEDIUM', '{}'::jsonb, '{"情感冷漠":3,"冲动控制":4,"认知扭曲":3,"人际操控":3,"反社会":3,"生活方式":3}'::jsonb, FALSE, NULL, 'PENDING', NOW() - INTERVAL '3 DAY'),
(9,  1, 12, 'LOW', '{}'::jsonb, '{"情感冷漠":2,"冲动控制":2,"认知扭曲":1,"人际操控":2,"反社会":1,"生活方式":2}'::jsonb, FALSE, NULL, 'ARCHIVED', NOW() - INTERVAL '7 DAY');

-- =====================================================
-- (E) 修复自增序列
-- =====================================================
SELECT setval(pg_get_serial_sequence('sys_user','id'), (SELECT MAX(id) FROM sys_user));
SELECT setval(pg_get_serial_sequence('assess_record','id'), (SELECT MAX(id) FROM assess_record));
SELECT setval(pg_get_serial_sequence('psych_scale','id'), (SELECT MAX(id) FROM psych_scale));
SELECT setval(pg_get_serial_sequence('scale_question','id'), (SELECT MAX(id) FROM scale_question));
