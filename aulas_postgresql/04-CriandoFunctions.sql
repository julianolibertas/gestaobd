-- Assista o vídeo desta aula
-- https://youtu.be/87P4JPbdf-U

CREATE OR REPLACE FUNCTION retorna_nome_funcionario(p_func_id INT)
RETURNS TEXT AS
$$
DECLARE
    v_nome  TEXT;
    v_ativo BOOLEAN;
BEGIN
    -- Busca o nome e o status do funcionário
    SELECT funcionario_nome, funcionario_ativo
      INTO v_nome, v_ativo
      FROM funcionario
     WHERE funcionario_id = p_func_id;

    -- Tratamento caso o ID não exista no banco
    IF NOT FOUND THEN
        RETURN 'Funcionário não encontrado!';
    END IF;

    -- Avaliação da regra de negócio
    IF v_ativo THEN
        RETURN v_nome || ' - Funcionário Ativo';
    ELSE
        RETURN v_nome || ' - Funcionário Inativo';
    END IF;
END;
$$
LANGUAGE plpgsql;

select * from funcionario f;

select retorna_nome_funcionario(3); -- Funcionário encontrado
select retorna_nome_funcionario(5); -- Funcionário não encontrado

-- Inserir a Function em uma query funcionários
select retorna_nome_funcionario(f.funcionario_id), f.funcionario_codigo  from funcionario f ;

-----------------------------------------------------

CREATE OR REPLACE FUNCTION rt_valor_comissao(p_func_id INT)
RETURNS NUMERIC(5, 2) AS 
$$
DECLARE             
    v_valor_comissao NUMERIC(5, 2);
BEGIN              
    SELECT funcionario_comissao
      INTO v_valor_comissao
      FROM funcionario
     WHERE funcionario_id = p_func_id;    

    -- Retorna 0.00 caso o funcionário não seja encontrado ou a comissão seja NULL
    RETURN COALESCE(v_valor_comissao, 0.00);
END;
$$
LANGUAGE plpgsql;


-- 1. Consultando a comissão de um funcionário específico via subquery pelo código
SELECT rt_valor_comissao(
    (SELECT funcionario_id FROM funcionario WHERE funcionario_codigo = 'FUNC-002')
) AS percentual_comissao;

-- 2. Calculando o valor em Reais da comissão sobre uma venda de R$ 100,00
SELECT 
    f.funcionario_nome,
    rt_valor_comissao(f.funcionario_id) AS taxa_comissao_pct,
    (100.00 * (rt_valor_comissao(f.funcionario_id) / 100)) AS valor_comissao_reais
FROM funcionario f
WHERE f.funcionario_codigo = 'FUNC-002';

-- Garante que a coluna existe na tabela venda para o script funcionar
ALTER TABLE venda ADD COLUMN IF NOT EXISTS venda_comissionado BOOLEAN DEFAULT FALSE;

-------------------------------

CREATE OR REPLACE FUNCTION calc_comissao(
    data_ini TIMESTAMP,
    data_fim TIMESTAMP
)
RETURNS VOID AS $$
DECLARE 
    total_comissao  NUMERIC(10, 2) := 0;
    porc_comissao   NUMERIC(5, 2)  := 0;
    reg             RECORD;

    -- Cursor com parâmetro INTEGER
    cr_porce CURSOR (p_func_id INTEGER) IS 
        SELECT rt_valor_comissao(p_func_id) AS perc;

BEGIN
    FOR reg IN ( 
         SELECT venda_id,
                funcionario_id,
                venda_total
           FROM venda
          WHERE venda_data_criacao >= data_ini
            AND venda_data_criacao <= data_fim 
            AND (venda_comissionado IS FALSE OR venda_comissionado IS NULL)
    ) LOOP         

        -- Uso do Cursor
        OPEN cr_porce(reg.funcionario_id);
        FETCH cr_porce INTO porc_comissao;
        CLOSE cr_porce;
        
        -- Cálculo da comissão individual da venda
        total_comissao := (reg.venda_total * porc_comissao) / 100;

        -- Insere registro de comissão (comissao_id gerado via IDENTITY)
        INSERT INTO comissao (
            funcionario_id,
            comissao_valor,
            comissao_ativo,
            comissao_data_criacao,
            comissao_data_atualizacao
        ) VALUES (
            reg.funcionario_id,
            total_comissao,
            TRUE,
            NOW(),
            NOW()
        );

        -- Atualiza a venda para evitar duplicidade de comissão
        UPDATE venda 
           SET venda_comissionado = TRUE
         WHERE venda_id = reg.venda_id;

        -- Reseta variáveis
        total_comissao := 0;
        porc_comissao  := 0;

    END LOOP;                                    
END;
$$ LANGUAGE plpgsql;



-- 2. Testando a Function 1 e 2
SELECT retorna_nome_funcionario(1); -- Retorna: "Carlos Silva - Funcionário Ativo"
SELECT rt_valor_comissao(1);        -- Retorna: 5.00

select * from venda v; 
-- 3. Inserindo uma Venda direta usando os IDs inteiros legíveis
INSERT INTO venda (venda_codigo, venda_valor, venda_total, funcionario_id, mesa_id)
VALUES ('VENDA-1004', 50.00, 50.00, 1, 1);

-- 4. Executando a Function de Cálculo de Comissão (VOID)
SELECT calc_comissao('2026-01-01 00:00:00', '2026-12-31 23:59:59');

-- 5. Conferindo os resultados gerados
SELECT * FROM comissao;
SELECT venda_id, venda_codigo, venda_comissionado FROM venda;
