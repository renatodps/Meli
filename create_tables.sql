---------------------------------------------------
-- SCRIPT DE CRIAÇÃO DE TABELAS CHALLENGE MELI   --                                                                                           --
-- AUTOR : RENATO DE PAIVA SANTOS                --
-- DATA: 04/03/205                               --
-- ÚLTIMA ATUALIZAÇÃO : 04/03/2025               --
-- VERSÃO : 04/03/2025                           --
---------------------------------------------------





--CREATE TABLE TABELA CUSTOMER

create table customer (
customer_id int NOT NULL,
email char(50) NOT NULL,
nombre  char(50) NOT NULL,
apelido char(50) NOT NULL,
sexo char(50) NOT NULL,
direccion char(50) NOT NULL,
fecha_nascimiento date NOT NULL,
telefono char(50) NOT NULL,
tipo_usuario char(50) NOT NULL,
primary key (customer_id)
 )

--CREATE TABLE TABELA ITEM
 create table item (
 item_id int NOT NULL,
 category_id int NOT NULL,
 item_description varchar(50) NOT NULL,
 preco int,
 status varchar (10)
 primary key (item_id),
 foreign key (category_id) references category (category_id)
 )

 --CREATE TABLE TABELA CATEGORY
 create table category (
 category_id int NOT NULL,
 category_descripcion varchar(50) NOT NULL,
 path varchar (100) NOT NULL,
 primary key( category_id)
 )

 
 --CREATE TABLE TABELA ORDER
 create table [order] (
 order_id int NOT NULL,
 item_id int NOT NULL,
 customer_id int NOT NULL,
 fecha_pedido date NOT NULL,
 cantidad int NOT NULL
 primary key (order_id),
 foreign key (customer_id) REFERENCES customer(customer_id),
 foreign key (item_id) REFERENCES item(item_id)
 )

 ALTER TABLE item ADD status varchar(10)