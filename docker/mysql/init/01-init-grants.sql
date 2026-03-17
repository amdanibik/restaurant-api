CREATE DATABASE IF NOT EXISTS restaurant_test;

GRANT ALL PRIVILEGES ON restaurant_development.* TO 'restaurant'@'%';
GRANT ALL PRIVILEGES ON restaurant_test.* TO 'restaurant'@'%';
FLUSH PRIVILEGES;
