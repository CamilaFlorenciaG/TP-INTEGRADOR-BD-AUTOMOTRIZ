CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_proveedor`(
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar insertar el proveedor.';
        ROLLBACK;
    END;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM Proveedores WHERE nombre = p_nombre) THEN
        SET nResultado = -2;
        SET cMensaje = 'El proveedor ya existe.';
        ROLLBACK;
    ELSE
        INSERT INTO Proveedores (nombre)
        VALUES (p_nombre);

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END