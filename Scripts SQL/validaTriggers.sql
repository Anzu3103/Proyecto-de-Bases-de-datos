--====================================================
--Nombre: validaTriggers.sql
-- Autor: Pedraza Martínez José Alberto, 
--		Santos Martínez Daniela                                              
--		Suxo Pacheco Elsa Guadalupe
--		Velázquez de León Lavarrios Alvar
--Descripción: recopilación de triggers a utilizar. Contiene código para
-- validar el funcionamiento de cada uno
--Fecha de elaboración: 30/05/2020
--====================================================

use Proyecto
go


--====================================================
--Nombre: persona.tgInsertDomicilio
--====================================================

-- Escenario
select * from persona.USUARIO
select * from persona.DOMICILIO
go

--intentando agregar otro domicilio como principal
begin tran
	insert into persona.DOMICILIO values
	('Calle1','1','Colonia1','Alcaldia1',1,1)
rollback tran

--agregando otro domicilio sin ser principal
begin tran
	insert into persona.DOMICILIO values
	('Calle2','2','Colonia2','Alcaldia2',0,1)
rollback tran

--====================================================
--Nombre: persona.tgUpdateDomicilio
--====================================================

-- Escenario
select * from persona.USUARIO
go
--Mostrando como se actualiza
begin tran
	select * from persona.DOMICILIO where claveUsuario=20
	update persona.DOMICILIO
		set principal=1 where claveDomicilio=2 
	select * from persona.DOMICILIO where claveUsuario=20
rollback tran


--====================================================
--Nombre: venta.tgValidacompraPU	
--====================================================

-- Escenario
select * from persona.USUARIO
select * from venta.compraPagina
select * from venta.COMPRA
go

--checando si el usuario está registrado para comprar
begin tran
	insert into venta.compraPagina 
		values ('CAMION',30,1)
rollback tran

--====================================================
--Nombre: catalogo.tgInsertCategoria
--====================================================

-- Escenario
select * from catalogo.CATEGORIA
go

--verificando que no haya doble categoría al insertar
begin tran
	insert into catalogo.CATEGORIA values
		(null, 'ALIMENTOS','Catálogo de alimentos')
rollback tran

--====================================================
--Nombre: catalogo.tgUpdateCategoria
--====================================================

-- Escenario
select * from catalogo.CATEGORIA
go

--verificando que no haya doble categoría al actualizar
begin tran
	update catalogo.CATEGORIA
		set nombre='ALIMENTOS'
		where claveCategoria=4
rollback tran

--tratando de hacer redundancia
begin tran
	update catalogo.CATEGORIA
		set claveSubcategoria=4
		where claveCategoria=4
rollback tran


--====================================================
--Nombre: venta.tgvalidaCompraTienda
--====================================================

-- Escenario
select * from venta.COMPRA
select * from venta.compraTienda
go
--Correcta ejecución
begin tran
	insert into venta.COMPRA (fechaCompra, montoTotal, IVA, tipoCompra) 
	values ('2019-07-07',0,5,'T') --31
rollback tran

--No permite el insert
begin tran
	insert into venta.compraTienda (comisionTotal, claveCompra, claveUsuario) 
	values (23,31,2)
rollback tran

--====================================================
--Nombre: venta.tgvalidaCesta
--====================================================

-- Escenario
select * from persona.USUARIO
select * from persona.tipoUsuario where claveUsuario=3
select * from venta.guarda

go
--intentando guardar en cesta siendo vendedor
begin tran
	insert into venta.guarda values
	(3,3)
rollback tran

--====================================================
--Nombre: venta.ManejoStockInsert
--====================================================

--Probando
--Suponiendo que alguien de repente pide mucho producto
begin tran
	select * from venta.almacenProducto where claveProducto=1
	select * from venta.tiendaProducto where claveProducto=1
	insert into venta.compraProducto
		values(1,2,100,5)
	select * from venta.almacenProducto where claveProducto=1
	select * from venta.tiendaProducto where claveProducto=1
rollback tran

--Mensaje de advertencia de bajo stock
begin tran
	select * from venta.almacenProducto where claveProducto=1
	select * from venta.tiendaProducto where claveProducto=1
	insert into venta.compraProducto
		values(1,2,45,5)
	select * from venta.almacenProducto where claveProducto=1
	select * from venta.tiendaProducto where claveProducto=1
rollback tran


--====================================================
--Nombre: venta.ManejoStockUdate
--====================================================

select * from venta.compraProducto where claveCompra=1 and claveProducto=1

--Probando, funciona similar al trigger anterior
begin tran
	select * from venta.tiendaProducto where claveProducto=1
	update venta.compraProducto set cantidad=45 
		where claveCompra=1 and claveProducto=1
	select * from venta.tiendaProducto where claveProducto=1
rollback tran


--====================================================
--Nombre: venta.manejoStockDelete
--====================================================


go

--Probando
--Si se quita una compra, se anula y regresa la cantidad al stock
begin tran
	select * from venta.tiendaProducto 
		where claveProducto=1 
	select * from venta.compraProducto 
		where claveProducto=1 and claveCompra=1

	delete venta.compraProducto 
		where claveProducto=1 and claveCompra=1

	select * from venta.tiendaProducto
		where claveProducto=1 
rollback