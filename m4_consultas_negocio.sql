USE Ventas_tech_DB;
--CONSULTA 1
SELECT 
	MONTH(fecha_venta) AS mes,
	SUM(cantidad * precio_unitario) AS total_facturado,
	COUNT(id_venta) AS ventas_totales,
	AVG(cantidad * precio_unitario) AS ticket_promedio
	FROM ventas
	GROUP BY MONTH(fecha_venta)
	;

--CONSULTA 2
SELECT TOP 5 id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
;

--CONSULTA 3
SELECT id_cliente,
COUNT(id_venta) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
;

--CONSULTA 4
WITH FacturacionPorProducto AS (
    SELECT 
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto)
SELECT 
    id_producto,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM FacturacionPorProducto) 
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS etiqueta_promedio
FROM FacturacionPorProducto
ORDER BY total_facturado DESC
;

--  El producto con id 1 es el que mayor facturación individual genera con un total de $3600
--  Todos los clientes que realizaron compras en el período ya habia realizado una venta anteriormente, ya que cada uno registra exactamente 2 pedidos.
--  Los productos 1 y 3 se encuentran "Por encima" del promedio general de facturación por producto.
