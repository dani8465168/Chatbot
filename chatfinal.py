import tkinter as tk
import time as tm
import re
import mysql.connector as mysqlconn
from datetime import datetime, date, timedelta, time
import qrcode
import json

from PIL import Image, ImageTk
import io


HOST="127.0.0.1"
USER="root"
PASSWORD=""
DATABASE="cinepolis"

# --- Expresiones regulares ---
consultar_boletos_RE = r"([cC]onsulta[r]* [bB]oleto[s]*|[cC]onsulta[r]* (mis|de) [bB]oleto[s]*)"
cartelera_RE = r"([Cc]artelera|[pP]el[ií]culas|[pP]el[ií]cula|estrenos)"
dulceria_RE = r"([dD]ulcer[ií]a|[pP]alomitas|[cC]ombos|[sS]nacks|[dD]ulces)"
boletos_RE = r"([bB]oleto|[bB]oletos|[eE]ntradas|[tT]ickets)"
promos_RE = r"([pP]romociones|descuentos|club|membres[ií]a)"
horarios_RE = r"([cC]onsulta[r]* [hH]orario[s]*|[cC]onsulta[r]* (mis|de) [bB]oleto[s]*|[hH]orario[s]*)"
salir_RE = r"[sS]alir|[aA]di[óo]s|[uU]ps|[eE]rror|[Nn]o"

fecha_RE = r"[0-9]{4}-[0-9]{2}-[0-9]{2}|hoy"
asiento_id_RE = r"([A-J][1-9]|[A-J]1[0-2])"
peliculas_RE = r"[0-9]+"

asientos_id_RE=r"([A-J][1-9],[ ]*|[A-J]1[0-2],[ ]*)*([A-J]1[0-2]|[A-J][1-9])"
reservas_id_RE=r"([1-9][0-9]*,)*[1-9][0-9]*"

# --- Chatbot ---
class CinepolisChatbot(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("🎬 Cinépolis Chatbot")
        self.geometry("600x600")
        self.configure(bg="#000000")

        # Conexión a BD
        self.conexion = mysqlconn.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DATABASE
        )
        self.cursor = self.conexion.cursor()

        # Estado y datos
        self.estado = "menu_principal"
        self.fecha_horario = date.today()
        self.pelicula_seleccionada = None
        self.peliculas_ids = []
        self.asientos_map = {}
        self.asientos_seleccionados = []

        # Área de chat
        self.chat_frame = tk.Frame(self, bg="#ffffff")
        self.chat_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        self.chat_text = tk.Text(
            self.chat_frame,
            wrap=tk.WORD,
            state="disabled",
            bg="#1d1d1d",
            fg="#000000",
            font=("Arial", 12)
        )
        self.chat_text.pack(fill=tk.BOTH, expand=True)

        # Entrada de usuario
        self.entry_frame = tk.Frame(self, bg="#001F54")
        self.entry_frame.pack(fill=tk.X, padx=10, pady=5)

        self.entry = tk.Entry(self.entry_frame, font=("Arial", 12))
        self.entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5)
        self.entry.bind("<Return>", self.enviar)

        self.send_btn = tk.Button(
            self.entry_frame,
            text="Enviar",
            command=self.enviar,
            bg="#FFD700",
            fg="black",
            font=("Arial", 12, "bold")
        )
        self.send_btn.pack(side=tk.RIGHT)

        # Mensaje inicial
        self.escribir_bot("👋 ¡Bienvenido a Cinépolis Chatbot!")
        self.mostrar_menu()

    # --- Mostrar mensajes ---
    def escribir_bot(self, texto):
        self.chat_text.config(state="normal")
        self.chat_text.insert(tk.END, f"🤖: {texto}\n", "bot")
        self.chat_text.tag_config("bot", foreground="#ffffff")
        self.chat_text.config(state="disabled")
        self.chat_text.see(tk.END)

    def escribir_usuario(self, texto):
        self.chat_text.config(state="normal")
        self.chat_text.insert(tk.END, f"🧑: {texto}\n", "user")
        self.chat_text.tag_config("user", foreground="gold")
        self.chat_text.config(state="disabled")
        self.chat_text.see(tk.END)

    def mostrar_menu(self):
        self.escribir_bot("Los servicios con los que te puedo ayudar son:\n\tCartelera 🎬\n\tDulcería 🍿\n\tBoletos 🎟\n\tPromociones 💳\n\tConsulta de boletos 🎟\n\tSalir 🚪")

    # --- Procesar entrada ---
    def enviar(self, event=None):
        mensaje = self.entry.get().strip()
        if not mensaje:
            return
        self.escribir_usuario(mensaje)
        self.entry.delete(0, tk.END)
        self.responder(mensaje)

    # --- Responder ---
    def responder(self, mensaje):
        if self.estado == "menu_principal":
            if re.findall(cartelera_RE, mensaje):
                self.mostrar_cartelera() ## Correcto
            elif re.findall(consultar_boletos_RE, mensaje):
                self.escribir_bot("Ingresa el ID de la reserva de tu boleto (ej: 186,213,...)")
                self.escribir_bot("Lo puedes encontrar escaneando el QR que se te dió cuando los reservaste")
                self.estado = "esperando_consulta_boletos"
            elif re.findall(boletos_RE, mensaje):
                self.escribir_bot("Vamos a comprar boletos. Escribe la fecha (yyyy-mm-dd o 'hoy'):")
                self.estado = "esperando_fecha_boletos"
            elif re.findall(dulceria_RE, mensaje):
                self.mostrar_dulceria()
            elif re.findall(promos_RE, mensaje):
                self.mostrar_promociones()
            elif re.findall(salir_RE, mensaje):
                self.escribir_bot("Gracias por visitarnos. ¡Hasta luego!")
                tm.sleep(1.5)
                self.destroy()
            else:
                self.escribir_bot("Lo siento, no entendí tu opción, regresando al menú\n")
                self.mostrar_menu()

        elif self.estado == "esperando_fecha_boletos":
            self.procesar_fecha_boletos(mensaje)
        elif self.estado == "esperando_fecha_horarios":
            self.procesar_fecha_horarios(mensaje)
        elif self.estado == "seleccion_funcion":
            self.seleccionar_funcion(mensaje)
        elif self.estado == "seleccion_asientos":
            self.seleccionar_asientos(mensaje)
        elif self.estado == "esperando_consulta_boletos":
            self.consultar_boletos_usuario(mensaje)

    # --- Funciones auxiliares ---
    def mostrar_cartelera(self):
        fecha_peliculas = date.today()
        query = f"""
            SELECT DISTINCT p.titulo
            FROM ent_funciones f
            JOIN cat_peliculas p ON f.pelicula_id = p.id
            WHERE f.fecha = '{fecha_peliculas}'
            ORDER BY p.id;
        """
        self.cursor.execute(query)
        resultados = self.cursor.fetchall()
        if resultados:
            self.escribir_bot("🎬 Cartelera de hoy:")
            for (titulo,) in resultados:
                self.escribir_bot(f"- {titulo}")
        else:
            self.escribir_bot("No hay funciones para el día de hoy, regresando al menú principal\n")
        self.mostrar_menu()

    def mostrar_dulceria(self):
        # Ejemplo de dulcería
        self.escribir_bot("🍿 Dulcería disponible: Palomitas, Chocolates, Galletas, Refrescos.\n")
        self.mostrar_menu()

    def mostrar_promociones(self):
        # Ejemplo de promociones
        self.escribir_bot("💳 Promociones: 2x1 en palomitas martes, 10% de descuento en entradas con membresía.")
        self.mostrar_menu()

    def consultar_boletos_usuario(self, mensaje):
        m = re.search(reservas_id_RE,mensaje)
        if m:
            r_ids = list(map(str,m.group().strip().split(",")))
            for r_id in r_ids:
                try:
                    query = f"""
                        SELECT f.fecha, f.hora, p.titulo, p.descripcion, a.fila, a.columna
                        FROM ent_reserva r
                        JOIN ent_funciones f ON f.id = r.funcion_id
                        JOIN cat_peliculas p ON f.pelicula_id = p.id
                        JOIN cat_asientos a ON a.id = r.asiento_id
                        WHERE r.id = '{r_id}';
                    """
                    print(query)
                    self.cursor.execute(query)
                    response = self.cursor.fetchone()
                    if response:
                        self.escribir_bot(f"{response[0]} {response[1]} {response[2]}\nAsiento: {response[4]}{response[5]}\nDescripción: {response[3]}")
                except Exception as e:
                    self.escribir_bot(f"El ID {r_id} ingresado no corresponde a una reserva válida: {e}")
        else:
            self.escribir_bot("El formato de los IDs no corresponde con el formato esperado, regresando al menú\n")
        self.estado = "menu_principal"
        self.mostrar_menu()

    def procesar_fecha_boletos(self, mensaje):
        m = re.search(fecha_RE, mensaje)
        if not m:
            self.escribir_bot("Formato de fecha no válido. Intenta de nuevo.")
            self.estado = "menu_principal"
            return

        self.fecha_horario = date.today() if m.group() == "hoy" else datetime.strptime(m.group(), "%Y-%m-%d").date()
        if (self.fecha_horario - date.today()).days < 0 or (self.fecha_horario - date.today()).days > 6:
            self.escribir_bot("Fecha fuera del rango permitido (hoy a 6 días).")
            self.estado = "menu_principal"
            return

        # Mostrar funciones disponibles
        query = f"""
            SELECT f.id, p.titulo, f.hora, p.duracion
            FROM ent_funciones f
            JOIN cat_peliculas p ON f.pelicula_id = p.id
            WHERE f.fecha = '{self.fecha_horario}'
        """

        self.cursor.execute(query)
        funciones = self.cursor.fetchall()
        self.peliculas_ids = []
        self.escribir_bot(f"Funciones para {self.fecha_horario}:")
        for (fid, titulo, hora, duracion) in funciones:
            self.escribir_bot(f"({fid}) {hora} {duracion} min  {titulo}")
            self.peliculas_ids.append(str(fid))
        self.escribir_bot("Escribe el ID de la función que quieres seleccionar:")
        self.estado = "seleccion_funcion"

    def procesar_fecha_horarios(self, mensaje):
        self.procesar_fecha_boletos(mensaje)

    def seleccionar_funcion(self, mensaje):
        m = re.search(peliculas_RE, mensaje)
        if not m or m.group() not in self.peliculas_ids:
            self.escribir_bot("ID de función no válido. Regresando al menú.\n")
            self.mostrar_menu()
            self.estado = "menu_principal"
            return

        self.pelicula_seleccionada = m.group()
        
        
        
        funcion_seleccionada=f"""
                                SELECT f.fecha, f.hora, p.duracion
                                FROM ent_funciones f
                                JOIN cat_peliculas p ON f.pelicula_id = p.id
                                WHERE f.id = '{self.pelicula_seleccionada}'
        """

        self.cursor.execute(funcion_seleccionada)
        f_s = self.cursor.fetchone()
        fecha = f_s[0]   # tipo date
        hora = f_s[1]    # tipo time

        print(f_s)

        # Si hora viene como timedelta, conviértelo a time
        if isinstance(hora, timedelta):
            segundos = hora.total_seconds()
            horas = int(segundos // 3600)
            minutos = int((segundos % 3600) // 60)
            segundos = int(segundos % 60)
            hora = time(horas, minutos, segundos)

        # Combinas fecha y hora en un datetime
        funcion_dt = datetime.combine(fecha, hora)

        # Ahora puedes restar
        diferencia = funcion_dt - datetime.now()

        if (diferencia.total_seconds() / 60) <= -int(f_s[2]):
            self.escribir_bot("La función ya ha terminado, no podemos asignarle asientos, regresando al menú principal\n")
            self.estado = "menu_principal"
            self.mostrar_menu()
            return
        elif (diferencia.total_seconds() / 60) <= -30:
            self.escribir_bot("La función ya va a la mitad o más, ya no podemos darle asientos, regresando al menú principal\n")
            self.estado = "menu_principal"
            self.mostrar_menu()
            return

        
        
        query = f"""
            SELECT a.id, a.fila, a.columna
            FROM cat_asientos a
            WHERE a.id NOT IN (
                SELECT asiento_id FROM ent_reserva WHERE funcion_id = {self.pelicula_seleccionada}
            )
            ORDER BY a.id
        """
        self.cursor.execute(query)
        asientos = self.cursor.fetchall()
        if not asientos:
            self.escribir_bot("No hay asientos disponibles para esta función.")
            self.estado = "menu_principal"
            return

        self.asientos_map = {f"{fila}{columna}":aid for (aid, fila, columna) in asientos}
        self.escribir_bot("Asientos disponibles:")
        for key in self.asientos_map:
            self.escribir_bot(key)
        self.escribir_bot("Ingresa los asientos que quieras reservar separados por coma (ej: A1,B2):")
        self.estado = "seleccion_asientos"

    def seleccionar_asientos(self, mensaje):
        m = re.search(asientos_id_RE,mensaje)

        if m:
            asientos_validos = list(map(str,m.group().strip().split(",")))
            print(asientos_validos)
            if not asientos_validos:
                self.escribir_bot(f"El o los asientos ya estás ocupados o no son válidos. Regresando al menú.")
                self.estado = "menu_principal"
                return

            self.asientos_seleccionados = [self.asientos_map[s] for s in asientos_validos]
            for asiento in self.asientos_seleccionados:
                try:
                    query = f"""
                        INSERT INTO ent_reserva (funcion_id, asiento_id)
                        VALUES ({self.pelicula_seleccionada}, {asiento})
                    """
                    self.cursor.execute(query)
                    self.escribir_bot(f"Asiento {asiento} reservado correctamente")
                except:
                    self.escribir_bot(f"El asiento {asiento} ya fue tomado. Ignorando...")
            self.conexion.commit()
            self.escribir_bot(f"Asientos reservados correctamente: {asientos_validos}")


            # Generar QR

            reservas = []
            for a_s in self.asientos_seleccionados:
                consulta_reservas = f"""
                                    SELECT id 
                                    FROM ent_reserva
                                    WHERE funcion_id = '{self.pelicula_seleccionada}' 
                                        and asiento_id = '{a_s}'
                                    """
                self.cursor.execute(consulta_reservas)
                reserva_id = self.cursor.fetchone()
                reservas.append(reserva_id[0])

            datos_reserva = {
                "reservas": reservas
            }
            contenido_qr = json.dumps(datos_reserva)
            qr = qrcode.QRCode(
                version=1,
                error_correction=qrcode.constants.ERROR_CORRECT_H,
                box_size=10,
                border=4,
            )
            qr.add_data(contenido_qr)
            qr.make(fit=True)
            imagen_qr = qr.make_image(fill_color="black", back_color="white")

            # Convertir a PhotoImage para Tkinter
            bio = io.BytesIO()
            imagen_qr.save(bio, format="PNG")
            bio.seek(0)
            tk_image = ImageTk.PhotoImage(Image.open(bio))

            # Mostrar en el chat
            self.chat_text.config(state="normal")
            self.chat_text.image_create(tk.END, image=tk_image)
            self.chat_text.insert(tk.END, "\n")
            self.chat_text.config(state="disabled")
            self.chat_text.see(tk.END)

            # Para evitar que la imagen se recolecte por el garbage collector
            self.qr_image = tk_image
            self.estado = "menu_principal"
            self.escribir_bot("Guarde el qr para poder acceder a la función\n")
            self.mostrar_menu()


# --- Ejecutar app ---
if __name__ == "__main__":
    app = CinepolisChatbot()
    app.mainloop()
