-- Criando nosso banco de dados.

create database comercial;

show databases;

use comercial;

-- ============================================================
-- 1. TABELAS INDEPENDENTES (CADASTROS BASE)
-- ============================================================

-- Tabela de Clientes
CREATE TABLE comclien (
    n_numeclien INT NOT NULL AUTO_INCREMENT,
    c_codiclien VARCHAR(10) UNIQUE,
    c_nomeclien VARCHAR(50) NOT NULL,
    c_razaclien VARCHAR(50),
    d_dataclien DATE DEFAULT (CURRENT_DATE),
    c_cnpjclien VARCHAR(18),
    c_foneclien VARCHAR(15),
    c_cidaclien VARCHAR(50),
    c_estaclien VARCHAR(50),
    PRIMARY KEY (n_numeclien)
);

desc comclien;

-- Tabela de Fornecedores
CREATE TABLE comforne (
    n_numeforne INT NOT NULL AUTO_INCREMENT,
    c_codiforne VARCHAR(10) UNIQUE,
    c_nomeforne VARCHAR(50) NOT NULL,
    c_razaforne VARCHAR(50),
    c_foneforne VARCHAR(15),
    PRIMARY KEY (n_numeforne)
);

desc comforne;

-- Tabela de Vendedores
CREATE TABLE comvende (
    n_numevende INT NOT NULL AUTO_INCREMENT,
    c_codivende VARCHAR(10) UNIQUE,
    c_nomevende VARCHAR(50) NOT NULL,
    c_razavende VARCHAR(50),
    c_fonevende VARCHAR(15),
    n_porcvende DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (n_numevende),
    -- Garante que a porcentagem de comissão seja válida (0% a 100%)
    CONSTRAINT chk_comvende_porc CHECK (n_porcvende >= 0.00 AND n_porcvende <= 100.00)
);

-- ============================================================
-- 2. TABELAS DEPENDENTES (COM CHAVES ESTRANGEIRAS)
-- ============================================================

-- Tabela de Produtos
CREATE TABLE comprodu (
    n_numeprodu INT NOT NULL AUTO_INCREMENT,
    c_codiprodu VARCHAR(20) UNIQUE,
    c_descprodu VARCHAR(100) NOT NULL,
    n_valoprodu DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    c_situprodu VARCHAR(1) NOT NULL DEFAULT 'A',
    n_numeforne INT NOT NULL,
    PRIMARY KEY (n_numeprodu),
    -- Regras de validação (CHECK)
    CONSTRAINT chk_comprodu_valor CHECK (n_valoprodu >= 0.00),
    CONSTRAINT chk_comprodu_situ CHECK (c_situprodu IN ('A', 'I')), -- 'A'tivo ou 'I'nativo
    -- Chave Estrangeira
    CONSTRAINT fk_comprodu_comforne FOREIGN KEY (n_numeforn)
        REFERENCES comforne (n_numeforn)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Tabela de Vendas (Cabeçalho da Venda)
CREATE TABLE comvenda (
    n_numevenda INT NOT NULL AUTO_INCREMENT,
    c_codivenda VARCHAR(10) UNIQUE,
    n_numeclien INT NOT NULL,
    n_numeforne INT NOT NULL,
    n_numevende INT NOT NULL,
    n_valovenda DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    n_descvenda DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    n_totavenda DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    d_datavenda DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (n_numevenda),
    -- Regras de validação (CHECK)
    CONSTRAINT chk_comvenda_valores CHECK (n_valovenda >= 0.00 AND n_descvenda >= 0.00 AND n_totavenda >= 0.00),
    -- Chaves Estrangeiras
    CONSTRAINT fk_comvenda_comclien FOREIGN KEY (n_numeclien)
        REFERENCES comclien (n_numeclien)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_comvenda_comforne FOREIGN KEY (n_numeforne)
        REFERENCES comforne (n_numeforne)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_comvenda_comvende FOREIGN KEY (n_numevende)
        REFERENCES comvende (n_numevende)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Tabela de Itens da Venda (Detalhe / Associação N:M)
CREATE TABLE comivenda (
    n_numeivenda INT NOT NULL AUTO_INCREMENT,
    n_numevenda  INT NOT NULL,
    n_numeprodu  INT NOT NULL,
    n_valoivenda DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    n_qtdeivenda INT NOT NULL DEFAULT 1,
    n_descivenda DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (n_numeivenda),
    -- Regras de validação (CHECK)
    CONSTRAINT chk_comivenda_qtde CHECK (n_qtdeivenda > 0),
    CONSTRAINT chk_comivenda_valores CHECK (n_valoivenda >= 0.00 AND n_descivenda >= 0.00),
    -- Chaves Estrangeiras
    CONSTRAINT fk_comivenda_comvenda FOREIGN KEY (n_numevenda)
        REFERENCES comvenda (n_numevenda)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_comivenda_comprodu FOREIGN KEY (n_numeprodu)
        REFERENCES comprodu (n_numeprodu)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- Inicio Alteração das Tabeals --

alter table comclien add column c_cidaclien varchar(50);

alter table comclien add column c_estclien varchar(50);		

alter table comclien drop column c_estclien;	

alter table comclien add column c_estaclien varchar(50);	

alter table comclien modify column  c_estaclien int;

alter table comclien modify column c_estaclien varchar(100);
	
-- Fim Alteração das Tabeals --	

-- Inicio de exclusão de tabelas -- 
drop table comvendas;
-- Fim de exclusão de tabelas -- 

-- Inicio da criação dos inidex -- 
alter table comprodu 
	add index comprodu_conforne_idx (n_numeforne asc);
alter table comvenda 
	add index comvenda_comclien (n_numeclien asc);
alter table comvenda 
	add index comvenda_comforne_idx (n_numeforne asc);
 
alter table comivenda 
	add index comivenda_comprodu_idx(n_numeprodu asc);
-- Fim da criação dos index --


-- Inicio da criação de usuarios -- 

	-- criar um usuario
mysql> create user 'comercial'@'%' identified by 'comerci@l';

	-- dando permissão
mysql> grant all privileges on *.* to 'comercial'@'%' with grant option;	

	-- selecionando as permissões do usuario
mysql> show grants for comercial@localhost;	

	-- para consultar os usuarios criados 
mysql> select user,	host from mysql.user;
	
-- Fim da criação de usuarios -- 

