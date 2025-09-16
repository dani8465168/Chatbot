DROP DATABASE IF EXISTS cinepolis;
CREATE DATABASE cinepolis;
USE cinepolis;

DROP TABLE IF EXISTS cat_salas;
DROP TABLE IF EXISTS cat_horarios;
DROP TABLE IF EXISTS cat_peliculas;
DROP TABLE IF EXISTS ent_asientos;
DROP TABLE IF EXISTS ent_funciones;

CREATE TABLE cat_salas(
    id INT(3) AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(3) NOT NULL
);

CREATE TABLE cat_peliculas(
    id INT(12) AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    duracion INT(4) NOT NULL,
    descripcion VARCHAR(1024) NOT NULL,
    rate VARCHAR(5) NOT NULL,
    url_imagen VARCHAR(250) NOT NULL
);

CREATE TABLE cat_asientos(
    id INT(3) AUTO_INCREMENT PRIMARY KEY,
    fila VARCHAR(2) NOT NULL,
    columna VARCHAR(3) NOT NULL,
    UNIQUE (fila,columna)
);

CREATE TABLE ent_funciones(
    id INT(15) AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    sala_id INT(3) NOT NULL,
    pelicula_id INT(12) NOT NULL,
    FOREIGN KEY (sala_id) REFERENCES cat_salas(id) ON DELETE CASCADE,
    FOREIGN KEY (pelicula_id) REFERENCES cat_peliculas(id) ON DELETE CASCADE,
    UNIQUE (fecha,hora,sala_id)
);

CREATE TABLE ent_reserva(
    id INT(15) AUTO_INCREMENT PRIMARY KEY,
    funcion_id INT(15) NOT NULL,
    asiento_id INT(3) NOT NULL,
    FOREIGN KEY (funcion_id) REFERENCES ent_funciones(id) ON DELETE CASCADE,
    FOREIGN KEY (asiento_id) REFERENCES cat_asientos(id) ON DELETE CASCADE,
    UNIQUE(funcion_id,asiento_id)
);



---- Movies table

INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('War of the Worlds','91','Will Radford is a top analyst for Homeland Security who tracks potential threats through a mass surveillance program, until one day an attack by an unknown entity leads him to question whether the government is hiding something from him... and from the rest of the world.','4.3','/yvirUYrva23IudARHn3mMGVxWqM.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Demon Slayer: Kimetsu no Yaiba Infinity Castle','155','The Demon Slayer Corps are drawn into the Infinity Castle, where Tanjiro, Nezuko, and the Hashira face terrifying Upper Rank demons in a desperate fight as the final battle against Muzan Kibutsuji begins.','7.5','/aFRDH3P7TX61FVGpaLhKr6QiOC1.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('The Conjuring: Last Rites','135','Paranormal investigators Ed and Lorraine Warren take on one last terrifying case involving mysterious entities they must confront.','6.8','/29ES27icY5CzTcMhlz1H4SdQRod.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Weapons','129','When all but one child from the same class mysteriously vanish on the same night at exactly the same time, a community is left questioning who or what is behind their disappearance.','7.5','/cpf7vsRZ0MYRQcnLWteD5jK9ymT.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Nobody 2','89','Former assassin Hutch Mansell takes his family on a nostalgic vacation to a small-town theme park, only to be pulled back into violence when they clash with a corrupt operator, a crooked sheriff, and a ruthless crime boss.','7.288','/svXVRoRSu6zzFtCzkRsjZS7Lqpd.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Stockholm Bloodbath','145','In 1520, the notorious and power-hungry Danish King Christian II is determined to seize the Swedish crown from Sten Sture, no matter what it takes. Meanwhile, sisters Freja and Anne make a solemn promise to seek revenge on the men who brutally murdered their family. Everything comes to a head in the heart of Stockholm, where the sisters are drawn into a ruthless political struggle between Sweden and Denmark that culminates in a mass execution, presided over by the mad King "Christian the Tyrant," known as the Stockholm Bloodbath.','6.219','/tzXOB8nxO70SfSbOhrYcY94x6MI.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Get Fast','88','When The Thief''s partner is kidnapped after stealing millions in cash from a merciless drug lord named Nushi, he reluctantly teams up with an angst-ridden orphan to rescue him. Nushi enlists her most trusted hitman, The Cowboy, a lovable charmer who''s quick with his guns, to track down the Thief. Guns, cars, and explosions will give the newfound partners a head start, but how long will they be able to keep it up?','6.0','/2MZBpW0bfQNJdWPCDM7OZetem1L.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('The Naked Gun','85','Only one man has the particular set of skills... to lead Police Squad and save the world: Lt. Frank Drebin Jr.','6.767','/aq0JMbmSfPwG8JvAzExJPrBHqmG.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Superman','130','Superman, a journalist in Metropolis, embarks on a journey to reconcile his Kryptonian heritage with his human upbringing as Clark Kent.','7.5','/wPLysNDLffQLOVebZQCbXJEv6E6.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Detective Dee: The Four Heavenly Kings','132','Dee, the detective serving Chinese empress Wu Zetian, is called upon to investigate a series of strange events in Loyang, including the appearance of mysterious warriors wearing Chiyou ghost masks, foxes that speak human language and the pillar sculptures in the palace coming alive.','6.226','/nZ3XTA5ZlGOj92jRBSYglW8r9QY.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('F1','156','Racing legend Sonny Hayes is coaxed out of retirement to lead a struggling Formula 1 team—and mentor a young hotshot driver—while chasing one more chance at glory.','7.818','/9PXZIUsSDh4alB80jheWX4fhZmy.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Jurassic World Rebirth','134','Five years after the events of Jurassic World Dominion, covert operations expert Zora Bennett is contracted to lead a skilled team on a top-secret mission to secure genetic material from the world''s three most massive dinosaurs. When Zora''s operation intersects with a civilian family whose boating expedition was capsized, they all find themselves stranded on an island where they come face-to-face with a sinister, shocking discovery that''s been hidden from the world for decades.','6.381','/1RICxzeoNCAO5NpcRMIgg1XT6fm.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('The Thing Behind The Door','81','The story of Adèle, a youg woman who''s literally haunted by the death of her husband, killed in a trench during World War One. Desperate and unable to face this tragic loss, Adèle turns to black magic in the hope to bring her lover back. The miracle will happen, but Adèle will have to pay the price for opening this Pandora Box.','5.333','/iFqHmF8ZSY9jOhstqeRxuzxPkFp.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Mission: Impossible - The Final Reckoning','170','Ethan Hunt and team continue their search for the terrifying AI known as the Entity — which has infiltrated intelligence networks all over the globe — with the world''s governments and a mysterious ghost from Hunt''s past on their trail. Joined by new allies and armed with the means to shut the Entity down for good, Hunt is in a race against time to prevent the world as we know it from changing forever.','7.3','/z53D72EAOxGRqdr7KXXWp9dJiDe.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('How to Train Your Dragon','125','On the rugged isle of Berk, where Vikings and dragons have been bitter enemies for generations, Hiccup stands apart, defying centuries of tradition when he befriends Toothless, a feared Night Fury dragon. Their unlikely bond reveals the true nature of dragons, challenging the very foundations of Viking society.','8.0','/q5pXRYTycaeW6dEgsCrd4mYPmxM.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('KPop Demon Hunters','96','When K-pop superstars Rumi, Mira and Zoey aren''t selling out stadiums, they''re using their secret powers to protect their fans from supernatural threats.','8.34','/22AouvwlhlXbe3nrFcjzL24bvWH.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Ice Road: Vengeance','113','Big rig ice road driver Mike McCann travels to Nepal to scatter his late brother''s ashes on Mt. Everest. While on a packed tour bus traversing the deadly 12,000 ft. terrain of the infamous Road to the Sky, McCann and his mountain guide encounter a group of mercenaries and must fight to save themselves, the busload of innocent travelers, and the local villagers'' homeland.','6.555','/cQN9rZj06rXMVkk76UF1DfBAico.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Highest 2 Lowest','133','When a titan music mogul, widely known as having the "best ears in the business", is targeted with a ransom plot, he is jammed up in a life-or-death moral dilemma.','5.884','/kOzwIr0R7WhaFgoYUZFLPZA2RBZ.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Together','101','With a move to the countryside already testing the limits of a couple''s relationship, a supernatural encounter begins an extreme transformation of their love, their lives, and their flesh.','7.142','/m52XidzKx94bKlToZfEXUnL3pdy.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Lookout','80','Seeking peace away from her turbulent life, a young woman accepts a job as a fire lookout at a remote wilderness tower. As she settles into her new role, eerie disturbances and strange occurrences begin to unfold, and she must uncover the chilling secrets that disrupt her isolation before it''s too late.','8.7','/nlMsTk94ylLywUdDWsOqwBDi19l.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Striking Rescue','106','A veteran Muay Thai expert goes on a take-no-prisoners mission of revenge after his wife and daughter are brutally murdered by mysterious forces.','7.577','/nML8rOI4GOiiEsXgknuhZeUF8M7.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Eenie Meanie','106','A former teenage getaway driver gets dragged back into her unsavory past when a former employer offers her a chance to save the life of her chronically unreliable ex-boyfriend.','6.4','/12Va3oO3oYUdOd75zM57Nx1976a.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('The Bad Guys 2','104','The now-reformed Bad Guys are trying (very, very hard) to be good, but instead find themselves hijacked into a high-stakes, globe-trotting heist, masterminded by a new team of criminals they never saw coming: The Bad Girls.','7.836','/26oSPnq0ct59l07QOXZKyzsiRtN.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('La hacienda: El regreso de los malditos','70','A group of friends return to their hometown after many years. The trip is an excuse to reminisce about old times but turns into a nightmare when they unearth their darkest memories.','10.0','/vXUfuM7tPvAL8HjjnsFO4yYbKUs.jpg');
INSERT INTO cat_peliculas (titulo,duracion,descripcion,rate,url_imagen) VALUES ('Maalikaya','70','Kara, a young inmate who unleashes her hidden sexual fantasies while serving time. After meeting Lila, a seductive inmate played by Jenn Rosa, Kara finds a new purpose in life. But her dark past still haunts her even behind bars.','7.2','/4DJmVEm6JupITScpsSjyyrvOMGr.jpg');

---- Rooms table

INSERT INTO cat_salas (nombre) VALUES ('1');
INSERT INTO cat_salas (nombre) VALUES ('2');
INSERT INTO cat_salas (nombre) VALUES ('3');
INSERT INTO cat_salas (nombre) VALUES ('4');
INSERT INTO cat_salas (nombre) VALUES ('5');
INSERT INTO cat_salas (nombre) VALUES ('6');
INSERT INTO cat_salas (nombre) VALUES ('7');
INSERT INTO cat_salas (nombre) VALUES ('8');
INSERT INTO cat_salas (nombre) VALUES ('9');
INSERT INTO cat_salas (nombre) VALUES ('10');

---- Seats

INSERT INTO cat_asientos (fila,columna) VALUES ('A','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('A','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('B','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('C','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('D','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('E','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('F','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('G','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('H','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('I','12');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','1');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','2');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','3');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','4');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','5');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','6');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','7');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','8');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','9');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','10');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','11');
INSERT INTO cat_asientos (fila,columna) VALUES ('J','12');


INSERT INTO ent_funciones (fecha,hora,sala_id,pelicula_id) VALUES ("2025-09-13","15:00","1","1");
