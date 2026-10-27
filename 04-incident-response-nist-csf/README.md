# Gestión y Respuesta a Incidentes bajo el Marco NIST CSF

## Resumen Ejecutivo
La respuesta estructurada a incidentes garantiza que una intrusión o compromiso de seguridad sea detectado, contenido y remediado minimizando el impacto operativo en el negocio.  
Este proyecto presenta la documentación formal de un incidente de seguridad (infección por malware a través de phishing dirigido en un endpoint corporativo), estructurado bajo las cinco funciones del marco del **NIST Cybersecurity Framework (CSF)**: *Identificar, Proteger, Detectar, Responder y Recuperar*, complementado con la fase de *Lecciones Aprendidas*.

---

## Ficha del Incidente
* **ID de Ticket / Incidente:** INC-2026-1024
* **Severidad:** Media-Alta (Nivel 2)
* **Fecha y Hora de Detección:** 24 de Octubre de 2026 - 10:15 UTC-3
* **Vector de Infección:** Correo electrónico de phishing con archivo adjunto comprimido (`factura_vencida.zip`)
* **Activo Afectado:** Estación de trabajo `WS-FIN-04` (Área Contable)
* **Analista a Cargo:** Luis Andrés Guerrero

---

## Ciclo de Vida del Incidente (Alineación NIST CSF)

### 1. Identificar (Identify)
* **Activos Críticos:** Estación de trabajo conectada a la red corporativa interna con acceso a registros contables y facturación.
* **Evaluación de Riesgo:** Riesgo inminente de movimiento lateral hacia el servidor de base de datos (`DB_PROD_FINANCE`) y potencial compromiso de credenciales.

### 2. Proteger (Protect)
* **Medidas Existentes:** Antivirus perimetral, políticas de menor privilegio (usuario local sin permisos de Administrador de Dominio) y segmentación básica de subred.
* **Brecha Identificada:** La inspección de adjuntos del servidor de correo no bloqueó archivos comprimidos con macros y el usuario carecía de autenticación de dos factores (2FA) en la sesión del equipo.

### 3. Detectar (Detect)
* **Detección Inicial:** Alerta del agente EDR reportando la ejecución anómala de `powershell.exe` invocando conexiones salientes hacia una dirección IP externa no categorizada (`203.0.113.55`).
* **Análisis de Artefactos:** 
  * Extracción del hash SHA-256 del binario ejecutado:  
    `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`
  * Verificación en VirusTotal: Identificado como troyano descargador (*dropper*) con 48/72 detecciones en motores de seguridad.

### 4. Responder (Respond)
* **Contención Inmediata:**
  * **Aislamiento de Red:** Desconexión física e inhabilitación remota del adaptador de red del equipo `WS-FIN-04` para evitar propagación lateral.
  * **Bloqueo en Firewall:** Incorporación de la IP externa atacante a la lista de denegación perimetral.
  * **Revocación de Accesos:** Inhabilitación preventiva de la cuenta de usuario en Active Directory y cierre forzado de sesiones activas.
* **Erradicación:**
  * Extracción del archivo malicioso y eliminación de claves de persistencia en el Registro de Windows (`HKCU\Software\Microsoft\Windows\CurrentVersion\Run`).
  * Análisis forense de memoria para confirmar la ausencia de procesos residuales.

### 5. Recuperar (Recover)
* **Restauración:**
  * Reinstalación limpia de la imagen corporativa segura y aplicación de los últimos parches de seguridad de Windows.
  * Restauración de archivos de trabajo desde la copia de respaldo segura más reciente (comprobada libre de infección).
  * Monitoreo reforzado de tráfico de red en el endpoint durante las 72 horas posteriores a la reconexión.

---

## Lecciones Aprendidas y Mejoras Post-Incidente

1. **Ajuste en Filtros de Correo:** Configurar el gateway de correo corporativo para bloquear extensiones ejecutables dentro de archivos `.zip` y someter enlaces a análisis en sandbox previo a la entrega.
2. **Capacitación y Concientización:** Programar talleres de simulación de phishing enfocados en personal con acceso a datos financieros críticos.
3. **Control de Ejecución de Políticas (AppLocker):** Restringir la ejecución no supervisada de PowerShell y scripts en terminales de usuarios estándar.
