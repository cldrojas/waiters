
create table usuario(
	id int primary key auto_increment,	
	email varchar(25) not null,
	password varchar(255) not null
);

create table cargo(
	id int primary key auto_increment,
	nombre varchar(25) not null
);

create table categoria(
	id int primary key auto_increment,
	nombre varchar(25) not null
);

create table local(
	id int primary key auto_increment,
	nombre varchar(25) not null
);

create table trabajador(
	id int primary key auto_increment,
	nombre varchar(25) not null,
	cargo int not null,
	usuario int not null,
	activo int not null DEFAULT 1,
	foreign key (cargo) references cargo (id),
	foreign key (usuario) references usuario (id)
);

create table venta(
	id int primary key auto_increment,
	fecha date not null DEFAULT CURDATE(),
	trabajador int not null,
	local int not null,
	valor int not null,
	foreign key (trabajador) references trabajador (id),
	foreign key (local) references local (id)
);

create table sandwich(
	id int primary key auto_increment,
	nombre varchar(25) not null,
	categoria int not null,
	valor int not null,
	foreign key (categoria) references categoria (id)
);

create table detalle_venta(
	id int primary key auto_increment,
	sandwich int not null,
	venta int not null,
	foreign key (sandwich) references sandwich (id),
	foreign key (venta) references venta (id)
);

insert into cargo (nombre) values ('cocinero'), ('cajero'), ('mesero'), ('admin');
insert into local (nombre) values ('lincoyan'), ('bilbao');
insert into categoria (nombre) values ('carne'), ('filete de ave'), ('hamburguesa casera'), ('lomito'), ('hamburguesa vegana'),('extras');
insert into usuario (email,password) values ('admin', 'spinnetcl'), ('cocina','spinnetcl'), ('mesa','spinnetcl'), ('caja','spinnetcl');
insert into trabajador (nombre, cargo, usuario) values ('admin',4,1);