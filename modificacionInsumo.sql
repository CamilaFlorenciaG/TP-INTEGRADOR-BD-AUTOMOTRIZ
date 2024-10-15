CREATE DEFINER=`root`@`localhost` PROCEDURE `modificacionInsumo`(
    IN p_codigo INT,
    IN p_descripcion VARCHAR(45),
    IN p_precio FLOAT,
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)

)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el insumo existe
    IF NOT EXISTS (SELECT 1 FROM insumos WHERE codigo = p_codigo) THEN
        SET nResultado = -2;
        SET cMensaje = 'No existe el insumo con ese codigo';
    ELSE
                -- Actualizar el insumos
                UPDATE insumos
                SET codigo = p_codigo,
					descripcion = p_descripcion,
                    precio = p_precio,
					nombre = p_nombre
                WHERE codigo = p_codigo;

                -- Confirmar la actualización exitosa
                SET nResultado = 0;
                SET cMensaje = 'Insumo actualizado exitosamente.';
            END IF;

END