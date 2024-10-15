CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_montaje_vehiculo`(
    IN p_patente VARCHAR(10),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255),
    OUT p_patente_ocupante VARCHAR(10)
)
BEGIN
    DECLARE v_linea_id INT;
    DECLARE v_estacion_id INT;
    DECLARE v_vehiculo_ocupante VARCHAR(10);
    DECLARE v_estacion_ocupada INT;
    DECLARE v_orden_min INT;

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET nResultado = -1;
        SET cMensaje = 'Error al iniciar el montaje del vehículo.';
        SET p_patente_ocupante = NULL;
    END;

    -- Etiqueta para el bloque principal
    proc_block: BEGIN

        START TRANSACTION;

        -- Verificar si el vehículo existe
        IF NOT EXISTS (SELECT 1 FROM Vehiculo WHERE patente = p_patente) THEN
            SET nResultado = -2;
            SET cMensaje = 'El vehículo no existe.';
            SET p_patente_ocupante = NULL;
            ROLLBACK;
            LEAVE proc_block;
        END IF;

        -- Obtener la línea de montaje asignada al vehículo
        SELECT linea_de_montaje_id_linea INTO v_linea_id
        FROM Vehiculo
        WHERE patente = p_patente;

        -- Obtener el orden mínimo (primera estación) de la línea de montaje
        SELECT MIN(orden) INTO v_orden_min
        FROM Estacion_de_Trabajo
        WHERE linea_de_montaje_id_linea = v_linea_id;

        IF v_orden_min IS NULL THEN
            SET nResultado = -3;
            SET cMensaje = 'La línea de montaje no tiene estaciones asignadas.';
            SET p_patente_ocupante = NULL;
            ROLLBACK;
            LEAVE proc_block;
        END IF;

        -- Obtener el ID de la primera estación
        SELECT id_estacion INTO v_estacion_id
        FROM Estacion_de_Trabajo
        WHERE linea_de_montaje_id_linea = v_linea_id AND orden = v_orden_min;

        -- Verificar si la estación está ocupada
        SELECT COUNT(*) INTO v_estacion_ocupada
        FROM Vehiculo_en_Estacion
        WHERE estacion_id_estacion = v_estacion_id AND fecha_egreso IS NULL;

        IF v_estacion_ocupada > 0 THEN
            -- Obtener la patente del vehículo que ocupa la estación
            SELECT vehiculo_patente INTO v_vehiculo_ocupante
            FROM Vehiculo_en_Estacion
            WHERE estacion_id_estacion = v_estacion_id AND fecha_egreso IS NULL
            LIMIT 1;

            SET nResultado = -4;
            SET cMensaje = 'La primera estación está ocupada.';
            SET p_patente_ocupante = v_vehiculo_ocupante;
            ROLLBACK;
            LEAVE proc_block;
        END IF;

        -- Posicionar el vehículo en la primera estación
        INSERT INTO Vehiculo_en_Estacion (vehiculo_patente, estacion_id_estacion, fecha_ingreso, fecha_egreso)
        VALUES (p_patente, v_estacion_id, NOW(), NULL);

        COMMIT;
        SET nResultado = 0;
        SET cMensaje = '';
        SET p_patente_ocupante = NULL;

    END proc_block;

END