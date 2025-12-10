BEGIN;

TRUNCATE TABLE assess_record RESTART IDENTITY CASCADE;
TRUNCATE TABLE sys_user RESTART IDENTITY CASCADE;

DELETE FROM psych_scale WHERE id = 1;
INSERT INTO psych_scale (id, name, description) VALUES (1, 'PCL-R', '精神病态评估量表');

INSERT INTO sys_user (id, username, real_name, password, role, tags) VALUES (1, 'admin', '张主任', '123456', 'DOCTOR', NULL);

INSERT INTO sys_user (id, username, real_name, password, role, tags) VALUES
(2,  'liqiang',      '李强',      '123456', 'PRISONER', ARRAY['重点关注']),
(3,  'wangjianguo',  '王建国',    '123456', 'PRISONER', ARRAY['重点关注']),
(4,  'chenzhiyuan',  '陈志远',    '123456', 'PRISONER', NULL),
(5,  'liuhaifeng',   '刘海峰',    '123456', 'PRISONER', NULL),
(6,  'zhangweimin',  '张伟民',    '123456', 'PRISONER', NULL),
(7,  'zhoumingyu',   '周明宇',    '123456', 'PRISONER', NULL),
(8,  'zhaoxinyu',    '赵新宇',    '123456', 'PRISONER', NULL),
(9,  'sunlina',      '孙丽娜',    '123456', 'PRISONER', NULL),
(10, 'zhengkai',     '郑凯',      '123456', 'PRISONER', NULL),
(11, 'yanglei',      '杨磊',      '123456', 'PRISONER', NULL),
(12, 'hujunjie',     '胡俊杰',    '123456', 'PRISONER', NULL),
(13, 'guozihao',     '郭子豪',    '123456', 'PRISONER', NULL),
(14, 'hetingting',   '何婷婷',    '123456', 'PRISONER', NULL),
(15, 'luozhicheng',  '罗志诚',    '123456', 'PRISONER', NULL),
(16, 'gaoxiang',     '高翔',      '123456', 'PRISONER', NULL),
(17, 'linchen',      '林晨',      '123456', 'PRISONER', NULL),
(18, 'xieyutong',    '谢雨桐',    '123456', 'PRISONER', NULL),
(19, 'tangsiyuan',   '唐思远',    '123456', 'PRISONER', NULL);

INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time) VALUES
(2, 1, 36, 'HIGH',
 '{"1":2,"2":2,"3":2,"4":2}'::jsonb,
 '{"情感冷漠":6,"冲动控制":6,"反社会":6,"认知扭曲":5,"生活方式":5,"人际操控":5}'::jsonb,
 TRUE,
 '该对象缺乏共情能力，具有典型反社会人格障碍特征，建议立即启动二级干预流程并持续密切监控。',
 'PENDING',
 now() - interval '1 hour'
),
(3, 1, 34, 'HIGH',
 '{"1":2,"2":2,"3":1,"4":2}'::jsonb,
 '{"情感冷漠":6,"冲动控制":5,"反社会":6,"认知扭曲":4,"生活方式":4,"人际操控":5}'::jsonb,
 FALSE,
 '多次访谈显示对规则漠视、冲动性强，需加强个体化干预。',
 'PROCESSING',
 now() - interval '1 day' - interval '2 hour'
);

INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time) VALUES
(4,  1, 26, 'MEDIUM', '{"1":1,"2":2,"3":2}'::jsonb, '{"情感冷漠":4,"冲动控制":4,"反社会":3,"认知扭曲":3,"生活方式":3,"人际操控":3}'::jsonb, FALSE, NULL, 'PENDING',     now() - interval '2 day'),
(5,  1, 24, 'MEDIUM', '{"1":1,"2":1,"3":2}'::jsonb, '{"情感冷漠":3,"冲动控制":4,"反社会":3,"认知扭曲":3,"生活方式":2,"人际操控":3}'::jsonb, FALSE, NULL, 'PENDING',     now() - interval '3 day'),
(6,  1, 22, 'MEDIUM', '{"1":2,"2":0,"3":2}'::jsonb, '{"情感冷漠":3,"冲动控制":3,"反社会":3,"认知扭曲":3,"生活方式":2,"人际操控":3}'::jsonb, FALSE, NULL, 'PENDING',     now() - interval '4 day'),
(7,  1, 20, 'MEDIUM', '{"1":1,"2":1,"3":1}'::jsonb, '{"情感冷漠":3,"冲动控制":3,"反社会":2,"认知扭曲":2,"生活方式":2,"人际操控":2}'::jsonb, FALSE, NULL, 'PROCESSING', now() - interval '5 day'),
(8,  1, 18, 'MEDIUM', '{"1":1,"2":0,"3":2}'::jsonb, '{"情感冷漠":2,"冲动控制":3,"反社会":2,"认知扭曲":2,"生活方式":2,"人际操控":2}'::jsonb, FALSE, NULL, 'PENDING',     now() - interval '6 day');

INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, is_teaching_case, expert_annotation, status, create_time) VALUES
(9,  1, 12, 'LOW', '{"1":0,"2":1,"3":1}'::jsonb, '{"情感冷漠":2,"冲动控制":2,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'ARCHIVED',  now() - interval '7 day'),
(10, 1, 10, 'LOW', '{"1":1,"2":0,"3":1}'::jsonb, '{"情感冷漠":1,"冲动控制":2,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '3 day'),
(11, 1,  9, 'LOW', '{"1":0,"2":1,"3":0}'::jsonb, '{"情感冷漠":1,"冲动控制":2,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '2 day'),
(12, 1,  8, 'LOW', '{"1":0,"2":0,"3":2}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '1 day'),
(13, 1,  8, 'LOW', '{"1":0,"2":0,"3":2}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '5 day'),
(14, 1,  7, 'LOW', '{"1":1,"2":0,"3":0}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '4 day'),
(15, 1,  7, 'LOW', '{"1":1,"2":0,"3":0}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'ARCHIVED',  now() - interval '6 day'),
(16, 1,  6, 'LOW', '{"1":0,"2":1,"3":0}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '7 day'),
(17, 1,  6, 'LOW', '{"1":0,"2":1,"3":0}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '2 day'),
(18, 1,  5, 'LOW', '{"1":1,"2":0,"3":0}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '1 day'),
(19, 1,  5, 'LOW', '{"1":1,"2":0,"3":0}'::jsonb, '{"情感冷漠":1,"冲动控制":1,"反社会":1,"认知扭曲":1,"生活方式":1,"人际操控":1}'::jsonb, FALSE, NULL, 'PENDING',    now() - interval '3 day');

SELECT setval(pg_get_serial_sequence('sys_user','id'),      (SELECT COALESCE(MAX(id),1) FROM sys_user),      TRUE);
SELECT setval(pg_get_serial_sequence('assess_record','id'), (SELECT COALESCE(MAX(id),1) FROM assess_record), TRUE);

COMMIT;
VALUES (1, 'chen_baozao', '123456', 'PRISONER', '陈暴躁')
ON CONFLICT (id) DO UPDATE SET username=EXCLUDED.username, real_name=EXCLUDED.real_name, password=EXCLUDED.password, role=EXCLUDED.role;

INSERT INTO sys_user (id, username, password, role, real_name)
VALUES (2, 'dr_zhang', '123456', 'DOCTOR', '张主任')
ON CONFLICT (id) DO UPDATE SET username=EXCLUDED.username, real_name=EXCLUDED.real_name, password=EXCLUDED.password, role=EXCLUDED.role;

INSERT INTO sys_user (id, username, password, role, real_name)
VALUES (3, 'li_chongdong', '123456', 'PRISONER', '李冲动')
ON CONFLICT (id) DO UPDATE SET username=EXCLUDED.username, real_name=EXCLUDED.real_name, password=EXCLUDED.password, role=EXCLUDED.role;

INSERT INTO sys_user (id, username, password, role, real_name)
VALUES (4, 'zhao_fanshe', '123456', 'PRISONER', '赵反社')
ON CONFLICT (id) DO UPDATE SET username=EXCLUDED.username, real_name=EXCLUDED.real_name, password=EXCLUDED.password, role=EXCLUDED.role;

INSERT INTO psych_scale (id, name, total_score)
VALUES (1, 'PCL-R 精神病态量表', 40)
ON CONFLICT (id) DO NOTHING;

INSERT INTO scale_question (scale_id, content, dimension, options) VALUES
  (1, '表面迷人，健谈', '人际操控', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
  (1, '缺乏悔意或罪恶感', '情感冷漠', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
  (1, '极度讨厌无聊', '感觉寻求', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
  (1, '容易冲动行事', '冲动控制', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb),
  (1, '认为受害者是自找的', '认知扭曲', '[{"label": "0分-不符合", "score": 0}, {"label": "1分-部分符合", "score": 1}, {"label": "2分-完全符合", "score": 2}]'::jsonb);

-- 4. 高风险评估记录（用于通知中心展示）
INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, create_time)
VALUES (3, 1, 36, 'HIGH', '{"1":2,"2":2,"3":2,"4":2,"5":2}'::jsonb,
        '{"认知扭曲":6,"情感冷漠":6,"冲动控制":6}'::jsonb,
        NOW() - INTERVAL '30 minutes')
ON CONFLICT DO NOTHING;

INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, create_time)
VALUES (4, 1, 34, 'HIGH', '{"1":2,"2":2,"3":2,"4":1,"5":2}'::jsonb,
        '{"反社会":6,"人际操控":4,"生活方式":4}'::jsonb,
        NOW() - INTERVAL '2 hours')
ON CONFLICT DO NOTHING;

INSERT INTO assess_record (user_id, scale_id, total_score, risk_level, answers, dimension_analysis, create_time)
VALUES (1, 1, 32, 'HIGH', '{"1":2,"2":1,"3":2,"4":2,"5":1}'::jsonb,
        '{"冲动控制":6,"感觉寻求":6}'::jsonb,
        NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;
