CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_avanzar_vehiculo_estacion`(
    IN p_patente VARCHAR(10),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_linea_id INT;
    DECLARE v_current_estacion_id INT;
    DECLARE v_current_orden INT;
    DECLARE v_next_estacion_id INT;
    DECLARE v_estacion_ocupada INT;
    
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET nResultado = -1;
        SET cMensaje = 'Error al avanzar el vehículo a la siguiente estación.';
    END;
    
    -- Etiqueta para el bloque principal
    proc_block: BEGIN
    
        START TRANSACTION;
        
        -- Verificar si el vehículo existe
        IF NOT EXISTS (SELECT 1 FROM Vehiculo WHERE patente = p_patente) THEN
            SET nResultado = -2;
            SET cMensaje = 'El vehículo no existe.';
            ROLLBACK;
            LEAVE proc_block;
        END IF;
        
        -- Verificar si el vehículo está en alguna estación
        SELECT ve.estacion_id_estacion INTO v_current_estacion_id
        FROM Vehiculo_en_Estacion ve
        WHERE ve.vehiculo_patente = p_patente AND ve.fecha_egreso IS NULL
        LIMIT 1;
        
        IF v_current_estacion_id IS NULL THEN
            SET nResultado = -3;
            SET cMensaje = 'El vehículo no se encuentra en ninguna estación.';
            ROLLBACK;
            LEAVE proc_block;
        END IF;
        
        -- Obtener el orden de la estación actual
        SELECT orden INTO v_current_orden
        FROM Estacion_de_Trabajo
        WHERE id_estacion = v_current_estacion_id;
        
        -- Marcar salida del vehículo de la estación actual
        UPDATE Vehiculo_en_Estacion
        SET fecha_egreso = NOW()
        WHERE vehiculo_patente = p_patente AND fecha_egreso IS NULL;
        
        -- Obtener el ID de la línea de montaje del vehículo
        SELECT linea_de_montaje_id_linea INTO v_linea_id
        FROM Vehiculo
        WHERE patente = p_patente;
        
        -- Obtener la siguiente estación en la línea de montaje
        SELECT id_estacion INTO v_next_estacion_id
        FROM Estacion_de_Trabajo
        WHERE linea_de_montaje_id_linea = v_linea_id AND orden > v_current_orden
        ORDER BY orden ASC
        LIMIT 1;
        
        -- Si no hay siguiente estación, es la última
        IF v_next_estacion_id IS NULL THEN
            -- Marcar el vehículo como finalizado
            UPDATE Vehiculo
            SET fecha_fin = NOW()
            WHERE patente = p_patente;
            
            SET nResultado = 0;
            SET cMensaje = '';
            COMMIT;
            LEAVE proc_block;
        END IF;
        
        -- Verificar si la siguiente estación está ocupada
        SELECT COUNT(*) INTO v_estacion_ocupada
        FROM Vehiculo_en_Estacion
        WHERE estacion_id_estacion = v_next_estacion_id AND fecha_egreso IS NULL;
        
        IF v_estacion_ocupada > 0 THEN
            SET nResultado = -4;
            SET cMensaje = 'La siguiente estación está ocupada.';
            ROLLBACK;
            LEAVE proc_block;
        END IF;
        
        -- Posicionar el vehículo en la siguiente estación
        INSERT INTO Vehiculo_en_Estacion (vehiculo_patente, estacion_id_estacion, fecha_ingreso, fecha_egreso)
        VALUES (p_patente, v_next_estacion_id, NOW(), NULL);
        
        COMMIT;
        SET nResultado = 0;
        SET cMensaje = '';
        
    END proc_block;

END