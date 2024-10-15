CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_insumo`(
    IN p_codigo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar eliminar el insumo.';
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_exists FROM Insumos WHERE codigo = p_codigo;

    IF v_exists = 0 THEN
        SET nResultado = -2;
        SET cMensaje = 'El insumo no existe.';
        ROLLBACK;
    ELSEIF EXISTS (SELECT 1 FROM Proveedores_has_Insumos WHERE insumo_codigo = p_codigo) THEN
        SET nResultado = -3;
        SET cMensaje = 'No se puede eliminar el insumo porque está asociado a proveedores.';
        ROLLBACK;
    ELSE
        DELETE FROM Insumos WHERE codigo = p_codigo;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END