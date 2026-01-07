-- 简化修复脚本：只修复角色并添加量表

BEGIN;

-- 1. 更新角色（如果有旧数据）
UPDATE sys_user SET role = 'ROLE_CLIENT' WHERE role = 'PRISONER';
UPDATE sys_user SET role = 'ROLE_COUNSELOR' WHERE role = 'DOCTOR';

-- 2. 添加量表数据
INSERT INTO psych_scale (name, description)
VALUES ('SCL-90', 'Symptom Checklist-90')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO psych_scale (name, description)
VALUES ('SDS', 'Self-Rating Depression Scale')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO psych_scale (name, description)
VALUES ('SAS', 'Self-Rating Anxiety Scale')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

INSERT INTO psych_scale (name, description)
VALUES ('PCL-R', 'Hare Psychopathy Checklist-Revised')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;

COMMIT;

-- 查看结果
SELECT 'Scales:' AS info, COUNT(*) FROM psych_scale;
