CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificar_concesionario`(
    IN p_id_concesionario INT,
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
        SET cMensaje = 'Error al intentar modificar el concesionario.';
        ROLLBACK;
    END;

    START TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM Concesionaria WHERE id_concesionaria = p_id_concesionario) THEN
        SET nResultado = -2;
        SET cMensaje = 'El concesionario no existe.';
        ROLLBACK;
    ELSE
        UPDATE Concesionaria
        SET nombre = p_nombre,
            terminal_automotriz_id_terminal = p_terminal_id,
            direccion = p_direccion
        WHERE id_concesionaria = p_id_concesionario;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END