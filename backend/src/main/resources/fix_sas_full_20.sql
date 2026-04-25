-- ============================================================
-- SAS 焦虑自评量表补全脚本 (标准 20 题版)
-- fix_sas_full_20.sql
-- ============================================================

BEGIN;

-- 1. 获取 SAS 量表 ID
DO $$
DECLARE
    sas_id INT;
BEGIN
    SELECT id INTO sas_id FROM psych_scale WHERE name = 'SAS' LIMIT 1;
    
    IF sas_id IS NOT NULL THEN
        -- 清除旧的 SAS 题目
        DELETE FROM scale_question WHERE scale_id = sas_id;

        -- 插入标准 20 题
        INSERT INTO scale_question (scale_id, content, dimension, options, sort_order) VALUES
        (sas_id, '我觉得比平常容易紧张和着急', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 1),
        (sas_id, '我无缘无故地感到害怕', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 2),
        (sas_id, '我容易心里烦乱或觉得惊恐', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 3),
        (sas_id, '我觉得我可能将要发疯', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 4),
        (sas_id, '我觉得一切都很好，也不会发生什么不幸', '精神症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb, 5),
        (sas_id, '我手脚颤抖打颤', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 6),
        (sas_id, '我因为头痛、颈痛和背痛而苦恼', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 7),
        (sas_id, '我觉得容易衰弱和疲乏', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 8),
        (sas_id, '我觉得心平气和，并且容易安静坐着', '精神症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb, 9),
        (sas_id, '我觉得心跳很快', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 10),
        (sas_id, '我因为一阵阵头晕而苦恼', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 11),
        (sas_id, '我有晕倒发作或觉得要晕倒似的', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 12),
        (sas_id, '我呼气吸气都感到很容易', '躯体症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb, 13),
        (sas_id, '我手脚麻木和刺痛', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 14),
        (sas_id, '我因为胃痛和消化不良而苦恼', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 15),
        (sas_id, '我常常要小便', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 16),
        (sas_id, '我的手常常是干燥温暖的', '躯体症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb, 17),
        (sas_id, '我脸红发热', '躯体症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 18),
        (sas_id, '我容易入睡并且一夜睡得很好', '躯体症状', '[{"label": "没有或很少时间", "score": 4}, {"label": "小部分时间", "score": 3}, {"label": "相当多时间", "score": 2}, {"label": "绝大部分时间", "score": 1}]'::jsonb, 19),
        (sas_id, '我做噩梦', '精神症状', '[{"label": "没有或很少时间", "score": 1}, {"label": "小部分时间", "score": 2}, {"label": "相当多时间", "score": 3}, {"label": "绝大部分时间", "score": 4}]'::jsonb, 20);

        -- 更新量表元数据
        UPDATE psych_scale SET danger_threshold = 40, max_score = 80 WHERE id = sas_id;
    END IF;
END $$;

COMMIT;
