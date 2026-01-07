-- 序列修复脚本
SELECT setval('sys_user_id_seq', COALESCE((SELECT MAX(id) FROM sys_user), 0) + 1, false);
SELECT setval('psych_scale_id_seq', COALESCE((SELECT MAX(id) FROM psych_scale), 0) + 1, false);
SELECT setval('assess_record_id_seq', COALESCE((SELECT MAX(id) FROM assess_record), 0) + 1, false);
SELECT setval('scale_question_id_seq', COALESCE((SELECT MAX(id) FROM scale_question), 0) + 1, false);
