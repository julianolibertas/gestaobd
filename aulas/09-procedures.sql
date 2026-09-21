/*
"temos a necessidade de criar um campo para armazenar o valor da comissão para cada venda."
"Esse valor será baseado na porcentagem de comissão que cada vendedor tem que ganhar, que estará 
cadastrada em um outro campo que também vamos criar na tabela de vendedores. Devemos criar esses 
dois campos utilizando o comando alter table que já aprendemos: o campo n_porcvende na tabela 
de vendedores e o n_vcomvenda na de vendas:
 "
*/
-- alter table comvende add n_porcvende float(10,2); ## Já existe
alter table comvenda add n_vcomvenda float(10,2);

DELIMITER $$
CREATE OR REPLACE PROCEDURE processa_comissionamento(
	in data_inicial date,
	in data_final date, 
	out total_processado int
)
begin
	-- variáveis de controle
	DECLARE fim INT DEFAULT 0;
	DECLARE aux INT DEFAULT 0;

	DECLARE v_venda INT DEFAULT 0;
	DECLARE v_total_venda FLOAT(10,2) DEFAULT 0.00;
	DECLARE v_vendedor INT DEFAULT 0;
	DECLARE v_comissao FLOAT(10,2) DEFAULT 0.00;
	DECLARE v_valor_comissao FLOAT(10,2) DEFAULT 0.00;
	

	## cursor para buscar os registros a serem
	## processados entre a data inicial e data final
	## e o valor total de venda é maior que zero
	DECLARE busca_pedido CURSOR FOR
		SELECT n_numevenda, 
			n_totavenda, 
			n_numevende
		FROM comvenda
		WHERE d_datavenda BETWEEN data_inicial and data_final
		AND n_totavenda >0;
	
	-- Handler para interromper o LOOP quando o cursor não encontrar mais registros
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = 1;
	
	## abro o cursor
	OPEN busca_pedido;
		## inicio do loop
		vendas: LOOP
			## recebo o valor do percentual de cada vendedor
			FETCH busca_pedido INTO v_venda, v_total_venda, v_vendedor;	
			-- Sai do loop quando o cursor esgotar os registros
	        IF fim = 1 THEN
	            LEAVE vendas;
	        END IF;
	
			-- Busca a comissão do vendedor com tratamento para valor nulo (default 1%)
	        SELECT COALESCE(n_porcvende, 1.00)
	          INTO v_comissao
	          FROM comvende
	         WHERE n_numevende = v_vendedor;
		
-- Regra de cálculo: se > 0 calcula percentual; se = 0 zera comissão
        IF (v_comissao > 0) THEN
            SET v_valor_comissao = (v_total_venda * v_comissao) / 100.00;
        ELSE
            SET v_valor_comissao = 0.00;
        END IF;

        -- Atualiza a VENDA correta usando a chave primária 'v_venda'
        UPDATE comvenda 
           SET n_vcomvenda = v_valor_comissao
         WHERE n_numevenda = v_venda;

        SET aux = aux + 1;
    END LOOP vendas;

    CLOSE busca_pedido;

    -- Atribui o total de registros processados ao parâmetro OUT
    SET total_processado = aux;

    COMMIT;
END$$
DELIMITER ;

call processa_comissionamento('2015-01-01', '2015-05-30', @a);
select @a;

