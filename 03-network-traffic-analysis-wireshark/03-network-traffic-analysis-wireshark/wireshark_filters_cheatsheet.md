# Guía Rápida de Filtros de Wireshark para Analistas SOC

| Objetivo de Análisis | Filtro de Visualización en Wireshark |
| :--- | :--- |
| **Escaneo TCP SYN** | `tcp.flags.syn == 1 and tcp.flags.ack == 0` |
| **Conexiones rechazadas (Reset)** | `tcp.flags.reset == 1` |
| **Tráfico HTTP sensible / Formularios** | `http.request.method == "POST"` |
| **Búsqueda de credenciales en tránsito** | `http contains "password" or http contains "user"` |
| **Filtrado por host específico** | `ip.addr == 192.168.1.105` |
| **Filtrar rango o subred completa** | `ip.src == 192.168.1.0/24` |
| **Tráfico DNS anómalo** | `dns.flags.response == 0 and !dns.qry.name contains "corp"` |
| **Broadcasts ARP excesivos (Storms)** | `arp.opcode == 1` |
| **Tráfico no cifrado en puertos estándar** | `tcp.port in {21, 23, 80}` |
