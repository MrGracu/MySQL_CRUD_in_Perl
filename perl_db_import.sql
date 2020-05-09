DROP DATABASE IF EXISTS db_perl;

CREATE DATABASE db_perl DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'perl_user'@'localhost' IDENTIFIED BY 'Z8nIilL3323Ee';
GRANT ALL PRIVILEGES ON db_perl.* To 'perl_user'@'localhost';