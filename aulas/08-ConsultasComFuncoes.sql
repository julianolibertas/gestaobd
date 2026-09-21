-- "Consultas com funções"

-- lista todas as vendas e quem comprou
select c_codiclien, c_razaclien
        from comvenda, comclien
        where comvenda.n_numeclien = comclien.n_numeclien
        order by c_razaclien;
-- lista a quem comprou
select c_codiclien, c_razaclien
        from comvenda, comclien
        where comvenda.n_numeclien = comclien.n_numeclien
        group by c_codiclien, c_razaclien 
        order by c_razaclien;
-- lista quem comprou e quantas vezes
select c_codiclien, c_razaclien, count(n_numevenda) as Qtde
        from comvenda, comclien
        where comvenda.n_numeclien = comclien.n_numeclien
        group by c_codiclien, c_razaclien 
        order by c_razaclien;
-- conta quantos clientes cadastrados
select count(*) from comclien;
-- having, clientes que tiveram mais que duas vendas 
select c_razaclien, count(n_numevenda)
           from comclien, comvenda
          where comvenda.n_numeclien = comclien.n_numeclien
          group by c_razaclien  
       having count(n_numevenda) > 2;
-- qual o maior venda?
select max(n_totavenda) maior_venda from comvenda;
-- qual o maior venda?
select min(n_totavenda) maior_venda from comvenda;
-- menor e maior venda
select min(n_totavenda) menor_venda, max(n_totavenda) 
         maior_venda from comvenda;
-- Somando as vendas, descontos e total vendas
select sum(n_valovenda) valor_venda, 
                sum(n_descvenda) descontos, 
                sum(n_totavenda) total_venda
           from comvenda
          where d_datavenda between '2015-01-01' and '2015-01-31';
-- Média das vendas
select format(avg(n_totavenda),2) from comvenda;
-- substr() e length()
select c_codiprodu, c_descprodu
            from comprodu
           where substr(c_codiprodu,1,3) = '123'
           and length(c_codiprodu) > 4;
-- "selecionar apenas os cinco primeiros caracteres do campo c_razaclien 
-- e contar quantos deles temos no código do cliente"
select substr(c_razaclien,1,5) Razao_Social, 
                length(c_codiclien) Tamanho_Cod
           from comclien;
-- "listar os clientes concatenando a razão social e o telefone"
select concat(c_razaforne,' - fone: ', c_foneforne) 
           from comforne
          order by c_razaforne;
-- com filtro
select 
         concat(c_codiclien,'  ',c_razaclien, '  ', c_nomeclien)
           from comclien
      where c_razaclien like 'GREA%';

-- usando o concat_ws
select 
         concat_ws(' - ',c_codiclien,c_razaclien, c_nomeclien)
           from comclien
      where c_razaclien like 'GREA%';

-- Exibir minúscula. lcase ou lower
select lcase(c_razaclien) from comclien;
-- Exibir maiúsculo.
select ucase('Banco de dados mysql') from dual;

-- Round para arrendodar e definir a qtde de casas.
select round('213.142',2) from dual;
-- alternativa ao round,  Format
select format('213.142',2) from dual;
-- "truncar as casas decimais"
select truncate(max(n_totavenda),0) maior_venda from comvenda;
select truncate(min(n_totavenda),1) maior_venda from comvenda;

-- raiz quadrada
select SQRT(4);

-- OPERADORES - Multiplicação
select (n_qtdeivenda * n_valoivenda) multiplicação
           from comivenda
      where n_numeivenda = 4;
-- divisão
select truncate((sum(n_valoivenda) / 
          count(n_numeivenda)),2) divisão
            from comivenda;
-- subtrair
select (n_valoivenda - n_descivenda) subtração
           from comivenda
      where n_numeivenda = 4;


-- FUNÇÕES DATA
select CURDATE();

select NOW();

select SYSDATE();

select CURTIME();

-- diferenças entre datas
select datediff('2026-02-01 23:59:59','2026-01-01');
-- adicionar dias
select date_add('2026-09-09', interval 31 day);
-- nome do dia em uma data
select DAYNAME('2026-09-09');
-- retorna o dia no mês
select dayofmonth('2026-09-09');
-- extrair o ano
select extract(year from '2026-09-09');
-- extrair o último dia do mês.
select last_day('2024-02-01');

-- formatando datas
select date_format('2026-09-09',get_format(date,'EUR'));

select str_to_date('01.01.2015',get_format(date,'USA'));


