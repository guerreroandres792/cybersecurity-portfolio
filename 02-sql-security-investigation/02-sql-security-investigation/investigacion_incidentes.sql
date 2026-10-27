-- =============================================================================
-- Proyecto: Auditoría de Accesos e Investigación de Incidentes con SQL
-- Analista: Luis Andrés Guerrero
-- Rol objetivo: Analista de Ciberseguridad Junior / SOC Tier 1
-- Descripción:
--   Consultas SQL diseñadas para auditar registros de autenticación (logins),
--   detectar accesos anómalos fuera de horario laboral e identificar
--   dispositivos sospechosos o intentos de inicio de sesión no autorizados.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- ESCENARIO 1: Intentos de inicio de sesión fallidos fuera del horario laboral
-- Objetivo: Identificar actividad posterior a las 18:00 hs con fallo de credenciales
-- -----------------------------------------------------------------------------
SELECT 
    login_time,
    username,
    ip_address,
    status
FROM log_in_attempts
WHERE login_time > '18:00:00' 
  AND status = 'failed'
ORDER BY login_time DESC;


-- -----------------------------------------------------------------------------
-- ESCENARIO 2: Identificación de IPs con múltiples intentos fallidos (Fuerza Bruta)
-- Objetivo: Agrupar por dirección IP para detectar patrones de ataque sistemático
-- -----------------------------------------------------------------------------
SELECT 
    ip_address,
    COUNT(*) AS total_fallos
FROM log_in_attempts
WHERE status = 'failed'
GROUP BY ip_address
HAVING COUNT(*) >= 3
ORDER BY total_fallos DESC;


-- -----------------------------------------------------------------------------
-- ESCENARIO 3: Auditoría de máquinas y endpoints por sistema operativo y departamento
-- Objetivo: Filtrar equipos de un departamento crítico (ej. Finanzas o IT)
--           que no cuenten con las actualizaciones o SO autorizados.
-- -----------------------------------------------------------------------------
SELECT 
    device_id,
    operating_system,
    department,
    ip_address
FROM employees_devices
WHERE department = 'Finance' 
  AND operating_system NOT LIKE 'Windows 11%';


-- -----------------------------------------------------------------------------
-- ESCENARIO 4: Correlación de accesos no autorizados a servidores confidenciales
-- Objetivo: Cruzar registros de autenticación con la nómina para verificar si
--           personal de soporte o externo intentó ingresar a servidores de base de datos
-- -----------------------------------------------------------------------------
SELECT 
    e.employee_id,
    e.username,
    e.department,
    l.login_time,
    l.server_accessed,
    l.status
FROM log_in_attempts l
JOIN employees e ON l.username = e.username
WHERE l.server_accessed = 'DB_PROD_FINANCE'
  AND e.department != 'Finance';
