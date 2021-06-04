--====================================================
--Nombre: dml.sql
--Autor: Pedraza Martínez José Alberto, 
--		Santos Martínez Daniela                                              
--		Suxo Pacheco Elsa Guadalupe
--		Velázquez de León Lavarrios Alvar
--Descripción: instrucciones que conforman al DML
-- (triggers, procedimientos almacenados, cursores, vistas, etc.)
--Fecha de elaboración: 30/05/2020
--====================================================

use Proyecto
go

-- ============================= Triggers ==================================


--====================================================
--Nombre: persona.tgInsertDomicilio
--Descripción: trigger que revisa que solo haya un domicilio 
-- principal al insertar
--Fecha de elaboración: 29/05/2020
--====================================================
create or alter trigger persona.tgInsertDomicilio
on persona.DOMICILIO
instead of insert --debe ser revisado antes de insertar
as
begin
	declare @nuevoPrincipal bit, --variables 
		@claveUsuario int
	select @nuevoPrincipal=principal, @claveUsuario=claveUsuario from inserted;
	--si existe un domicilio de un usuario especifico con un domicilio ya principal
	if exists (select * from persona.DOMICILIO where principal=@nuevoPrincipal 
		and claveDomicilio=@claveUsuario and @nuevoPrincipal=1)
		begin
			print 'No se puede insertar. Ya existe domicilio principal'
			print 'Para cambiar a otro principal, actualiza una vez ingresado'
		end
	--si se trata de otro domicilio no principal, agregar
	else
	begin
		insert into persona.DOMICILIO 
			select calle, numero, colonia, alcaldia, principal, claveUsuario from inserted;
		print 'Domicilio insertado exitosamente.'
	end
end
go


--====================================================
--Nombre: persona.tgUpdateDomicilio
--Descripción: trigger que verifica que solo haya un domicilio
-- principal al actualizar
--Fecha de elaboración: 29/05/2020
--====================================================
create or alter trigger persona.tgUpdateDomicilio
on persona.DOMICILIO
after UPDATE --después de la actualizacion, hay que "apagar" el anterior Principal
as
begin
	declare @principal bit, --variables
		@claveDomicilio int,
		@claveUsuario int
	select @principal=principal, @claveDomicilio=claveDomicilio,
		@claveUsuario=claveUsuario from inserted

	--si cambió de domicilio principal, los demás colocarlos en 0
	if @principal=1
	begin
		update persona.DOMICILIO set principal=0 
			where claveUsuario=@claveUsuario and claveDomicilio!=@claveDomicilio
		print 'Actualizado domicilio principal.'
	end
end
go


--====================================================
--Nombre: venta.tgValidacompraPU	
--Descripción: trigger que valida que el usuario exista antes
-- de insertar (adquirir producto en linea)
--Fecha de elaboración: 29/05/2020
--====================================================
create or alter trigger venta.tgValidacompraPU
on venta.compraPagina 
instead of insert --solo lo podrá insertar si existe por eso se revisa
as
begin
	declare @claveUsuario int --variable

	select @claveUsuario=claveUsuario from inserted
	--Si la claveUsuario no existe en usuario, no se agrega a la tabla
	if @claveUsuario not in (select claveUsuario from persona.USUARIO)
	begin
		print 'Debe ser usuario registrado para adquirir por internet'
		print 'No se registra'
	end
	else --si existe, procede la inserción
	begin
		insert into venta.compraPagina
			select tipoTransporte,claveUsuario,claveCompra from inserted;
	end
end
go


--====================================================
--Nombre: catalogo.tgInsertCategoria
--Descripción: trigger que valida que no se inserten categorías de productos ya existentes
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter trigger catalogo.tgInsertaCategoria
on catalogo.CATEGORIA
instead of insert --solo lo podrá insertar si no existe
as
begin
	declare @nombre varchar(40)

	select @nombre=nombre from inserted
	--Si ya existe una categoria con ese nombre, no se inserta
	if exists (select * from catalogo.CATEGORIA where nombre=@nombre)
	begin
		print 'No se puede insertar. Ya existe esa categoría'
	end
	else --si no existe, procede la inserción
	begin
		insert into catalogo.CATEGORIA
			select claveSubcategoria, nombre, descripcion from inserted;
	end
end
go


--====================================================
--Nombre: catalogo.tgUpdateCategoria
--Descripción: trigger que valida que no se repitan categorías de productos ya existentes
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter trigger catalogo.tgActualizaCategoria
on catalogo.CATEGORIA
instead of update --solo lo podrá actualizar si no se repiten nombres
as
begin
	declare @claveCategoria int,
			@claveSubctegoria int,
			@nombre varchar(40),
			@descripcion varchar(50)

	select @nombre=nombre, @claveSubctegoria=claveSubcategoria, @claveCategoria=claveCategoria from inserted

	-- No se puede tener una categoría cuya categoría padre sea la misma categoría
	if @claveCategoria=@claveSubctegoria
	begin
		print 'No se puede actualizar. La categoria no puede tener como padre la misma categoria'
	end
	else
	begin
		-- Si ya existe una categoria con ese nombre, pero es sobre el catalogo a actualizar, se realiza
		if exists (select * from catalogo.CATEGORIA where nombre=@nombre) 
		AND @claveCategoria=(select claveCategoria from catalogo.CATEGORIA where nombre=@nombre)
		begin
			select @claveCategoria=claveCategoria, @claveSubctegoria=@claveSubctegoria, @nombre=nombre, 
			@descripcion=descripcion from inserted

			update catalogo.CATEGORIA
			set claveSubcategoria=@claveSubctegoria, nombre=@nombre, descripcion=@descripcion
			where claveCategoria=@claveCategoria
		end
		-- Si ya existe una categoria con ese nombre, no se actualiza
		else if exists (select * from catalogo.CATEGORIA where nombre=@nombre) 
		AND @claveCategoria<>(select claveCategoria from catalogo.CATEGORIA where nombre=@nombre)
		begin
			print 'No se puede actualizar. Ya existe otro registro con ese nombre'
		end
	end
end
go


--====================================================
--Nombre: venta.tgvalidaCompraTienda
--Descripción: trigger que valida que exista por lo menos un producto en una venta (compraTienda)
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter trigger venta.tgvalidaCompraTienda
on venta.compraTienda
instead of insert --solo se podrá insertar si en una compra hay por lo menos un producto
as
begin
	declare @claveCompra int,
			@tipoCompra char(1)

	select @claveCompra=claveCompra from inserted
	select @tipoCompra=tipoCompra from venta.COMPRA where claveCompra=@claveCompra

	-- Si existe por lo menos un producto que vendió desde la tienda, se agrega
	if exists(select * from venta.compraProducto where claveCompra=@claveCompra) AND @tipoCompra='T'
	begin
		print 'Venta realizada'
		insert into venta.compraTienda select comisionTotal, claveCompra, claveUsuario from inserted
	end
	else
		print 'No se pudo confirmar la venta. No hay productos o el tipo de compra no es de tipo Tienda'
end
go


--====================================================
--Nombre: venta.tgvalidaCesta
--Descripción: trigger que valida que exista solo los usuarios registrados (R) puedan 
-- guardar en la cesta
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter trigger venta.tgvalidaCesta
on venta.guarda
instead of insert --solo se podrán insertar los usuarios registrados
as
begin
	declare @claveUsuario int,
			@tipoUsuario char(1)

	select @claveUsuario=claveUsuario from inserted
	select @tipoUsuario=tipoUsuario from persona.tipoUsuario where claveUsuario=@claveUsuario

	if @tipoUsuario='R'
		insert into venta.guarda select claveProducto, claveUsuario from inserted
	else
		print 'Permiso denegado. Solo se puede guardar en la cesta si es un usuario registrado'

end
go


--====================================================
--Nombre: venta.ManejoStockInsert
--Descripción: trigger que valida que al insertar un producto en una compra
-- se actualice de stock y re-orden
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter trigger venta.ManejoStockInsert
on venta.compraProducto	--El trigger es para la tabla compraTienda
instead of insert	--Es instead of debido a que si no hay suficiente stock no se va a insertar
as
begin
	--Se declaran las variables que se van a utilizar 
	declare 
			@claveCompra int,--Se utilizara para obtener el tipo de compra en una consulta
			@claveProducto int,--Se utilizará Para saber cual es el producto al que se le actualizará el stock
			@cantidad int,	--Se utilizará para restarlo al stock
			@precio money,	--Se utilizará en el update
			@tipoCompra char(1),--Se utilizará para saber si actualizar el stock de la tienda o almacen
			@stock int,	--Variable para obtener el stock actual
			@nuevoStock int	--El stock calculado

	--Se asignan los valores de la tabla inserted
	select @claveCompra=claveCompra from inserted
	select @claveProducto=claveProducto from inserted
	select @cantidad=cantidad from inserted
	select @precio=precio from inserted
	--Se obtiene el tipo de compra de la tabla compra
	select @tipoCompra=tipoCompra from venta.COMPRA where claveCompra=@claveCompra

	--Dependiendo del tipo de compra se actualizrá el stock del almacen o de la tienda
	if @tipoCompra='T'
	begin
		--Calculamos el stock
		select @stock=stock from venta.tiendaProducto where claveProducto=@claveProducto 
		select @nuevoStock=@stock-@cantidad
		
		--Si el stock es menor a 0 significa que no hay productos suficientes y manda un mensaje
		if @nuevoStock<0
		Begin
			print 'No es posible agregar este producto a la compra debido a que no suficiente stock'
		end
		else
		begin
			if @nuevoStock is null	--Si es null significa que no hay un stock registrado
			begin
				print'No hay un stock registrado en la tienda para este producto'
			end
			else
			begin
				--Como si hay stock suficiente se inserta en compraProducto y se actualiza el stock
				insert into venta.compraProducto
				values(@claveProducto,@claveCompra,@cantidad,@precio)
				update venta.tiendaProducto set stock=@nuevoStock where claveProducto=@claveProducto
				--Si el stock final es igual o menor a 5 significa que se tienen que pedir más productos
				if(@nuevoStock<=5)
				begin
					print 'Stock bajo, se necesita pedir más productos'
				end
			end
		end
	end
	--Es el mimso procedimiento pero para el almacen
	if @tipoCompra='P'
	begin
		--Se calcula el stock resultante		
		select @stock=stock from venta.almacenProducto where claveProducto=@claveProducto 
		select @nuevoStock=@stock-@cantidad
		--Si es menor a 0 signifca que no hay productos suficientes
		if @nuevoStock<0
		Begin
			--Se manda el mensaje
			print 'No es posible agregar este producto a la compra debido a que no suficiente stock'
		end
		else
		--Significa que si hay stock suficiente
		begin
			if @nuevoStock is null	--Si es null significa que no hay un stock registrado
			begin
				print 'No hay un stock registrado para este producto en el almacen'
			end
			else
			begin
				--Se inserta en la tabla compraProducto
				insert into venta.compraProducto
				values(@claveProducto,@claveCompra,@cantidad,@precio)
			
				--Se actualiza el stock
				update venta.almacenProducto set stock=@nuevoStock where claveProducto=@claveProducto
				if(@nuevoStock<=5)
				begin
					print 'Stock bajo, se necesita pedir más productos'
				end
			end
		end
	end
	
end
Go


--====================================================
--Nombre: venta.ManejoStockUdate
--Descripción: trigger que valida que al actualizar un producto en una compra
-- se actualice de stock y re-orden
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter trigger venta.ManejoStockUdate
on venta.compraProducto	--La tabla compraProducto es la que tiene la cantidad de producto de la compra
instead of update	--Es instead debido a que si no hay suficiente producto no se va a actualizar
as
begin
	if update(cantidad)	--Sólo si se actualiza el campo de cantidad
	begin
		--Se declaran las variables que se van a actualizar
		declare
		@cantidad int,--
		@nuevaCantidad int,
		@stock int,--
		@nuevoStock int,--
		@claveProducto int,--
		@claveCompra int,--
		@tipoCompra char(1)--
	
		--Se asignan los valores de la tabla inserted
		select @claveProducto=claveProducto from inserted
		select @claveCompra=claveCompra from inserted
		select @nuevaCantidad=cantidad from inserted
		
		--Se obtiene el tipo de compra
		select @tipoCompra=tipoCompra from venta.compra where @claveCompra=claveCompra
			
		--Dependiendo del tipo de compra se verificará el stock en la tienda o en el almacen
		if @tipoCompra='T'
		begin
			--Se calcula el stock final
			select @stock=stock from venta.tiendaProducto where claveProducto=@claveProducto
			--Se obtiene la cantidad que esta actualmente
			select @Cantidad=cantidad from venta.compraProducto where claveCompra=@claveCompra and claveProducto=@claveProducto
			--El nuevo stock es la suma con la diferencia entre la cantidad actual y la que se quiere poner
			select @nuevostock=@stock+(@cantidad-@nuevaCantidad)
			
			--Si es menor a cero no se puede actualizar 
			if @nuevoStock<0
			begin
				print 'No se puede actualizar debido a que no hay suficiente cantidad de producto'
			end
			--Si es cero o mayor si hay suficientes productos y se puede actualizar
			else
			begin
				--
				if @nuevoStock is null	--Si es null significa que no hay un stock registrado
				begin
					print 'No hay un stock registrado para este producto en la tienda'
				end
				else
				begin
					--Como si hay stock suficiente se actualiza en compraProducto y se actualiza el stock
					update venta.compraProducto set cantidad=@nuevaCantidad where claveCompra=@claveCompra and claveProducto=@claveProducto
					update venta.tiendaProducto set stock=@nuevoStock where claveProducto=@claveProducto
					--Si el stock final es igual o menor a 5 significa que se tienen que pedir más productos
					if(@nuevoStock<=5)
					begin
						print 'Stock bajo, se necesita pedir más productos'
					end
				end
			end
		end
		--Es el mismo procedimento que en la tienda pero para el almacen
		if @tipoCompra='p'
		begin
			--Se calcula el stock final
			select @stock=stock from venta.almacenProducto where claveProducto=@claveProducto
			--Se obtiene la cantidad actual
			select @Cantidad=cantidad from venta.compraProducto where claveCompra=@claveCompra and claveProducto=@claveProducto
			--El nuevo stock es el stock más la diferencia entre la cantidad actual y la nueva
			select @nuevostock=@stock+(@cantidad-@nuevaCantidad)
			--Si es menor a cero no se puede actualizar
			if @nuevoStock<0
			begin
				print 'No se puede actualizar debido a que no hay suficiente cantidad de producto'
			end
			else
			begin
				if @nuevoStock is null
				begin
					print 'No hay un stock registrado en el almacen para este producto'
				end
				else
				begin
					--Como si hay stock suficiente se actualiza en compraProducto y se actualiza el stock
					update venta.compraProducto set cantidad=@nuevaCantidad where claveCompra=@claveCompra and claveProducto=@claveProducto
					update venta.almacenProducto set stock=@nuevoStock where claveProducto=@claveProducto
					--Si el stock final es igual o menor a 5 significa que se tienen que pedir más productos
					if(@nuevoStock<=5)
					begin
						print 'Stock bajo, se necesita pedir más productos'
					end
				end
			end
		end
	end
end
Go


--====================================================
--Nombre: venta.manejoStockDelete
--Descripción: trigger que valida que al eliminar un producto en una compra
-- se actualice de stock y re-orden
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter trigger venta.manejoStockDelete
on venta.compraProducto
for delete	--Es for debido a que siempre se va a poder eliminar
as
begin
	--Declaramos las variables que vamos a utilizar
	declare
	@claveproducto int,
	@clavecompra int,
	@cantidad int,
	@tipoCompra char(1),
	@stock int,
	@nuevoStock int

	--Asignamos los valores de la tabla deleted
	select @claveproducto=claveproducto from deleted
	select @clavecompra=claveCompra from deleted
	select @cantidad=cantidad from deleted
	
	--Obtenemos el tipo de compra
	select @tipoCompra=tipoCompra from venta.COMPRA where claveCompra=@clavecompra

	--Si el tipo de compra es de tipo tienda trabajamos con el stock de la tienda
	if @tipoCompra='T'
	begin
		--calculamos el nuevo stock
		select @stock=stock from venta.tiendaProducto where claveProducto=@claveproducto
		select @nuevoStock=@stock+@cantidad
		
		if @nuevoStock is null	--Significa que no hay un stock registrado para ese producto
		begin
			print'No hay un stock registrado para ese producto en la tienda'
		end
		else
		begin
			--Actualizamos el stock
			update venta.tiendaProducto set stock=@nuevoStock where claveProducto=@claveproducto
		end
	end
	--Si el tipo de stock es de la página trabajamos con el stock del almacen
	if @tipoCompra='P'
	begin
		--calculamos el nuevo stock
		select @stock=stock from venta.almacenProducto where claveProducto=@claveproducto
		select @nuevoStock=@stock+@cantidad
		
		if @nuevoStock is null	--Significa que no hay un stock registrado para ese producto
		begin
			print'No hay un stock registrado para ese producto en el almacen'
		end
		else
		begin
			--Actualizamos el stock
			update venta.tiendaProducto set stock=@nuevoStock where claveProducto=@claveproducto
		end
	end
end
go


-- =============================== Vistas =======================================


--====================================================
--Nombre: persona.visProductosUsuLinea
--Descripción: Vista que obtiene todos los productos que 
--los usuarios han comprado por linea
--Fecha de elaboración: 30/05/2020
--====================================================
CREATE or ALTER VIEW persona.visProductosUsuLinea AS
	select u.usuario as USUARIO, p.nombre as PRODUCTO, cantidad, 
		cprod.precio as precioUnitario from persona.USUARIO u
		inner join venta.compraPagina cp
		on u.claveUsuario=cp.claveUsuario --con esto conseguimos el usuario que compró en línea
		inner join venta.compraProducto cprod
		on cp.claveCompra=cprod.claveCompra --con esto obtenemos el id de la compra del usuario
		inner join catalogo.PRODUCTO p
		on cprod.claveProducto=p.claveProducto --al conseguir el idCompra sabemos los datos del productos
go


--====================================================
--Nombre: persona.visOfertaProductos
--Descripción: Vista que muestra para todos los usuario 
--suscritos a un producto, las ofertas que existan
--Fecha de elaboración: 30/05/2020
--====================================================
CREATE or ALTER VIEW persona.visOfertaProductos as
	select usuario, u.nombre+u.paterno+isnull(u.materno, ' - ') as nombreCompleto, 
		p.nombre as PRODUCTO, o.descripcion as OFERTA , o.tipoOferta as tipo from persona.USUARIO u 
		left join venta.suscribe s
		on u.claveUsuario=s.claveUsuario --como se pide ver de todos los usuarios, se usa left
		left join catalogo.PRODUCTO p
		on s.claveProducto=p.claveProducto --con esto sabemos los productos suscritos
		left join venta.incluye i
		on p.claveProducto=i.claveProducto --vemos si cuentan con oferta
		left join catalogo.OFERTA o
		on i.claveOferta=o.claveOferta --mostramos información de la oferta
go

--====================================================
--Nombre: persona.visTiendaStockProducto
--Descripción: Vista que muestra los productos disponibles
--en tiendas físicas
--Fecha de elaboración: 30/05/2020
--====================================================
CREATE or ALTER VIEW venta.visTiendaStockProducto as
	select t.claveTienda as numTienda, p.nombre as PRODUCTO, stock from catalogo.TIENDA t
		left join venta.tiendaProducto tp
		on t.claveTienda=tp.claveTienda
		left join catalogo.PRODUCTO p
		on tp.claveProducto=p.claveProducto
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


-- ==================================================================
-- Nombre: pusuCrearNuevoUsuario
-- Fecha: 30 de mayo de 2020
-- Descripción: procedimiento almacenado para crear nuevos usuarios, logins y registros en la tabla USUARIO
-- ==================================================================

use Proyecto
go

create or alter procedure pusuCrearNuevoUsuario
	-- Variables para usuario y login
	@nombreUsuario varchar(100),
	@contraseña varchar(100),
    @baseDatos varchar(100),
	@tipoUsuario char(2),

	-- Variables para el registro en la tabla USUARIO
	@sexo char(1),
	@curp varchar(40),
	@email varchar(40),
	@nombre varchar(40),
	@paterno varchar(40),
	@materno varchar(40),
	@fechaCumpleaños datetime,
	@sueldo int,
	@escolaridad varchar(40)
as
begin

	if @tipoUsuario in ('R','V','G')
	begin
		-- Primero se crean el usuario y login correspondientes
		declare @n_nombreUsuario varchar(200)
		declare @n_contraseña varchar(200)
		declare @n_baseDatos varchar(200)
		set @n_nombreUsuario = replace(@nombreUsuario,'''', '''''')
		set @n_contraseña = replace(@contraseña,'''', '''''')
		set @n_baseDatos = replace(@baseDatos,'''', '''''')

		-- Se crea el código a ejecutar automáticamente para la creación del usuario y login
		declare @sql nvarchar(max)
		set @sql = 'use master;' +
			'create login ' + @n_nombreUsuario + ' with password = ''' + @n_contraseña + '''; ' +
			'use ' + @n_baseDatos + ';' +
			'create user ' + @n_nombreUsuario + ' from login ' + @n_nombreUsuario + ';'
		exec (@sql)

		declare @sql2 nvarchar(max)
		-- Ahora se inserta un nuevo registro en la tabla USUARIO
		insert into persona.USUARIO (usuario,sexo,curp,email,contraseña,nombre,paterno,materno,fechaCumpleaños) values
		(@nombreUsuario,@sexo,@curp,@email,@contraseña,@nombre,@paterno,@materno,@fechaCumpleaños)

		-- Si se va a crear un usuario registrado
		if @tipoUsuario='R'
		begin
			print 'Registrado'
			set @sql2 = 'USE ' + @baseDatos + ';' + 'ALTER ROLE registrado ADD MEMBER ' + @nombreUsuario + ';'
			exec (@sql2)

			-- Añadir a la tabla tipoUsuario
			insert into persona.tipoUsuario (tipoUsuario, claveUsuario) values
			('R',(select claveUsuario from persona.USUARIO where usuario=@nombreUsuario))

		end
		-- Si se va a crear un usuario vendedor
		else if @tipoUsuario='V'
		begin
			print 'Vendedor'
			set @sql2 = 'USE ' + @baseDatos + ';' + 'ALTER ROLE vendedor ADD MEMBER ' + @nombreUsuario + ';'
			exec (@sql2)

			-- Añadir a la tabla vendedor
			insert into persona.VENDEDOR (sueldo, claveUsuario) values
			(@sueldo,(select claveUsuario from persona.USUARIO where usuario=@nombreUsuario))

			-- Añadir a la tabla tipoUsuario
			insert into persona.tipoUsuario (tipoUsuario, claveUsuario) values
			('V',(select claveUsuario from persona.USUARIO where usuario=@nombreUsuario))

		end
		-- Si se va a crear un usuario gestor
		else if @tipoUsuario='G'
		begin
			print 'Gestor'
			set @sql2 = 'USE ' + @baseDatos + ';' + 'ALTER ROLE gestor ADD MEMBER ' + @nombreUsuario + ';'
			exec (@sql2)

			-- Añadir a la tabla gestor
			insert into persona.GESTOR(escolaridad, claveUsuario) values
			(@escolaridad,(select claveUsuario from persona.USUARIO where usuario=@nombreUsuario))

			-- Añadir a la tabla tipoUsuario
			insert into persona.tipoUsuario (tipoUsuario, claveUsuario) values
			('G',(select claveUsuario from persona.USUARIO where usuario=@nombreUsuario))

		end
	end
	else
		print 'Opción no válida'
end
go


-- ==================================================================
-- Nombre: pusuMejorVendedor
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra qué vendedor realiza más ventas en un periodo de tiempo
-- ==================================================================
create or alter procedure pusuMejorVendedor

--Definimos los parámetros de entrada y salida

@fechaInicio	date,	--Inicio del periodo del que se quieren obtener las ventas
@fechaFin		date	--Fecha fin del periodo del que se quieren obtener las ventas

as
begin
	--Declaramos las variables que vamos a utilzar
	declare @MaxVenta money		--Se almacenara el valor de la venta máxima para utilizarlo en la consulta y obtener los datos del vendedor


	--Esta tabla sirve para guardar las compras que se encuetran en el intervalo de tiempo
	create table #temCompra
	(claveCompra int,montoTotal money)


	--Se insertan las compras que se encuentran en el periodo de tiempo recibido
	insert into #temCompra(claveCompra, montoTotal)
		select claveCompra, montoTotal from venta.compra
		where fechaCompra>=@fechaInicio and fechaCompra<=@fechaFin	--La condición es que se encuentre en el intervalo de las fechas

	--Primero en una subconsulta se obtiene la suma de las ventas de cada vendedor después
	--se obtiene la suma de ventas mayor y se gurada en la variable llamada maxVenta,
	-- se utilizará para la consulta principal
	select @maxVenta=max(ventaTotal) from	--Se selecciona la suma de ventas mayor y se guarda en la variable maxVenta
		(select sum(c.montoTotal) as VentaTotal from persona.usuario u	--Se suma el monto total de las ventas
		inner join persona.vendedor v		--Se hace un join con vendedor porque ahí se almacenan los que son vendedores	
		on u.claveUsuario=v.claveUsuario
		inner join venta.compraTienda ct	--Se hace un join con compra tienda porque tiene el id de las ventas de cada vendedor
		on ct.claveUsuario=v.claveUsuario	
		inner join #temCompra c				--Se hace un join con la tabla temporal compra porque tiene las ventas del periodo de tiempo recibido		
		on c.claveCompra=ct.claveCompra	
		group by v.claveUsuario) as ventasTotales	--La agrupación se hace mediante la clave usurio para obtener la suma de ventas de cada usuario
	
	--En la consulta principal se utilizan los mismos join pero se muestra la información del vendedor y para saber cual es el que más vendio se compara su suma con la variable maxVenta
	select v.claveUsuario,u.nombre+' '+u.paterno+' '+isnull(u.materno,'') as nombreCompleto,sum(c.montoTotal) as VentaTotal,@fechainicio as FechaInicio, @fechaFin as Fechafin from persona.usuario u
	inner join persona.vendedor v	--unimos con la tabla de vendedor debido a que es la que nos dice cuales usuarios son vendedores
	on u.claveUsuario=v.claveUsuario	
	inner join venta.compraTienda ct	--Unimos con la tabla compraTienda porque tiene las ventas de los vendedores
	on ct.claveUsuario=v.claveUsuario	
	inner join #temCOMPRA c		--Unimos con la tabla temporal compra porque tiene el monto de cada compra en el periodo de tiempo recibido
	on c.claveCompra=ct.claveCompra	
	group by v.claveUsuario,u.nombre,u.paterno,u.materno
	having @MaxVenta=sum(c.montoTotal)	--Comparamos con el valor obtenido del la suma mayor de ventas por vendedor

	drop table #temCompra	--Eliminamos la tabla temporal
end
GO


-- ==================================================================
-- Nombre: pusuConMasVentas
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra en qué épocas se realizan más ventas
-- ==================================================================
create or alter procedure pusuConMasVentas
@year int,	--Año del que se van a obtener  las compras
@top int	--Número de meses que se van a comprar
as
	
	begin
	
	select top (@top) mes as mes,@year as año,sum(montoTotal) as VentaTotal from		--Obtenemos la suma agrupando por mes y usamos top para controlar el numero de resultados
		(select montoTotal as montoTotal, month(fechaCompra) as mes from venta.compra where year(fechaCompra)=@year) as obtenermes	--Subconsulta para obtentener las compras del año dado y el mes de cada una
	group by mes --Agrupar por mes para sumar las compras de cada mes
	order by sum(montoTotal) desc	--Se ordenan de forma descendente para mostrar primero a los que tienen más ventas
	end
GO


-- ==================================================================
-- Nombre: pusuProductoComprado
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra qué productos son los más comprados
-- ==================================================================
create or alter procedure pusuProductoComprado
--Parámetros que se van a recibir
@fechaInicio datetime,	--Fecha de inicio del perido
@fechaFin	datetime,	--Fecha de fin del periodo
@numeroDeProductos int	--Número de productos que se van a mostrar
as

begin
	--Se crea una tabla temporal donde se van a guardar las compras dentro del periodo de tiempo
	create table #temComProducto
	(claveProducto int,cantidad int,precio money)

	--Se insetan las compras que se encuentran en el periodo de tiempo dado
	insert into #temComProducto
		select p.claveProducto,cp.cantidad,cp.precio from catalogo.producto p
		inner join venta.compraProducto cp	--Se hace un join con compraProducto debido a que tiene las ventas donde están los productos
		on p.claveProducto=cp.claveProducto
		inner join venta.COMPRA c		--Se hace un join con compra debido a que tiene la fecha de compra
		on c.claveCompra=cp.claveCompra
		where c.fechaCompra>=@fechaInicio and c.fechaCompra<=@fechaFin	--La condición es que se encuentre entre las fechas dadas
	
	--Se utiliza top y la variable numeroDeProductos para decidir cuantos productos se van a mostrar 
	--para mostrar los más vendidos se debe ordenar por el total de Venta y en orden decendente
	
	select top (@numeroDeProductos) cp.claveProducto, p.nombre,sum(cantidad*cp.precio) as ventaTotal,@fechaInicio as FechaInicio,@fechaFin as FechaFin from #temComProducto cp
	inner join catalogo.PRODUCTO p	--Se hace un join con Producto porque tiene la clave del producto y su nombre
	on p.claveProducto=cp.claveProducto
	group by p.nombre, cp.claveProducto order by sum(cantidad*cp.precio) desc

	drop table #temComProducto	--Se elimina la tabla temporal
end
GO


-- ==================================================================
-- Nombre: pusuMedioDeMayorVenta
-- Fecha: 29 de mayo de 2020
-- Descripción: Muestra por qué medio se realizan más ventas (internet o físico)
-- ==================================================================
create or alter procedure pusuMedioDeMayorVenta
@fechaInicio	date,	--Fecha de inicio del periodo
@fechaFin		date	--Fecha de fin del periodo
as
begin
	declare 
	@ventaTotal money	--Se guradará la máxima para utilizarla en la consulta principal

	--Se crea una tabla temporal para guardar las compras dentro del periodo de tiempo
	create table #temcompra (claveCompra int,montoTotal money,tipoCompra char(1))

	--Se insertan las compras que están dentro entre las fechas en la tabla temporal
	insert into #temcompra
	select claveCompra,montoTotal,tipoCompra from venta.compra
	where fechacompra>=@fechaInicio and fechaCompra<=@fechaFin

	--Se gurda la suma mayor de ventas en la variable ventaTotal
	select @ventaTotal=max(ventaTotal) from (select tipoCompra as tipoCompra, sum(montoTotal) as ventaTotal from #temcompra
	group by tipoCompra) as ventaTotal

	--Se selecciona el tipo de compra y el total de venta además de mostrar la fecha de inicio y fin  
	select tipocompra, sum(montoTotal) as VentaTotal,@fechaInicio as FechaIncio,@fechaFin as FechaFin from #temcompra
	group by tipoCompra
	having sum(montoTotal)=@ventaTotal	--Se utiliza una comparación con el valor de la venta máxima obtenida anteriormente

	drop table #temcompra	--Se elimina la tabla temporal
end
go

--====================================================
--Nombre: venta.paGuardarEnCesta
--Descripción: procedimiento que guarda productos en la cesta de un usuario
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter procedure venta.paGuardarEnCesta 
	@nombreUsuario varchar(40),
	@nombreProducto varchar(40)
as
begin
	declare @claveUsuario int,
			@claveProducto int

	select @claveUsuario=claveUsuario from persona.USUARIO where usuario=@nombreUsuario
	select @claveProducto=claveProducto from catalogo.PRODUCTO where nombre=@nombreProducto

	if exists (select * from catalogo.PRODUCTO where claveProducto=@claveProducto) AND
	exists (select * from persona.USUARIO where claveUsuario=@claveUsuario)
	begin
		insert into venta.guarda (claveProducto, claveUsuario) values
		(@claveProducto,@claveUsuario)
	end
	else
	begin
		print 'El producto no se pudo guardar. No existe el producto en la tienda o el usuario no existe'
	end
end
go


--====================================================
--Nombre: venta.paCompraDesdeCesta
--Descripción: procedimiento que mueve los productos almacenados desde la cesta hacia la compra
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter procedure venta.paCompraDesdeCesta
	@nombreUsuario varchar(40),
	@nombreProducto varchar(40),
	@claveCompra int,
	@cantidad int
as
begin
	declare @claveUsuario int,
			@claveProducto int

	select @claveUsuario=claveUsuario from persona.USUARIO where usuario=@nombreUsuario
	select @claveProducto=claveProducto from catalogo.PRODUCTO where nombre=@nombreProducto

	if exists (select * from venta.guarda where claveUsuario=@claveUsuario AND claveProducto=claveProducto)
	begin
		-- Movemos el producto desde la cesta hasta la compra
		insert into venta.compraProducto (claveCompra, claveProducto, cantidad, precio) values
		(@claveCompra, @claveProducto, @cantidad, (select precio from catalogo.PRODUCTO where claveProducto=@claveProducto))
		-- Quitamos el elemento movido
		delete from venta.guarda where claveProducto=@claveProducto AND claveUsuario=@claveUsuario
		print 'Producto registrado en la compra'
	end
	else
	begin
		print 'Error. El producto o el usuario no se encuentran registrados en la cesta'
	end
end
go


--====================================================
--Nombre: BUSCADOR
--Descripción: procedimiento que mostrara una busqueda de productos por parametros
--Fecha de elaboración: 29/05/2020
--====================================================
CREATE OR ALTER PROCEDURE BUSCADOR
    --parametros de entrada 
	@operacion char(1),
	@var varchar(40), --descripcion 
	@var2 varchar(40)--cuando exista una categoria 

AS
BEGIN
	--DESCRIPCION->D
	--CATEGORIA->C
	--SUBCATEGORIA->S
	--NOMBRE->N
	IF @operacion in ('D','C','S', 'N')
	begin
		IF @operacion = 'D' --entrara cuando la entrada sea D
		BEGIN
			select 'POR DESCRIPCIÓN DEL PRODUCTO' as 'BUSQUEDA' 
			select @var as 'SU BUSQUEDA ES'

			if exists(select descripcionDetallada
						  from catalogo.PRODUCTO 
						  )--Si existe un registro en la descripcion de algun producto 
			begin
				if (@var is not null)--Si los datos introducidos para la descripcion no son nulos 
				begin
					 select C.nombre as 'Categoria', isnull(SC.nombre, 'Sin subcategoria') as 'Subcategoria', upper(P.nombre) as 'Nombre del producto', descripcionDetallada as 'Descripción del producto', precio
					 from catalogo.PRODUCTO as P
					 left join venta.pertenece as PE
					 on P.claveProducto=PE.claveProducto
					 left join catalogo.CATEGORIA as C
					 on PE.claveCategoria=C.claveCategoria
					 left join catalogo.CATEGORIA as SC
					 on C.claveSubcategoria=SC.claveCategoria
					 where P.descripcionDetallada like '%'+@var+'%' 

				end 
				else
				begin
					select 'DATOS INCOMPLETOS' as 'ERROR'
				end
			end
			else
			begin
				print 'NO EXISTEN REGISTROS DISPONIBLES'
			end
		end	


		IF @operacion = 'N' --entrara cuando la entrada sea N para buscar un nombre del producto
		begin
			select 'POR NOMBRE DEL PRODUCTO' as 'BUSQUEDA'
			select @var as 'SU BUSQUEDA ES'

			if exists(select nombre
						  from catalogo.PRODUCTO 
						  )--Si existe un registro en nombre de algun producto 
			begin
				if (@var is not null)--Si los datos introducidos para el nombre no son nulos 
				begin
					 select C.nombre as 'Categoria', isnull(SC.nombre, 'Sin subcategoria') as 'Subcategoria', upper(P.nombre) as 'Nombre del producto', descripcionDetallada as 'Descripción del producto', precio
					 from catalogo.PRODUCTO as P
					 left join venta.pertenece as PE
					 on P.claveProducto=PE.claveProducto
					 left join catalogo.CATEGORIA as C
					 on PE.claveCategoria=C.claveCategoria
					 left join catalogo.CATEGORIA as SC
					 on C.claveSubcategoria=SC.claveCategoria
					 where P.nombre like '%'+@var+'%';  
			 
				end 
				else
				begin
					select 'DATOS INCOMPLETOS' as 'ERROR' 
				end
			end
			else
			begin
				print 'NO EXISTEN REGISTROS DISPONIBLES'
			end
		end 


		IF @operacion = 'C' --entrara cuando la entrada sea N para buscar un nombre del producto
		begin
			select 'POR LA CATEGORIA DEL PRODUCTO' as 'BUSQUEDA'
			select @var as 'SU BUSQUEDA ES'

			if exists(select nombre
						  from catalogo.CATEGORIA 
						  )--Si existe un registro en la categoria de algun producto 
			begin
				if (@var is not null)--Si los datos introducidos para la categoria no son nulos 
				begin
					 select C.nombre as 'Categoria', isnull(SC.nombre, 'Sin subcategoria') as 'Subcategoria', upper(P.nombre) as 'Nombre del producto', descripcionDetallada as 'Descripción del producto', precio
					 from catalogo.PRODUCTO as P
					 left join venta.pertenece as PE
					 on P.claveProducto=PE.claveProducto
					 left join catalogo.CATEGORIA as C
					 on PE.claveCategoria=C.claveCategoria
					 left join catalogo.CATEGORIA as SC
					 on C.claveSubcategoria=SC.claveCategoria
					 where C.nombre like '%'+@var+'%';  
			 
				end 
				else
				begin
					select 'DATOS INCOMPLETOS' as 'ERROR' 
				end
			end
			else
			begin
				print 'NO EXISTEN REGISTROS DISPONIBLES'
			end
		end 


		IF @operacion = 'S' --entrara cuando la entrada sea N para buscar un nombre del producto
		begin
			select 'POR LA SUBCATEGORIA DEL PRODUCTO' as 'BUSQUEDA'
			select @var as 'SU BUSQUEDA ES'

			if exists(select S.nombre --Si existen subcategorias 
						  from catalogo.CATEGORIA as C
						  inner join catalogo.CATEGORIA as S
						  on C.claveSubcategoria=S.claveCategoria
						  )--Si existe un registro en subcategorias de algun producto 
			begin

				if (@var is not null)
				begin

					if (@var2 is not null)--Si los datos introducidos para la subcategoria y categoria no son nulos 
					begin
					
						select @var2 as 'CATEGORIA ELEGIDA'

						 select C.nombre as 'Categoria', isnull(SC.nombre, 'Sin subcategoria') as 'Subcategoria', upper(P.nombre) as 'Nombre del producto', descripcionDetallada as 'Descripción del producto', precio
						 from catalogo.PRODUCTO as P
						 left join venta.pertenece as PE
						 on P.claveProducto=PE.claveProducto
						 left join catalogo.CATEGORIA as C
						 on PE.claveCategoria=C.claveCategoria
						 left join catalogo.CATEGORIA as SC
						 on C.claveSubcategoria=SC.claveCategoria
						 where SC.nombre like '%'+@var+'%'
						 and C.nombre=@var2
			 
					end 

					if (@var2 is null)--Si la busqueda es no nula pero la categoria si
					begin

						 select C.nombre as 'Categoria', isnull(SC.nombre, 'Sin subcategoria') as 'Subcategoria', upper(P.nombre) as 'Nombre del producto', descripcionDetallada as 'Descripción del producto', precio
						 from catalogo.PRODUCTO as P
						 left join venta.pertenece as PE
						 on P.claveProducto=PE.claveProducto
						 left join catalogo.CATEGORIA as C
						 on PE.claveCategoria=C.claveCategoria
						 left join catalogo.CATEGORIA as SC
						 on C.claveSubcategoria=SC.claveCategoria
						 where SC.nombre like '%'+@var+'%';  
			 
					end 

				end
				else
				begin
					select 'DATOS INCOMPLETOS' as 'ERROR'
				end
			end
			else
			begin
				print 'NO EXISTEN REGISTROS DISPONIBLES'
			end
		end 

 end
 ELSE  
 begin
	print'OPCION NO VALIDA'
 end
END
go

-- =================== Funciones de Usuario =================================


--====================================================
--Nombre: venta.domicilioDeCompraEnLinea
--Descripción: Con la clave de compra se puede ver el transporte y el domicilio 
-- principal del usuario
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter function venta.domicilioDeCompraEnLinea(@claveC INTEGER)  --variable de entrada 
returns table as --retornara una tabla con la informacion
return(
		select CP.claveCompra, (U.paterno+' '+isnull(U.materno, ' ')+' '+U.nombre) AS 'Nombre del usuario', CP.tipoTransporte as 'Tipo de transporte',
		C.fechaCompra as 'Fecha de la compra', '->' as 'Domicilio principal', calle, numero, colonia, alcaldia
		from venta.compraPagina as CP
		inner join persona.USUARIO as U
		on CP.claveUsuario=U.claveUsuario
		inner join persona.DOMICILIO as D
		on U.claveUsuario=D.claveUsuario
		inner join venta.COMPRA as C
		on CP.claveCompra=C.claveCompra
		where D.principal=1 and CP.claveCompra=@claveC
)
go


--====================================================
--Nombre: venta.precios
--Descripción: Mostrara los productos que esten en el intervalo de precios
-- dados, la tienda y el stock en el que se encuentra
--Fecha de elaboración: 31/05/2020
--====================================================
create or alter function venta.precios(@precio1 INTEGER, @precio2 INTEGER)  --variables de intervalo de precio
returns table as --retornara una tabla con la informacion
return(
		--se seleccionan los datos que se quieren mostrar del producto de las tablas PRODUCTO,
		-- claveProducto y TIENDA, con la restriccion del precio
		select C.nombre as 'Nombre del producto', descripcionDetallada as 'Descripción del producto', 
		precio as 'Precio', T.claveTienda as 'Tienda', TP.stock as 'stock'
		from catalogo.PRODUCTO as C
		inner join venta.tiendaProducto as TP
		on C.claveProducto=TP.claveProducto
		inner join catalogo.TIENDA as T
		on TP.claveTienda=T.claveTienda
		where precio>=@precio1 and precio<=@precio2
		--Es inner join porque si no se encuentra un producto en el stock o en la tienda no lo mostrara en las opciones 
)
go
