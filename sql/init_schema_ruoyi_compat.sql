-- ----------------------------
-- One-shot init schema for Snow (Ruoyi base + business tables)
-- Usage:
--   1) Run this file in an empty database/schema
--   2) Then start backend and initialize data as needed
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================
-- Part 1: Ruoyi base tables/data
-- ============================
-- This entrypoint uses `SOURCE` so you can initialize in one run.
-- Run with MySQL client, for example:
--   mysql -u root -p your_db < init_schema_ruoyi_compat.sql
--
-- If your executor doesn't support SOURCE, run the 3 files in order:
--   1) ry_20250417.sql
--   2) business_schema_ruoyi_style.sql
--   3) the ALTER TABLE statements below

SOURCE ry_20250417.sql;

-- ============================
-- Part 2: Business tables
-- ============================
SOURCE business_schema_ruoyi_style.sql;

-- ============================
-- Part 3: Compatibility patches
-- ============================
-- Make App registration unique by phone number.
-- Note: Ruoyi base data already includes some sample phones; ensure no duplicates before applying in a non-empty DB.
ALTER TABLE sys_user
  ADD UNIQUE KEY uk_sys_user_phonenumber (phonenumber);

SET FOREIGN_KEY_CHECKS = 1;

