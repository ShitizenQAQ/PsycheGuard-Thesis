-- 插入基础用户数据
INSERT INTO sys_user (username, role, tags) VALUES 
('doctor', 'ROLE_COUNSELOR', NULL),
('client1', 'ROLE_CLIENT', ARRAY['High Risk']),
('client2', 'ROLE_CLIENT', NULL);

-- 默认密码逻辑在后端处理，数据库暂不存储密码(或根据字段增加)
-- 之前看Entity没有password字段??? 
-- wait, checking SysUser.java again... 
-- Actually SysUser.java usually has password. Let me check the init.sql again.
