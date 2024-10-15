CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generar_vehiculos_pedido`(
    IN p_id_venta INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE v_modelo_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_linea_id INT;
    DECLARE v_i INT;
    DECLARE v_patente VARCHAR(10);
    DECLARE done INT DEFAULT FALSE;

    -- Cursor para recorrer los detalles de la venta
    DECLARE cur CURSOR FOR 
        SELECT modelo_id_modelo, cantidad FROM Ventas_Detalle WHERE id_venta = p_id_venta;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET nResultado = -1;
        SET cMensaje = 'Error al generar los vehículos.';
    END;

    -- Etiqueta para el bloque principal
    proc_block: BEGIN

        START TRANSACTION;

        -- Verificar si la venta existe
        SELECT COUNT(*) INTO v_exists FROM Ventas_Realizadas WHERE id_venta = p_id_venta;
        IF v_exists = 0 THEN
            SET nResultado = -2;
            SET cMensaje = 'La venta no existe.';
            ROLLBACK;
            LEAVE proc_block;
        END IF;

        -- Abrir cursor para recorrer los modelos en el detalle de la venta
        OPEN cur;
        read_loop: LOOP
            FETCH cur INTO v_modelo_id, v_cantidad;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Obtener la línea de montaje correspondiente al modelo
            SELECT id_linea INTO v_linea_id FROM Linea_de_Montaje WHERE modelo_id_modelo = v_modelo_id LIMIT 1;

            IF v_linea_id IS NULL THEN
                SET nResultado = -3;
                SET cMensaje = CONCAT('No se encontró línea de montaje para el modelo ', v_modelo_id);
                ROLLBACK;
                LEAVE proc_block;
            END IF;

            -- Generar los vehículos
            SET v_i = 1;
            WHILE v_i <= v_cantidad DO
                -- Generar patente única
                SET v_patente = NULL;
                WHILE v_patente IS NULL OR EXISTS(SELECT 1 FROM Vehiculo WHERE patente = v_patente) DO
                    SET v_patente = CONCAT(
                        CHAR(FLOOR(RAND() * 26) + 65), -- Letra mayúscula aleatoria
                        CHAR(FLOOR(RAND() * 26) + 65),
                        CHAR(FLOOR(RAND() * 26) + 65),
                        LPAD(FLOOR(RAND() * 1000), 3, '0') -- Número de 3 dígitos
                    );
                END WHILE;

                -- Insertar el vehículo en la tabla
                INSERT INTO Vehiculo (patente, modelo_id_modelo, linea_de_montaje_id_linea, fecha_inicio, fecha_fin)
                VALUES (v_patente, v_modelo_id, v_linea_id, NOW(), NULL);

                SET v_i = v_i + 1;
            END WHILE;
        END LOOP;

        CLOSE cur;

        COMMIT;
        SET nResultado = 0;
        SET cMensaje = '';

    END proc_block;

END