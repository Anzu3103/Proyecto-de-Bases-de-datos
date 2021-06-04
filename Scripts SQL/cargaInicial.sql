-- ==================================================================
-- Nombre: cargaInicial.sql
-- Autor: Pedraza Martínez José Alberto, 
--		Santos Martínez Daniela                                              
--		Suxo Pacheco Elsa Guadalupe
--		Velázquez de León Lavarrios Alvar
-- Fecha: 29 de mayo de 2020
-- Descripción: inserción de datos inicales en la base de datos
-- ==================================================================

-- Nota: para insertar usuarios es necesario haber creado el procedimiento almacenado "pusuCrearNuevoUsuario"
-- así como también algunos los elementos del DML (triggers, procedimientos, funciones)

use Proyecto
go

-- Inserta 1 Tienda (adicional)
insert into catalogo.TIENDA default values
go


-- Inserta 1 Almacén (adicional)
insert into catalogo.ALMACEN default values
go
 --select * from catalogo.TIENDA
 --select * from catalogo.ALMACEN

-- Inserta 5 ofertas
insert into catalogo.OFERTA (descripcion,tipoOferta,fechaInicio,fechaFin) values 
('2 X 1','PROMOCION','2020-02-10','2020-02-15'),
('20% DE DESCUENTO','DESCUENTO','2020-07-05','2020-07-25'),
('3 X 2','PROIMOCION','2020-04-01','2020-04-20'),
('30% DE DESCUENTO','DESCUENTO','2020-06-25','2020-06-27'),
('-50 PESOS DE DESCUENTO','DESCUENTO','2020-04-15','2020-04-15')
go

/*select * from catalogo.OFERTA
go*/


-- Inserta 5 vendedores
exec pusuCrearNuevoUsuario 'usuarioVen1','3262','Proyecto','V','M','curpVendedor1','ipsum@dictummagna.ca',
	'Ingrid','Williams','Madden','1982-08-02',8000,null
exec pusuCrearNuevoUsuario 'usuarioVen2','6149','Proyecto','V','H','curpVendedor2','sit@tinciduntdui.net',
	'Blair','Daugherty','Mckay','2004-07-04',6500,null
exec pusuCrearNuevoUsuario 'usuarioVen3','4195','Proyecto','V','M','curpVendedor3','non.lacinia@mollisDuissit.com',
	'Rebekah','Webster','Ray','1995-07-29',7000,null
exec pusuCrearNuevoUsuario 'usuarioVen4','4780','Proyecto','V','H','curpVendedor4','mus@vulputaterisus.org',
	'Tarik','Dillard','Black','1993-02-03',9250,null
exec pusuCrearNuevoUsuario 'usuarioVen5','1623','Proyecto','V','H','curpVendedor5','amet.massa@utnulla.edu',
	'Gillian','Michael','Conway','1963-11-01',7780,null
go


-- Inserta 10 usuarios gestores
exec pusuCrearNuevoUsuario 'usuarioGes1','6823','Proyecto','G','H','curpGestor1','eu@bibendumfermentum.co.uk',
	'Dale','Alston','Estrada','1999-08-24',null,'LICENCIATURA'
exec pusuCrearNuevoUsuario 'usuarioGes2','2246','Proyecto','G','M','curpGestor2','est@etmagnaPraesent.net',
	'Wyoming','Villarreal','Mejia','1989-04-04',null,'MAESTRIA'
exec pusuCrearNuevoUsuario 'usuarioGes3','5605','Proyecto','G','H','curpGestor3','pharetra@viverra.com',
	'Thaddeus','Francis','Calderon','1978-06-26',null,'MAESTRIA'
exec pusuCrearNuevoUsuario 'usuarioGes4','6591','Proyecto','G','M','curpGestor4','Proin@nasceturridiculus.net',
	'Simone','Dodson','Macias','1990-06-14',null,'LICENCIATURA'
exec pusuCrearNuevoUsuario 'usuarioGes5','6227','Proyecto','G','H','curpGestor5','dolor@replacerat.org',
	'Kai','Pennington','Griffith','1975-06-02',null,'MAESTRIA'
exec pusuCrearNuevoUsuario 'usuarioGes6','8113','Proyecto','G','H','curpGestor6','consectetuer.mauris@ategestasa.co.uk',
	'Calvin','Hart','Moody','1990-03-14',null,'DOCTORADO'
exec pusuCrearNuevoUsuario 'usuarioGes7','8589','Proyecto','G','M','curpGestor7','sapien.molestie@eumetus.net',
	'Malachi','Butler','Webster','1985-10-29',null,'MAESTRIA'
exec pusuCrearNuevoUsuario 'usuarioGes8','5611','Proyecto','G','H','curpGestor8','vel.vulputate@congue.co.uk',
	'Jarrod','Vazquez','Adams','1989-03-06',null,'LICENCIATURA'
exec pusuCrearNuevoUsuario 'usuarioGes9','6899','Proyecto','G','H','curpGestor9','gravida.Aliquam@metusvitaevelit.co.uk',
	'Thomas','Hunt','Avila','1991-02-18',null,'LICENCIATURA'
exec pusuCrearNuevoUsuario 'usuarioGes10','2626','Proyecto','G','M','curpGestor10','semper.auctor@metusVivamus.ca',
	'Cassandra','Hyde','Cain','1984-03-27',null,'DOCTORADO'
go


-- Inserta 10 usuarios registrados
exec pusuCrearNuevoUsuario 'usuarioRegistrado1','4694','Proyecto','R','H','curpRegistrado1','cursus@Fusce.org',
	'Wang','Mathis','Cervantes','1987-11-15',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado2','7431','Proyecto','R','M','curpRegistrado2','adipiscing.fringilla@variusorci.edu',
	'Colette','Brewer','Hughes','2003-11-18',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado3','3101','Proyecto','R','H','curpRegistrado3','Fusce@velit.org',
	'Steel','Humphrey','Hancock','1991-01-30',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado4','8111','Proyecto','R','M','curpRegistrado4','Proin@elementum.org',
	'Angelica','Fernandez','Jensen','1986-09-01',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado5','6239','Proyecto','R','M','curpRegistrado5','pellentesque@ornareFusce.net',
	'Tara','Lindsay','Cortez','1991-11-16',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado6','5410','Proyecto','R','H','curpRegistrado6','convallis@pedeac.net',
	'Brent','Cole','Mccarthy','1984-12-15',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado7','3508','Proyecto','R','M','curpRegistrado7','sed.leo.Cras@luctussit.net',
	'Penelope','Randall','Christian','1994-05-11',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado8','8525','Proyecto','R','M','curpRegistrado8','egestas@mollisDuis.edu',
	'Violet','Allen','Underwood','1997-02-15',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado9','2804','Proyecto','R','H','curpRegistrado9','Nunc.ut@placeratvelit.org',
	'Xavier','Lane','Bird','1987-10-08',null,null
exec pusuCrearNuevoUsuario 'usuarioRegistrado10','7693','Proyecto','R','M','curpRegistrado10','orci.Donec.nibh@necmauris.com',
	'Abigail','Compton','Gamble','1995-10-09',null,null
go

/*select * from persona.USUARIO
select * from persona.tipoUsuario
select * from persona.VENDEDOR
select * from persona.GESTOR
go*/


-- Insertar 7 domicilios (adicional)
insert into persona.DOMICILIO(calle, numero,colonia,alcaldia,principal,claveUsuario)
values('ROSA', 64, 'TIBURON', 'ALVARO OBREGON', 1, 20),
	  ('SANDIA', 53, 'AMARILLO', 'BENITO JUAREZ', 0, 20),
	  ('ATLANTIS', 23, 'ALGODON', 'TLAHUAC', 0, 20),
	  ('PERA', 76, 'CORAZON', 'TLAHUAC', 1, 21),
	  ('JAMAICA', 55, 'LUZ', 'XOCHIMILCO', 0, 21),
	  ('LIBRO', 987, 'TORTUGA','BENITO JUAREZ', 1, 23),
	  ('MOLINO', 534, 'PAZ', 'COYOACAN', 1, 19)
go

--select * from persona.DOMICILIO

-- Inserta 4 categorías con 5 productos cada una
insert into catalogo.CATEGORIA (claveSubcategoria, nombre, descripcion) values 
(null, 'ALIMENTOS','Catálogo de alimentos'), --1
(1,'LACTEOS','Catálogo de alimentos lácteos'), --2
(1,'FRUTAS','Catálogo de frutas'), --3
(null,'BEBIDAS','Catálogo de bebidas'), --4
(4,'REFRESCOS','Catálogo de refrescos'), --5
(4,'JUGOS','Catálogo de jugos'), --6
(null, 'ELECTRONICA','Catálogo de aparatos electrónicos') --7
go

insert into catalogo.PRODUCTO (nombre, descripcionDetallada, precio) values
('Queso Lala','Queso Oaxaca Lala de 500g',35), --1
('Leche Lala','Leche entera Lala de 1L',20), --2
('Leche Alpura','Leche deslactosada Alpura de 1L',22), --3
('Danonino bebible','Danonino bebible de 250ml',12), --4
('Crema Aguascalientes','Crema Light Aguascalientes de 100ml',19), --5

('Manzana','Manzana 1kg',30), --6
('Limon','Limon 1kg',22), --7
('Mango','Manzanas 1kg',18), --8
('Naranja','Manzanas 1kg',20), --9
('Plátano','Plátano 1 kg',15), --10

('Coca-Cola','Coca-Cola 3L',35), --11
('Pepsi','Pepsi 3L',32), --12
('Sprite','Sprite 2L',25), --13
('Jarritos Uva','Jarritos Uva 1L',22), --14
('Manzanita Sol','Manzanita Sol 2L',24), --15

('Televisión HD Sony','Televisión HD de 42 pulgadas Sony',7000), --16
('Reproductor de DVD Samsung','Reproductor de DVD Samsung',5500), --17
('Xbox Series X','Consola de videojuegos marca Xbox',8000), --18
('Audífonos Spectra','Audífonos alámbricos Spectra',140), --19
('Memoria USB Kingston','USB 8GB Kingston',130) --20
go

insert into venta.pertenece (claveProducto, claveCategoria) values
(1,2),(2,2),(3,2),(4,2),(5,2),
(6,3),(7,3),(8,3),(9,3),(10,3),
(11,5),(12,5),(13,5),(14,5),(15,5),
(16,7),(17,7),(18,7),(19,7),(20,7)
go

/*select * from catalogo.CATEGORIA
select * from catalogo.PRODUCTO
select * from venta.pertenece
go*/

-- Insertar los productos en la tienda (adicional)
insert into venta.tiendaProducto (claveProducto, claveTienda, stock) values 
(1, 1,50),(2, 1,45),(3, 1,34),(4, 1,50),(5, 1,43),(6, 1,34),(7,1,51), (8,1,23), (9,1,63), (10,1,23), 
(11,1,45), (12,1,53), (13,1,23), (14,1,29), (15,1,15), (16,1,25), (17,1,38), (18,1,55), (19,1,30), (20,1,39)
go

/*select * from catalogo.PRODUCTO
select * from catalogo.TIENDA
select * from venta.tiendaProducto
go*/

-- Insertar los productos en el almacén (adicional)
insert into venta.almacenProducto (claveProducto, claveAlmacen, stock) values 
(1, 1,50),(2, 1,45),(3, 1,34),(4, 1,50),(5, 1,43),(6, 1,34),(7,1,51), (8,1,23), (9,1,63), (10,1,23), 
(11,1,45), (12,1,53), (13,1,23), (14,1,29), (15,1,15), (16,1,25), (17,1,38), (18,1,55), (19,1,30), (20,1,39)
go

/*select * from catalogo.ALMACEN
select * from catalogo.PRODUCTO
select * from venta.almacenProducto
go*/

-- Inserta 5 cestas pendientes de compra
insert into venta.guarda (claveProducto, claveUsuario) values
(1,16),(6,16),(7,16),(10,16),(14,16), -- Cesta del usuario con id=16
(2,22),(3,22),(4,22), -- Cesta del usuario con id=22
(6,18),(7,18),(8,18),(9,18),(10,18), -- Cesta del usuario con id=18
(11,19),(13,19), -- Cesta del usuario con id=19
(18,25),(20,25),(19,25) -- Cesta del usuario con id=25
go

/*select * from venta.guarda
select * from persona.USUARIO
select * from catalogo.PRODUCTO
go*/


-- Inserta 10 ventas en establecimiento
insert into venta.COMPRA (fechaCompra, montoTotal, IVA, tipoCompra) values
('2020-04-15',550,16,'T'), --1
('2018-11-14',60,12,'T'), --2
('2018-06-23',808,08,'T'), --3
('2016-05-17',50,16,'T'), --4
('2017-12-03',30,16,'T'), --5
('2019-09-08',68,14,'T'), --6
('2020-02-22',10,14,'T'), --7
('2020-01-06',5,08,'T'), --8
('2019-05-12',23,12,'T'), --9
('2016-04-11',12,16,'T') --10
go
--select * from venta.COMPRA

insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(1,1,2,(select precio from catalogo.PRODUCTO where claveProducto=1))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(6,2,5,(select precio from catalogo.PRODUCTO where claveProducto=6))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(7,3,2,(select precio from catalogo.PRODUCTO where claveProducto=7))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(10,4,1,(select precio from catalogo.PRODUCTO where claveProducto=10))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(14,5,1,(select precio from catalogo.PRODUCTO where claveProducto=14))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(2,6,2,(select precio from catalogo.PRODUCTO where claveProducto=2))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(3,7,2,(select precio from catalogo.PRODUCTO where claveProducto=3))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(4,8,4,(select precio from catalogo.PRODUCTO where claveProducto=4))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(6,9,3,(select precio from catalogo.PRODUCTO where claveProducto=6))
go
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(7,10,1,(select precio from catalogo.PRODUCTO where claveProducto=7))
go

--select * from venta.compraProducto

insert into venta.compraTienda (comisionTotal, claveCompra, claveUsuario) values
(5,1,1),
(5,2,1),
(5,3,2),
(5,4,2),
(5,5,3),
(5,6,3),
(5,7,4),
(5,8,4),
(5,9,5),
(5,10,5)
go

--select * from venta.compraTienda

-- Inserta 20 ventas para usuarios registrados
insert into venta.COMPRA (fechaCompra, montoTotal, IVA, tipoCompra) values
('2020-04-15',150,16,'P'), --11
('2018-11-14',220,12,'P'), --12
('2018-06-23',300,08,'P'), --13
('2016-05-17',30,16,'P'), --14
('2017-12-03',50,16,'P'), --15
('2019-09-08',70,14,'P'), --16
('2020-02-22',80,14,'P'), --17
('2020-01-06',10,08,'P'), --18
('2019-05-12',90,12,'P'), --19
('2016-04-11',550,16,'P'), --20
('2020-04-15',240,16,'P'), --21
('2018-11-14',60,12,'P'), --22
('2018-06-23',80,08,'P'), --23
('2016-05-17',76,16,'P'), --24
('2017-12-03',33,16,'P'), --25
('2019-09-08',89,14,'P'), --26
('2020-02-22',287,14,'P'), --27
('2020-01-06',234,08,'P'), --28
('2019-05-12',111,12,'P'), --29
('2016-04-11',107,16,'P') --30
go

--select * from venta.COMPRA 

insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(1,11,2,(select precio from catalogo.PRODUCTO where claveProducto=1))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(6,12,5,(select precio from catalogo.PRODUCTO where claveProducto=6))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(7,13,2,(select precio from catalogo.PRODUCTO where claveProducto=7))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(10,14,1,(select precio from catalogo.PRODUCTO where claveProducto=10))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(14,15,1,(select precio from catalogo.PRODUCTO where claveProducto=14))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(2,16,2,(select precio from catalogo.PRODUCTO where claveProducto=2))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(3,17,2,(select precio from catalogo.PRODUCTO where claveProducto=3))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(4,18,4,(select precio from catalogo.PRODUCTO where claveProducto=4))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(6,19,3,(select precio from catalogo.PRODUCTO where claveProducto=6))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(7,20,1,(select precio from catalogo.PRODUCTO where claveProducto=7))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(1,21,2,(select precio from catalogo.PRODUCTO where claveProducto=1))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(6,22,5,(select precio from catalogo.PRODUCTO where claveProducto=6))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(7,23,2,(select precio from catalogo.PRODUCTO where claveProducto=7))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(10,24,1,(select precio from catalogo.PRODUCTO where claveProducto=10))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(14,25,1,(select precio from catalogo.PRODUCTO where claveProducto=14))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(2,26,2,(select precio from catalogo.PRODUCTO where claveProducto=2))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(3,27,2,(select precio from catalogo.PRODUCTO where claveProducto=3))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(4,28,4,(select precio from catalogo.PRODUCTO where claveProducto=4))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(6,29,3,(select precio from catalogo.PRODUCTO where claveProducto=6))
insert into venta.compraProducto (claveProducto, claveCompra, cantidad, precio) values 
(7,30,1,(select precio from catalogo.PRODUCTO where claveProducto=7))
go

--select * from venta.compraProducto

insert into venta.compraPagina (tipoTransporte, claveUsuario, claveCompra) values
('CAMION',16,11),
('CAMION',16,12),
('MOTOCICLETA',16,13),
('CAMION',22,14),
('CAMION',22,15),
('MOTOCICLETA',18,16),
('MOTOCICLETA',18,17),
('CAMION',17,18),
('MOTOCICLETA',25,19),
('CAMION',25,20),
('CAMION',23,21),
('CAMION',17,22),
('CAMION',18,23),
('MOTOCICLETA',20,24),
('CAMION',21,25),
('MOTOCICLETA',20,26),
('MOTOCICLETA',16,27),
('CAMION',19,28),
('CAMION',19,29),
('MOTOCICLETA',23,30)
go

--select * from venta.compraPagina

--Usuarios suscribiendose a un producto
insert into venta.suscribe (claveUsuario, claveProducto)
	values (17,13), (17,14), (17,15), (17,16), (17,11), 
			(19,1), (19,13), (19,5), (19,6), (19,12), 
			(18,3), (18,4), (22,20), (22,16), (18,6), 
			(20,2), (20,1), (20,19), (21,6), (20,7), 
			(25,11), (25,19), (25,15), (25,16), (25,20)
go

--select * from venta.suscribe


--Vinculando productos con ciertas ofertas
insert into venta.incluye (claveOferta,claveProducto)
	values (1,14), (1,16), (1,20), (1,15), (1,6),
			(2,19), (3,15), (5,2), (4,13), (2,11),
			(2,18), (3,16), (5,1), (4,14), (4,12),
			(2,17), (3,11), (5,10), (4,7), (3,4)
go
--select * from venta.incluye