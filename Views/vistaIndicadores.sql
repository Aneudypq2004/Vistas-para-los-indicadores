-- 1) Ventas Totales por Período (Año y Mes)
CREATE VIEW DWH.VentasTotalesPorPeriodo AS
SELECT 
    YEAR(O.FechaOrden) AS Año,
    MONTH(O.FechaOrden) AS Mes,
    SUM(DP.Cantidad * DP.Precio) AS VentasTotales
FROM Ordenes O
JOIN DetallesDelPedido DP ON O.OrdenID = DP.OrdenID
GROUP BY YEAR(O.FechaOrden), MONTH(O.FechaOrden);
GO

-- 2) Ventas por Categoría de Producto
CREATE VIEW DWH.VentasPorCategoriaProducto AS
SELECT 
    C.NombreCategoria AS Categoria,
    SUM(DP.Cantidad * DP.Precio) AS VentasTotales
FROM DetallesDelPedido DP
JOIN Productos P ON DP.ProductoID = P.ProductoID
JOIN Categorias C ON P.CategoriaID = C.CategoriaID
GROUP BY C.NombreCategoria;
GO

-- 3) Total de Ventas por Categoría
CREATE VIEW DWH.TotalVentasPorCategoria AS
SELECT 
    C.NombreCategoria AS Categoria,
    SUM(DP.Cantidad * DP.Precio) AS VentasTotales
FROM Productos P
JOIN Categorias C ON P.CategoriaID = C.CategoriaID
JOIN DetallesDelPedido DP ON P.ProductoID = DP.ProductoID
GROUP BY C.NombreCategoria;
GO

-- 4) Ventas por Región/País
CREATE VIEW DWH.VentasPorRegion AS
SELECT 
    R.NombreRegion AS Region,
    SUM(DP.Cantidad * DP.Precio) AS VentasTotales
FROM Ordenes O
JOIN Clientes CL ON O.ClienteID = CL.ClienteID
JOIN EmpleadoTerritorio ET ON ET.EmpleadoID = O.ClienteID -- Asumiendo relación
JOIN Territorios T ON ET.TerritorioID = T.TerritorioID
JOIN Regiones R ON T.RegionID = R.RegionID
JOIN DetallesDelPedido DP ON O.OrdenID = DP.OrdenID
GROUP BY R.NombreRegion;
GO

-- 5) Número de Pedidos Procesados por Empleado
CREATE VIEW DWH.NumeroPedidosPorEmpleado AS
SELECT 
    E.NombreEmpleado,
    COUNT(O.OrdenID) AS NumeroDePedidos
FROM Empleados E
JOIN Ordenes O ON E.EmpleadoID = O.ClienteID
GROUP BY E.NombreEmpleado;
GO

-- 6) Productividad de Empleados (Ventas por Empleado)
CREATE VIEW DWH.VentasPorEmpleado AS
SELECT 
    E.NombreEmpleado,
    SUM(DP.Cantidad * DP.Precio) AS VentasTotales
FROM Empleados E
JOIN Ordenes O ON E.EmpleadoID = O.ClienteID
JOIN DetallesDelPedido DP ON O.OrdenID = DP.OrdenID
GROUP BY E.NombreEmpleado;
GO

-- 7) Clientes Atendidos por Empleado
CREATE VIEW DWH.ClientesAtendidosPorEmpleado AS
SELECT 
    E.NombreEmpleado,
    COUNT(DISTINCT O.ClienteID) AS NumeroClientes
FROM Empleados E
JOIN Ordenes O ON E.EmpleadoID = O.ClienteID
GROUP BY E.NombreEmpleado;
GO

-- 8) Productos Más Vendidos
CREATE VIEW DWH.ProductosMasVendidos AS
SELECT 
    P.NombreProducto,
    SUM(DP.Cantidad) AS CantidadVendida
FROM DetallesDelPedido DP
JOIN Productos P ON DP.ProductoID = P.ProductoID
GROUP BY P.NombreProducto
ORDER BY CantidadVendida DESC;
GO

-- 9) Productos Más Vendidos por Categoría
CREATE VIEW DWH.ProductosMasVendidosPorCategoria AS
SELECT 
    C.NombreCategoria,
    P.NombreProducto,
    SUM(DP.Cantidad) AS CantidadVendida
FROM DetallesDelPedido DP
JOIN Productos P ON DP.ProductoID = P.ProductoID
JOIN Categorias C ON P.CategoriaID = C.CategoriaID
GROUP BY C.NombreCategoria, P.NombreProducto
ORDER BY C.NombreCategoria, CantidadVendida DESC;
GO

-- 10) Total de Ventas por Transportista
CREATE VIEW DWH.TotalVentasPorTransportista AS
SELECT 
    T.NombreTransportista,
    SUM(DP.Cantidad * DP.Precio) AS VentasTotales
FROM Ordenes O
JOIN Transportistas T ON O.TransportistaID = T.TransportistaID
JOIN DetallesDelPedido DP ON O.OrdenID = DP.OrdenID
GROUP BY T.NombreTransportista;
GO

-- 11) Número de Órdenes Enviadas por Transportista
CREATE VIEW DWH.NumeroOrdenesPorTransportista AS
SELECT 
    T.NombreTransportista,
    COUNT(O.OrdenID) AS NumeroOrdenes
FROM Ordenes O
JOIN Transportistas T ON O.TransportistaID = T.TransportistaID
GROUP BY T.NombreTransportista;
GO

-- 12) Total de Ventas por Cliente
CREATE VIEW DWH.TotalVentasPorCliente AS
SELECT 
    C.NombreCliente,
    SUM(DP.Cantidad * DP.Precio) AS VentasTotales
FROM Ordenes O
JOIN Clientes C ON O.ClienteID = C.ClienteID
JOIN DetallesDelPedido DP ON O.OrdenID = DP.OrdenID
GROUP BY C.NombreCliente;
GO

-- 13) Número de Órdenes por Cliente
CREATE VIEW DWH.NumeroOrdenesPorCliente AS
SELECT 
    C.NombreCliente,
    COUNT(O.OrdenID) AS NumeroOrdenes
FROM Ordenes O
JOIN Clientes C ON O.ClienteID = C.ClienteID
GROUP BY C.NombreCliente;
GO
