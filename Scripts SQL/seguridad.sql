-- ==================================================================
-- Nombre: seguridad.sql
-- Autor: Pedraza Martínez José Alberto, 
--		Santos Martínez Daniela                                              
--		Suxo Pacheco Elsa Guadalupe
--		Velázquez de León Lavarrios Alvar
-- Fecha: 30 de mayo de 2020
-- Descripción: script para crear usuarios con determinados permisos
-- ==================================================================

use Proyecto
go

-- Roles para los usuarios que se almacenen en la base
create role registrado
create role vendedor
create role gestor
go

-- Roles para los usuarios del manejador
create role consulta
create role administrador
go

-- Permisos para los usuarios registrados
grant select on Schema::catalogo to registrado
deny insert, update, delete on Schema::catalogo to registrado

grant select, insert, update, delete on venta.guarda to registrado
grant select, insert, update, delete on venta.suscribe to registrado
grant select, insert, update, delete on venta.compraPagina to registrado
grant select, insert, update, delete on venta.COMPRA to registrado
grant select, insert, update, delete on venta.compraProducto to registrado
grant select on venta.compraTienda to registrado
grant select on venta.incluye to registrado
grant select on venta.pertenece to registrado
grant select on venta.almacenProducto to registrado
grant select on venta.tiendaProducto to registrado
deny insert, update, delete on venta.compraTienda to registrado
deny insert, update, delete on venta.incluye to registrado
deny insert, update, delete on venta.pertenece to registrado
deny insert, update, delete on venta.almacenProducto to registrado
deny insert, update, delete on venta.tiendaProducto to registrado

grant select, insert, update, delete on persona.DOMICILIO to registrado
grant select, insert, update, delete on persona.TELEFONOUSUARIO to registrado
grant select, update on persona.USUARIO to registrado
grant select on persona.tipoUsuario to registrado
grant select on persona.VENDEDOR to registrado
grant select on persona.GESTOR to registrado
deny insert, delete on persona.USUARIO to registrado
deny insert, update, delete on persona.tipoUsuario to registrado
deny insert, update, delete on persona.VENDEDOR to registrado
deny insert, update, delete on persona.GESTOR to registrado
go

-- Permisos para los usuarios vendedores
grant select on Schema::catalogo to vendedor
deny insert, update, delete on Schema::catalogo to vendedor

grant select on Schema::persona to vendedor
deny insert, update, delete on Schema::persona to vendedor

grant select, insert, update, delete on venta.compraTienda to vendedor
grant select on venta.COMPRA to vendedor
grant select on venta.guarda to vendedor
grant select on venta.suscribe to vendedor
grant select on venta.compraPagina to vendedor
grant select on venta.compraProducto to vendedor
grant select on venta.incluye to vendedor
grant select on venta.pertenece to vendedor
grant select on venta.almacenProducto to vendedor
grant select on venta.tiendaProducto to vendedor
deny insert, update, delete on venta.COMPRA to vendedor
deny insert, update, delete on venta.guarda to vendedor
deny insert, update, delete on venta.suscribe to vendedor
deny insert, update, delete on venta.compraPagina to vendedor
deny insert, update, delete on venta.compraProducto to vendedor
deny insert, update, delete on venta.incluye to vendedor
deny insert, update, delete on venta.pertenece to vendedor
deny insert, update, delete on venta.almacenProducto to vendedor
deny insert, update, delete on venta.tiendaProducto to vendedor
go

-- Permisos para los usuarios gestores
grant select, insert, update, delete on Schema::catalogo to gestor
grant select, insert, update, delete on Schema::persona to gestor

grant select on venta.compraTienda to gestor
grant select on venta.COMPRA to gestor
grant select on venta.guarda to gestor
grant select on venta.suscribe to gestor
grant select on venta.compraPagina to gestor
grant select on venta.compraProducto to gestor
grant select, insert, update, delete on venta.incluye to gestor
grant select, insert, update, delete on venta.pertenece to gestor
grant select, insert, update, delete on venta.almacenProducto to gestor
grant select, insert, update, delete on venta.tiendaProducto to gestor
deny insert, update, delete on venta.compraTienda to gestor
deny insert, update, delete on venta.COMPRA to gestor
deny insert, update, delete on venta.guarda to gestor
deny insert, update, delete on venta.suscribe to gestor
deny insert, update, delete on venta.compraPagina to gestor
deny insert, update, delete on venta.compraProducto to gestor
go

-- Permisos para los usuarios consultores
grant select on Schema::catalogo to consulta
grant select on Schema::persona to consulta
grant select on Schema::venta to consulta
deny insert, update, delete on Schema::catalogo to consulta
deny insert, update, delete on Schema::persona to consulta
deny insert, update, delete on Schema::venta to consulta
go

-- Permisos para los usuarios administradores
grant select, insert, update, delete on Schema::catalogo to administrador
grant select, insert, update, delete on Schema::persona to administrador
grant select, insert, update, delete on Schema::venta to administrador
go


-- Creamos al usuarioConsulta, usuarioGestor y usuarioAdministrador
use master
create login usuarioConsulta with password = '1234zaq*'
use Proyecto
create user usuarioConsulta from login usuarioConsulta
ALTER ROLE consulta ADD MEMBER usuarioConsulta

use master
create login usuarioGestor with password = '1234zaq*'
use Proyecto
create user usuarioGestor from login usuarioGestor
ALTER ROLE gestor ADD MEMBER usuarioGestor

use master
create login usuarioAdministrador with password = '1234zaq*'
use Proyecto
create user usuarioAdministrador from login usuarioAdministrador
ALTER ROLE administrador ADD MEMBER usuarioAdministrador
go


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