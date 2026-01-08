
-- ==========================================
-- 补录：自评量表 (Type = SELF)
-- ==========================================

-- SCL-90 (综合体检)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'SCL-90', '90项症状清单，世界上最著名的心理健康综合体检量表，涵盖思维、情感、行为、人际关系等10个维度。', 'SELF', TRUE, 160, 450
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SCL-90');

-- PHQ-9 (快速抑郁)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'PHQ-9', '病人健康问卷，国际通用的抑郁症快速筛查工具，常用于基层医疗机构。', 'SELF', TRUE, 10, 27
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'PHQ-9');

-- GAD-7 (快速焦虑)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'GAD-7', '广泛性焦虑量表，用于快速评估焦虑症状的严重程度。', 'SELF', TRUE, 10, 21
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'GAD-7');

-- EPQ (人格测试)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'EPQ', '艾森克人格问卷，用于评估内外向(E)、神经质(N)、精神质(P)及掩饰性(L)等人格特质。', 'SELF', TRUE, 60, 100
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'EPQ');


-- ==========================================
-- 补录：他评量表 (Type = OBSERVER)
-- ==========================================

-- HAMD-17 (抑郁金标准)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'HAMD-17', '汉密尔顿抑郁量表 (17项版)，临床评估抑郁状态的金标准，由经过培训的专业人员进行评定。', 'OBSERVER', TRUE, 17, 52
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'HAMD-17');

-- HAMA (焦虑金标准)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'HAMA', '汉密尔顿焦虑量表，精神科临床用于评估焦虑症状严重程度的首选工具。', 'OBSERVER', TRUE, 14, 56
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'HAMA');

-- BPRS (精神病性)
INSERT INTO psych_scale (name, description, type, is_enabled, danger_threshold, max_score) 
SELECT 'BPRS', '简明精神病评定量表，主要用于评定精神分裂症等重性精神病的症状变化。', 'OBSERVER', TRUE, 35, 126
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'BPRS');
