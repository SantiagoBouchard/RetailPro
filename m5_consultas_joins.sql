
-- PRE-ENTREGA 5: 




-- Consulta 1: (INNER JOIN)
-- Propósito: Cruzar la tabla de ventas con las tablas de dimensiones 

SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS ciudad_cliente,
    p.nombre_producto,
    cat.nombre_categoria AS categoria_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Unifica transacciones, clientes, productos 
-- y categorías en una sola estructura, quedando lista como tabla 
-- de hechos optimizada para los reportes de Power BI.



-- Consulta 2: (LEFT JOIN)
-- Propósito: Identificar clientes registrados que nunca han realizado ninguna 
-- compra para que el área de CRM pueda contactarlos con campañas comerciales.


SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 de los 5 clientes registrados se encuentran sin compras; 
-- el 100% de la base actual de clientes ya registra al menos un pedido.



-- Consulta 3: (LEFT JOIN)
-- Propósito: Identificar artículos del catálogo que no tienen ninguna venta registrada. 

SELECT 
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio,
    p.stock
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;

-- Hallazgo: 0 artículos del catálogo actual se encuentran sin movimiento 
-- comercial, ya que todos los productos registrados en la tabla (del 1 al 6)  poseen al menos una venta asociada.



-- Consulta 4: (UNION ALL)
-- Propósito: Simular la unión de ventas de dos canales o periodos distintos 
-- agregando una etiqueta literal y agruparlas para comparar su rendimiento total.


SELECT 
    canal, 
    SUM(total) AS total_canal
FROM (
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Online' AS canal
    FROM ventas 
    WHERE fecha_venta < '2024-03-12'
    
    UNION ALL
    
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Presencial' AS canal
    FROM ventas 
    WHERE fecha_venta >= '2024-03-12'
) AS consolidado
GROUP BY canal;

-- Hallazgo: El periodo categorizado como "Online" concentra el 56% de la 
-- facturación frente al 44% del periodo "Presencial".
