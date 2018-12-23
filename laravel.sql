CREATE DATABASE IF NOT EXISTS `homestead` DEFAULT CHARACTER SET utf8mb4;
CREATE USER IF NOT EXISTS 'homestead'@'%' IDENTIFIED BY 'secret';
GRANT ALL ON `homestead`.* TO 'homestead'@'%';
