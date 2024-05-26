-- Crie o usuário WEB_CLIENT
CREATE USER 'WEB_CLIENT'@'%' IDENTIFIED BY 'Lmxy20#a';

-- Conceda permissões de leitura para todas as tabelas do sistema
GRANT SELECT ON *.* TO 'WEB_CLIENT'@'%';

-- Conceda permissões de escrita e atualização para todas as tabelas relacionadas com dados dos clientes e encomendas
GRANT INSERT, UPDATE ON BuyPy.Client TO 'WEB_CLIENT'@'%';
GRANT INSERT, UPDATE ON BuyPy.Order TO 'WEB_CLIENT'@'%';

-- Conceda permissões para apagar dados nas tabelas Order e Ordered_Item
GRANT DELETE ON BuyPy.Order TO 'WEB_CLIENT'@'%';
GRANT DELETE ON BuyPy.Ordered_Item TO 'WEB_CLIENT'@'%';


-- Conceda permissões para atualizar o campo quantidade na tabela Product
GRANT UPDATE (quantity) ON BuyPy.Product TO 'WEB_CLIENT'@'%';

-- Conceda permissões para executar os procedimentos CreateOrder, GetOrderTotal e AddProductToOrder
GRANT EXECUTE ON PROCEDURE CreateOrder TO 'WEB_CLIENT'@'%';
GRANT EXECUTE ON PROCEDURE GetOrderTotal TO 'WEB_CLIENT'@'%';
GRANT EXECUTE ON PROCEDURE AddProductToOrder TO 'WEB_CLIENT'@'%';

-- -----------------------------------------------------------------------------------------------------------------------------

-- Criar o usuário BUYDB_OPERATOR
CREATE USER 'BUYDB_OPERATOR'@'%' IDENTIFIED BY 'Lmxy20#a';

-- Conceder permissões para leitura, escrita, atualização e remoção de dados de todas as tabelas
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'BUYDB_OPERATOR'@'%';

-- Conceder permissões para executar todos os procedimentos armazenados
GRANT EXECUTE ON PROCEDURE *.* TO 'BUYDB_OPERATOR'@'%';

-- Criar o usuário BUYDB_ADMIN
CREATE USER 'BUYDB_ADMIN'@'%' IDENTIFIED BY 'Lmxy20#a';

-- Conceder permissões para leitura, escrita, atualização e remoção de dados de todas as tabelas
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'BUYDB_ADMIN'@'%';

-- Conceder permissões para executar todos os procedimentos armazenados
GRANT EXECUTE ON PROCEDURE *.* TO 'BUYDB_ADMIN'@'%';


GRANT ALL PRIVILEGES ON BUYPY.* TO 'BUYDB_ADMIN'@'%';
