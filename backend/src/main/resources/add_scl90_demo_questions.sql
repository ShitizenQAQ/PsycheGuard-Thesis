-- SCL-90 精简演示版 (10题覆盖10个因子)
-- 假设 SCL-90 的 ID 是自动获取的 (这里先清理旧题目)
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
