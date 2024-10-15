CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_pedido`(
    IN p_id_pedido INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar eliminar el pedido.';
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_exists FROM Pedido WHERE id_pedido = p_id_pedido;

    IF v_exists = 0 THEN
        SET nResultado = -2;
        SET cMensaje = 'El pedido no existe.';
        ROLLBACK;
    ELSE
        DELETE FROM Pedido_Detalle WHERE id_pedido = p_id_pedido;
        DELETE FROM Pedido WHERE id_pedido = p_id_pedido;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END