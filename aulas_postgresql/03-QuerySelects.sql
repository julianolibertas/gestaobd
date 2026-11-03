-- Seleciona todos os produtos registados
SELECT * FROM produto;

-- Lista apenas o código, nome e preço dos produtos
SELECT produto_codigo, produto_nome, produto_valor 
FROM produto;

-- Lista apenas as mesas que estão na área externa e ativas
SELECT mesa_codigo, mesa_area_restaurante 
FROM mesa 
WHERE mesa_ativo = true 
  AND mesa_area_restaurante = 'EXTERNA';

-- Lista os funcionários e as suas comissões, do maior para o menor percentual
SELECT 
    funcionario_nome AS "Nome do Funcionário",
    funcionario_cargo AS "Cargo",
    funcionario_comissao AS "Comissão (%)"
FROM funcionario
ORDER BY funcionario_comissao DESC;

-- Simula um desconto de 10% no valor dos produtos
SELECT 
    produto_nome,
    produto_valor AS "Preço Original",
    ROUND(produto_valor * 0.90, 2) AS "Preço com 10% de Desconto"
FROM produto;

-- Exibe as vendas com os nomes dos respetivos funcionários e códigos das mesas
SELECT 
    v.venda_codigo AS "Código da Venda",
    f.funcionario_nome AS "Atendido por",
    m.mesa_codigo AS "Mesa",
    v.venda_total AS "Total (R$)"
FROM venda v
INNER JOIN funcionario f ON v.funcionario_id = f.funcionario_id
INNER JOIN mesa m ON v.mesa_id = m.mesa_id;

-- Detalha os produtos vendidos na venda com código 'VENDA-1001'
SELECT 
    v.venda_codigo,
    p.produto_nome,
    iv.itens_venda_quantidade AS "Qtd",
    iv.itens_venda_valor AS "Valor Unitário",
    iv.itens_venda_total AS "Subtotal"
FROM itens_venda iv
INNER JOIN venda v ON iv.venda_id = v.venda_id
INNER JOIN produto p ON iv.produto_id = p.produto_id
WHERE v.venda_codigo = 'VENDA-1001';


-- Total de vendas e valor acumulado por funcionário
SELECT 
    f.funcionario_nome AS "Funcionário",
    COUNT(v.venda_id) AS "Total de Vendas Realizadas",
    SUM(v.venda_total) AS "Faturação Total"
FROM venda v
INNER JOIN funcionario f ON v.funcionario_id = f.funcionario_id
GROUP BY f.funcionario_nome
ORDER BY "Faturação Total" DESC;


-- Lista apenas os funcionários que faturaram mais de R$ 40,00 no total
SELECT 
    f.funcionario_nome,
    SUM(v.venda_total) AS total_faturado
FROM venda v
INNER JOIN funcionario f ON v.funcionario_id = f.funcionario_id
GROUP BY f.funcionario_nome
HAVING SUM(v.venda_total) > 40.00;