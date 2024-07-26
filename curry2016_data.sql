CREATE DATABASE curry2016;
USE curry2016;
CREATE TABLE stats(game INT,
				date VARCHAR(20),
                age VARCHAR(10),
                team CHAR(3),
                location VARCHAR(4),
                opponent CHAR(3),
                spread VARCHAR(10),
                starter INT,
                minutes VARCHAR(30),
                field_goals INT,
                field_goals_attempted INT,
                field_goal_percentage DOUBLE,
                three_pointers INT,
                three_pointers_attempted INT,
                three_point_percentage DOUBLE,
                free_throws INT,
                free_throws_attempted INT,
                free_throw_percentage TEXT,
                offensive_rebounds INT,
                defensive_rebounds INT,
                rebounds INT,
                assists INT,
                steals INT,
                blocks INT,
                turnovers INT,
                personal_fouls INT,
                points INT,
                game_score DOUBLE,
                plus_minus VARCHAR(5));
                
                
-- The following statement is unable to be executed rn because of 'secure_file_priv' location.
-- SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:\Users\Drew Brackman\Documents\Portfolio\Stephen Curry 2016\curry2016.csv'
INTO TABLE stats
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(game, @datestring, age, team, location, opponent, spread, starter, minutes, field_goals, field_goals_attempted, field_goal_percentage,
	three_pointers, three_pointers_attempted, three_point_percentage, free_throws, free_throws_attempted, free_throw_percentage,
    offensive_rebounds, defensive_rebounds, rebounds, assists, steals, blocks, turnovers, personal_fouls, points, game_score, plus_minus)
SET date = STR_TO_DATE(@date_string, '%m/%d/%Y');

-- Change free_throw_percentage and date columns to the correct data types, because they weren't able to be imported correctly.
-- NOTE - Still need to convert minutes, spread, and plus_minus columns
ALTER TABLE stats
MODIFY COLUMN free_throw_percentage DOUBLE,
MODIFY COLUMN date DATE;

-- 
SELECT field_goals_attempted FROM stats
WHERE field_goal_percentage > .5;

SELECT field_goals_attempted FROM stats
WHERE field_goal_percentage <= .5;

-- season high, low, and average in points 
SELECT MAX(points) as "season high", MIN(points) as "season low", AVG(points) as average
FROM stats;

-- minutes played in game with lowest points of the season
SELECT minutes
FROM stats
WHERE points = (SELECT MIN(points) FROM stats);

-- point average, 3P%, and games played before the year changed
SELECT AVG(points) as "point average", SUM(three_pointers)/SUM(three_pointers_attempted) as "3P%", COUNT(*) as "games played"
FROM stats
WHERE date < '2016-01-01';

-- number of times steph made more than ten threes in a game
SELECT COUNT(*) as "ten or more 3's"
FROM stats
WHERE three_pointers >= 10;

-- Steph's 3P% for games in which he made n 3's
-- This is interesting to me because you see that the three point percentage rises every time the number of 
-- threes made increased (the only exception being between 6 and 7 made threes). This shows that Steph isn't
-- just making more threes when he shoots more, but rather he is making more when he is 'feeling it' more. I 
-- would be interested to compare this to more recent seasons, because it seems that there are more games where
-- Steph scored a lot of threes because he was shooting lots.
SELECT three_pointers, COUNT(*) AS 'number of games', SUM(three_pointers)/SUM(three_pointers_attempted) AS '3P%'
FROM stats
GROUP BY three_pointers
ORDER BY three_pointers;

-- similar to the table above, this shows Steph's 3P% for games in which he attempted different numbers of threes
SELECT three_pointers_attempted, COUNT(*) AS 'number of games', SUM(three_pointers)/SUM(three_pointers_attempted) AS '3P%'
FROM stats
GROUP BY three_pointers_attempted
ORDER BY three_pointers_attempted;