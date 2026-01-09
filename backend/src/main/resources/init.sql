-- 1. 用户表 (新增 password, real_name)
CREATE TABLE IF NOT EXISTS sys_user (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  real_name VARCHAR(255),
  password VARCHAR(255) NOT NULL, -- 存储 BCrypt 哈希
  role VARCHAR(32) NOT NULL,
  tags TEXT[], -- PostgreSQL 数组类型
  create_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT sys_user_role_chk CHECK (role IN ('ROLE_COUNSELOR','ROLE_CLIENT','COUNSELOR','CLIENT','DOCTOR','PRISONER'))
);

-- 2. 量表表 (新增配置字段)
CREATE TABLE IF NOT EXISTS psych_scale (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  type VARCHAR(20) DEFAULT 'SELF', -- SELF(自评) / OBSERVER(他评)
  is_enabled BOOLEAN DEFAULT TRUE,
  danger_threshold INT DEFAULT 6,
  max_score INT,
  create_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. 题目表 (新增 dimension)
CREATE TABLE IF NOT EXISTS scale_question (
  id SERIAL PRIMARY KEY,
  scale_id INT NOT NULL REFERENCES psych_scale(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  dimension VARCHAR(50), -- 维度分析的关键字段
  sort_order INT, -- 题目显示顺序
  options JSONB NOT NULL -- 选项定义 [{"label":"是","score":1}]
);

-- 4. 测评记录表
CREATE TABLE IF NOT EXISTS assess_record (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES sys_user(id) ON DELETE CASCADE,
  scale_id INT NOT NULL REFERENCES psych_scale(id) ON DELETE CASCADE,
  total_score INT NOT NULL,
  risk_level VARCHAR(32) NOT NULL,
  answers JSONB NOT NULL,
  dimension_analysis JSONB NOT NULL,
  is_teaching_case BOOLEAN DEFAULT FALSE,
  expert_annotation TEXT,
  status VARCHAR(32) DEFAULT 'PENDING',
  create_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. 通知表
CREATE TABLE IF NOT EXISTS notifications (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES sys_user(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content TEXT,
  type VARCHAR(32) DEFAULT 'INFO',
  related_url VARCHAR(512),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
