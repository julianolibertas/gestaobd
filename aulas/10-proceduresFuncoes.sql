/*
 * Vamos criar uma function para retornar o nome do cliente. Poderíamos fazer uma consulta 
 * por meio de um join para realizar esse retorno, o mesmo que fizemos no capítulo 5, 
 * quando queríamos retornar o nome do cliente da venda.  
 * Porém, imagine que você está fazendo uma consulta com muitas tabelas e joins em seu sistema.
 */

DELIMITER $$
CREATE or REPLACE FUNCTION rt_nome_cliente(v_numeclien int)
RETURNS VARCHAR(50)
BEGIN
	DECLARE nome varchar(50);
	SELECT c_nomeclien INTO nome
		FROM comclien
	WHERE n_numeclien = v_numeclien;

	RETURN nome;
END$$
DELIMITER ;

## estou passando como parâmetro o id do cliente igual a 1
select rt_nome_cliente(1);
select rt_nome_cliente(1) from dual;

## irei retornar o código da venda, nome do cliente e a 
## data da venda ordenando pelo nome e em seguida pela data
select c_codivenda, rt_nome_cliente(n_numeclien), d_datavenda from comvenda order by 2,3;

## funciona com root por causa dos privelégios
set global event_scheduler = on;

select SYSDATE() from dual;

delimiter $$
create or replace event processa_comissao
on schedule every 1 week starts '2026-09-21 23:38:22'
do 
	begin
		call processa_comissionamento(
			current_date() - interval 7 day,
		current_date(), @a);
	end
$$
delimiter ;

## para vermos o resultado, vamos consultar as vendas desse período
select c_codivenda Codigo, 
               n_totavenda Total, 
          n_vcomvenda Comissao
           from comvenda
      where 
        d_datavenda between current_date() - interval 60 day 
          and current_date();
		
/*
"Podemos também executar os eventos com outras periodicidades, entre elas:
                  
 on schedule every 1 year: uma vez por ano;
 on schedule every 1 month: uma vez por mês;
 on schedule every 1 day: uma vez ao dia;
 on schedule every 1 hour: uma vez por hora;
 on schedule every 1 minute: uma vez por minuto;
 on schedule every 1 second: uma vez por segundo."
*/

delimiter $$
create or replace event processa_comissao_event
on schedule every 10 minute
starts current_timestamp
ends current_timestamp + interval 30 minute
do
begin
	call processa_comissionamento( 
		current_date() - interval 7 day, 
	current_date(), 
	@a);
end 
$$    
delimiter ;

/*
 * "Ao criar um evento, ele fica habilitado automaticamente. Pode acontecer que, 
 * depois de um período, você não queira mais que o processo execute maquinalmente. 
 * Em vez de excluí-lo, você pode apenas desabilitá-lo com o seguinte comando:"
 * 
 */
alter event processa_comissao_event disable;

## E para habilitá-lo novamente:
alter event processa_comissao_event enable;


## Para realizar a nossa operação, devemos consultar o percentual da comissão 
## do cadastro de vendedores para gerar o cálculo.

delimiter $$
create function rt_percentual_comissao(vn_n_numevende int)
	returns float deterministic
	begin
		declare percentual_comissao float(10,2);-+/ ,
		select n_porcvende
			into percentual_comissao
			from comvende
		where n_numevende = vn_n_numevende;
		return percentual_comissao;
	end;
$$
delimiter ;