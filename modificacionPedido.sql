CREATE DEFINER=`root`@`localhost` PROCEDURE `modificacionPedido`(
    IN p_boleta_num INT,
    IN p_terminal_automotriz_Id_terminal INT,
    IN p_proveedores_id_proveedor INT,
    IN p_cabecera VARCHAR(35),
    IN p_detalle VARCHAR(200),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT 1 FROM Pedido WHERE boleta_num = p_boleta_num) THEN
        SET nResultado = -1;
        SET cMensaje = 'El pedido no existe.';
    ELSE
                -- Actualizar el pedido
                UPDATE Pedido
                SET cabecera = p_cabecera,
                    terminal_automotriz_Id_terminal = p_terminal_automotriz_Id_terminal,
                    detalle = p_detalle
                WHERE boleta_num = p_boleta_num;

                -- Confirmar la actualización exitosa
                SET nResultado = 0;
                SET cMensaje = 'Pedido actualizado exitosamente.';

    END IF;

END