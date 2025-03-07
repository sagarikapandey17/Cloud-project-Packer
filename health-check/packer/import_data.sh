  #!/bin/bash

  sudo mysql --local-infile=1 -u root << 'EOSQL'
  SET GLOBAL local_infile=1;
  USE recommend;
  LOAD DATA LOCAL INFILE '/opt/mysql_data/movies.csv'
  INTO TABLE movies
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

  LOAD DATA LOCAL INFILE '/opt/mysql_data/genre.csv'
  INTO TABLE genres
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

  LOAD DATA LOCAL INFILE '/opt/mysql_data/movie_genre.csv'
  INTO TABLE movie_genres
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS (movieId, genreID);

  LOAD DATA LOCAL INFILE '/opt/mysql_data/tags.csv'
  INTO TABLE tags
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS (userId, movieId, tag, timestamp);

  LOAD DATA LOCAL INFILE '/opt/mysql_data/links.csv'
  INTO TABLE links
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS (movieId, imdbId, tmdbId);

  LOAD DATA LOCAL INFILE '/opt/mysql_data/ratings.csv'
  INTO TABLE ratings
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS (userId, movieId, rating, timestamp);
EOSQL
