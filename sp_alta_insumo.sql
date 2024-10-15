CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_insumo`(
    IN p_codigo INT,
    IN p_descripcion VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar insertar el insumo.';
        ROLLBACK;
    END;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM Insumos WHERE codigo = p_codigo) THEN
        SET nResultado = -2;
        SET cMensaje = 'El insumo ya existe.';
        ROLLBACK;
    ELSE
        INSERT INTO Insumos (codigo, descripcion)
        VALUES (p_codigo, p_descripcion);

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END