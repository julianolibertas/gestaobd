desc comvenda;
select * from comvenda where n_numevenda = 22;

## delete FROM comvenda where n_numevenda = 21;
## inserir uma venda na tabela comvenda;
INSERT INTO comvenda (
	c_codivenda,
	n_numeclien,
	n_numeforne,
	n_numevende
) value (
	22, 
	4,
	2,
	2
);

desc comivenda;
select * from comprodu;
/*
1 NOTEBOOK	1251.29
2 SMARTPHONE	1242.21
3 DESKTOP	1241.21
*/
insert into comivenda (
	n_numevenda,  # amarra itens à venda
	n_numeprodu,  # numero do produto
	n_valoivenda, # valor unitário do produto
	n_qtdeivenda, # qtde de itens da venda
	n_descivenda # valor do desconto
) VALUES 
(22, 1, 1251.29, 2, 200.00),
(22, 2, 1242.21, 3, 300.00),
(22, 3, 1241.21, 1, 0.00);

select * from comivenda where n_numevenda = 22;
/*
Campos calculados
n_valovenda = Valor da venda sem desconto
n_descvenda = Valor desconto
n_totavenda = Valor total venda menos descontos
d_datavenda = data da venda - automático por causa o default curdate()
n_vcomvenda = Valor da comissão vendedores - Porcentagem x TotalVenda
 */
desc comivenda;
select * from comivenda;
select * from comprodu;


## =======================================================================

## "consultar o percentual da comissão do cadastro de vendedores para gerar o cálculo."
DELIMITER $$

CREATE OR REPLACE FUNCTION rt_percentual_comissao(vn_n_numevende INT)
RETURNS DECIMAL(5,2)
    READS SQL DATA
BEGIN
    DECLARE percentual_comissao DECIMAL(5,2) DEFAULT 0.00;

    SELECT COALESCE(n_porcvende, 0.00) 
      INTO percentual_comissao
      FROM comvende
     WHERE n_numevende = vn_n_numevende;

    RETURN percentual_comissao;
END$$

DELIMITER ;

## =======================================================================
## Trigger antes da atualização (update)

DELIMITER $$

CREATE OR REPLACE TRIGGER tri_vendas_bu
BEFORE UPDATE ON comvenda
FOR EACH ROW
BEGIN
    DECLARE percentual_comissao DECIMAL(5,2) DEFAULT 0.00;
    DECLARE valor_comissao DECIMAL(10,2) DEFAULT 0.00;

    -- Recalcula se o valor total mudou OU se o vendedor responsável foi alterado
    IF NOT (OLD.n_totavenda <=> NEW.n_totavenda) 
       OR NOT (OLD.n_numevende <=> NEW.n_numevende) THEN
       
        -- Chamada direta da função escalar sem sobrecarga de SELECT
        SET percentual_comissao = rt_percentual_comissao(NEW.n_numevende);

        -- Cálculo da comissão garantindo que totais negativos ou nulos fiquem zerados
        SET valor_comissao = ROUND((COALESCE(NEW.n_totavenda, 0.00) * percentual_comissao) / 100.00, 2);

        -- Atribuição direta ao novo registro antes de gravar em disco
        SET NEW.n_vcomvenda = valor_comissao;
    END IF;
END$$

DELIMITER ;

## =======================================================================
## "after insert (depois de inserir)"
DELIMITER $$

CREATE OR REPLACE TRIGGER tri_vendas_ai
AFTER INSERT ON comivenda
FOR EACH ROW
BEGIN
    UPDATE comvenda cv
    INNER JOIN (
        SELECT 
            n_numevenda,
            SUM(n_valoivenda * n_qtdeivenda) AS soma_bruta,
            SUM(COALESCE(n_descivenda, 0.00)) AS soma_desconto,
            SUM((n_valoivenda * n_qtdeivenda) - COALESCE(n_descivenda, 0.00)) AS soma_liquida
        FROM comivenda
        WHERE n_numevenda = NEW.n_numevenda
        GROUP BY n_numevenda
    ) itens ON cv.n_numevenda = itens.n_numevenda
    SET 
        cv.n_valovenda = itens.soma_bruta,
        cv.n_descvenda = itens.soma_desconto,
        cv.n_totavenda = itens.soma_liquida
    WHERE cv.n_numevenda = NEW.n_numevenda;
END$$

DELIMITER ;

## =======================================================================
## "after Update (depois de atualizar)"
DELIMITER $$

CREATE OR REPLACE TRIGGER tri_vendas_au
AFTER UPDATE ON comivenda
FOR EACH ROW
BEGIN
    -- 1. Recalcula o pedido atualizado (NEW)
    UPDATE comvenda cv
    INNER JOIN (
        SELECT 
            n_numevenda,
            SUM(n_valoivenda * n_qtdeivenda) AS soma_bruta,
            SUM(COALESCE(n_descivenda, 0.00)) AS soma_desconto,
            SUM((n_valoivenda * n_qtdeivenda) - COALESCE(n_descivenda, 0.00)) AS soma_liquida
        FROM comivenda
        WHERE n_numevenda = NEW.n_numevenda
        GROUP BY n_numevenda
    ) itens ON cv.n_numevenda = itens.n_numevenda
    SET 
        cv.n_valovenda = itens.soma_bruta,
        cv.n_descvenda = itens.soma_desconto,
        cv.n_totavenda = itens.soma_liquida
    WHERE cv.n_numevenda = NEW.n_numevenda;

    -- 2. Segurança: se o item mudou de número de venda, recalcula também a venda anterior (OLD)
    IF OLD.n_numevenda <> NEW.n_numevenda THEN
        UPDATE comvenda cv
        LEFT JOIN (
            SELECT 
                n_numevenda,
                SUM(n_valoivenda * n_qtdeivenda) AS soma_bruta,
                SUM(COALESCE(n_descivenda, 0.00)) AS soma_desconto,
                SUM((n_valoivenda * n_qtdeivenda) - COALESCE(n_descivenda, 0.00)) AS soma_liquida
            FROM comivenda
            WHERE n_numevenda = OLD.n_numevenda
            GROUP BY n_numevenda
        ) itens ON cv.n_numevenda = itens.n_numevenda
        SET 
            cv.n_valovenda = COALESCE(itens.soma_bruta, 0.00),
            cv.n_descvenda = COALESCE(itens.soma_desconto, 0.00),
            cv.n_totavenda = COALESCE(itens.soma_liquida, 0.00)
        WHERE cv.n_numevenda = OLD.n_numevenda;
    END IF;
END$$

DELIMITER ;

## =======================================================================
## "after delete (depois de deletar)"
DELIMITER $$

CREATE OR REPLACE TRIGGER tri_vendas_ad
AFTER DELETE ON comivenda
FOR EACH ROW
BEGIN
    UPDATE comvenda cv
    LEFT JOIN (
        SELECT 
            n_numevenda,
            SUM(n_valoivenda * n_qtdeivenda) AS soma_bruta,
            SUM(COALESCE(n_descivenda, 0.00)) AS soma_desconto,
            SUM((n_valoivenda * n_qtdeivenda) - COALESCE(n_descivenda, 0.00)) AS soma_liquida
        FROM comivenda
        WHERE n_numevenda = OLD.n_numevenda
        GROUP BY n_numevenda
    ) itens ON cv.n_numevenda = itens.n_numevenda
    SET 
        cv.n_valovenda = COALESCE(itens.soma_bruta, 0.00),
        cv.n_descvenda = COALESCE(itens.soma_desconto, 0.00),
        cv.n_totavenda = COALESCE(itens.soma_liquida, 0.00)
    WHERE cv.n_numevenda = OLD.n_numevenda;
END$$

DELIMITER ;


## =======================================================================
-- 1. Insere uma venda base vazia
INSERT INTO comvenda (c_codivenda, n_numeclien, n_numeforne, n_numevende, d_datavenda)
VALUES ('VND-001', 1, 1, 1, CURRENT_DATE);

-- Pega o ID gerado da venda (exemplo: supondo que seja 1)
SET @venda_id = LAST_INSERT_ID();

-- 2. TESTE AFTER INSERT: Insere 2 unidades a R$ 100,00 com R$ 10,00 de desconto
INSERT INTO comivenda (n_numevenda, n_numeprodu, n_valoivenda, n_qtdeivenda, n_descivenda)
VALUES (@venda_id, 1, 100.00, 2, 10.00);

-- Conferir comvenda: Bruto deve estar 200.00, Desconto 10.00, Total 190.00
SELECT n_valovenda, n_descvenda, n_totavenda FROM comvenda WHERE n_numevenda = @venda_id;

-- 3. TESTE AFTER UPDATE: Altera a quantidade de 2 para 5
UPDATE comivenda 
SET n_qtdeivenda = 5 
WHERE n_numevenda = @venda_id;

-- Conferir comvenda: Bruto deve estar 500.00, Desconto 10.00, Total 490.00
SELECT n_valovenda, n_descvenda, n_totavenda FROM comvenda WHERE n_numevenda = @venda_id;

-- 4. TESTE AFTER DELETE: Remove o item da venda
DELETE FROM comivenda WHERE n_numevenda = @venda_id;

-- Conferir comvenda: Deve zerar perfeitamente (0.00, 0.00, 0.00)
SELECT n_valovenda, n_descvenda, n_totavenda FROM comvenda WHERE n_numevenda = @venda_id;

