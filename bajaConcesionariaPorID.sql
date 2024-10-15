CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaConcesionariaPorID`(
    IN p_id_concesionaria INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verifica si el concesionario ya existe y lo borra
    IF EXISTS (SELECT 1 FROM concesionaria WHERE id_concesionaria = p_id_concesionaria) THEN
    
        SET nResultado = 0;
        SET cMensaje = 'se borro correctamente';
        
        delete from concesionaria where id_concesionaria = p_id_concesionaria;
        
    ELSE
        -- sino da mensaje de que no existe
        SET nResultado = -1;
        SET cMensaje = 'Concesionario ingresado no existe';
        
    END IF;
END