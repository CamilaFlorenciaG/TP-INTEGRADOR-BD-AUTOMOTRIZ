CREATE DEFINER=`root`@`localhost` PROCEDURE `altaProveedor`(
    IN p_id_proveedor INT,
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(150)
)
BEGIN
    -- Verificar si ya existe un proveedor con la misma id
    IF EXISTS (SELECT 1 FROM Proveedores WHERE id_proveedor = p_id_proveedor) THEN
        SET nResultado = -1; 
        SET cMensaje = 'Ya existe un proveedor con la misma id';
    -- Verificar si ya existe un proveedor con el mismo nombre
    ELSE
		IF EXISTS (SELECT 1 FROM Proveedores WHERE nombre = p_nombre) THEN
			SET nResultado = -1; 
			SET cMensaje = 'Ya existe un proveedor con el mismo nombre';
		ELSE
			-- Insertar el nuevo proveedor
			INSERT INTO Proveedores (id_proveedor, nombre) 
			VALUES (p_id_proveedor, p_nombre);
			SET nResultado = 0; 
			SET cMensaje = 'Proveedor insertado con éxito';
		END IF;
    END IF;
END