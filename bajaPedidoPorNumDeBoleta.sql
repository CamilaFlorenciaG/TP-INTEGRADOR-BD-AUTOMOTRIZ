CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaPedidoPorNumDeBoleta`(
    IN p_boleta_num INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verifica si el pedido ya existe y lo borra
    IF EXISTS (SELECT 1 FROM Pedido WHERE boleta_num = p_boleta_num) THEN

        SET nResultado = 0;
        SET cMensaje = 'se borro correctamente';

        DELETE FROM Pedido where boleta_num = p_boleta_num;

    ELSE
        -- sino da mensaje de que no existe
        SET nResultado = -1;
        SET cMensaje = 'pedido ingresado no existe';

    END IF;
END