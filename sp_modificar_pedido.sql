CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificar_pedido`(
    IN p_id_pedido INT,
    IN p_terminal_id INT,
    IN p_proveedor_id INT,
    IN p_fecha_pedido DATE,
    IN p_insumos JSON,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar modificar el pedido.';
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_exists FROM Pedido WHERE id_pedido = p_id_pedido;

    IF v_exists = 0 THEN
        SET nResultado = -2;
        SET cMensaje = 'El pedido no existe.';
        ROLLBACK;
    ELSE
        UPDATE Pedido
        SET terminal_automotriz_id_terminal = p_terminal_id,
            proveedor_id = p_proveedor_id,
            fecha_pedido = p_fecha_pedido
        WHERE id_pedido = p_id_pedido;

        -- Eliminar detalles anteriores
        DELETE FROM Pedido_Detalle WHERE id_pedido = p_id_pedido;

        -- Insertar nuevos detalles
        SET @insumo_index = 0;
        WHILE JSON_EXTRACT(p_insumos, CONCAT('$[', @insumo_index, ']')) IS NOT NULL DO
            SET @insumo_codigo = JSON_EXTRACT(p_insumos, CONCAT('$[', @insumo_index, '].codigo'));
            SET @cantidad = JSON_EXTRACT(p_insumos, CONCAT('$[', @insumo_index, '].cantidad'));

            INSERT INTO Pedido_Detalle (id_pedido, insumo_codigo, cantidad)
            VALUES (p_id_pedido, @insumo_codigo, @cantidad);

            SET @insumo_index = @insumo_index + 1;
        END WHILE;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END