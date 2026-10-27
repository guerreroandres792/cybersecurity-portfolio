# Inspección de Tráfico de Red y Triaje de Paquetes con Wireshark

## Resumen Ejecutivo
El análisis del tráfico de red a nivel de paquetes es esencial para detectar anomalías, validar alertas emitidas por sistemas NIDS/SIEM y contener vectores de ataque en etapas tempranas.  
Este proyecto documenta la investigación forense de un archivo de captura de red (`.pcap`), aplicando filtros de visualización avanzados en Wireshark, reconstrucción de flujos TCP y análisis de protocolos para identificar un escaneo de puertos malicioso y la transmisión de credenciales sin cifrar.

## Escenario del Incidente
El equipo SOC recibió una alerta de comportamiento anómalo en el segmento de red interna `192.168.1.0/24`. Se requirió que el analista examinara la captura de tráfico para responder las siguientes preguntas clave:
1. ¿Qué dirección IP externa o interna inició el escaneo y qué técnica utilizó?
2. ¿Qué puertos y servicios del host destino fueron identificados como vulnerables o expuestos?
3. ¿Hubo transmisión de información sensible o credenciales en texto plano (sin cifrar)?
4. ¿Cuáles son las medidas de contención inmediatas recomendadas?

## Herramientas y Protocolos Analizados
* **Herramienta:** Wireshark, Tcpdump.
* **Protocolos:** Suite TCP/IP, ARP, DNS, HTTP, TCP (Flags SYN, ACK, RST), ICMP.
* **Conceptos:** Handshake de 3 vías, escaneo TCP SYN (Half-open), seguimiento de flujos TCP (*Follow TCP Stream*), modelo OSI / Tríada CID.

## Metodología de Investigación y Filtros Aplicados

### 1. Identificación del Escaneo de Red (Reconocimiento)
Se analizó la presencia de múltiples paquetes TCP con la bandera SYN activa dirigidos a puertos secuenciales en un corto período de tiempo.

* **Filtro de visualización aplicado:**
  ```text
  tcp.flags.syn == 1 and tcp.flags.ack == 0
