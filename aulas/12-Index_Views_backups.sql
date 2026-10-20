## cria um novo índice 
ALTER TABLE comclien ADD 
	INDEX idx_comclien_1(c_razaclien);
## cria índice
ALTER TABLE comclien ADD 
	INDEX idx_comclien_2(c_codiclien);
## lista todos os índices da comclien
SHOW INDEXES FROM comclien;
## lista conteúdo da comclien
DESC comclien;
## apaga um índice
ALTER TABLE comclien DROP INDEX idx_comclien_1;

## criando uma nova view 
CREATE OR REPLACE VIEW clientes_vendas as 
	SELECT c_razaclien,
		c_nomeclien,
		c_cnpjclien,
		c_codivenda,
		n_totavenda,
		d_datavenda
		from comclien,
			comvenda
		where comclien.n_numeclien = comvenda.n_numeclien
		order by 1;

## excluíndo uma view
DROP VIEW view_clientes_vendas;

## usando uma view
select * from clientes_vendas;

## cria uma nova view sem join(permite insert, updade, delete)
CREATE OR REPLACE VIEW produtos as 
	select n_numeprodu,
	c_codiprodu,
	c_descprodu, 
	n_valoprodu, 
	c_situprodu,
	n_numeforne
	from comprodu;

## compara view com table
desc produtos;
desc comprodu;

## inserir dados direto da view
INSERT INTO produtos 
	values (6, '0006', 'SMART WATCH', 2412.98, 'A', 1);

## lista conteudo da view
SELECT * FROM produtos;
SELECT * FROM comprodu;

## atualiza um registro usando view
UPDATE produtos SET n_valoprodu = '1245.99'
          WHERE n_numeprodu = 6;
## apagar um registro usando a view
delete from produtos where n_numeprodu = 6;



/*
"Vamos criar um backup de todas as tabelas do banco do nosso projeto. 
Este criará um arquivo com a extensão .sql, que vai conter os scripts 
de criação e inserção de registros das tabelas exportadas. 
Vamos abrir o console e navegar até a pasta bin da instalação do MySQL." 
 
 */
mysqldump -u root -p 
       comercial > c:/bkp_tables_views.sql


"mysqldump  -u root -p --routines --triggers 
2       comercial > c:/bkp_full.sql"
     
## backup usando container docker MariaDB
docker exec -i nome_do_contentor mariadb-dump -u root -p'sua_senha' --routines --triggers nome_da_base_de_dados > backup_nome_da_base.sql       
docker exec -i 7094f6bf14ce mariadb-dump -u root -p'senha' --routines --triggers comercial > backup_comerciale.sql

## restaurando banco de dados.
docker exec -i nome_do_contentor mariadb -u root -p'sua_senha' nome_da_base_de_dados < backup_nome_da_base.sql
docker exec -i 7094f6bf14ce mariadb -u root -p'senha' comercial02 < backup_comerciale.sql



# Desempenho 
 
alter table nome_tabela
add index nome_index(nome_coluna);

alter table nome_tabela
add unique index nome_index(nome_coluna);

show index from nome_tabela;

alter table nome_tabela drop index nome_index;
 

# Views
 
## Não fique reescrevendo códigos repetitivos. Crie  views
 
create or replace view nome_view as
		select campos
		from tabelas
		where codições;

drop view nome_view;
 

# Crei Backup 
 
## Crie backups com frequência. Ele poderá salvar seu sistema um dia!
 
## Exportando uma tabela
mysql\bin> mysqldump -u root -p comercial comclien > c:/bkp_clien.sql

## Exportando tudo
mysql\bin> mysqldump -u root -p –routines –triggers comercial > c:/bkp_full.sql

## Importando tudo
mysql\bin> mysql -h localhost -u root -p comercial2 < c:/bkp_full.sql
 
 
## Listar as variáveis
show VARIABLES;

set nome_da_variavel = novo_valor;
 
# Visualizando e matando as conexões ativas em nosso banco de dados.
 
## Visualizando conexões ativas
show processlist;

## Matando conexões ativas
kill numero_PID;
 