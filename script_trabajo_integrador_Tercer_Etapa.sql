-- MySQL Script con Modificaciones y Mejoras

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tp1_integrador
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `tp1_integrador`;
use `tp1_integrador`;

CREATE SCHEMA IF NOT EXISTS `tp1_integrador` DEFAULT CHARACTER SET utf8;
USE `tp1_integrador`;

-- -----------------------------------------------------
-- Tabla Terminal_automotriz
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Terminal_automotriz` (
  `id_terminal` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_terminal`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Proveedores
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proveedores` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Modelo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Modelo` (
  `id_modelo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_modelo`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Concesionaria
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Concesionaria` (
  `id_concesionaria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `terminal_automotriz_id_terminal` INT NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_concesionaria`),
  INDEX `fk_concesionaria_terminal_automotriz_idx` (`terminal_automotriz_id_terminal` ASC),
  CONSTRAINT `fk_concesionaria_terminal_automotriz`
    FOREIGN KEY (`terminal_automotriz_id_terminal`)
    REFERENCES `Terminal_automotriz` (`id_terminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Ventas_Realizadas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ventas_Realizadas` (
  `id_venta` INT NOT NULL AUTO_INCREMENT,
  `concesionaria_id_concesionaria` INT NOT NULL,
  `fecha_venta` DATE NOT NULL,
  PRIMARY KEY (`id_venta`),
  INDEX `fk_ventas_realizadas_concesionaria_idx` (`concesionaria_id_concesionaria` ASC),
  CONSTRAINT `fk_ventas_realizadas_concesionaria`
    FOREIGN KEY (`concesionaria_id_concesionaria`)
    REFERENCES `Concesionaria` (`id_concesionaria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Ventas_Detalle
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ventas_Detalle` (
  `id_venta` INT NOT NULL,
  `modelo_id_modelo` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`id_venta`, `modelo_id_modelo`),
  INDEX `fk_ventas_detalle_modelo_idx` (`modelo_id_modelo` ASC),
  CONSTRAINT `fk_ventas_detalle_venta`
    FOREIGN KEY (`id_venta`)
    REFERENCES `Ventas_Realizadas` (`id_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ventas_detalle_modelo`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `Modelo` (`id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Vehiculo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Vehiculo` (
  `patente` VARCHAR(10) NOT NULL,
  `modelo_id_modelo` INT NOT NULL,
  `linea_de_montaje_id_linea` INT NOT NULL,
  `fecha_inicio` DATETIME NOT NULL,
  `fecha_fin` DATETIME NULL,
  PRIMARY KEY (`patente`),
  INDEX `fk_vehiculo_modelo_idx` (`modelo_id_modelo` ASC),
  INDEX `fk_vehiculo_linea_de_montaje_idx` (`linea_de_montaje_id_linea` ASC),
  CONSTRAINT `fk_vehiculo_modelo`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `Modelo` (`id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehiculo_linea_de_montaje`
    FOREIGN KEY (`linea_de_montaje_id_linea`)
    REFERENCES `Linea_de_Montaje` (`id_linea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Linea_de_Montaje
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Linea_de_Montaje` (
  `id_linea` INT NOT NULL AUTO_INCREMENT,
  `modelo_id_modelo` INT NOT NULL,
  `terminal_automotriz_id_terminal` INT NOT NULL,
  `capacidad_productiva` INT NOT NULL,
  PRIMARY KEY (`id_linea`),
  INDEX `fk_linea_de_montaje_modelo_idx` (`modelo_id_modelo` ASC),
  INDEX `fk_linea_de_montaje_terminal_automotriz_idx` (`terminal_automotriz_id_terminal` ASC),
  CONSTRAINT `fk_linea_de_montaje_modelo`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `Modelo` (`id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_linea_de_montaje_terminal_automotriz`
    FOREIGN KEY (`terminal_automotriz_id_terminal`)
    REFERENCES `Terminal_automotriz` (`id_terminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Estacion_de_Trabajo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estacion_de_Trabajo` (
  `id_estacion` INT NOT NULL AUTO_INCREMENT,
  `tarea` VARCHAR(45) NOT NULL,
  `linea_de_montaje_id_linea` INT NOT NULL,
  `orden` INT NOT NULL,
  PRIMARY KEY (`id_estacion`),
  INDEX `fk_estacion_de_trabajo_linea_de_montaje_idx` (`linea_de_montaje_id_linea` ASC),
  CONSTRAINT `fk_estacion_de_trabajo_linea_de_montaje`
    FOREIGN KEY (`linea_de_montaje_id_linea`)
    REFERENCES `Linea_de_Montaje` (`id_linea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Vehiculo_en_Estacion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Vehiculo_en_Estacion` (
  `id_vehiculo_estacion` INT NOT NULL AUTO_INCREMENT,
  `vehiculo_patente` VARCHAR(10) NOT NULL,
  `estacion_id_estacion` INT NOT NULL,
  `fecha_ingreso` DATETIME NOT NULL,
  `fecha_egreso` DATETIME NULL,
  PRIMARY KEY (`id_vehiculo_estacion`),
  INDEX `fk_vehiculo_en_estacion_vehiculo_idx` (`vehiculo_patente` ASC),
  INDEX `fk_vehiculo_en_estacion_estacion_idx` (`estacion_id_estacion` ASC),
  CONSTRAINT `fk_vehiculo_en_estacion_vehiculo`
    FOREIGN KEY (`vehiculo_patente`)
    REFERENCES `Vehiculo` (`patente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehiculo_en_estacion_estacion`
    FOREIGN KEY (`estacion_id_estacion`)
    REFERENCES `Estacion_de_Trabajo` (`id_estacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Insumos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Insumos` (
  `codigo` INT NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Proveedores_has_Insumos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proveedores_has_Insumos` (
  `proveedor_id` INT NOT NULL,
  `insumo_codigo` INT NOT NULL,
  `precio` FLOAT NOT NULL,
  PRIMARY KEY (`proveedor_id`, `insumo_codigo`),
  INDEX `fk_proveedores_insumos_insumo_idx` (`insumo_codigo` ASC),
  INDEX `fk_proveedores_insumos_proveedor_idx` (`proveedor_id` ASC),
  CONSTRAINT `fk_proveedores_insumos_proveedor`
    FOREIGN KEY (`proveedor_id`)
    REFERENCES `Proveedores` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_proveedores_insumos_insumo`
    FOREIGN KEY (`insumo_codigo`)
    REFERENCES `Insumos` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Insumos_por_Estacion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Insumos_por_Estacion` (
  `insumo_codigo` INT NOT NULL,
  `estacion_id_estacion` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`insumo_codigo`, `estacion_id_estacion`),
  INDEX `fk_insumos_estacion_insumo_idx` (`insumo_codigo` ASC),
  INDEX `fk_insumos_estacion_estacion_idx` (`estacion_id_estacion` ASC),
  CONSTRAINT `fk_insumos_estacion_insumo`
    FOREIGN KEY (`insumo_codigo`)
    REFERENCES `Insumos` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_insumos_estacion_estacion`
    FOREIGN KEY (`estacion_id_estacion`)
    REFERENCES `Estacion_de_Trabajo` (`id_estacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Pedido
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `terminal_automotriz_id_terminal` INT NOT NULL,
  `proveedor_id` INT NOT NULL,
  `fecha_pedido` DATE NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedido_terminal_automotriz_idx` (`terminal_automotriz_id_terminal` ASC),
  INDEX `fk_pedido_proveedor_idx` (`proveedor_id` ASC),
  CONSTRAINT `fk_pedido_terminal_automotriz`
    FOREIGN KEY (`terminal_automotriz_id_terminal`)
    REFERENCES `Terminal_automotriz` (`id_terminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_proveedor`
    FOREIGN KEY (`proveedor_id`)
    REFERENCES `Proveedores` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Pedido_Detalle
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pedido_Detalle` (
  `id_pedido` INT NOT NULL,
  `insumo_codigo` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`id_pedido`, `insumo_codigo`),
  INDEX `fk_pedido_detalle_insumo_idx` (`insumo_codigo` ASC),
  CONSTRAINT `fk_pedido_detalle_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `Pedido` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_detalle_insumo`
    FOREIGN KEY (`insumo_codigo`)
    REFERENCES `Insumos` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla Fecha_Entrega
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fecha_Entrega` (
  `id_venta` INT NOT NULL,
  `fecha_entrega` DATE NOT NULL,
  PRIMARY KEY (`id_venta`),
  CONSTRAINT `fk_fecha_entrega_venta`
    FOREIGN KEY (`id_venta`)
    REFERENCES `Ventas_Realizadas` (`id_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;



-- Ejemplo: Alta de Concesionario, Paso 1: Asegurar que existe una Terminal Automotriz
INSERT INTO Terminal_automotriz (nombre)
VALUES ('Terminal Central');

-- Declarar variables para capturar los parámetros de salida
SET @nResultado = 0;
SET @cMensaje = '';

-- Invocar el procedimiento con datos de ejemplo
CALL sp_alta_concesionario(
    'Concesionario Los Robles', -- p_nombre
    1,                          -- p_terminal_id (id de la terminal automotriz)
    'Av. Siempre Viva 742',     -- p_direccion
    @nResultado,
    @cMensaje
);

-- Visualizar los resultados
SELECT @nResultado AS nResultado, @cMensaje AS cMensaje;



-- Ejemplo: Alta de Pedidos, Paso 1: Asegurar que existe una Terminal Automotriz
						--   Paso 2: Asegurar que exista un proveedor
INSERT INTO Proveedores (nombre)
VALUES ('Proveedor ABC');

-- Paso 3: Asegurar que existan insumos
INSERT INTO Insumos (codigo, descripcion)
VALUES (1001, 'Motor V8'), (1002, 'Llantas de aleación');

-- Verificar los insumos
SELECT * FROM Insumos;
-- ASEGURARSE QUE EL CODIGO EXISTE
SET @insumos_json = '[
    {"codigo": 1001, "cantidad": 5},
    {"codigo": 1002, "cantidad": 20}
]';

-- Invocar el procedimiento con datos de ejemplo
CALL sp_alta_pedido(
    1,                -- p_terminal_id (id de la terminal automotriz)
    1,                -- p_proveedor_id (id del proveedor)
    CURDATE(),        -- p_fecha_pedido
    @insumos_json,    -- p_insumos (JSON con los detalles)
    @nResultado,
    @cMensaje
);

-- Visualizar los resultados
SELECT @nResultado AS nResultado, @cMensaje AS cMensaje;




-- Invocar el procedimiento ALTA DE PROVEEDOR con datos de ejemplo
CALL sp_alta_proveedor(
    'Proveedor XYZ',  -- p_nombre
    @nResultado,
    @cMensaje
);

-- Visualizar los resultados
SELECT @nResultado AS nResultado, @cMensaje AS cMensaje;



-- Invocar el procedimiento ALTA DE INSUMOS con datos de ejemplo
CALL sp_alta_insumo(
    2001,               -- p_codigo
    'Neumático 17"',    -- p_descripcion
    @nResultado,
    @cMensaje
);

-- Visualizar los resultados
SELECT @nResultado AS nResultado, @cMensaje AS cMensaje;



-- TAREA NUMERO 3 DEL TRABAJO INTEGRADOR --
-- PUNTO 1:
-- Invocar el procedimiento

INSERT INTO Modelo (nombre) VALUES ('Modelo A'), ('Modelo B');
SELECT * FROM Modelo;
-- Supongamos que 'Modelo A' tiene id_modelo = 1, 'Modelo B' tiene id_modelo = 2

INSERT INTO Linea_de_Montaje (modelo_id_modelo, terminal_automotriz_id_terminal, capacidad_productiva)
VALUES (1, 1, 100), (2, 1, 80);

-- Crear una venta
INSERT INTO Ventas_Realizadas (concesionaria_id_concesionaria, fecha_venta)
VALUES (2, CURDATE());
SET @id_venta = LAST_INSERT_ID();

-- Agregar detalles de la venta
INSERT INTO Ventas_Detalle (id_venta, modelo_id_modelo, cantidad)
VALUES (@id_venta, 1, 2), (@id_venta, 2, 3);


CALL sp_generar_vehiculos_pedido(
    3,              -- p_id_venta (reemplaza con el ID de venta correspondiente)
    @nResultado,
    @cMensaje
);

-- Visualizar los resultados
SELECT @nResultado AS nResultado, @cMensaje AS cMensaje;
SELECT * FROM Vehiculo;



-- PUNTO 2 iniciar montaje:


-- Declarar variables para capturar los parámetros de salida
SET @nResultado = 0;
SET @cMensaje = '';
SET @p_patente_ocupante = '';

-- Asegurarse de que hay una estacion de trabajo asociada a la linea de montaje del vehiculo
INSERT INTO `tp1_integrador`.`estacion_de_trabajo` (`id_estacion`, `tarea`, `linea_de_montaje_id_linea`, `orden`) VALUES ('2', '1', '2', '1');

-- Invocar el procedimiento
CALL sp_iniciar_montaje_vehiculo(
    'NQR427',           -- p_patente
    @nResultado,
    @cMensaje,
    @p_patente_ocupante
);

-- Visualizar los resultados
SELECT @nResultado AS nResultado, @cMensaje AS cMensaje, @p_patente_ocupante AS patente_ocupante;
SELECT * FROM tp1_integrador.vehiculo_en_estacion;



-- PUNTO 3 Avanzar Montaje:




-- Declarar variables para capturar los parámetros de salida
SET @nResultado = 0;
SET @cMensaje = '';

-- Verificar si hay una siguiente estacion de trabajo
-- si el vehiculo esta o no se ve reflejado en la fecha de egreso
INSERT INTO `tp1_integrador`.`estacion_de_trabajo` (`id_estacion`, `tarea`, `linea_de_montaje_id_linea`, `orden`) VALUES ('3', '1', '2', '1');
INSERT INTO `tp1_integrador`.`estacion_de_trabajo` (`id_estacion`, `tarea`, `linea_de_montaje_id_linea`, `orden`) VALUES ('4', '1', '2', '1');

-- Invocar el procedimiento
CALL sp_avanzar_vehiculo_estacion(
    'NQR427',           -- p_patente
    @nResultado,
    @cMensaje
);

-- Visualizar los resultados
SELECT @nResultado AS nResultado, @cMensaje AS cMensaje;











SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
