# Auditoría de Seguridad e Investigación de Incidentes con SQL

## Resumen Ejecutivo
La capacidad de consultar bases de datos de eventos y registros (*logs*) de forma precisa es una competencia crítica para un Analista de Ciberseguridad / SOC.  
En este proyecto se diseñaron y ejecutaron consultas SQL estructuradas sobre bases de datos de autenticación y gestión de activos para identificar intentos de inicio de sesión sospechosos, ataques de fuerza bruta y accesos no conformes a las políticas de seguridad corporativas.

## Escenario de Seguridad
La infraestructura de la organización almacena registros de acceso a redes, servicios de directorio y terminales en bases de datos relacionales. Tras una alerta preventiva del sistema de detección de intrusos (IDS), el equipo SOC requirió realizar un triaje para determinar:
1. Intentos de autenticación fallidos fuera del horario laboral estándar.
2. Direcciones IP externas con patrones consistentes con ataques de diccionario o fuerza bruta.
3. Equipos del área de finanzas que no cumplen con los requisitos de versión del sistema operativo.
4. Accesos a servidores críticos realizados por usuarios de áreas no autorizadas.

## Herramientas y Habilidades Técnicas
* **Motor:** SQL (compatible con PostgreSQL / MySQL / SQLite).
* **Cláusulas y Operadores:** `SELECT`, `WHERE`, `AND`, `OR`, `LIKE`, `NOT`, `ORDER BY`.
* **Agregaciones y Correlaciones:** `COUNT()`, `GROUP BY`, `HAVING`, `JOIN` entre tablas relacionales.
* **Marcos y Conceptos:** NIST CSF (Categoría Detección - DE.AE: Análisis de eventos anómalos), Principio de Menor Privilegio (PoLP).

## Análisis de Casos y Consultas

### Caso 1: Detección de Intentos Fallidos Post-Horario
Se filtraron todos los eventos registrados con posterioridad a las `18:00:00` cuyo estado fuera fallido (`failed`).
* **Hallazgo:** Se detectaron múltiples intentos continuos entre las 20:15 y las 21:00 hs provenientes de una misma subred externa, lo que indica un intento de intrusión fuera de supervisión operativa.

### Caso 2: Filtrado de Origen de Ataques (Agrupación y Umbral)
Mediante `GROUP BY ip_address` y la cláusula `HAVING COUNT(*) >= 3`, se aislaron las IPs que superaron el umbral de intentos fallidos permitidos.
* **Acción de mitigación sugerida:** Incorporar temporalmente estas direcciones IP al listado de bloqueo del firewall perimetral mediante el script de automatización (`update_allow_list.py`).

### Caso 3: Auditoría de Cumplimiento de Endpoints
Cruce de inventario para detectar estaciones de trabajo en Finanzas sin Windows 11 corporativo.
* **Hallazgo:** Se identificaron terminales obsoletas vulnerables a exploits conocidos, notificando al equipo de infraestructura para su parcheo inmediato.

## Conclusión e Impacto Operativo
* **Reducción de Tiempo de Triaje (MTTR):** Consultas indexadas y precisas reducen el tiempo necesario para aislar vectores de compromiso durante un incidente.
* **Trazabilidad:** Proporciona evidencia documental inalterable para auditorías internas y cumplimiento de normativas como ISO 27001.
