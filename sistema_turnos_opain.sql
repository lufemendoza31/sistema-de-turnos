-- =========================================================================
-- PROYECTO: Sistema de Gestión de Turnos - OPAL / OPIN (Opain S.A.)
-- AUTORES: Luisa Fernanda Mendoza Peña - Fabian Morales 
-- DESCRIPCIÓN: Script DDL y DML para la administración de personal y turnos.
-- =========================================================================

-- 1. Crear la base de datos
DROP DATABASE IF EXISTS sistema_turnos_opain;
CREATE DATABASE sistema_turnos_opain CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sistema_turnos_opain;

-- 2. Creación de Tablas (con restricciones de integridad referencial)

-- Tabla de Cargos / Roles en Operaciones y Seguridad
CREATE TABLE cargos (
    id_cargo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    salario_base DECIMAL(10,2) NOT NULL
);

-- Tabla de Empleados
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    id_cargo INT NOT NULL,
    fecha_contratacion DATE NOT NULL,
    CONSTRAINT fk_empleado_cargo FOREIGN KEY (id_cargo) 
        REFERENCES cargos(id_cargo) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);

-- Tabla de Turnos (Asignación 5x1 u operativa)
CREATE TABLE turnos (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    fecha_turno DATE NOT NULL,
    tipo_turno ENUM('Mañana', 'Tarde', 'Noche', 'Descanso') NOT NULL,
    estado VARCHAR(30) DEFAULT 'Programado',
    CONSTRAINT fk_turno_empleado FOREIGN KEY (id_empleado) 
        REFERENCES empleados(id_empleado) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

-- =========================================================================
-- 3. Inserción de Datos de Prueba (DML)
-- =========================================================================

-- Insertar Cargos
INSERT INTO cargos (nombre_cargo, descripcion, salario_base) VALUES
('Agente de Seguridad', 'Control de accesos y filtros de seguridad en terminal', 1800000.00),
('Supervisor de Operaciones', 'Coordinación general de operaciones en plataforma', 2800000.00),
('Especialista de Sistemas', 'Soporte técnico de infraestructura y bases de datos', 3200000.00);

-- Insertar Empleados
INSERT INTO empleados (documento, nombres, apellidos, correo, telefono, id_cargo, fecha_contratacion) VALUES
('1020304050', 'Carlos', 'Ramírez', 'carlos.ramirez@opain.co', '3101234567', 1, '2024-03-15'),
('1020304051', 'Ana María', 'Gómez', 'ana.gomez@opain.co', '3112345678', 2, '2023-08-10'),
('1020304052', 'Luis', 'Torres', 'luis.torres@opain.co', '3123456789', 3, '2025-01-20');

-- Insertar Turnos
INSERT INTO turnos (id_empleado, fecha_turno, tipo_turno, estado) VALUES
(1, '2026-11-14', 'Mañana', 'Completado'),
(1, '2026-11-15', 'Noche', 'Programado'),
(2, '2026-11-14', 'Tarde', 'Completado'),
(3, '2026-11-14', 'Mañana', 'Completado');

-- =========================================================================
-- 4. Consultas Útiles (JOINS y reportes)
-- =========================================================================

-- Consulta: Listar empleados con su respectivo cargo y datos de contacto
SELECT 
    e.documento,
    CONCAT(e.nombres, ' ', e.apellidos) AS nombre_completo,
    c.nombre_cargo,
    c.salario_base,
    e.correo
FROM empleados e
INNER JOIN cargos c ON e.id_cargo = c.id_cargo;

-- Consulta: Ver la programación de turnos con nombres de empleados
SELECT 
    t.id_turno,
    CONCAT(e.nombres, ' ', e.apellidos) AS empleado,
    t.fecha_turno,
    t.tipo_turno,
    t.estado
FROM turnos t
INNER JOIN empleados e ON t.id_empleado = e.id_empleado
ORDER BY t.fecha_turno DESC;
