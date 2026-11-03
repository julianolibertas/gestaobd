drop table comissao;
drop table itens_venda;
drop table produto;
drop table funcionario;
drop table venda;
drop table mesa;


create table if not exists mesa(
	mesa_id INTEGER not null primary key, 
	mesa_codigo VARCHAR(20) not null UNIQUE,
	mesa_ativo BOOLEAN default true,
	mesa_data_criacao TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    mesa_data_atualizacao TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- Para inserir autonumeracao GENERATED ALWAYS AS IDENTITY
-- Sequencia ou autonumeracao
ALTER TABLE mesa 
    ALTER COLUMN mesa_id ADD GENERATED ALWAYS AS IDENTITY;

create table if not exists funcionario(
	funcionario_id   INTEGER not null primary key GENERATED ALWAYS AS IDENTITY,
	funcionario_codigo 			 VARCHAR(20) not null UNIQUE,
	funcionario_nome             VARCHAR(100),
    funcionario_ativo            BOOLEAN DEFAULT true,
    funcionario_comissao         NUMERIC(5, 2) DEFAULT 0.00,
    funcionario_cargo            VARCHAR(30),
    funcionario_data_criacao TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    funcionario_data_atualizacao TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- DROP TABLE IF EXISTS venda;

CREATE TABLE IF NOT EXISTS venda(
    venda_id               INTEGER not null primary key GENERATED ALWAYS AS IDENTITY,
    venda_codigo           VARCHAR(20) not null unique,
    venda_valor 		   NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    venda_total    		   NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    venda_desconto 		   NUMERIC(10, 2) DEFAULT 0.00,
    venda_ativo            BOOLEAN DEFAULT true,
    venda_data_criacao     TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    venda_data_atualizacao TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    funcionario_id         INTEGER not null,
    mesa_id                INTEGER not null,
    CONSTRAINT venda_funcionario_fk FOREIGN KEY (funcionario_id)
        REFERENCES funcionario (funcionario_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT venda_mesa_fk        FOREIGN KEY (mesa_id)
        REFERENCES mesa (mesa_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID);


-- DROP TABLE IF EXISTS produto;

CREATE TABLE IF NOT EXISTS produto(
    produto_id               INTEGER not null primary key GENERATED ALWAYS AS IDENTITY,
    produto_codigo           VARCHAR(20),
    produto_nome             VARCHAR(60),
    produto_valor 			 NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    produto_ativo            BOOLEAN NOT NULL DEFAULT true,
    produto_data_criacao     TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    produto_data_atualizacao TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP);

-- DROP TABLE IF EXISTS itens_venda;

CREATE TABLE IF NOT EXISTS itens_venda(
    itens_venda_id            INTEGER not null primary key GENERATED ALWAYS AS IDENTITY,
    venda_id                  INTEGER not null,
    produto_id                INTEGER not null,
    itens_venda_valor 		  NUMERIC(10, 2) NOT NULL,
    itens_venda_quantidade    INTEGER NOT NULL CHECK (itens_venda_quantidade > 0),
    itens_venda_total         NUMERIC(10, 2) NOT NULL,
    itens_data_criacao 		  TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    itens_data_atualizacao    TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    itens_venda_comissionado  BOOLEAN DEFAULT FALSE,
    CONSTRAINT itens_venda_produto_fk FOREIGN KEY (produto_id)
        REFERENCES produto (produto_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT itens_venda_venda_fk FOREIGN KEY (venda_id)
        REFERENCES venda (venda_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);

-- DROP TABLE IF EXISTS comissao;

CREATE TABLE IF NOT EXISTS comissao(
    comissao_id               INTEGER not null primary key GENERATED ALWAYS AS IDENTITY,
    funcionario_id            INTEGER not null,
    comissao_valor 			  NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    comissao_ativo            BOOLEAN DEFAULT true,
    comissao_data_criacao 	  TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    comissao_data_atualizacao TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT comissao_funcionario_fk FOREIGN KEY (funcionario_id)
        REFERENCES funcionario (funcionario_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);

-----------------------------------------------------


-- se precisar apagar alguma constraint
ALTER TABLE comissao DROP CONSTRAINT comissao_funcionario_fk;

-- Constraint de validação table vendas
ALTER TABLE venda ADD CHECK (venda_total > 0);

-- Constraint não permitir valor NULL
ALTER TABLE funcionario ADD CHECK (funcionario_nome IS NOT NULL);




--Para campos UUID, também podemos fixar um valor padrão para a chave primária 
-- ser gerada automaticamente, através do seguinte comando:
ALTER TABLE produto
ALTER column produto_id SET DEFAULT gen_random_uuid();

-- inserir um campo novo
ALTER TABLE comissao ALTER COLUMN comissao_data_pagamento TYPE DATE USING NULL;

-- Vamos alterar a nossa tabela MESA e adicionar um tipo de campo ENUM 
-- para podermos indicar onde a mesa fica posicionada, se é na área externa ou interna 
-- do restaurante. 
-- Primeiro precisamos criar o campo do tipo ENUM. 
CREATE TYPE area_restaurante AS ENUM('INTERNA', 'EXTERNA');
-- E então adicionamos na tabela um novo campo mesa_area_restaurante, 
-- que passa a ser um campo do tipo area_restaurante que foi criado como ENUM. 
ALTER TABLE mesa ADD COLUMN mesa_area_restaurante area_restaurante;