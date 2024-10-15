CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificar_proveedor`(
    IN p_id_proveedor INT,
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar modificar el proveedor.';
        ROLLBACK;
    END;

    START TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM Proveedores WHERE id_proveedor = p_id_proveedor) THEN
        SET nResultado = -2;
        SET cMensaje = 'El proveedor no existe.';
        ROLLBACK;
    ELSE
        UPDATE Proveedores
        SET nombre = p_nombre
        WHERE id_proveedor = p_id_proveedor;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END