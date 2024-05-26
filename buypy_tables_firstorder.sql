-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BuyPy
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BuyPy
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BuyPy` DEFAULT CHARACTER SET utf8 ;
USE `BuyPy` ;

-- -----------------------------------------------------
-- Table `BuyPy`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Product` (
  `id` VARCHAR(10) NOT NULL,
  `quantity` INT UNSIGNED NOT NULL,
  `price` DECIMAL UNSIGNED NOT NULL,
  `vat` REAL UNSIGNED NOT NULL,
  `score` TINYINT(1) NULL,
  `product_image` VARCHAR(45) NULL,
  `active` VARCHAR(45) NULL,
  `reason` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Electronic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Electronic` (
  `product_id` VARCHAR(10) NOT NULL,
  `serial_number` INT NOT NULL,
  `brand` VARCHAR(20) NOT NULL,
  `model` VARCHAR(20) NOT NULL,
  `spec_tec` LONGTEXT NULL,
  `type` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_electronica_produtos1_idx` (`product_id` ASC) VISIBLE,
  UNIQUE INDEX `serial_number_UNIQUE` (`serial_number` ASC) VISIBLE,
  CONSTRAINT `fk_electronica_produtos1`
    FOREIGN KEY (`product_id`)
    REFERENCES `BuyPy`.`Product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Book` (
  `product_id` VARCHAR(10) NOT NULL,
  `isbn13` VARCHAR(20) NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `genre` VARCHAR(50) NOT NULL,
  `publisher` VARCHAR(100) NOT NULL,
  `publication_date` DATE NOT NULL,
  INDEX `fk_livros_produtos1_idx` (`product_id` ASC) VISIBLE,
  UNIQUE INDEX `isbn13_UNIQUE` (`isbn13` ASC) VISIBLE,
  PRIMARY KEY (`product_id`),
  CONSTRAINT `fk_livros_produtos1`
    FOREIGN KEY (`product_id`)
    REFERENCES `BuyPy`.`Product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Client` (
  `id` INT NOT NULL,
  `firstname` VARCHAR(250) NOT NULL,
  `surname` VARCHAR(250) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `zip_code` VARCHAR(20) NOT NULL,
  `city` VARCHAR(30) NOT NULL,
  `country` VARCHAR(30) NOT NULL DEFAULT 'Portugal',
  `phone_number` VARCHAR(15) NULL,
  `last_login` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `birthdate` DATE NOT NULL,
  `is_active` TINYINT(1) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_time` DATETIME NULL DEFAULT NOW(),
  `delivery_method` ENUM('regular', 'urgent') NULL DEFAULT 'regular',
  `status` ENUM('open', 'processing', 'pending', 'closed', 'cancelled') NULL DEFAULT 'open',
  `payment_card_number` INT NOT NULL,
  `payment_card_name` VARCHAR(20) NOT NULL,
  `payment_card_expiration` DATE NOT NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Order_Client1_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `BuyPy`.`Client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Recommendation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Recommendation` (
  `recomendacao` INT NOT NULL AUTO_INCREMENT,
  `data_rec` DATE NULL,
  `client_id` INT NOT NULL,
  `product_id` VARCHAR(10) NOT NULL,
  `reason` VARCHAR(500) NULL,
  `start_date` DATE NULL,
  PRIMARY KEY (`recomendacao`),
  INDEX `fk_Recommendation_Product1_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_Recommendation_Client1_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_Recommendation_Product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `BuyPy`.`Product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recommendation_Client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `BuyPy`.`Client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Operator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Operator` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(250) NOT NULL,
  `surname` VARCHAR(250) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Author`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Author` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `fullname` VARCHAR(100) NULL,
  `birthdate` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`Ordered_Item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`Ordered_Item` (
  `id` INT NOT NULL,
  `quantity` INT UNSIGNED NOT NULL,
  `price` DECIMAL UNSIGNED NOT NULL,
  `vat_amount` DECIMAL UNSIGNED NOT NULL,
  `Order_id` INT NOT NULL,
  `Product_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`, `Order_id`),
  INDEX `fk_Ordered_Item_Order1_idx` (`Order_id` ASC) VISIBLE,
  INDEX `fk_Ordered_Item_Product1_idx` (`Product_id` ASC) VISIBLE,
  CONSTRAINT `fk_Ordered_Item_Order1`
    FOREIGN KEY (`Order_id`)
    REFERENCES `BuyPy`.`Order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ordered_Item_Product1`
    FOREIGN KEY (`Product_id`)
    REFERENCES `BuyPy`.`Product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BuyPy`.`BookAuthor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BuyPy`.`BookAuthor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `product_id` VARCHAR(10) NOT NULL,
  `author_id` INT NOT NULL,
  PRIMARY KEY (`id`, `product_id`, `author_id`),
  INDEX `fk_BookAuthor_Book1_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_BookAuthor_Author1_idx` (`author_id` ASC) VISIBLE,
  CONSTRAINT `fk_BookAuthor_Book1`
    FOREIGN KEY (`product_id`)
    REFERENCES `BuyPy`.`Book` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BookAuthor_Author1`
    FOREIGN KEY (`author_id`)
    REFERENCES `BuyPy`.`Author` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------------------------------------------

-- Testar os store procedures criados


#CALL ProductByType('Book');

#CALL DailyOrders('2024-04-26');

#CALL AnnualOrders(11, 2024);

#Select * from BuyPy.Order;
#CALL CreateOrder(12, 'urgent', 1234567890, 'Guilherme Novo', '2026-12-01');
#Select * from BuyPy.Order;
#CALL GetOrderTotal(28);
#CALL AddProductToOrder(40, 'P007', 34);                         #
#CALL GetOrderTotal(28);
#Select * from BuyPy.Product;
#CALL AddBook('ID_DO_LIVRO', 'ISBN_DO_LIVRO', 'TÍTULO_DO_LIVRO', 'GÊNERO_DO_LIVRO', 'EDITORA_DO_LIVRO', 'DATA_DE_PUBLICAÇÃO_DO_LIVRO');
#CALL AddElec('ID_DO_PRODUTO', 'NUMERO_DE_SERIE', 'MARCA', 'MODELO', 'ESPECIFICACOES_TECNICAS', 'TIPO');


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
