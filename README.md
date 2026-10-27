# Automatización de Revocación de Accesos de Red con Python

## Resumen Ejecutivo.
En entornos corporativos y operaciones de seguridad (SOC), la gestión manual de listas de control de acceso (ACL) representa un riesgo operativo crítico y una superficie de ataque latente debido a desvinculaciones o compromisos de endpoints.  
Este proyecto implementa un script en Python que automatiza la lectura, comparación, depuración y actualización de un archivo de direcciones IP permitidas (`allow_list.txt`), aplicando el principio de mínimo privilegio de manera confiable.

## Escenario de Seguridad
La organización maneja una lista de direcciones IP autorizadas que tienen acceso a servidores internos y recursos restringidos. Al detectarse direcciones IP sospechosas o credenciales en desuso, el equipo de seguridad genera una lista de revocación (`remove_list`).  
El objetivo es automatizar la exclusión de estas direcciones del archivo productivo garantizando la integridad de los datos.

## Herramientas y Conceptos Aplicados
* **Lenguaje:** Python 3.x
* **Conceptos:** Manejo seguro de archivos (`with open`), manipulación de cadenas y listas (`.read()`, `.split()`, `.remove()`, `.join()`), estructuras de control condicional y bucles.
* **Marcos y Principios:** NIST CSF (Categoría Proteger / Control de Accesos - PR.AC), Tríada CID (Integridad y Confidencialidad).

## Metodología Paso a Paso

1. **Lectura segura del archivo de acceso:**  
   Se utiliza la declaración `with` para asegurar el cierre automático del archivo tras la lectura, previniendo bloqueos de recursos o fugas de descriptores de archivo.
   
2. **Normalización de datos:**  
   El contenido del archivo se transforma en una lista estructurada mediante `.split()`, permitiendo iterar y buscar elementos de manera eficiente.

3. **Verificación y remoción controlada:**  
   Se implementa una verificación con `if ip in ips_permitidas` antes de invocar `.remove()`, evitando excepciones en tiempo de ejecución (`ValueError`) en caso de que una IP ya no figure en el archivo.

4. **Escritura y persistencia:**  
   Los datos depurados se unen con caracteres de nueva línea (`\n`) y se sobreescriben en el archivo original con modo `"w"`.

## Ejemplo de Ejecución

```bash
$ python3 update_allow_list.py
[+] Proceso completado exitosamente.
[i] IPs revocadas (3): 192.168.1.105, 10.0.0.45, 172.16.0.99
[i] Total de IPs vigentes: 4
