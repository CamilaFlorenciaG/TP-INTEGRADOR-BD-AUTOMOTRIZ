CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_concesionario`(
    IN p_nombre VARCHAR(45),
    IN p_terminal_id INT,
    IN p_direccion VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar insertar el concesionario.';
        ROLLBACK;
    END;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM Concesionaria WHERE nombre = p_nombre AND direccion = p_direccion) THEN
        SET nResultado = -2;
        SET cMensaje = 'El concesionario ya existe.';
        ROLLBACK;
    ELSE
        INSERT INTO Concesionaria (nombre, terminal_automotriz_id_terminal, direccion)
        VALUES (p_nombre, p_terminal_id, p_direccion);

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END