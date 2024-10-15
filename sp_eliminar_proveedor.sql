CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_proveedor`(
    IN p_id_proveedor INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar eliminar el proveedor.';
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_exists FROM Proveedores WHERE id_proveedor = p_id_proveedor;

    IF v_exists = 0 THEN
        SET nResultado = -2;
        SET cMensaje = 'El proveedor no existe.';
        ROLLBACK;
    ELSEIF EXISTS (SELECT 1 FROM Pedido WHERE proveedor_id = p_id_proveedor) THEN
        SET nResultado = -3;
        SET cMensaje = 'No se puede eliminar el proveedor porque tiene pedidos asociados.';
        ROLLBACK;
    ELSE
        DELETE FROM Proveedores WHERE id_proveedor = p_id_proveedor;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END