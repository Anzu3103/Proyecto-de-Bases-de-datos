-- ==================================================================
-- Nombre: informes.sql
-- Autor: Pedraza Martínez José Alberto, 
--		Santos Martínez Daniela                                              
--		Suxo Pacheco Elsa Guadalupe
--		Velázquez de León Lavarrios Alvar
-- Fecha: 31 de mayo de 2020
-- Descripción: muestra informes de estadísticas mediante procedimientos almacenados
-- ==================================================================

-- =============== Estadísticas realizadas con procedimientos almacenados ======================


-- ==================================================================
-- Nombre: pusuMejorVendedor
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra qué vendedor realiza más ventas en un periodo de tiempo
-- ==================================================================

--Probamos el procedimiento
execute pusuMejorVendedor '2016-01-01','2020-01-04'
GO


-- ==================================================================
-- Nombre: pusuConMasVentas
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra en qué épocas se realizan más ventas
-- ==================================================================

--Prueba
execute pusuConMasVentas 2020,3
Go


-- ==================================================================
-- Nombre: pusuProductoComprado
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra qué productos son los más comprados
-- ==================================================================

--Prueba
execute pusuProductoComprado '2019-01-01', '2020-02-01',3
Go


-- ==================================================================
-- Nombre: pusuMedioDeMayorVenta
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra por qué medio se realizan más ventas (internet o físico)
-- ==================================================================

--Prueba
execute pusuMedioDeMayorVenta '2019-01-01', '2020-01-01'
go
