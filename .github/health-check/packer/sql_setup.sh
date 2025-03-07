#!/bin/bash
sudo mysql -u root <<EOSQL
CREATE DATABASE IF NOT EXISTS recommend;
CREATE USER IF NOT EXISTS 'webapp'@'%' IDENTIFIED WITH mysql_native_password BY 'testing';
GRANT ALL PRIVILEGES ON recommend.* TO 'webapp'@'%' WITH GRANT OPTION;
GRANT FILE ON *.* TO 'webapp'@'%';
GRANT SYSTEM_VARIABLES_ADMIN ON *.* TO 'webapp'@'%';
SET GLOBAL local_infile = 1;
FLUSH PRIVILEGES;
EOSQL

echo "Creating tables..."
sudo mysql -u root recommend <<EOSQL
CREATE TABLE IF NOT EXISTS movies (
    movieId INT PRIMARY KEY,
    title VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS genres (
    genreID INT PRIMARY KEY,
    genreName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS movie_genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieId INT,
    genreID INT,
    FOREIGN KEY (movieId) REFERENCES movies(movieId) ON DELETE CASCADE,
    FOREIGN KEY (genreID) REFERENCES genres(genreID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS links (
    movieId INT NOT NULL,
    imdbId VARCHAR(30) DEFAULT NULL, 
    tmdbId VARCHAR(30) DEFAULT NULL, 
    PRIMARY KEY (movieId)
);

CREATE TABLE IF NOT EXISTS ratings (
    userId INT NOT NULL,
    movieId INT NOT NULL,
    rating DECIMAL(2,1) DEFAULT NULL,
    timestamp INT DEFAULT NULL,
    PRIMARY KEY (userId, movieId)
);

CREATE TABLE IF NOT EXISTS tags (
    userId INT NOT NULL,
    movieId INT NOT NULL,
    tag VARCHAR(255) NOT NULL, 
    timestamp INT DEFAULT NULL,
    PRIMARY KEY (userId, movieId, tag)
);
EOSQL

echo "MySQL setup completed."
