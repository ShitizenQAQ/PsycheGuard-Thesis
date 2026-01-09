-- ============================================================
-- SAS 量表题目选项强制修复脚本
-- fix_sas_options_force.sql
-- 生成时间: 2026-01-09
-- 说明: 使用 UPDATE 强制覆盖修复所有 SAS 题目的选项分值逻辑
-- ============================================================

BEGIN;

-- ============================================================
-- 第一步: 定义正向计分选项 (1-4分制)
-- 适用于: 负面/焦虑症状题目 (如"紧张"、"害怕"、"疼痛")
-- ============================================================
UPDATE scale_question
SET options = '[
  {"label": "没有或很少时间", "score": 1},
  {"label": "小部分时间", "score": 2},
  {"label": "相当多时间", "score": 3},
  {"label": "绝大部分时间", "score": 4}
]'::jsonb
WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1);

-- ============================================================
-- 第二步: 修正反向计分题目 (4-1分制)
-- 适用于: 正面/健康状态题目 (如"睡得好"、"一切都很好"、"平静")
-- ============================================================

-- 反向题1: "我觉得一切都很好,也不会发生什么不幸"
UPDATE scale_question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1)
  AND content LIKE '%一切都很好%';

-- 反向题2: "我觉得心平气和,并且容易安静坐着"
UPDATE scale_question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1)
  AND content LIKE '%心平气和%';

-- 反向题3: "我呼气吸气都感到很容易"
UPDATE scale_question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1)
  AND content LIKE '%呼气吸气%';

-- 反向题4: "我的手常常是干燥温暖的"
UPDATE scale_question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1)
  AND content LIKE '%干燥温暖%';

-- 反向题5: "我容易入睡并且一夜睡得很好"
UPDATE scale_question
SET options = '[
  {"label": "没有或很少时间", "score": 4},
  {"label": "小部分时间", "score": 3},
  {"label": "相当多时间", "score": 2},
  {"label": "绝大部分时间", "score": 1}
]'::jsonb
WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'SAS' LIMIT 1)
  AND content LIKE '%容易入睡%';

COMMIT;

-- ============================================================
-- 验证结果
-- ============================================================
SELECT 
  sq.id,
  sq.content,
  sq.options->0->>'score' AS first_option_score,
  CASE 
    WHEN (sq.options->0->>'score')::int = 4 THEN '✓ 反向计分'
    WHEN (sq.options->0->>'score')::int = 1 THEN '✓ 正向计分'
    ELSE '❌ 异常'
  END AS scoring_type
FROM scale_question sq
JOIN psych_scale ps ON sq.scale_id = ps.id
WHERE ps.name = 'SAS'
ORDER BY sq.id;
