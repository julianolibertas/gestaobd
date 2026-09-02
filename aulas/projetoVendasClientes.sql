show databases;

show tables;

create table comclien(
	n_numeclien int NOT NULL auto_increment,
	c_codiclien varchar(10) UNIQUE,
	c_nomeclien varchar(100) NOT NULL,
	c_razaclien varchar(100),
	d_dataclien date default (CURRENT_DATE),
	c_cnpjclien varchar(18),
	c_foneclien varchar(15),
	c_cidaclien varchar(100),
	c_estaclien varchar(50),
	primary key (n_numeclien)
);

desc comclien;