import mysql.connector as mysqlconn
from datetime import date, timedelta

HOST="127.0.0.1"
USER="root"
PASSWORD=""
DATABASE="cinepolis"

def nextIndex(begin,n):
    lim=begin
    while lim <= n:
        yield lim
        lim += 1
        if lim >= n:
            lim = 0

if __name__ == "__main__":

    hours=["11:00","14:00","17:00","20:00"]
    try:
        conexion=mysqlconn.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DATABASE
        )

        cursor = conexion.cursor()

        queryPeliculasId="SELECT id FROM cat_peliculas"
        querySalasId="SELECT id FROM cat_salas"
        queryLastDay="SELECT fecha,pelicula_id,sala_id FROM ent_funciones ORDER BY id DESC LIMIT 1"

        cursor.execute(queryPeliculasId)
        peliculasId=[i[0] for i in cursor.fetchall()]

        cursor.execute(querySalasId)
        salasId=[i[0] for i in cursor.fetchall()]

        cursor.execute(queryLastDay)
        lastDay = cursor.fetchall()

        
        today=date.today()

        print(peliculasId)
        print(salasId)
        print("Last Day: " + str(lastDay))
        for (fecha,pelicula_id,sala_id,) in lastDay:
            actual=(fecha-today).days

            actual = 0 if actual < 0 else actual + 1
            print(actual)
            peliculaIt=nextIndex(peliculasId.index(pelicula_id),len(peliculasId))

            for i in range(actual,7):
                for hour in hours:
                    for salaId in salasId:
                        functionInsert=f"INSERT INTO ent_funciones (fecha,hora,sala_id,pelicula_id) VALUES (%s,%s,%s,%s)"
                        pid=peliculasId[next(peliculaIt)] 
                        valores = (
                            (today + timedelta(days=i)).strftime("%Y-%m-%d"),  # fecha formateada
                            hour,                                              # hora como string
                            salaId,                                            # id de sala
                            pid                                 # id de película
                        )

                        cursor.execute(functionInsert,valores)
                        print(f"({today+timedelta(days=i)},{hour},{salaId},{pid})")
            conexion.commit()

        print("Connection successfully granted")
    except Exception as e:
        print(e)