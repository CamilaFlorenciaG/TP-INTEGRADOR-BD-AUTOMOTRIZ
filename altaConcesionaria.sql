CREATE DEFINER=`root`@`localhost` PROCEDURE `altaConcesionaria`(
    IN p_id_concesionaria INT,
    IN p_nombre VARCHAR(100),
    IN p_terminal_automotriz_Id_terminal INT,
    IN p_direccion VARCHAR(150),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el concesionario existe
    IF EXISTS (SELECT 1 FROM concesionaria WHERE id_concesionaria = p_id_concesionaria) THEN
        SET nResultado = -2;
        SET cMensaje = 'Ya existe un concesionario con el mismo id';
    ELSE
        -- Verificar si ya existe otro concesionario con el mismo nombre
        IF EXISTS (SELECT 1 FROM concesionaria WHERE nombre = p_nombre ) THEN
            SET nResultado = -1;
            SET cMensaje = 'Ya existe otro concesionario con ese nombre.';
        ELSE
            -- Verificar si ya existe otro concesionario con la misma dirección
            IF EXISTS (SELECT 1 FROM concesionaria WHERE direccion = p_direccion ) THEN
                SET nResultado = -1;
                SET cMensaje = 'Ya existe otro concesionario con esa dirección.';
            ELSE
                -- Insertar nuevo concesionario
			INSERT INTO concesionaria (id_concesionaria, nombre, terminal_automotriz_Id_terminal, direccion)
			VALUES (p_id_concesionaria, p_nombre, p_terminal_automotriz_Id_terminal, p_direccion);
			
			-- Confirmar la inserción exitosa
			SET nResultado = 0;
			SET cMensaje = 'Concesionario insertado con éxito.';
            END IF;
        END IF;
    END IF;


END