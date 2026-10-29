BEGIN;

-- 1. POPULANDO A TABELA: mesa
INSERT INTO mesa (mesa_codigo, mesa_ativo, mesa_area_restaurante) VALUES
('MESA-01', true, 'INTERNA'),
('MESA-02', true, 'INTERNA'),
('MESA-03', true, 'EXTERNA'),
('MESA-04', true, 'EXTERNA'),
('MESA-05', false, 'INTERNA');

-- 2. POPULANDO A TABELA: funcionario
INSERT INTO funcionario (funcionario_codigo, funcionario_nome, funcionario_ativo, funcionario_comissao, funcionario_cargo) VALUES
('FUNC-001', 'Carlos Silva', true, 5.00, 'Garçom'),
('FUNC-002', 'Mariana Oliveira', true, 5.00, 'Garçom'),
('FUNC-003', 'Roberto Santos', true, 10.00, 'Gerente'),
('FUNC-004', 'Ana Costa', false, 5.00, 'Garçom');

-- 3. POPULANDO A TABELA: produto
INSERT INTO produto (produto_codigo, produto_nome, produto_valor, produto_ativo) VALUES
('PROD-001', 'Refrigerante Lata 350ml', 6.00, true),
('PROD-002', 'Cerveja Artesanal IPA 500ml', 18.00, true),
('PROD-003', 'Hambúrguer Artesanal Especial', 32.50, true),
('PROD-004', 'Batata Frita Porção', 22.00, true),
('PROD-005', 'Sobremesa Pudim de Leite', 12.00, true);

-- 4. POPULANDO A TABELA: venda
-- Nota: 'venda_total' deve ser > 0 devido à CHECK constraint adicionada no script DDL.
INSERT INTO venda (venda_codigo, venda_valor, venda_desconto, venda_total, funcionario_id, mesa_id) VALUES
('VENDA-1001', 56.50, 0.00, 56.50, 1, 1),
('VENDA-1002', 40.00, 5.00, 35.00, 2, 3),
('VENDA-1003', 12.00, 0.00, 12.00, 1, 2);

-- 5. POPULANDO A TABELA: itens_venda
-- Venda 1 (Mesa 1, Funcionario 1) -> Batata (22.00) + Hambúrguer (32.50) + Refri (2x 6.00 = 12.00) - Desconto extra de itens
INSERT INTO itens_venda (venda_id, produto_id, itens_venda_valor, itens_venda_quantidade, itens_venda_total, itens_venda_comissionado) VALUES
(1, 4, 22.00, 1, 22.00, true),
(1, 3, 32.50, 1, 32.50, true),
(1, 1, 6.00, 2, 12.00, true);

-- Venda 2 (Mesa 3, Funcionario 2) -> 2 Cervejas Artesanais (2x 18.00 = 36.00)
INSERT INTO itens_venda (venda_id, produto_id, itens_venda_valor, itens_venda_quantidade, itens_venda_total, itens_venda_comISSIONADO) VALUES
(2, 2, 18.00, 2, 36.00, true);

-- Venda 3 (Mesa 2, Funcionario 1) -> 1 Sobremesa (12.00)
INSERT INTO itens_venda (venda_id, produto_id, itens_venda_valor, itens_venda_quantidade, itens_venda_total, itens_venda_comissionado) VALUES
(3, 5, 12.00, 1, 12.00, false);

-- 6. POPULANDO A TABELA: comissao
INSERT INTO comissao (funcionario_id, comissao_valor, comissao_ativo) VALUES
(1, 3.32, true),
(2, 1.80, true);

COMMIT;