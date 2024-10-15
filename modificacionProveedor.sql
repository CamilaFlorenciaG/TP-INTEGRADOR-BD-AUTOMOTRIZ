CREATE DEFINER=`root`@`localhost` PROCEDURE `modificacionProveedor`(
    IN p_id_proveedor INT,
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(150)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el concesionario existe
    IF NOT EXISTS (SELECT 1 FROM Proveedores WHERE id_proveedor = p_id_proveedor) THEN
        SET nResultado = -2;
        SET cMensaje = 'El proveedor no existe.';
    ELSE
        -- Verificar si ya existe otro proveedor con el mismo nombre
        IF EXISTS (SELECT 1 FROM Proveedores WHERE nombre = p_nombre ) THEN
            SET nResultado = -1;
            SET cMensaje = 'Ya existe otro proveedor con ese nombre.';
        ELSE
                -- Actualizar el proveedor
                UPDATE Proveedores
                
                SET 
					-- id_proveedor = p_id_proveedor,
					nombre = p_nombre
				
                WHERE id_proveedor = p_id_proveedor;

                -- Confirmar la actualización exitosa
                SET nResultado = 0;
                SET cMensaje = 'Concesionario actualizado exitosamente.';
            END IF;
        END IF;

END