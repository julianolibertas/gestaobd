docker exec -it <nome_do_container> mariadb -u root -p

-- Erro na importação, depois de alterar tamanho do campo endereço.
drop table erp_Coloboradores;

-- Fazer um backup da tabela erp_Coloboradores
create table tb_colaboradores as select * from erp_Coloboradores;

-- pesquisa os campos data com valor NULL
select ec.Admissao, ec.Demissao, ec.Venc_Ferias, ec.Nascimento  from tb_colaboradores ec where ec.Demissao = 'NULL' 

-- retira todos os campos NULL
update tb_colaboradores ec set Demissao = NULL where Demissao = 'NULL'

-- Altera os campos datas com VARCHAR para DATE.
ALTER TABLE tb_colaboradores MODIFY COLUMN Admissao DATE DEFAULT NULL NULL;
ALTER TABLE tb_colaboradores MODIFY COLUMN Demissao DATE DEFAULT NULL NULL;
ALTER TABLE tb_colaboradores MODIFY COLUMN Venc_Ferias DATE DEFAULT NULL NULL;
ALTER TABLE tb_colaboradores MODIFY COLUMN Nascimento DATE DEFAULT NULL NULL;

select * from tb_colaboradores tc;

-- listar agrupado
select DISTINCT ID_Empresa from tb_colaboradores tc ;
select DISTINCT tc.Status from tb_colaboradores tc ORDER by 1;
select DISTINCT tc.sexo from tb_colaboradores tc ORDER by 1;
select DISTINCT tc.ID_Est_Civil from tb_colaboradores tc ORDER by 1;
select DISTINCT tc.Deficiente from tb_colaboradores tc ORDER by 1;
select DISTINCT tc.Aposentado  from tb_colaboradores tc ORDER by 1;





-- Quando usar função, obrigatórioo agrupar os campos
select ID_Empresa, count(*) from tb_colaboradores tc group by ID_Empresa 