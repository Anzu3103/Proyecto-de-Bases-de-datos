
/******************************************************************************************/
/**                                                                                      **/
/**		Autores:																	     **/
/**					Pedraza Martínez José Alberto                                        **/
/**					Santos Martínez Daniela                                              **/
/**					Suxo Pacheco Elsa Guadalupe                                          **/
/**					Velázquez de León Lavarrios Alvar                                    **/
/**                                                                                      **/
/**		Fecha de creación: 29/05/20                                                      **/ 
/**                                                                                      **/
/**		Descripción: Se mostrara la creacion de la base de datos Proyecto,               **/
/**		asi como la creacion de tablas, llaves primarias y foraneas, constraints         **/
/**     e indices de un sistema de una tienda comercial	                                 **/
/**                                                                                      **/
/******************************************************************************************/


--------------------------------------------------------------------------------------------------------------
------------------------------CREANDO LA BASE DE DATOS Proyecto------------------------------------------------
create database Proyecto
go




--------------------------------------------------------------------------------------------------------------
-----------------------------POSISIONANDONOS EN LA BASE DE DATOS Proyecto-------------------------------------
use Proyecto
go




--------------------------------------------------------------------------------------------------------------
------------------------------------------CREANDO ESQUEMAS----------------------------------------------------

CREATE SCHEMA catalogo
go
CREATE SCHEMA persona
go
CREATE SCHEMA venta




--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA ALMACEN EN EL ESQUEMA CATALOGO--------------------------------------

CREATE TABLE catalogo.ALMACEN ( 

	--DEFINIENDO LA LLAVE PRIMARIA CON LA COLUMNA claveAlmacen
	claveAlmacen  int identity (1,1) PRIMARY KEY  CLUSTERED (claveAlmacen ASC) NOT NULL 
)
go




--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA PRODUCTO EN EL ESQUEMA CATALOGO--------------------------------------

CREATE TABLE catalogo.PRODUCTO ( 

	--DEFINIENDO LA LLAVE PRIMARIA CON LA COLUMNA claveProducto
	claveProducto        int identity (1,1)  PRIMARY KEY  CLUSTERED (claveProducto ASC) NOT NULL ,
	nombre               varchar(40)  NOT NULL ,
	descripcionDetallada varchar(50)  NOT NULL ,
	precio               money  NOT NULL 
)


--CREANDO UN INDICE NONCLUSTERED 
--LLAMADO NC_nombre 
--EN LA TABLA catalogo.PRODUCTO
--CON LA COLUMA nombre
CREATE NONCLUSTERED INDEX NC_nombre on catalogo.PRODUCTO(nombre ASC);
GO




--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA almacenProducto EN EL ESQUEMA venta--------------------------------------


CREATE TABLE venta.almacenProducto ( 
	claveProducto        int NOT NULL ,
	claveAlmacen         int NOT NULL ,
	stock                integer NULL CONSTRAINT DF_stockAP DEFAULT (5),

	--DEFINIENDO UN CONSTRAINT PARA LA LLAVE PRIMARIA COMPUESTA DE LA TABLA 
	CONSTRAINT PK_almacenProducto PRIMARY KEY (claveProducto ASC,claveAlmacen ASC),

	--DEFINIENDO UN CONSTRAINT PARA LA LLAVE FORANEA rel_producto
	--QUE TIENE RELACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_producto FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA REFERENCIADA
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

    --DEFINIENDO UN CONSTRAINT PARA LA LLAVE FORANEA rel_almacen
	--RELACION CON catalogo.ALMACEN(claveAlmacen)
	CONSTRAINT rel_almacen FOREIGN KEY (claveAlmacen) REFERENCES catalogo.ALMACEN(claveAlmacen)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA REFERENCIADA
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)

--SE CREARA UN INDICE NONCLUSTERED EN LA TABLA venta.almacenProducto PARA LA COLUMNA stock
CREATE NONCLUSTERED INDEX NC_stockA on venta.almacenProducto(stock ASC);
go




--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA CATEGORIA EN EL ESQUEMA catalogo--------------------------------------

CREATE TABLE catalogo.CATEGORIA( 
	claveCategoria       int identity (1,1)  NOT NULL ,
	claveSubcategoria    int  NULL ,
	nombre               varchar(40)  NULL ,
	descripcion          varchar(50)  NULL, 
	
	--SE CREA UN CONSTRAINT PARA LA LLAVE PRIMARIA CON LA COLUMNA claveCategoria
	CONSTRAINT PKCategoria PRIMARY KEY (claveCategoria ASC),
	
	--SE CREA UN CONSTRAINT PARA LA LLAVE FORANEA QUE TENDRA RELACION CON LA TABLA catalogo.CATEGORIA
	CONSTRAINT rel_subCategoria FOREIGN KEY (claveSubcategoria) REFERENCES catalogo.CATEGORIA(claveCategoria)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA 
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)

----SE CREARA UN INDICE NONCLUSTERED EN LA TABLA catalogo.CATEGORIA PARA LA COLUMNA nombre
CREATE NONCLUSTERED INDEX NC_nomCategoria on catalogo.CATEGORIA(nombre);
go



--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA TIENDA EN EL ESQUEMA catalogo--------------------------------------

CREATE TABLE catalogo.TIENDA( 
	--SE DECLARA LA COLUMNA Y EL CONSTRAINT PARA LA LLAVE PRIMARIA 
	claveTienda          integer identity(1,1)  NOT NULL,
	CONSTRAINT PKtienda PRIMARY KEY CLUSTERED (claveTienda ASC)
)
go




--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA tiendaProducto EN EL ESQUEMA venta-----------------------------------

CREATE TABLE venta.tiendaProducto( 
	claveProducto        integer  NOT NULL ,
	claveTienda          integer  NOT NULL ,
	stock                integer NULL CONSTRAINT DF_stockTP DEFAULT (5),--SE DECLARA UN CONSTRAINT PARA TENER UN VALOR POR DEFAULT

	--SE DECLARA UN CONSTRAINT PARA LA LLAVE PRIMARIA COMPUESTA DE LA TABLA 
	CONSTRAINT PKtiendaProducto PRIMARY KEY  CLUSTERED (claveProducto ASC,claveTienda ASC),

	--SE DECLARA UN CONSTRAINT PARA LA LLAVE FORANEA QUE TENDRA RELACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_tiendaProd FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA 
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	--SE DECLARA UN CONSTRAINT PARA LA LLAVE FORANEA QUE TENDRA RELACION CON LA TABLA catalogo.TIENDA
	CONSTRAINT rel_tienda FOREIGN KEY (claveTienda) REFERENCES catalogo.TIENDA(claveTienda)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA 
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)

--SE CREA UN INDICE NONCLUSTERED EN LA TABLA venta.tiendaProducto PARA LA COLUMNA stock
CREATE NONCLUSTERED INDEX NC_stockT on venta.tiendaProducto(stock ASC);
go



--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA USUARIO EN EL ESQUEMA persona---------------------------------------

CREATE TABLE persona.USUARIO
( 
	claveUsuario         int identity (1,1),
	usuario              varchar(40)  NOT NULL UNIQUE,
	sexo                 char(1)  NOT NULL CONSTRAINT CH_sexo CHECK(sexo in ('M','H')),--SE DEFINE UN CONSTRAINT PARA UN CHECK QUE DEFINE EL SEXO 
	curp                 varchar(40)  NOT NULL ,
	email                varchar(40)  NOT NULL ,
	contraseña           varchar(40)  NOT NULL ,
	nombre               varchar(40)  NOT NULL ,
	paterno              varchar(40)  NOT NULL ,
	materno              varchar(40)  NULL ,
	fechaCumpleaños      datetime  NULL,

	--SE DEFINE UN CONSTRAINT PARA LA LLAVE PRIMARIA DE LA TABLA 
	CONSTRAINT PKUsuario PRIMARY KEY  CLUSTERED (claveUsuario ASC),
	
	--SE DEFINE UN CONSTRAINT PARA UN UNIQUE EN DONDE TENDREMOS DE PARAMETRO EL CURP PARA QUE NO SE REPITA
	CONSTRAINT UQ_curp UNIQUE (curp)
)

--DEFINE UN INDICE UNIQUE NONCLUSTERED EN LA TABLA persona.USUARIO EN LA COLUMNA usuario
CREATE UNIQUE NONCLUSTERED INDEX NC_usuario on persona.USUARIO(usuario ASC);
go



--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA VENDEDOR EN EL ESQUEMA persona---------------------------------------

CREATE TABLE persona.VENDEDOR( 
	sueldo               MONEY  NULL ,
	claveUsuario         integer  NOT NULL,
	
	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA 
	CONSTRAINT PK_vendedor PRIMARY KEY  CLUSTERED (claveUsuario ASC), 
	
	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE FORANEA QUE TIENE RELACION CON persona.USUARIO
	CONSTRAINT rel_usrVend FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--SE ELIMINARA Y SE ACTUALIZARA EN CASCADA. 
		--ESTO QUIERE DECIR QUE SE ELIMINARA EN LA TABLA PADRE COMO EN LAS QUE SE TENGA 
		--REGISTROS REFERENCIADAS EN ESTA 
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	--SE DEFINE UN CONSTRAINT PARA UN CHECK, EN DONDE SOLO SE PODRAN TENER SUELDOS MAYORES A 5000
	CONSTRAINT CH_sueldo CHECK(sueldo>5000),
)
go



--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA COMPRA EN EL ESQUEMA venta------------------------------------------

CREATE TABLE venta.COMPRA( 
	claveCompra          int identity (1,1)  NOT NULL ,
	fechaCompra          datetime  NOT NULL ,
	montoTotal           money  NOT NULL ,
	IVA                  tinyint  NOT NULL ,
	tipoCompra       char(1)  NOT NULL, 

	--SE DEFINE UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED 
	CONSTRAINT PKCOMPRA PRIMARY KEY  CLUSTERED (claveCompra ASC),

	--SE DEFINE UN CHECK PARA QUE EN EL TIPO DE COMPRA SOLO SE PUEDAN INTRODUCIR DOS OPCIONES 
	CONSTRAINT	CK_tipo CHECK (tipoCompra in ('P','T')),
)

--SE CREA UN INDICE NONCLUSTERED EN LA TABLA venta.COMPRA PARA LA COLUMNA montoTotal
CREATE NONCLUSTERED INDEX NC_montoTotal on venta.COMPRA(montoTotal DESC);

go



--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA compraPagina EN EL ESQUEMA venta-------------------------------------

CREATE TABLE venta.compraPagina( 
	tipoTransporte       varchar(40)  NOT NULL ,
	claveUsuario         int  NOT NULL ,
	claveCompra          int  NOT NULL,

	--SE DEFINE UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED Y LA COLUMNA claveCompra
	CONSTRAINT PK_compraPagina PRIMARY KEY CLUSTERED (claveCompra ASC),

	--SE DEFINE UN CONSTRAINT PARA LA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA venta.COMPRA
	CONSTRAINT rel_tipoCPagina FOREIGN KEY (claveCompra) REFERENCES venta.COMPRA(claveCompra)
		--SE ELIMINARA Y SE ACTUALIZARA EN CASCADA. 
		--ESTO QUIERE DECIR QUE SE ELIMINARA EN LA TABLA PADRE COMO EN LAS QUE SE TENGA 
		--REGISTROS REFERENCIADAS EN ESTA 
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	--SE DEFINE UN CONSTRAINT PARA LA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.USUARIO
	CONSTRAINT rel_usuario FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA 
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)

--DEFINIMOS UN INDICE NONCLUSTERED EN LA TABLA venta.compraPagina PARA LA COLUMNA claveUsuario
CREATE NONCLUSTERED INDEX NC_usu on venta.compraPagina(claveUsuario ASC);
go





--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA compraProducto EN EL ESQUEMA venta-----------------------------------

CREATE TABLE venta.compraProducto( 
	claveProducto        int NOT NULL ,
	claveCompra          int NOT NULL ,
	cantidad             integer  NOT NULL,
	precio               money NOT NULL, 
	
	--SE DEFINE UN CONSTRAINT PARA LA LLAVE PRIMARIA CON UN CLUESTERED CON MAS DE 1 PARAMETRO  
	CONSTRAINT PK_compraProducto PRIMARY KEY CLUSTERED (claveProducto ASC,claveCompra ASC),
	
	--SE DEFINE UN CONSTRAINT PARA LA LLAVE FORANEA QUE TIENE RLACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_compraProd FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA 
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	--SE DEFINE UN CONSTRAINT PARA OTRA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA venta.COMPRA
	CONSTRAINT rel_compra FOREIGN KEY (claveCompra) REFERENCES venta.COMPRA(claveCompra)
		--RECHAZA LA ELIMINACION O ACTUALIZACION PARA LA TABLA PRIMARIA 
		--SI HAY UN VALOR EN UNA TABLA EXTERNA RELACIONADO A LA TABLA 
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)
go


--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA compraTienda EN EL ESQUEMA venta-----------------------------------

CREATE TABLE venta.compraTienda( 
	comisionTotal        tinyint  NOT NULL ,
	claveCompra          int  NOT NULL ,
	claveUsuario         int  NOT NULL ,

	--SE DEFINE UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED 
	CONSTRAINT PK_compraTienda PRIMARY KEY  CLUSTERED (claveCompra ASC),
	
	--SE DEFINE UN CONSTRAINT PARA LA LLAVE FORANEA QUE TIENE RELACIÓN CON LA TABLA venta.COMPRA
	CONSTRAINT rel_compraTienda FOREIGN KEY (claveCompra) REFERENCES venta.COMPRA(claveCompra)
		--SE ELIMINARA Y ACTUALIZARA EN CASCADA 
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	--SE DEFINE OTRA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.VENDEDOR
	CONSTRAINT rel_compraUsuario FOREIGN KEY (claveUsuario) REFERENCES persona.VENDEDOR(claveUsuario)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)

--SE DEFINE UN INDICE NONCLUSTERED EN LA TABLA venta.compraTienda PARA LA COLUMNA claveUsuario
CREATE NONCLUSTERED INDEX NC_Vendedor on venta.compraTienda(claveUsuario ASC);
go


--------------------------------------------------------------------------------------------------------------
-------------------------CREANDO LA TABLA DOMICILIO EN EL ESQUEMA persona-------------------------------------

CREATE TABLE persona.DOMICILIO
( 
	claveDomicilio       integer  NOT NULL identity(1,1),
	calle                varchar(40)  NOT NULL ,
	numero               varchar(35)  NOT NULL ,
	colonia              varchar(50)  NOT NULL ,
	alcaldia             varchar(40)  NOT NULL ,
	principal            bit  NOT NULL ,
	claveUsuario         int  NOT NULL, 

	--SE DEFINE UN CONSTRAINT CON CLUSTERED PARA LA LLAVE PRIMARIA DE LA TABLA 
	CONSTRAINT PKDomicilio PRIMARY KEY  CLUSTERED (claveDomicilio ASC),

	--SE DEFINE UN CONSTRAINT PARA LA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.USUARIO
	CONSTRAINT rel_domUsuario FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)

--SE DEFINE UN INDICE NONCLUSTERED EN LA TABLA persona.DOMICILIO PARA LA COLUMNA claveUsuario
CREATE NONCLUSTERED INDEX NC_usuDom on persona.DOMICILIO(claveUsuario ASC);
go



--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA GESTOR EN EL ESQUEMA persona-------------------------------------

CREATE TABLE persona.GESTOR( 
	escolaridad          varchar(40)  NOT NULL ,
	claveUsuario         int  NOT NULL, 

	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED
	CONSTRAINT PK_Gestor PRIMARY KEY  CLUSTERED (claveUsuario ASC),

	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.USUARIO
	CONSTRAINT rel_gestorUsuario FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--SE ACTUALIZA Y SE ELIMINARA EN CASCADA 
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
go


--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA guarda EN EL ESQUEMA venta---------------------------------------

CREATE TABLE venta.guarda( 
	claveProducto        int  NOT NULL ,
	claveUsuario         int  NOT NULL ,
	
	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED
	CONSTRAINT PK_guarda PRIMARY KEY  CLUSTERED (claveProducto ASC,claveUsuario ASC),

	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_guardaProd FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.USUARIO
	CONSTRAINT rel_guardaUsuario FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)
go

--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA IMAGEN EN EL ESQUEMA catalogo---------------------------------------


CREATE TABLE catalogo.IMAGEN( 
	claveImagen          int NOT NULL ,
	imagen               varchar(150)  NOT NULL ,
	claveProducto        int  NOT NULL ,

	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED
	CONSTRAINT PK_imagen PRIMARY KEY  CLUSTERED (claveImagen ASC,claveProducto ASC),
	
	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_imgProd FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)
go



--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA OFERTA EN EL ESQUEMA catalogo---------------------------------------

CREATE TABLE catalogo.OFERTA( 
	claveOferta          int identity(1,1) NOT NULL CONSTRAINT PKoferta PRIMARY KEY ,--SE DECLARA LA LLAVE PRIMARIA  
	descripcion          varchar(100)  NOT NULL ,
	tipoOferta           varchar(100)  NOT NULL ,
	fechaInicio          datetime  NOT NULL ,
	fechaFin             datetime  NOT NULL ,
	CONSTRAINT CH_FechaFin CHECK(40>= datediff(day, fechaInicio,fechaFin))--SE DEFINE UN CONSTRAINT PARA UN CHECK EN DONDE LA FECHA FIN SEA MENOR O IGUAL A 40 DIAS 
)

--SE DEFINEN INDICES NONCLUSTERED 
CREATE NONCLUSTERED INDEX NC_Oferta on catalogo.OFERTA(descripcion ASC);
CREATE NONCLUSTERED INDEX NC_tipoOferta on catalogo.OFERTA(tipoOferta ASC);
go


--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA incluye EN EL ESQUEMA venta---------------------------------------

CREATE TABLE venta.incluye( 
	claveProducto        int NOT NULL ,
	claveOferta          int NOT NULL ,

	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED CON 2 PARAMETROS 
	CONSTRAINT PK_incluye PRIMARY KEY  CLUSTERED (claveProducto ASC,claveOferta ASC),
	
	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_incluyeProd FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA catalogo.OFERTA
	CONSTRAINT rel_incluyeOferta FOREIGN KEY (claveOferta) REFERENCES catalogo.OFERTA(claveOferta)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)
go


--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA pertenece EN EL ESQUEMA venta---------------------------------------


CREATE TABLE venta.pertenece( 
	claveProducto        int  NOT NULL ,
	claveCategoria       int  NOT NULL, 
	
	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED CON 2 PARAMETROS
	CONSTRAINT PK_pertenece PRIMARY KEY CLUSTERED (claveProducto ASC,claveCategoria ASC),
	
	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_perteneceProd FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA catalogo.CATEGORIA
	CONSTRAINT rel_perteneceCat FOREIGN KEY (claveCategoria) REFERENCES catalogo.CATEGORIA(claveCategoria)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)
go


--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA suscribe EN EL ESQUEMA venta---------------------------------------

CREATE TABLE venta.suscribe( 
	claveProducto        int  NOT NULL ,
	claveUsuario         int  NOT NULL ,
	
	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED CON 2 PARAMETROS 
	CONSTRAINT PKsuscribe PRIMARY KEY CLUSTERED (claveProducto ASC,claveUsuario ASC),
	
	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA catalogo.PRODUCTO
	CONSTRAINT rel_susProd FOREIGN KEY (claveProducto) REFERENCES catalogo.PRODUCTO(claveProducto)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.USUARIO
	CONSTRAINT rel_susUser FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)
go


--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA TELEFONOUSUARIO EN EL ESQUEMA persona-----------------------------

CREATE TABLE persona.TELEFONOUSUARIO( 
	claveTel             int identity(1,1) NOT NULL CONSTRAINT PKtelUsuario PRIMARY KEY , --SE DEFINE LA LLAVE PRIMARIA
	telefono             char(10)  NOT NULL ,
	claveUsuario         int NOT NULL ,
	
	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.USUARIO
	CONSTRAINT rel_user FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	--SE DEFINE UN CONSTRAINT UNIQUE PARA QUE EL TELEFONO NO SE REPITA 
	CONSTRAINT UQ_tel UNIQUE (telefono)
)

--SE DEFINE UN INDICE NONCLUSTERED EN LA TABLA persona.TELEFONOUSUARIO PARA LA COLUMNA claveUsuario
CREATE NONCLUSTERED INDEX NC_tel on persona.TELEFONOUSUARIO(claveUsuario ASC);
go


--------------------------------------------------------------------------------------------------------------
----------------------------CREANDO LA TABLA tipoUsuario EN EL ESQUEMA persona-----------------------------

CREATE TABLE persona.tipoUsuario (
	tipoUsuario char (1) NOT NULL,
	claveUsuario int NOT NULL,

	--DEFINIMOS UN CONSTRAINT PARA LA LLAVE PRIMARIA CON CLUSTERED CON 2 PARAMETROS
	CONSTRAINT PK_tipoUsuario PRIMARY KEY  CLUSTERED (tipoUsuario ASC,claveUsuario ASC),
	
	--SE DEFINE UN CONSTRAINT PARA LLAVE FORANEA QUE TIENE RELACION CON LA TABLA persona.USUARIO
	CONSTRAINT rel_tipoUsuario FOREIGN KEY (claveUsuario) REFERENCES persona.USUARIO(claveUsuario)
		--NO SE ELIMINARA O ACTUALIZARA CUANDO EXISTAN REGISTROS EN OTRAS TABLAS QUE SE RELACIONEN CON ESTÁ
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)

