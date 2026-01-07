-- 最简修复脚本

-- 1. 更新角色（如果有数据的话）
UPDATE sys_user SET role = 'ROLE_CLIENT' WHERE role = 'PRISONER';
UPDATE sys_user SET role = 'ROLE_COUNSELOR' WHERE role = 'DOCTOR';

-- 2. 添加量表（只添加不存在的）
INSERT INTO psych_scale (name, description)
SELECT 'SCL-90', 'Symptom Checklist-90: Contains 90 items for comprehensive mental health assessment'
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SCL-90');

INSERT INTO psych_scale (name, description)
SELECT 'SDS', 'Self-Rating Depression Scale: 20-item scale for measuring depression severity'
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SDS');

INSERT INTO psych_scale (name, description)
SELECT 'SAS', 'Self-Rating Anxiety Scale: 20-item scale for measuring anxiety severity'
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'SAS');

INSERT INTO psych_scale (name, description)
SELECT 'PCL-R', 'Hare Psychopathy Checklist-Revised: 20-item scale for psychopathy assessment'
WHERE NOT EXISTS (SELECT 1 FROM psych_scale WHERE name = 'PCL-R');

-- 查看结果
SELECT '=== Repair Complete ===' AS message;
SELECT name, description FROM psych_scale;
