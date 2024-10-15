CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_pedido`(
    IN p_terminal_id INT,
    IN p_proveedor_id INT,
    IN p_fecha_pedido DATE,
    IN p_insumos JSON, -- Formato: [{"codigo":1,"cantidad":10},{"codigo":2,"cantidad":20}]
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar insertar el pedido.';
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Pedido (terminal_automotriz_id_terminal, proveedor_id, fecha_pedido)
    VALUES (p_terminal_id, p_proveedor_id, p_fecha_pedido);

    SET @last_pedido_id = LAST_INSERT_ID();

    -- Procesar los insumos
    SET @insumo_index = 0;
    WHILE JSON_EXTRACT(p_insumos, CONCAT('$[', @insumo_index, ']')) IS NOT NULL DO
        SET @insumo_codigo = JSON_EXTRACT(p_insumos, CONCAT('$[', @insumo_index, '].codigo'));
        SET @cantidad = JSON_EXTRACT(p_insumos, CONCAT('$[', @insumo_index, '].cantidad'));

        INSERT INTO Pedido_Detalle (id_pedido, insumo_codigo, cantidad)
        VALUES (@last_pedido_id, @insumo_codigo, @cantidad);

        SET @insumo_index = @insumo_index + 1;
    END WHILE;

    SET nResultado = 0;
    SET cMensaje = '';
    COMMIT;
END