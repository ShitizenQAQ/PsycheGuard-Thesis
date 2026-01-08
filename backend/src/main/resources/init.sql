CREATE TABLE IF NOT EXISTS sys_user (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  role VARCHAR(32) NOT NULL,
  tags TEXT[],
  CONSTRAINT sys_user_role_chk CHECK (role IN ('COUNSELOR','CLIENT','DOCTOR','PRISONER'))
);

CREATE TABLE IF NOT EXISTS psych_scale (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  type VARCHAR(20) DEFAULT 'SELF'
);

CREATE TABLE IF NOT EXISTS scale_question (
  id SERIAL PRIMARY KEY,
  scale_id INT NOT NULL REFERENCES psych_scale(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  options JSONB NOT NULL
);

CREATE TABLE IF NOT EXISTS assess_record (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES sys_user(id) ON DELETE CASCADE,
  scale_id INT NOT NULL REFERENCES psych_scale(id) ON DELETE CASCADE,
  total_score INT NOT NULL,
  risk_level VARCHAR(32) NOT NULL,
  answers JSONB NOT NULL,
  dimension_analysis JSONB NOT NULL
);
