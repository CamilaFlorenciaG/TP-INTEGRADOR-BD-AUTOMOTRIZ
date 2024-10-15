-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tp1_integrador
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tp1_integrador
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tp1_integrador` DEFAULT CHARACTER SET utf8 ;
USE `tp1_integrador` ;

-- -----------------------------------------------------
-- Table `tp1_integrador`.`Terminal_automotriz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Terminal_automotriz` (
  `id_terminal` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `fecha_de_entrega` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_terminal`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Proveedores` (
  `id_proveedor` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Modelo` (
  `id_modelo` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_modelo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Concesionaria` (
  `id_concesionaria` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `terminal_automotriz_Id_terminal` INT NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_concesionaria`),
  INDEX `fk_concesionaria_Terminal Automotriz1_idx` (`terminal_automotriz_Id_terminal` ASC) VISIBLE,
  CONSTRAINT `fk_concesionaria_Terminal Automotriz1`
    FOREIGN KEY (`terminal_automotriz_Id_terminal`)
    REFERENCES `tp1_integrador`.`Terminal_automotriz` (`id_terminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`ventas_realizadas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`ventas_realizadas` (
  `id_ventas_realizadas` INT NOT NULL,
  `concesionaria_id_concesionaria` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`id_ventas_realizadas`),
  INDEX `fk_ventas realizadas_concesionaria1_idx` (`concesionaria_id_concesionaria` ASC) VISIBLE,
  CONSTRAINT `fk_ventas realizadas_concesionaria1`
    FOREIGN KEY (`concesionaria_id_concesionaria`)
    REFERENCES `tp1_integrador`.`Concesionaria` (`id_concesionaria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Ventas_realizadas_has_Modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Ventas_realizadas_has_Modelo` (
  `ventas _realizadas_id` INT NOT NULL,
  `modelo_id_modelo` INT NOT NULL,
  PRIMARY KEY (`ventas _realizadas_id`, `modelo_id_modelo`),
  INDEX `fk_ventas realizadas_has_Modelo_Modelo1_idx` (`modelo_id_modelo` ASC) VISIBLE,
  INDEX `fk_ventas realizadas_has_Modelo_ventas realizadas1_idx` (`ventas _realizadas_id` ASC) VISIBLE,
  CONSTRAINT `fk_ventas realizadas_has_Modelo_ventas realizadas1`
    FOREIGN KEY (`ventas _realizadas_id`)
    REFERENCES `tp1_integrador`.`ventas_realizadas` (`id_ventas_realizadas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ventas realizadas_has_Modelo_Modelo1`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `tp1_integrador`.`Modelo` (`id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Vehiculo` (
  `patente` VARCHAR(10) NOT NULL,
  `color` VARCHAR(45) NOT NULL,
  `ventas realizadas_has_modelo_ventas realizadas_id` INT NOT NULL,
  `ventas realizadas_has_modelo_modelo_id_modelo` INT NOT NULL,
  `fecha_inicio` DATETIME NOT NULL,
  `fecha_fin` DATETIME NULL,
  PRIMARY KEY (`patente`, `ventas realizadas_has_modelo_ventas realizadas_id`, `ventas realizadas_has_modelo_modelo_id_modelo`),
  INDEX `fk_Vehiculo_ventas realizadas_has_Modelo1_idx` (`ventas realizadas_has_modelo_ventas realizadas_id` ASC, `ventas realizadas_has_modelo_modelo_id_modelo` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_ventas realizadas_has_Modelo1`
    FOREIGN KEY (`ventas realizadas_has_modelo_ventas realizadas_id` , `ventas realizadas_has_modelo_modelo_id_modelo`)
    REFERENCES `tp1_integrador`.`Ventas_realizadas_has_Modelo` (`ventas _realizadas_id` , `modelo_id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Linea_de_montaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Linea_de_montaje` (
  `id_linea_de_montaje` INT NOT NULL,
  `modelo_id_modelo` INT NOT NULL,
  `Terminal_automotriz_Id_terminal` INT NOT NULL,
  `capacidad_productiva` INT NULL,
  `vehiculo_patente` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id_linea_de_montaje`),
  INDEX `fk_Linea de Montaje_Modelo_idx` (`modelo_id_modelo` ASC) VISIBLE,
  INDEX `fk_Linea de Montaje_Terminal Automotriz1_idx` (`Terminal_automotriz_Id_terminal` ASC) VISIBLE,
  INDEX `fk_Linea de Montaje_Vehiculo1_idx` (`vehiculo_patente` ASC) VISIBLE,
  CONSTRAINT `fk_Linea de Montaje_Modelo`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `tp1_integrador`.`Modelo` (`id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Linea de Montaje_Terminal Automotriz1`
    FOREIGN KEY (`Terminal_automotriz_Id_terminal`)
    REFERENCES `tp1_integrador`.`Terminal_automotriz` (`id_terminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Linea de Montaje_Vehiculo1`
    FOREIGN KEY (`vehiculo_patente`)
    REFERENCES `tp1_integrador`.`Vehiculo` (`patente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Estacion_de_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Estacion_de_trabajo` (
  `tarea` VARCHAR(45) NOT NULL,
  `linea_de_montaje_id_linea_de_montaje` INT NOT NULL,
  `orden` INT NOT NULL,
  INDEX `fk_Estacion de trabajo_Linea de Montaje1_idx` (`linea_de_montaje_id_linea_de_montaje` ASC) VISIBLE,
  PRIMARY KEY (`tarea`),
  CONSTRAINT `fk_Estacion de trabajo_Linea de Montaje1`
    FOREIGN KEY (`linea_de_montaje_id_linea_de_montaje`)
    REFERENCES `tp1_integrador`.`Linea_de_montaje` (`id_linea_de_montaje`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Insumos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Insumos` (
  `codigo` INT NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  `precio` FLOAT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Pedido` (
  `boleta_num` INT NOT NULL,
  `terminal_automotriz_Id_terminal` INT NOT NULL,
  `proveedores_Id_proveedor` INT NOT NULL,
  `cabecera` VARCHAR(35) NOT NULL,
  `detalle` VARCHAR(200) NOT NULL,
  
  PRIMARY KEY (`boleta_num`, `terminal_automotriz_Id_terminal`),
  INDEX `fk_Pedido_Terminal Automotriz1_idx` (`terminal_automotriz_Id_terminal` ASC) VISIBLE,
  INDEX `fk_Pedido_Proveedores1_idx` (`proveedores_Id_proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Terminal Automotriz1`
    FOREIGN KEY (`terminal_automotriz_Id_terminal`)
    REFERENCES `tp1_integrador`.`Terminal_automotriz` (`id_terminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Proveedores1`
    FOREIGN KEY (`proveedores_Id_proveedor`)
    REFERENCES `tp1_integrador`.`Proveedores` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tp1_integrador`.`Vehiculo_en_estacion_de_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Vehiculo_en_estacion_de_trabajo` (
  `estacion_de_trabajo_tarea` VARCHAR(45) NOT NULL,
  `vehiculo_patente` VARCHAR(10) NOT NULL,
  `fecha_ingreso` DATETIME NOT NULL,
  `fecha_egreso` DATETIME NULL,
  PRIMARY KEY (`estacion_de_trabajo_tarea`, `vehiculo_patente`),
  INDEX `fk_Estacion de trabajo_has_Vehiculo_Vehiculo1_idx` (`vehiculo_patente` ASC) VISIBLE,
  INDEX `fk_Estacion de trabajo_has_Vehiculo_Estacion de trabajo1_idx` (`estacion_de_trabajo_tarea` ASC) VISIBLE,
  CONSTRAINT `fk_Estacion de trabajo_has_Vehiculo_Estacion de trabajo1`
    FOREIGN KEY (`estacion_de_trabajo_tarea`)
    REFERENCES `tp1_integrador`.`Estacion_de_trabajo` (`tarea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estacion de trabajo_has_Vehiculo_Vehiculo1`
    FOREIGN KEY (`vehiculo_patente`)
    REFERENCES `tp1_integrador`.`Vehiculo` (`patente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Proveedores_has_Insumos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Proveedores_has_Insumos` (
  `proveedores_Id_proveedor` INT NOT NULL,
  `insumos_codigo` INT NOT NULL,
  PRIMARY KEY (`insumos_codigo`, `proveedores_Id_proveedor`),
  INDEX `fk_Proveedores_has_Insumos_Insumos1_idx` (`insumos_codigo` ASC) VISIBLE,
  INDEX `fk_Proveedores_has_Insumos_Proveedores1_idx` (`proveedores_Id_proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_Proveedores_has_Insumos_Proveedores1`
    FOREIGN KEY (`proveedores_Id_proveedor`)
    REFERENCES `tp1_integrador`.`Proveedores` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proveedores_has_Insumos_Insumos1`
    FOREIGN KEY (`insumos_codigo`)
    REFERENCES `tp1_integrador`.`Insumos` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp1_integrador`.`Insumos_has_Estacion_de_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1_integrador`.`Insumos_has_Estacion_de_trabajo` (
  `Insumos_codigo` INT NOT NULL,
  `Estacion_de_trabajo_tarea` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Insumos_codigo`, `Estacion_de_trabajo_tarea`),
  INDEX `fk_Insumos_has_Estacion_de_trabajo_Estacion_de_trabajo1_idx` (`Estacion_de_trabajo_tarea` ASC) VISIBLE,
  INDEX `fk_Insumos_has_Estacion_de_trabajo_Insumos1_idx` (`Insumos_codigo` ASC) VISIBLE,
  CONSTRAINT `fk_Insumos_has_Estacion_de_trabajo_Insumos1`
    FOREIGN KEY (`Insumos_codigo`)
    REFERENCES `tp1_integrador`.`Insumos` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Insumos_has_Estacion_de_trabajo_Estacion_de_trabajo1`
    FOREIGN KEY (`Estacion_de_trabajo_tarea`)
    REFERENCES `tp1_integrador`.`Estacion_de_trabajo` (`tarea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

use tp1_integrador;

-- --- terminal_automotriz ---

insert into terminal_automotriz (id_terminal,nombre,fecha_de_entrega) values (1, "terminal_1", '2024-10-27 18:30:00');

select * from terminal_automotriz;

-- ---------------------------------------------------------

-- --- ALTA CONCESIONARIA ---

CALL altaConcesionaria(10, 'AutoMovil S.A', 1, 'Av. Siempre Viva 123, Ciudad A',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;
CALL altaConcesionaria(11, 'Carros del Norte', 1, 'Calle Central 45, Ciudad B',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- MODIFICACION CONCESIONARIA ---

CALL modificacionConcesionaria(10, 'AutoMovil SA', 1, 'Av. Siempre Viva 123, Ciudad A',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;
CALL modificacionConcesionaria(11, 'Carros del sur', 1, 'Calle Central 45, Ciudad B',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- ALTA CONCESIONARIA ---

call bajaConcesionariaPorID(10,@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;
call bajaConcesionariaPorID(500,@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

select * from concesionaria;

-- ----------------------------------------------------------------------

--  --- ALTA PROVEEDORES ---

call altaProveedor(1, 'Proveedor Norte',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;
call altaProveedor(2, 'Suministros Globales',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- MODIFICACION PROVEEDORES ---

call modificacionProveedor(1, 'Proveedor Sur',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;
call modificacionProveedor(222222, 'Suministros aGlobales',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- BAJA PROVEEDORES ---

call bajaProveedorPorID(1, @nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

select * from proveedores;

-- ----------------------------------------------------------------------

-- --- ALTA PEDIDO ---

call altaPedido(1,1,4,"pintura","roja",@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;
call altaPedido(2,1,5,"llantas","cromadas",@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- MODIFICACION PEDIDO ---

call modificacionPedido(1,1,4,"rueda","verde",@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- BAJA PEDIDO ---

call bajaPedidoPorNumDeBoleta(1,@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

select * from pedido;

-- ----------------------------------------------------------------------

-- --- ALTA INSUMOS ---

call altaInsumos(1,'delantera derecha',25.05,'puerta',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;
call altaInsumos(2,'1.8 Troja',25.05,'motor',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- MODIFICACION INSUMOS ---
call modificacionInsumo(1,'delantera izq',15.05,'puerta',@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

-- --- BAJA INSUMOS ---

call bajaInsumoPorID(1,@nResultado1, @cMensaje1);
select @nResultado1, @cMensaje1;

select * from insumos;

-- ----------------------------------------------------------------------


