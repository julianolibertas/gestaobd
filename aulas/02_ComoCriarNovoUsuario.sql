-----------------------------------------------------------------------------------
-- ---------------------------------------------------------------
-- Criar Usuários e suas permissões.
-- ---------------------------------------------------------------

-- Executar como ROOT:
DROP USER IF EXISTS 'usermysql'@'%';

-- Criação com acesso de qualquer IP/Host (%)
CREATE USER 'usermysql'@'%' IDENTIFIED BY 'cursomysql';

-- 1. Concede acesso a todos os bancos e tabelas
GRANT ALL PRIVILEGES ON *.* TO 'usermysql'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Teste no DBeaver (Aluno): O aluno consegue criar bancos, ver tudo e apagar tabelas.

-- 2. Revoga todos os privilégios globais
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'usermysql'@'%';
FLUSH PRIVILEGES;

-- 1. Concede acesso apenas ao banco 'Colaboradores' (ou 'comercial')
GRANT SELECT, INSERT, UPDATE, DELETE ON Colaboradores.* TO 'usermysql'@'%';

-- Teste no DBeaver (Aluno):
-- Consegue fazer SELECT em qualquer tabela do banco Colaboradores:
-- SELECT * FROM Colaboradores.tb_colaboradores;
-- Mas se tentar acessar o banco 'mysql' ou 'information_schema', terá acesso negado.

-- 2. Revoga o acesso desse banco específico
REVOKE ALL PRIVILEGES ON Colaboradores.* FROM 'usermysql'@'%';

-- 1. Concede SELECT apenas em ID, Nome e Departamento (sem a coluna Salario)
GRANT SELECT (ID, Colaborador, ID_Depto) ON Colaboradores.tb_colaboradores TO 'usermysql'@'%';
FLUSH PRIVILEGES;

-- Lista todas as permissões
SHOW GRANTS FOR 'usermysql'@'%';

-- 2. Revoga permissão na tabela
REVOKE SELECT ON Colaboradores.tb_colaboradores FROM 'usermysql'@'%';

-- Lista todas as permissões
SHOW GRANTS FOR 'usermysql'@'%';

-- Da permissão para o usermysql acessar apenas o database Colaboradores.
GRANT ALL ON Colaboradores.* TO 'usermysql'@'%';

-- ---------------------------------------
create database comercial;

GRANT ALL ON comercial.* TO 'usermysql'@'%';

-- --------------------------------
-- Area do usermysql

-- ----------------------------------

show databases;

use Colaboradores;

select * from tb_colaboradores;

-- ESTE FUNCIONA:
SELECT ID, Colaborador, ID_Depto FROM tb_colaboradores;

-- ESTE VAI DAR ERRO [1143] (SELECT command denied for column 'Salario'):
SELECT ID, Colaborador, Salario FROM tb_raw_colaboradores;

create table tb_estados as 
select t.UF, t.Estado from tb_colaboradores t;

show tables;


use comercial;

show tables;
