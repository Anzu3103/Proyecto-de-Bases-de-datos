-- ==================================================================
-- Nombre: Pruebas_lenguajeProcedural.sql
-- Autor: Pedraza Martínez José Alberto, 
--		Santos Martínez Daniela                                              
--		Suxo Pacheco Elsa Guadalupe
--		Velázquez de León Lavarrios Alvar
-- Fecha: 31 de mayo de 2020
-- Descripción: script para ejecutar las pruebas de cada objeto creado
-- ==================================================================

use Proyecto
go

-- =============================== Vistas =======================================


--====================================================
--Nombre: persona.visProductosUsuLinea
--Descripción: Vista que obtiene todos los productos que 
--los usuarios han comprado por linea
--Fecha de elaboración: 30/05/2020
--====================================================

-- Escenario
select * from persona.USUARIO
select * from venta.compraPagina
select * from venta.compraProducto
select * from catalogo.PRODUCTO
go

select * from persona.visProductosUsuLinea
go


--====================================================
--Nombre: persona.visOfertaProductos
--Descripción: Vista que muestra para todos los usuario 
--suscritos a un producto, las ofertas que existan
--Fecha de elaboración: 30/05/2020
--====================================================

-- Escenario
select * from persona.USUARIO
select * from venta.suscribe
select * from catalogo.PRODUCTO
select * from venta.incluye
select * from catalogo.OFERTA
go


select * from persona.visOfertaProductos
go

--====================================================
--Nombre: persona.visTiendaStockProducto
--Descripción: Vista que muestra los productos disponibles
--en tiendas físicas
--Fecha de elaboración: 30/05/2020
--====================================================

-- Escenario
select * from catalogo.TIENDA
select * from venta.tiendaProducto
select * from catalogo.PRODUCTO
go

select * from venta.visTiendaStockProducto
go


-- =============================== Cursores ====================================


--====================================================
--Nombre: curCestaUsuario
--Descripción: Cursor que muestra el contenido de la cesta de cada usuario,
-- si es que tienen al menos un producto en cesta
--Fecha de elaboración: 30/05/2020
--====================================================
declare @claveUsuario int,
		@promMonto int,
		@nombre varchar(40),
		@paterno varchar(40),
		@materno varchar(40),
		@claveProducto int,
		@nombreProd varchar(40)

declare curCestaUsuario cursor
--se va a barrer únicamente a los usuarios que tengan al menos un producto en cesta
for (select u.claveUsuario, nombre, paterno, materno, claveProducto from persona.USUARIO u
		inner join venta.guarda g
		on u.claveUsuario=g.claveUsuario)
open curCestaUsuario
	--posicionandonos en el primer registro
	fetch curCestaUsuario into @claveUsuario, @nombre, @paterno, @materno, @claveProducto
	while @@FETCH_STATUS = 0 --mientras haya registros
	begin
		--se utiliza otro cursor para recorrer los productos coincidentes
		declare curProducto cursor
		for (select nombre from catalogo.PRODUCTO where claveProducto=@claveProducto)
		OPEN curProducto
			--posicionandonos en el primer registros de productos
			fetch curProducto into @nombreProd
			while @@FETCH_STATUS = 0
			begin
				--se muestra parte de los datos de usuario y el producto que tiene en canasta
				select  @claveUsuario as idUsuario, @nombre + @paterno + @materno as NombreCompleto,
					@nombreProd as PRODUCTO
				fetch curProducto into @nombreProd
			end
		CLOSE curProducto
		deallocate curProducto
		fetch curCestaUsuario into @claveUsuario, @nombre, @paterno, @materno, @claveProducto
	end
close curCestaUsuario
deallocate curCestaUsuario
go

-- ========================= Procedimientos Almacenados ========================================

--====================================================
--Nombre: venta.paGuardarEnCesta
--Descripción: procedimiento que guarda productos en la cesta de un usuario
--Fecha de elaboración: 31/05/2020
--====================================================

-- Escenario
select * from catalogo.PRODUCTO
select * from venta.guarda
go

begin tran
	select * from venta.guarda where claveUsuario=16

	exec venta.paGuardarEnCesta 'UsuarioRegistrado1','Xbox Series X'

	select * from venta.guarda where claveUsuario=16
rollback tran


--====================================================
--Nombre: venta.paCompraDesdeCesta
--Descripción: procedimiento que mueve los productos almacenados desde la cesta hacia la compra
--Fecha de elaboración: 31/05/2020
--====================================================

-- Escenario
select * from catalogo.PRODUCTO
select * from venta.guarda
select * from venta.COMPRA
select * from venta.compraProducto
go

begin tran
	select * from venta.guarda where claveUsuario=16
	select * from venta.compraProducto

	exec venta.paCompraDesdeCesta 'usuarioRegistrado1','Queso Lala',31,3

	select * from venta.guarda where claveUsuario=16
	select * from venta.compraProducto
rollback tran
go


--====================================================
--Nombre: BUSCADOR
--Descripción: procedimiento que mostrara una busqueda de productos por parametros
--Fecha de elaboración: 29/05/2020
--====================================================
-- Probando.. 

--Cuando no se tiene una opcion valida
EXEC BUSCADOR 'Z', 'bebidas', null --ejecutando el procedure 

--Cuando no se llena el parametro de busqueda
EXEC BUSCADOR 'S', null, null --ejecutando el procedure 

--Para buscar por la descripcion del producto
EXEC BUSCADOR 'D', '1kg', null --ejecutando el procedure 

--Para buscar por el nombre del producto
EXEC BUSCADOR 'N', 'leche', null --ejecutando el procedure 

--Para buscar por la categoria del producto
EXEC BUSCADOR 'C', 'frutas', null --ejecutando el procedure 

--Para buscar por la subcategoria del producto
EXEC BUSCADOR 'S', 'bebidas', null --ejecutando el procedure 

--Para buscar por la subcategoria del producto con categoria 
EXEC BUSCADOR 'S', 'alimentos', 'lacteos' --ejecutando el procedure 

--Cuando ponemos solo la subcategoria del producto nos descarta otras y es mas especifico 
EXEC BUSCADOR 'S', 'alimentos', null --ejecutando el procedure
go


-- =================== Funciones de Usuario =================================


--====================================================
--Nombre: venta.domicilioDeCompraEnLinea
--Descripción: Con la clave de compra se puede ver el transporte y el domicilio 
-- principal del usuario
--Fecha de elaboración: 31/05/2020
--====================================================

--Se debe introducir de parametro la clave de compra 
select * from venta.domicilioDeCompraEnLinea(21)
go


--====================================================
--Nombre: venta.precios
--Descripción: Mostrara los productos que esten en el intervalo de precios
-- dados, la tienda y el stock en el que se encuentra
--Fecha de elaboración: 31/05/2020
--====================================================

--Se debe introducir de parametro los intervalos de precio
select * from venta.precios(20, 25)
go

-- ==================== MANEJO DE ERRORES ====================
--Caso: insertar datos duplicados en columnas que conforman llave primaria

begin try
insert into venta.incluye (claveOferta,claveProducto)
	values (1,14), (1,14)
end try
begin catch
	if @@ERROR=2627
		print 'Error al insertar, se tratan de datos duplicados'
end catch