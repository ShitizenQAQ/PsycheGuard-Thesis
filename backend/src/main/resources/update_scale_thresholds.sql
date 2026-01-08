
-- ========================================================
-- 更新量表配置：设置医学标准的满分与警戒线
-- ========================================================

-- 1. PCL-R (精神病态): 20题 x 2分 = 40分。警戒线通常为 25-30，这里设为 20 (严格)
UPDATE psych_scale SET max_score = 40, danger_threshold = 20 WHERE name = 'PCL-R';

-- 2. PHQ-9 (抑郁筛查): 9题 x 3分 = 27分。 ≥10分 为中度抑郁(高风险)
UPDATE psych_scale SET max_score = 27, danger_threshold = 10 WHERE name = 'PHQ-9';

-- 3. GAD-7 (焦虑筛查): 7题 x 3分 = 21分。 ≥10分 为中度焦虑(高风险)
UPDATE psych_scale SET max_score = 21, danger_threshold = 10 WHERE name = 'GAD-7';

-- 4. SAS (焦虑自评): 20题 x 4分 = 80分。 标准分≥50 为焦虑
UPDATE psych_scale SET max_score = 80, danger_threshold = 50 WHERE name = 'SAS';

-- 5. SDS (抑郁自评): 20题 x 4分 = 80分。 标准分≥53 为抑郁
UPDATE psych_scale SET max_score = 80, danger_threshold = 53 WHERE name = 'SDS';

-- 6. SCL-90 (90项症状): 90题 x 5分 = 450分。 总分≥160 或 阳性项目数>43 为阳性
-- 这里简化为总分判断
UPDATE psych_scale SET max_score = 450, danger_threshold = 160 WHERE name = 'SCL-90';

-- 7. EPQ (人格): 满分不固定，通常看T分。这里暂设默认值
UPDATE psych_scale SET max_score = 100, danger_threshold = 60 WHERE name = 'EPQ';

-- 8. HAMD-17 (他评抑郁): 17项，满分约50-60。 ≥17分 为轻中度抑郁
UPDATE psych_scale SET max_score = 60, danger_threshold = 17 WHERE name = 'HAMD-17';

-- 9. HAMA (他评焦虑): 14项，满分56。 ≥14分 为肯定有焦虑
UPDATE psych_scale SET max_score = 56, danger_threshold = 14 WHERE name = 'HAMA';

-- 10. BPRS (精神病性): 18项 x 7分 = 126分。 ≥35分 为轻度精神病性症状
UPDATE psych_scale SET max_score = 126, danger_threshold = 35 WHERE name = 'BPRS';
