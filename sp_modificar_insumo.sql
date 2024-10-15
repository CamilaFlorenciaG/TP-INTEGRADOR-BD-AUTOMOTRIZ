CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificar_insumo`(
    IN p_codigo INT,
    IN p_descripcion VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar modificar el insumo.';
        ROLLBACK;
    END;

    START TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM Insumos WHERE codigo = p_codigo) THEN
        SET nResultado = -2;
        SET cMensaje = 'El insumo no existe.';
        ROLLBACK;
    ELSE
        UPDATE Insumos
        SET descripcion = p_descripcion
        WHERE codigo = p_codigo;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END