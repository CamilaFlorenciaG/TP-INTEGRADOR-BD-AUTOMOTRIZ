CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaProveedorPorID`(
    IN p_id_proveedor INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verifica si el proveedor ya existe y lo borra
    IF EXISTS (SELECT 1 FROM proveedores WHERE id_proveedor = p_id_proveedor) THEN
    
        SET nResultado = 0;
        SET cMensaje = 'se borro correctamente';
        
        delete from proveedores where id_proveedor = p_id_proveedor;
        
    ELSE
        -- sino da mensaje de que no existe
        SET nResultado = -1;
        SET cMensaje = 'Concesionario ingresado no existe';
        
    END IF;
END