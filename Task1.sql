CREATE DATABASE IF NOT EXISTS TestSK;
USE TestSK;

CREATE TABLE IF NOT EXISTS Students (
    name VARCHAR(255),
    surname VARCHAR(255),
    age INT
);

INSERT INTO Students (name, surname, age) VALUES 
    ('Іван', 'Іваненко', 20),
    ('Марія', 'Петренко', 22),
    ('Олександр', 'Сидоренко', 19),
    ('Анна', 'Коваленко', 21),
    ('Василь', 'Мельник', 23),
    ('Олена', 'Шевченко', 18);


SELECT AVG(age) as median_age
FROM (
    SELECT age
    FROM (
        SELECT age, @rownum:=@rownum+1 as `row_number`, @total_rows:=@rownum
        FROM Students, (SELECT @rownum:=0) r
        ORDER BY age
    ) as sorted
    WHERE
        sorted.row_number IN (FLOOR((@total_rows + 1) / 2), FLOOR((@total_rows + 2) / 2))
) as median_values;


SELECT *
FROM Students
WHERE age > (
    SELECT AVG(age) as median_age
    FROM (
        SELECT age
        FROM (
            SELECT age, @rownum:=@rownum+1 as `row_number`, @total_rows:=@rownum
            FROM Students, (SELECT @rownum:=0) r
            ORDER BY age
        ) as sorted
        WHERE
            sorted.row_number IN (FLOOR((@total_rows + 1) / 2), FLOOR((@total_rows + 2) / 2))
    ) as median_values
);
