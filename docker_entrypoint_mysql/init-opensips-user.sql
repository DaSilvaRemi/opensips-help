CREATE USER IF NOT EXISTS 'opensips'@'%' IDENTIFIED BY 'opensipsrw';
GRANT ALL PRIVILEGES ON opensips.* TO 'opensips'@'%';
FLUSH PRIVILEGES;