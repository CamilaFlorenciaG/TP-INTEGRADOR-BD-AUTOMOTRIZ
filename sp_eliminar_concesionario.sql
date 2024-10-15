CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_concesionario`(
    IN p_id_concesionario INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET nResultado = -1;
        SET cMensaje = 'Error al intentar eliminar el concesionario.';
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_exists FROM Concesionaria WHERE id_concesionaria = p_id_concesionario;

    IF v_exists = 0 THEN
        SET nResultado = -2;
        SET cMensaje = 'El concesionario no existe.';
        ROLLBACK;
    ELSEIF EXISTS (SELECT 1 FROM Ventas_Realizadas WHERE concesionaria_id_concesionaria = p_id_concesionario) THEN
        SET nResultado = -3;
        SET cMensaje = 'No se puede eliminar el concesionario porque tiene ventas asociadas.';
        ROLLBACK;
    ELSE
        DELETE FROM Concesionaria WHERE id_concesionaria = p_id_concesionario;

        SET nResultado = 0;
        SET cMensaje = '';
        COMMIT;
    END IF;
END