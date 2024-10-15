CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaInsumoPorID`(
    IN p_codigo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)

)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verifica si el insumo ya existe y lo borra
    IF EXISTS (SELECT 1 FROM insumos WHERE codigo = p_codigo) THEN

        SET nResultado = 0;
        SET cMensaje = 'se borro correctamente';

        DELETE FROM insumos where codigo = p_codigo;

    ELSE
        -- sino da mensaje de que no existe
        SET nResultado = -1;
        SET cMensaje = 'insumo ingresado no existe';

    END IF;
END