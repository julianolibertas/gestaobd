insert into comclien (
			n_numeclien, 
			c_codiclien,
			c_nomeclien,
			c_razaclien,
			d_dataclien,
			c_cnpjclien,
			c_foneclien,
			c_cidaclien,
			c_estaclien
) values (
			1, 
			'0001',
			'AARONSON',
			'AARONSON FURNITURE LTDA',
			'2015-02-17',
			'17807.928/0001-85',
			'(21) 8167-6584',
			'QUEIMADOS',
			'RJ'
);

-- Por padrão, o MariaDB roda com o modo de autoconfirmação (autocommit = 1) ligado, 
-- o que significa que cada comando executado é salvo imediatamente e de forma definitiva.

-- Desativa o autocommit para a conexão atual:
SET autocommit = 0;


-- atualizar nome cliente
update comclien set c_nomeclien = 'AARONSON FURNITURE', c_cidaclien = 'LONDRINA', c_estaclien = 'PR' where n_numeclien = 1;
-- Confirma alterações pendentes quando necessário:
COMMIT;

-- atualizar nome cliente
update comclien set c_nomeclien = 'AARONSON' where n_numeclien = 1;

-- Desfaz o comando anterior:
ROLLBACK;

select * from comclien;

delete from comclien where n_numeclien = 1;
-- Desfaz o comando anterior:
ROLLBACK;

truncate table comclien;

delete from comclien;
-- Confirma alterações pendentes quando necessário:
COMMIT;


-- Reativar o modo padrão quando terminar:
SET autocommit = 1;


select * from comclien;
select * from comforne;
select * from comvende;
select * from comvenda;
select * from comivenda;
