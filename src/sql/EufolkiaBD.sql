#CREATE DATABASE Eufolkia;

USE Eufolkia;

#Tablas principales

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo VARCHAR(100) NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    nivel ENUM('principiante', 'intermedio', 'avanzado', 'profesional'),
    genero_favorito varchar(50)
    
);


-- Crear tabla de instrumentos
CREATE TABLE if not exists instrumentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);
-- Insertar datos iniciales de instrumentos
INSERT ignore INTO  instrumentos (nombre) VALUES
('piano'),
('guitarra'),
('violin'),
('bateria'),
('flauta'),
('ukelele'),
('bajo'),
('voz'),
('saxofon'),
('trompeta'),
('otros');
-- Crear tabla de relación usuario-instrumentos
CREATE TABLE if not exists usuario_instrumento (
    id_usuario INT,
    id_instrumento INT,
    PRIMARY KEY (id_usuario, id_instrumento),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id),
    FOREIGN KEY (id_instrumento) REFERENCES instrumentos(id)
);


#SELECT u.usuario, i.nombre AS instrumento
#FROM usuario_instrumento ui
#JOIN usuarios u ON ui.id_usuario = u.id
#JOIN instrumentos i ON ui.id_instrumento = i.id;

select * from usuarios;




