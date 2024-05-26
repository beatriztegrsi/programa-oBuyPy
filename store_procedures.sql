USE `BuyPy` ;

DELIMITER //

CREATE PROCEDURE ProductByType (
    IN product_type VARCHAR(10)
)
BEGIN
    IF product_type IS NULL THEN
        -- Return all products
        SELECT p.id, p.price, p.score, p.active, p.product_image, 
               CASE 
                   WHEN e.product_id IS NOT NULL THEN 'Electronic'
                   WHEN b.product_id IS NOT NULL THEN 'Book'
                   ELSE NULL
               END AS type
        FROM Product p
        LEFT JOIN Electronic e ON p.id = e.product_id
        LEFT JOIN Book b ON p.id = b.product_id;
    ELSE
        -- Return products by type
        CASE product_type
            WHEN 'Electronic' THEN
                SELECT p.id, p.price, p.score, p.active, p.product_image, 'Electronic' AS type
                FROM Product p
                INNER JOIN Electronic e ON p.id = e.product_id;
            WHEN 'Book' THEN
                SELECT p.id, p.price, p.score, p.active, p.product_image, 'Book' AS type
                FROM Product p
                INNER JOIN Book b ON p.id = b.product_id;
            ELSE
                -- Invalid product type
                SELECT 'Invalid product type' AS Error;
        END CASE;
    END IF;
END//

DELIMITER ;


-- -------------------------------------------------------------------------------------


DELIMITER //

CREATE PROCEDURE DailyOrders (
    IN order_date DATE
)
BEGIN
    SELECT *
    FROM `Order`
    WHERE DATE(date_time) = order_date;
END//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE AnnualOrders(IN cliente_id INT, IN ano_encomenda INT)
BEGIN
    -- Seleciona todas as encomendas feitas por um cliente específico durante um ano específico
    SELECT *
    FROM `BuyPy`.`Order`
    WHERE `client_id` = cliente_id AND YEAR(`date_time`) = ano_encomenda;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE CreateOrder(
    IN cliente_id INT,
    IN metodo_expedicao ENUM('regular', 'urgent'),
    IN numero_cartao INT,
    IN nome_cartao VARCHAR(100),
    IN data_validade_cartao DATE
)
BEGIN
    -- Insere uma nova encomenda com os dados fornecidos
    INSERT INTO `BuyPy`.`Order` (
        `date_time`,
        `delivery_method`,
        `status`,
        `payment_card_number`,
        `payment_card_name`,
        `payment_card_expiration`,
        `client_id`
    )
    VALUES (
        NOW(),
        metodo_expedicao,
        'open', -- Definindo o status da encomenda como "open" por padrão
        numero_cartao,
        nome_cartao,
        data_validade_cartao,
        cliente_id
    );
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE `GetOrderTotal` (IN order_id INT)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    -- Calcula o montante total da encomenda
    SELECT SUM(price * quantity) INTO total
    FROM Ordered_Item
    WHERE Order_id = order_id;
    
    -- Devolve o montante total
    SELECT total;
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AddProductToOrder(
    IN order_id INT,
    IN product_id VARCHAR(10),
    IN quantity INT
)
BEGIN
    DECLARE total_price DECIMAL(10, 2);
    
    -- Calcular o preço total do produto
    SELECT price * quantity INTO total_price
    FROM Product
    WHERE id = product_id;
    
    -- Inserir o item da encomenda na tabela Ordered_Item
    INSERT INTO Ordered_Item (quantity, price, Order_id, Product_id)
    VALUES (quantity, total_price, order_id, product_id);
    
    -- Atualizar a quantidade de produtos disponíveis na tabela Product
    UPDATE Product
    SET quantity = quantity - quantity
    WHERE id = product_id;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE AddBook(
    IN book_id VARCHAR(10),
    IN isbn13 VARCHAR(20),
    IN title VARCHAR(50),
    IN genre VARCHAR(50),
    IN publisher VARCHAR(100),
    IN publication_date DATE
)
BEGIN
    INSERT INTO Book (product_id, isbn13, title, genre, publisher, publication_date)
    VALUES (book_id, isbn13, title, genre, publisher, publication_date);
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE AddElec(
    IN product_id VARCHAR(10),
    IN serial_number INT,
    IN brand VARCHAR(20),
    IN model VARCHAR(20),
    IN spec_tec LONGTEXT,
    IN type VARCHAR(10)
)
BEGIN
    INSERT INTO Electronic (product_id, serial_number, brand, model, spec_tec, type)
    VALUES (product_id, serial_number, brand, model, spec_tec, type);
END //

DELIMITER ;


