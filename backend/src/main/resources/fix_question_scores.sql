-- ============================================================
-- PsycheGuard 题目选项分值修复脚本
-- fix_question_scores.sql
-- 生成时间: 2026-01-09
-- 说明: 修正 SCL-90, SAS, SDS, PCL-R 量表的选项分值逻辑
-- ============================================================

-- 开始事务
BEGIN;

-- ============================================================
-- 第一部分: SCL-90 量表修正 (1-5分制)
-- 标准正向计分: 1=从无, 2=轻度, 3=中度, 4=偏重, 5=严重
-- ============================================================

-- 批量更新所有 SCL-90 题目为标准 1-5 分制
UPDATE question
SET options = '[
  {"label": "从无", "score": 1},
  {"label": "轻度", "score": 2},
  {"label": "中度", "score": 3},
  {"label": "偏重", "score": 4},
  {"label": "严重", "score": 5}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SCL-90%' LIMIT 1);

-- ============================================================
-- 第二部分: SAS 焦虑自评量表修正 (1-4分制，含反向题)
-- 正向计分: 1=没有或很少时间, 2=小部分时间, 3=相当多时间, 4=绝大部分时间
-- 反向题: 第5,9,13,17,19题 (分值 4,3,2,1)
-- ============================================================

-- 2.1 SAS 正向题默认选项
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 1},
  {"label": "小部分时间", "score": 2},
  {"label": "相当多时间", "score": 3},
  {"label": "绝大部分时间", "score": 4}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SAS%' OR name LIKE '%焦虑%' LIMIT 1);

-- 2.2 SAS 反向题修正 (关键词匹配)
-- 第5题: "我觉得一切都很好" / "心情愉快"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SAS%' OR name LIKE '%焦虑%' LIMIT 1)
  AND (content LIKE '%一切都很好%' OR content LIKE '%心情愉快%' OR content LIKE '%觉得比平常容易%');

-- 第9题: "我觉得平静,容易安静坐着"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SAS%' OR name LIKE '%焦虑%' LIMIT 1)
  AND (content LIKE '%平静%' OR content LIKE '%容易安静%');

-- 第13题: "我呼吸顺畅" / "容易吸气呼气"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SAS%' OR name LIKE '%焦虑%' LIMIT 1)
  AND (content LIKE '%呼吸顺畅%' OR content LIKE '%容易吸气%');

-- 第17题: "我手脚温暖"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SAS%' OR name LIKE '%焦虑%' LIMIT 1)
  AND content LIKE '%手脚温暖%';

-- 第19题: "我容易入睡并且一夜睡得很好"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SAS%' OR name LIKE '%焦虑%' LIMIT 1)
  AND (content LIKE '%容易入睡%' OR content LIKE '%睡得很好%');

-- ============================================================
-- 第三部分: SDS 抑郁自评量表修正 (1-4分制，含反向题)
-- 正向计分: 1=没有或很少时间, 2=小部分时间, 3=相当多时间, 4=绝大部分时间
-- 反向题: 第2,5,6,11,12,14,16,17,18,20题 (分值 4,3,2,1)
-- ============================================================

-- 3.1 SDS 正向题默认选项
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 1},
  {"label": "小部分时间", "score": 2},
  {"label": "相当多时间", "score": 3},
  {"label": "绝大部分时间", "score": 4}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1);

-- 3.2 SDS 反向题修正
-- 第2题: "我早上心情最好"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND content LIKE '%早上心情最好%';

-- 第5题: "我吃饭像平常一样多"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND content LIKE '%吃饭像平常%';

-- 第6题: "我的性功能正常" / "与异性接触时和以往一样"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND (content LIKE '%性功能正常%' OR content LIKE '%异性接触%' OR content LIKE '%和以往一样%');

-- 第11题: "我头脑跟平常一样清楚"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND content LIKE '%头脑跟平常一样%';

-- 第12题: "我做事像平时一样不感到困难"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND (content LIKE '%做事像平时%' OR content LIKE '%不感到困难%');

-- 第14题: "我对未来充满希望"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND content LIKE '%未来充满希望%';

-- 第16题: "我做决定没有困难"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND content LIKE '%做决定没有困难%';

-- 第17题: "我感到自己是有用的人"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND content LIKE '%自己是有用的%';

-- 第18题: "我的生活很有意义"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND content LIKE '%生活很有意义%';

-- 第20题: "我仍对以前喜欢的事情感兴趣"
UPDATE question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%SDS%' OR name LIKE '%抑郁%' LIMIT 1)
  AND (content LIKE '%仍对%感兴趣%' OR content LIKE '%喜欢的事情%');

-- ============================================================
-- 第四部分: PCL-R 量表修正 (0-2分制)
-- 标准计分: 0=不适用, 1=某种程度上适用, 2=完全适用
-- ============================================================

UPDATE question
SET options = '[
  {"label": "不适用(0分)", "score": 0},
  {"label": "某种程度上适用(1分)", "score": 1},
  {"label": "完全适用(2分)", "score": 2}
]'::jsonb
WHERE scale_id = (SELECT id FROM scale WHERE name LIKE '%PCL%' LIMIT 1);

-- ============================================================
-- 提交事务
-- ============================================================
COMMIT;

-- 验证更新结果
SELECT 
  s.name AS scale_name, 
  COUNT(q.id) AS question_count,
  q.options->>0 AS sample_option
FROM question q
JOIN scale s ON q.scale_id = s.id
WHERE s.name IN ('SCL-90', 'SAS', 'SDS', 'PCL-R', 'PCL-R精神变态检核表')
   OR s.name LIKE '%焦虑%' 
   OR s.name LIKE '%抑郁%'
GROUP BY s.name, q.options->>0
ORDER BY s.name;
