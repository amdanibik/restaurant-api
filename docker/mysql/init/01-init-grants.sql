CREATE DATABASE IF NOT EXISTS restaurant_test;

CREATE USER IF NOT EXISTS 'restaurant'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'password';
ALTER USER 'restaurant'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'password';
GRANT ALL PRIVILEGES ON restaurant_development.* TO 'restaurant'@'%';
GRANT ALL PRIVILEGES ON restaurant_test.* TO 'restaurant'@'%';
FLUSH PRIVILEGES;
