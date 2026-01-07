-- =====================================================
-- PsycheGuard 数据库修复脚本
-- 用途: 1. 修复历史角色数据 (PRISONER->CLIENT, DOCTOR->COUNSELOR)
--       2. 重置 admin 密码
--       3. 补全丢失的量表数据
-- 创建时间: 2026-01-07
-- =====================================================

-- 开始事务
BEGIN;

-- =====================================================
-- 第一部分：修复历史数据（角色迁移）
-- =====================================================

-- 1.1 更新旧角色名称到新角色名称
UPDATE sys_user 
SET role = 'ROLE_CLIENT' 
WHERE role = 'PRISONER';

UPDATE sys_user 
SET role = 'ROLE_COUNSELOR' 
WHERE role = 'DOCTOR';

-- 1.2 重置 admin 用户密码为 123456（如果存在的话）
UPDATE sys_user 
SET password = '123456' 
WHERE username = 'admin';

-- 1.3 如果 admin 不存在，则创建一个（可选，根据需要取消注释）
-- INSERT INTO sys_user (username, real_name, password, role, tags)
-- VALUES ('admin', '系统管理员', '123456', 'ROLE_COUNSELOR', NULL)
-- ON CONFLICT (username) DO NOTHING;

-- 显示修复结果
SELECT '角色迁移完成 ✓' AS status, COUNT(*) AS updated_count 
FROM sys_user 
WHERE role IN ('ROLE_CLIENT', 'ROLE_COUNSELOR');


-- =====================================================
-- 第二部分：补全丢失的量表数据
-- =====================================================

-- 2.1 插入 SCL-90 量表（90项症状清单）
INSERT INTO psych_scale (name, description, create_time)
VALUES (
    'SCL-90', 
    '症状自评量表 (Symptom Checklist-90)：含90个项目，从感觉、情感、思维、意识、行为、生活习惯、人际关系、饮食睡眠等十个方面分析心理健康状况。广泛应用于心理健康普查和临床诊断。',
    NOW()
)
ON CONFLICT (name) DO NOTHING;

-- 2.2 插入 SDS 量表（抑郁自评量表）
INSERT INTO psych_scale (name, description, create_time)
VALUES (
    'SDS', 
    '抑郁自评量表 (Self-Rating Depression Scale)：由20个项目组成，用于衡量抑郁状态的轻重程度及其在治疗过程中的变化。适用于具有抑郁症状的成年人，简便易行。',
    NOW()
)
ON CONFLICT (name) DO NOTHING;

-- 2.3 插入 SAS 量表（焦虑自评量表）
INSERT INTO psych_scale (name, description, create_time)
VALUES (
    'SAS', 
    '焦虑自评量表 (Self-Rating Anxiety Scale)：由20个项目组成，用于评定焦虑症状的轻重程度及其在治疗过程中的变化。适用于具有焦虑症状的成年人。',
    NOW()
)
ON CONFLICT (name) DO NOTHING;

-- 2.4 确保 PCL-R 量表存在（如果之前数据被清空了）
INSERT INTO psych_scale (name, description, create_time)
VALUES (
    'PCL-R', 
    '精神病态评估量表 (Hare Psychopathy Checklist-Revised)：由20个项目组成，用于评估反社会人格障碍特征。广泛用于司法和临床领域。',
    NOW()
)
ON CONFLICT (name) DO NOTHING;

-- 显示量表数据
SELECT '量表数据修复完成 ✓' AS status, COUNT(*) AS total_scales 
FROM psych_scale;

-- =====================================================
-- 提交事务
-- =====================================================
COMMIT;

-- 显示最终统计信息
SELECT '=== 修复完成 ===' AS message;
SELECT 'sys_user 用户总数' AS item, COUNT(*) AS count FROM sys_user
UNION ALL
SELECT 'CLIENT 来访者数量' AS item, COUNT(*) AS count FROM sys_user WHERE role = 'ROLE_CLIENT'
UNION ALL
SELECT 'COUNSELOR 咨询师数量' AS item, COUNT(*) AS count FROM sys_user WHERE role = 'ROLE_COUNSELOR'
UNION ALL
SELECT 'psych_scale 量表总数' AS item, COUNT(*) AS count FROM psych_scale;
