-- 文创管理菜单（父菜单: 2007）
-- 执行前请确认 2007 菜单存在

SET @menu_root_id := (
  SELECT menu_id
  FROM snow.sys_menu
  WHERE parent_id = 2007
    AND menu_type = 'C'
    AND perms = 'business:culturalCreative:list'
  LIMIT 1
);

SET @next_menu_id := (SELECT IFNULL(MAX(menu_id), 2000) + 1 FROM snow.sys_menu);

INSERT INTO snow.sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
)
SELECT
  @next_menu_id, '文创管理', 2007, 3, 'culturalCreative', 'business/culturalCreative/index', '', '', 1, 0,
  'C', '0', '0', 'business:culturalCreative:list', 'guide', 'admin', NOW(), '', NULL, '文创管理菜单'
FROM dual
WHERE @menu_root_id IS NULL;

SET @menu_root_id := (
  SELECT menu_id
  FROM snow.sys_menu
  WHERE parent_id = 2007
    AND menu_type = 'C'
    AND perms = 'business:culturalCreative:list'
  LIMIT 1
);

INSERT INTO snow.sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
)
SELECT
  @menu_root_id + 1, '文创查询', @menu_root_id, 1, '', '', '', '', 1, 0,
  'F', '0', '0', 'business:culturalCreative:query', '#', 'admin', NOW(), '', NULL, ''
FROM dual
WHERE @menu_root_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM snow.sys_menu
    WHERE parent_id = @menu_root_id
      AND perms = 'business:culturalCreative:query'
  );

INSERT INTO snow.sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
)
SELECT
  @menu_root_id + 2, '文创新增', @menu_root_id, 2, '', '', '', '', 1, 0,
  'F', '0', '0', 'business:culturalCreative:add', '#', 'admin', NOW(), '', NULL, ''
FROM dual
WHERE @menu_root_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM snow.sys_menu
    WHERE parent_id = @menu_root_id
      AND perms = 'business:culturalCreative:add'
  );

INSERT INTO snow.sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
)
SELECT
  @menu_root_id + 3, '文创修改', @menu_root_id, 3, '', '', '', '', 1, 0,
  'F', '0', '0', 'business:culturalCreative:edit', '#', 'admin', NOW(), '', NULL, ''
FROM dual
WHERE @menu_root_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM snow.sys_menu
    WHERE parent_id = @menu_root_id
      AND perms = 'business:culturalCreative:edit'
  );

INSERT INTO snow.sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
)
SELECT
  @menu_root_id + 4, '文创删除', @menu_root_id, 4, '', '', '', '', 1, 0,
  'F', '0', '0', 'business:culturalCreative:remove', '#', 'admin', NOW(), '', NULL, ''
FROM dual
WHERE @menu_root_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM snow.sys_menu
    WHERE parent_id = @menu_root_id
      AND perms = 'business:culturalCreative:remove'
  );

INSERT INTO snow.sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache,
  menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
)
SELECT
  @menu_root_id + 5, '文创导出', @menu_root_id, 5, '', '', '', '', 1, 0,
  'F', '0', '0', 'business:culturalCreative:export', '#', 'admin', NOW(), '', NULL, ''
FROM dual
WHERE @menu_root_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM snow.sys_menu
    WHERE parent_id = @menu_root_id
      AND perms = 'business:culturalCreative:export'
  );
