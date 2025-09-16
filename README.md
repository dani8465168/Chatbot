# Chatbot

Un chatbot para simular compras en la cadena Cinépolis que permite consultar cartelera, comprar boletos, dulcería y promociones, además de generar códigos QR para recuperar tus reservas.

---

## 🚀 Características
- Consulta de cartelera por fecha
- Compra de boletos con selección de asientos
- Generación de QR para las reservas
- Integración con MySQL
- Sistema de menús interactivos

---

## 📦 Requisitos
- Python 3.8+
- MySQL
- Librerías:
  - `mysql-connector-python`
  - `qrcode`
  - `pillow`
  - `re`

Instálalos con:
```bash
pip install mysql-connector-python qrcode pillow
```

## Ejecución
Para poder ejecutar el archivo chatBot.py
- Crea la base de datos con el archivo cinepolis.sql
- Crea las funciones ejecutando el scriptimport mysql.connector as mysqlconn
from datetime import datetime, date, timedelta, time
import qrcode
import json createFunciones.py
- Ejecuta el script chatBot.py
