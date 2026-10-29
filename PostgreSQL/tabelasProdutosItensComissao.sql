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
