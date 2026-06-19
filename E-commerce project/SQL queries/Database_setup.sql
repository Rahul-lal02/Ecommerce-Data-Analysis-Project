CREATE DATABASE EcommerceDB;

USE EcommerceDB;


select name from sys.databases;

SELECT DB_NAME() AS current_database;

SELECT *
FROM dbo.superstore_sales;

SELECT *
FROM INFORMATION_SCHEMA.TABLES;

USE EcommerceDB;

SELECT DB_NAME();