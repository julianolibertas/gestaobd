-- se existir apagar o usuario.
drop user if exists 'usermysql'@'%';
-- cria um novo usuário com a senha cursomysql
create user 'usermysql'@'%' IDENTIFIED BY 'cursomysql';
-- Concede todos os privilegios do BD
grant all privileges on *.* to 'usermysql'@'%' 
with grant option;
-- revoga todos os privilegios
revoke all privileges, grant option from 'usermysql'@'%';
flush privileges;
-- Concede acesso apenas ao banco de dados colaboradores
grant select, insert, update, delete on colaboradores.*
to 'usermysql'@'%';
revoke all privileges on colaboradores.*
from 'usermysql'@'%';

grant select (ID, Colaborador, ID_Depto) on 
colaboradores.tb_colaboradores
to 'usermysql'@'%';

show grants for 'usermysql'@'%';

create database comercial;

grant all privileges on comercial.* to 'usermysql'@'%' 
with grant option;

