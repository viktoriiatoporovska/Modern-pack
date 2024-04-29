USE TestSK;

CREATE TABLE IF NOT EXISTS Users (
    id INT PRIMARY KEY, -- Make 'id' a primary key to avoid duplicate entry error
    date_pay DATE
);

CREATE TABLE IF NOT EXISTS Visits (
    id INT,
    visit_date DATE, -- Rename 'date' to 'visit_date' to avoid conflict
    source VARCHAR(255),
    FOREIGN KEY (id) REFERENCES Users(id)
);

INSERT INTO Users (id, date_pay) VALUES
(1, '2022-05-15'),
(2, NULL),
(3, '2022-06-01'),
(4, '2022-06-15');

INSERT INTO Visits (id, visit_date, source) VALUES
(1, '2022-05-10', 'Google'),
(1, '2022-05-14', 'Facebook'),
(1, '2022-05-15', 'Email'),  -- After the purchase
(2, '2022-05-20', 'Google'),
(3, '2022-05-29', 'Email'),
(3, '2022-06-02', 'Facebook'), -- After the purchase
(4, '2022-06-10', 'Google'),
(4, '2022-06-13', 'Email'),
(4, '2022-06-17', 'Facebook'); -- After the purchase

-- If we can pay only when we are on the resource
SELECT Visits.id, Visits.source
FROM Visits
INNER JOIN Users ON Visits.id = Users.id
WHERE Visits.visit_date = Users.date_pay;

-- If we can pay at any time and we don't need to be on the resource
SELECT 
    v.id,
    v.source
FROM 
    Visits v
INNER JOIN 
    Users u ON v.id = u.id
WHERE 
    v.visit_date = (
        SELECT 
            MAX(v2.visit_date)
        FROM 
            Visits v2
        WHERE 
            v2.id = v.id
            AND (
                v2.visit_date < u.date_pay
                OR v2.visit_date = u.date_pay
            )
    );


