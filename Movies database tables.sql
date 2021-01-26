DROP TABLE IF EXISTS profits;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS directors;

CREATE TABLE directors (
  name varchar(50),  
  id int NOT NULL,
  gender int DEFAULT NULL,
  uid int DEFAULT NULL,
  department varchar(20) DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE movies (
  id int NOT NULL,
  original_title varchar(100) DEFAULT NULL,
  release_date date NOT NULL,
  title varchar(100) DEFAULT NULL,
  uid int DEFAULT NULL,
  director_id int NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT dir_id FOREIGN KEY (director_id) REFERENCES directors(id)
);

CREATE TABLE ratings(
	film_id int NOT NULL,
	popularity int DEFAULT NULL,
	vote_average decimal(5,1) DEFAULT NULL,
    vote_count int DEFAULT NULL,
	CONSTRAINT film_id FOREIGN KEY (film_id) REFERENCES movies(id)
);

CREATE TABLE profits(
	film_id int NOT NULL,
	budget int DEFAULT NULL,
	revenue int DEFAULT NULL,
	dir_id int NOT NULL,
	CONSTRAINT film_id FOREIGN KEY (film_id) REFERENCES movies(id),
	CONSTRAINT dir_id FOREIGN KEY (dir_id) REFERENCES directors(id)
);

COPY directors FROM 'C:\Users\Taguhi\Desktop\SQL final project\Movies data\directors.csv' with CSV HEADER; 
COPY  movies FROM 'C:\Users\Taguhi\Desktop\SQL final project\Movies data\movies.csv' with CSV HEADER;
COPY  ratings FROM 'C:\Users\Taguhi\Desktop\SQL final project\Movies data\ratings.csv' with CSV HEADER;
COPY  profits FROM 'C:\Users\Taguhi\Desktop\SQL final project\Movies data\profits.csv' with CSV HEADER;






 
 