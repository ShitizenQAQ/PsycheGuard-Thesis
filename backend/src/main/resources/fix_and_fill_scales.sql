-- ============================================================
-- PsycheGuard 量表阈值修复与题目补全脚本
-- fix_and_fill_scales.sql
-- 生成时间: 2026-01-09
-- 说明: 修复 SAS/SDS 阈值逻辑，补全 PHQ-9 和 GAD-7 题目数据
-- ============================================================

BEGIN;

-- ============================================================
-- 1. 修复 SAS/SDS 阈值 (改为原始分判定)
-- 原因: 当前阈值是"标准分"，但系统统计的是"原始分"
-- ============================================================
UPDATE psych_scale SET danger_threshold = 40 WHERE name = 'SAS';
UPDATE psych_scale SET danger_threshold = 42 WHERE name = 'SDS';

-- 如果表名是 scale 而不是 psych_scale，也执行一遍
UPDATE scale SET danger_threshold = 40 WHERE name LIKE '%SAS%' OR name LIKE '%焦虑自评%';
UPDATE scale SET danger_threshold = 42 WHERE name LIKE '%SDS%' OR name LIKE '%抑郁自评%';

-- ============================================================
-- 2. 补全 PHQ-9 (抑郁症筛查量表) 题目 - 满分27
-- 选项: 0=完全不会, 1=好几天, 2=一半以上天数, 3=几乎每天
-- ============================================================

-- 清除旧数据（如果有）
DELETE FROM scale_question WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'PHQ-9');
DELETE FROM question WHERE scale_id = (SELECT id FROM scale WHERE name = 'PHQ-9');

-- 插入 PHQ-9 题目 (兼容 question 表)
INSERT INTO question (scale_id, content, dimension, options)
SELECT id, content, dimension, options::jsonb
FROM (
  SELECT 
    (SELECT id FROM scale WHERE name = 'PHQ-9' LIMIT 1) AS id,
    unnest(ARRAY[
      '做事提不起劲或没有兴趣',
      '感到心情低落、沮丧或绝望',
      '入睡困难、睡不安稳或睡眠过多',
      '感觉疲倦或没有活力',
      '食欲不振或吃太多',
      '觉得自己很糟或觉得自己很失败，或让自己、家人失望',
      '对事物专注有困难，例如阅读报纸或看电视时',
      '动作或说话速度缓慢到别人已经察觉? 或烦躁不安、坐立难安',
      '有不如死掉或用某种方式伤害自己的念头'
    ]) AS content,
    '抑郁症状' AS dimension,
    '[{"label": "完全不会", "score": 0}, {"label": "好几天", "score": 1}, {"label": "一半以上天数", "score": 2}, {"label": "几乎每天", "score": 3}]' AS options
) AS phq9_data
WHERE id IS NOT NULL;

-- ============================================================
-- 3. 补全 GAD-7 (焦虑症筛查量表) 题目 - 满分21
-- 选项: 0=完全不会, 1=好几天, 2=一半以上天数, 3=几乎每天
-- ============================================================

-- 清除旧数据（如果有）
DELETE FROM scale_question WHERE scale_id = (SELECT id FROM psych_scale WHERE name = 'GAD-7');
DELETE FROM question WHERE scale_id = (SELECT id FROM scale WHERE name = 'GAD-7');

-- 插入 GAD-7 题目 (兼容 question 表)
INSERT INTO question (scale_id, content, dimension, options)
SELECT id, content, dimension, options::jsonb
FROM (
  SELECT 
    (SELECT id FROM scale WHERE name = 'GAD-7' LIMIT 1) AS id,
    unnest(ARRAY[
      '感觉紧张、焦虑或急切',
      '不能停止或无法控制担忧',
      '对各种各样的事情担忧过多',
      '很难放松下来',
      '由于坐立不安而无法静坐',
      '变得容易烦恼或急躁',
      '感到似乎将有可怕的事情发生而害怕'
    ]) AS content,
    '焦虑症状' AS dimension,
    '[{"label": "完全不会", "score": 0}, {"label": "好几天", "score": 1}, {"label": "一半以上天数", "score": 2}, {"label": "几乎每天", "score": 3}]' AS options
) AS gad7_data
WHERE id IS NOT NULL;

COMMIT;

-- ============================================================
-- 验证结果
-- ============================================================
SELECT name, danger_threshold FROM scale WHERE name IN ('SAS', 'SDS', 'PHQ-9', 'GAD-7');
SELECT s.name, COUNT(q.id) AS question_count 
FROM scale s 
LEFT JOIN question q ON q.scale_id = s.id 
WHERE s.name IN ('PHQ-9', 'GAD-7')
GROUP BY s.name;
