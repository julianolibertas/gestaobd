show databases;

show tables;
-- tabela clientes
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
-- tabela fornecedores
create table comforne (
	n_numeforne int PRIMARY key not null auto_increment,
	c_codiforne varchar(10) UNIQUE,
	c_nomeforne varchar(100) not null,
	c_razaforne varchar(100) not null,
	c_foneforne varchar(15)
);

desc comforne;
-- tabela vendedores
create table comvende (
	n_numevende int PRIMARY KEY NOT NULL auto_increment,
	c_codivende varchar(10) UNIQUE,
	c_nomevende varchar(100) NOT NULL,
	c_razavende varchar(100),
	c_fonevende varchar(15),
	n_porcvende decimal(5,2) NOT NULL default 0.00,
	CONSTRAINT chk_porcvende CHECK (n_porcvende >= 0.00 
		AND n_porcvende <= 100.00)
);

-- tabela produtos
create table comprodu (
	n_numeprodu int primary key not NULL auto_increment,
	c_codiprodu varchar(10) UNIQUE,
	c_descprodu varchar(100) NOT NULL,
	n_valoprodu decimal(10,2) NOT NULL default 0.00,
	c_situprodu varchar(1) NOT NULL DEFAULT 'A',
	n_numeforne int not null,
	CONSTRAINT chk_valor CHECK (n_valoprodu >= 0.00),
	constraint chk_situacao 
		CHECK (c_situprodu in ('A', 'I')),
	constraint fk_comprodu_comforme 
		FOREIGN KEY (n_numeforne)
		REFERENCES comforne (n_numeforne)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

desc comprodu;

-- tabela Vendas
create table comvenda (
	n_numevenda int primary key not null auto_increment,
	c_codivenda varchar(10) UNIQUE,
	n_numeclien int NOT null,
	n_numeforne int NOT null,
	n_numevende int NOT null,
	n_valovenda decimal(10,2) not null default 0.00,
	n_descvenda decimal(10,2) not null default 0.00,
	n_totavenda decimal(15,2) not null default 0.00,
	d_datavenda date not null default (current_date),
	constraint chk_valores CHECK (
		n_valovenda >= 0.00
		and n_descvenda >= 0.00
		and n_totavenda >= 0.00),
	constraint fk_comvenda_comclien 
		FOREIGN KEY (n_numeclien)
		REFERENCES comclien (n_numeclien)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	constraint fk_comvenda_comforne 
		FOREIGN KEY (n_numeforne)
		REFERENCES comforne (n_numeforne)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	constraint fk_comvenda_comvende 
		FOREIGN KEY (n_numevende)
		REFERENCES comvende (n_numevende)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

-- tabela de itens da venda
CREATE TABLE comivenda (
	n_numeivenda int PRIMARY KEY not null auto_increment,
	n_numevenda int NOT NULL,
	n_numeprodu int NOT NULL,
	n_valoivenda decimal(10,2) not null DEFAULT 0.00,
	n_qtdeivenda int not null default 1,
	n_descivenda decimal(10,2) not null default 0.00,
	CONSTRAINT chk_qtde CHECK (n_qtdeivenda > 0),
	CONSTRAINT chk_valores 
		CHECK (n_valoivenda >= 0.00 and n_descivenda >=0)
);





