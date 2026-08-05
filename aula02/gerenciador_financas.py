import sqlite3
from datetime import datetime
 
DB_NAME = "financas.db"

def conectar_bd():
  """ Conecta ao banco de dados e ativa a checagem de chaves estrangeiras (foreign keys).
  """ 
  conn = sqlite3.connect(DB_NAME)
  conn.execute("PRAGMA foreign_keys = ON;")
  return conn

def inicializar_bd():
  """ Cria as tabelas e insere dados iniciais caso o banco não exista. """
  with conectar_bd() as conn:
    cursor = conn.cursor()
    # 1. tabela categorias
    cursor.execute("""
                   CREATE TABLE IF NOT EXISTS categorias (
                     id INTEGER PRIMARY KEY AUTOINCREMENT,
                     nome TEXT NOT NULL UNIQUE,
                     tipo TEXT NOT NULL CHECK(tipo in ('RECEITA', 'DESPESA'))
                   );
                   """)
    # 2. Tabela transações
    cursor.execute("""
                   CREATE TABLE IF NOT EXISTS transacoes (
                     id INTEGER PRIMARY KEY AUTOINCREMENT,
                     descricao TEXT NOT NULL,
                     valor REAL NOT NULL CHECK(valor>0),
                     data TEXT NOT NULL, 
                     categoria_id INTEGER NOT NULL,
                     FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
                   );
                   """)
    
    # Popular dados padrão de categorias se tabela estiver vazia
    cursor.execute("SELECT COUNT(*) FROM categorias;")
    if cursor.fetchone()[0] == 0:
      categorias_padrao = [
        ("Salário", "RECEITA"),
        ("Investimentos", "RECEITA"),
        ("Alimentação", "DESPESA"),
        ("Transporte", "DESPESA"),
        ("Lazer", "DESPESA"),
        ("Moradia", "DESPESA"),
      ]
      cursor.executemany("INSERT INTO categorias (nome, tipo) VALUES (?,?);", categorias_padrao)
      conn.commit()
      
if __name__ == "__main__":
  inicializar_bd()