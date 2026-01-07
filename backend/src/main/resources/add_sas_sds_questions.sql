-- =====================================================
-- 补全 SAS 和 SDS 量表题目数据
-- =====================================================
-- 用途：为焦虑自评量表(SAS)和抑郁自评量表(SDS)添加测试题目
-- 每道题目包含维度标记，用于前端雷达图动态生成
-- =====================================================

-- ========== SAS (焦虑自评量表) ==========
-- 量表 ID: 3
-- 维度: 躯体性 (Somatic), 精神性 (Psychological)
DELETE FROM scale_question WHERE scale_id = 3;

INSERT INTO scale_question (scale_id, content, options) VALUES
(3, '维度:躯体性 我觉得比平常容易紧张和着急', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb),
(3, '维度:躯体性 我无缘无故地感到害怕', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb),
(3, '维度:精神性 我容易心里烦乱或觉得惊恐', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb),
(3, '维度:精神性 我觉得可能将要发疯', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb),
(3, '维度:躯体性 我觉得手脚发抖打颤', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb);

-- ========== SDS (抑郁自评量表) ==========
-- 量表 ID: 2
-- 维度: 核心抑郁 (Core), 生理机能 (Physiological)
DELETE FROM scale_question WHERE scale_id = 2;

INSERT INTO scale_question (scale_id, content, options) VALUES
(2, '维度:核心抑郁 我觉得闷闷不乐，情绪低沉', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb),
(2, '维度:核心抑郁 我觉得一天之中早晨最好', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb),
(2, '维度:生理机能 我吃饭象平时一样香', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb),
(2, '维度:生理机能 我睡眠不佳', '[{"label": "1分", "score": 1}, {"label": "2分", "score": 2}, {"label": "3分", "score": 3}, {"label": "4分", "score": 4}]'::jsonb);

-- =====================================================
-- 执行完成后，可通过以下 SQL 验证数据：
-- SELECT scale_id, content FROM scale_question WHERE scale_id IN (2, 3) ORDER BY scale_id, id;
-- =====================================================
