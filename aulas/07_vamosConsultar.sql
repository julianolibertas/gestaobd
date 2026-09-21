select n_numeclien, c_codiclien, c_razaclien from comclien;
select n_numeclien, c_codiclien, c_razaclien from comclien where c_codiclien = '0001';
select n_numeclien, c_codiclien, c_razaclien from comclien where c_codiclien <> '0001';
select n_numeclien, c_codiclien, c_razaclien from comclien where c_razaclien like 'L%';
select n_numeclien from comvenda;
select distinct n_numeclien from comvenda;

select c_codiclien, c_razaclien from comclien where n_numeclien in (1,2);
select c_codiclien, c_razaclien from comclien where n_numeclien not in (1,2);
-- somente os clientes que efutuaram compras
select c_codiclien, c_razaclien from comclien where n_numeclien in (select v.n_numeclien from comvenda v);
-- somente os clientes que não efutuaram compras
select c_codiclien, c_razaclien from comclien where n_numeclien not in (select v.n_numeclien from comvenda v);
-- lista vendas
select * from comvenda;
-- lista o numero da venda é quem comprou
select v.c_codivenda as Cod_venda, (select c.c_razaclien from comclien c where c.n_numeclien = v.n_numeclien)  from comvenda v; 

-- "Criando tabelas por meio de select"
create table comclien_bkp as(
      select * 
	   from comclien
	   where c_estaclien = 'SP');

-- "Inserindo registros por meio de select"
create table comcontato(
           n_numecontato int not null auto_increment, 
           c_nomecontato varchar(200),      
           c_fonecontato varchar(30),
           c_cidacontato varchar(200),
           c_estacontato varchar(2),
           n_numeclien   int,      
           primary key(n_numecontato));

-- "popular as colunas da nossa tabela comcontato com essas informações que temos da tabela comclien"
insert into comcontato(
        select n_numeclien,
             c_nomeclien,
         c_foneclien,
         c_cidaclien,
         c_estaclien,
         n_numeclien
        from comclien);

-- "Alterando registros por meio de select"
update comcontato set c_cidacontato = 'LONDRINA',
                              c_estacontato = 'PR'
         where n_numeclien in ( select n_numeclien
                                from comclien_bkp);


-- "Deletando registros por meio de select"
delete from comcontato
        where n_numeclien not in (select n_numeclien
                                  from comvenda );

select * from comcontato;