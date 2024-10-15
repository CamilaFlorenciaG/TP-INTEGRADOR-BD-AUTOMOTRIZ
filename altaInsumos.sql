CREATE DEFINER=`root`@`localhost` PROCEDURE `altaInsumos`(
    IN p_codigo INT,
    IN p_descripcion VARCHAR(45),
    IN p_precio FLOAT,
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)

)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el insumo existe
    IF EXISTS (SELECT 1 FROM insumos WHERE codigo = p_codigo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Ya existe un insumo con el mismo codigo';
    ELSE
        -- Verificar si ya existe otro insumo con el mismo nombre
        IF EXISTS (SELECT 1 FROM insumos WHERE nombre = p_nombre ) THEN
            SET nResultado = -1;
            SET cMensaje = 'Ya existe otro Insumo con ese nombre.';
            
            ELSE
                -- Insertar nuevo concesionario
			INSERT INTO insumos (codigo,descripcion ,precio, nombre)
			VALUES (p_codigo,p_descripcion ,p_precio,p_nombre);
			
			-- Confirmar la inserción exitosa
			SET nResultado = 0;
			SET cMensaje = 'Insumo insertado con éxito.';
            END IF;
        END IF;

END