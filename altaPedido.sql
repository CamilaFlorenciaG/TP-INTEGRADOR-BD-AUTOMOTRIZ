CREATE DEFINER=`root`@`localhost` PROCEDURE `altaPedido`(
    IN p_boleta_num INT,
    IN p_terminal_automotriz_id_terminal INT,
    IN p_proveedores_id_proveedor INT,
    IN P_cabecera VARCHAR(35),
	IN P_detalle VARCHAR(200),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido ya existe
    IF EXISTS (SELECT 1 FROM Pedido WHERE boleta_num = p_boleta_num) THEN
        SET nResultado = -1;
        SET cMensaje = 'El pedido ya existe con esa clave primaria.';
    ELSE
        -- Insertar nuevo pedido
        INSERT INTO Pedido (boleta_num, terminal_automotriz_id_terminal, proveedores_id_proveedor, cabecera, detalle)
        VALUES (p_boleta_num, p_terminal_automotriz_id_terminal, p_proveedores_id_proveedor, p_cabecera, p_detalle);

        -- Confirmar la inserción exitosa
        SET nResultado = 0;
        SET cMensaje = 'Pedido insertado con éxito.';

    END IF;
END