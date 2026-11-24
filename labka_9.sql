
-- Part 1.1

DROP TABLE IF EXISTS rentals, bikes, members, stations CASCADE;

CREATE TABLE stations (
    station_id INT PRIMARY KEY,
    station_name VARCHAR(50) NOT NULL,
    city VARCHAR(40) NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE bikes (
    bike_id INT PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    station_id INT REFERENCES stations(station_id),
    daily_rate NUMERIC(8,2) NOT NULL
);

CREATE TABLE members (
    member_id INT PRIMARY KEY,
    full_name VARCHAR(60) NOT NULL,
    city VARCHAR(40) NOT NULL,
    joined_on DATE NOT NULL
);

CREATE TABLE rentals (
    rental_id INT PRIMARY KEY,
    member_id INT REFERENCES members(member_id),
    bike_id INT REFERENCES bikes(bike_id),
    start_date DATE NOT NULL,
    end_date DATE,
    fee NUMERIC(8,2)
);


-- Part 1.2

INSERT INTO stations VALUES
(10, 'Central Park', 'Almaty', 4),
(20, 'Riverside', 'Almaty', 3),
(30, 'Expo Gate', 'Astana', 5),
(40, 'Old Town', 'Shymkent', 2),
(50, 'Depot', 'Astana', 0);

INSERT INTO bikes VALUES
(101, 'City Cruiser', 10, 4.50),
(102, 'City Cruiser', 10, 4.50),
(103, 'Mountain X', 20, 7.00),
(104, 'Mountain X', 30, 7.00),
(105, 'Road Sprint', 30, 9.25),
(106, 'Folding Mini', 40, 3.75),
(107, 'Cargo Hauler', 20, 12.00),
(108, 'Road Sprint', 10, 9.25);

INSERT INTO members VALUES
(1, 'Aisha Nurlanova', 'Almaty', '2023-03-14'),
(2, 'Daniyar Serik', 'Almaty', '2023-07-02'),
(3, 'Marta Kowalski', 'Astana', '2024-01-20'),
(4, 'Chen Wei', 'Astana', '2024-05-11'),
(5, 'Omar Haddad', 'Shymkent', '2024-09-30'),
(6, 'Elena Petrova', 'Almaty', '2025-02-05');

INSERT INTO rentals VALUES
(1, 1, 101, '2024-04-05', '2024-04-08', 13.50),
(2, 1, 103, '2024-06-11', '2024-06-16', 35.00),
(3, 1, 108, '2025-02-02', '2025-02-04', 18.50),
(4, 1, 102, '2025-05-20', '2025-05-27', 31.50),
(5, 2, 101, '2024-05-01', '2024-05-02', 4.50),
(6, 2, 107, '2024-11-15', '2024-11-19', 48.00),
(7, 2, 107, '2025-03-08', '2025-03-14', 72.00),
(8, 3, 104, '2024-02-14', '2024-02-18', 28.00),
(9, 3, 105, '2024-08-03', '2024-08-06', 27.75),
(10, 3, 104, '2025-01-09', '2025-01-10', 7.00),
(11, 3, 105, '2025-06-01', '2025-06-09', 74.00),
(12, 4, 104, '2024-07-19', '2024-07-21', 14.00),
(13, 4, 105, '2025-04-12', '2025-04-15', 27.75),
(14, 4, 103, '2025-07-23', '2025-07-29', 42.00),
(15, 5, 106, '2024-10-05', '2024-10-12', 26.25),
(16, 5, 106, '2025-01-18', '2025-01-20', 7.50),
(17, 5, 106, '2025-08-14', '2025-08-21', 26.25),
(18, 2, 102, '2025-09-02', '2025-09-05', 13.50),
(19, 1, 101, '2025-10-10', NULL, NULL),
(20, 4, 108, '2024-12-28', '2025-01-03', 55.50),
(21, 3, 103, '2025-02-26', '2025-03-02', 28.00),
(22, 5, 104, '2025-05-05', '2025-05-08', 21.00);

SELECT
    (SELECT COUNT(*) FROM stations) AS stations,
    (SELECT COUNT(*) FROM bikes) AS bikes,
    (SELECT COUNT(*) FROM members) AS members,
    (SELECT COUNT(*) FROM rentals) AS rentals;


-- Exercise 2.1

CREATE OR REPLACE FUNCTION rental_days(p_rental_id INT)
RETURNS INT AS $$
DECLARE
    result INT;
BEGIN
    SELECT end_date - start_date
    INTO result
    FROM rentals
    WHERE rental_id = p_rental_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

SELECT rental_days(2);
SELECT rental_days(11);
SELECT rental_days(19);
SELECT rental_days(999);


-- Exercise 2.2

CREATE OR REPLACE FUNCTION member_rental_count(p_member_id INT)
RETURNS INT AS $$
DECLARE
    result INT;
BEGIN
    SELECT COUNT(*)
    INTO result
    FROM rentals
    WHERE member_id = p_member_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

SELECT member_rental_count(1);
SELECT member_rental_count(5);
SELECT member_rental_count(6);
SELECT member_rental_count(99);


-- Exercise 2.3

CREATE OR REPLACE FUNCTION station_city(p_station_id INT)
RETURNS VARCHAR AS $$
DECLARE
    result VARCHAR;
BEGIN
    SELECT city
    INTO result
    FROM stations
    WHERE station_id = p_station_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

SELECT station_city(30);
SELECT station_city(77);


-- Exercise 2.4

SELECT rental_id,
       member_id,
       rental_days(rental_id) AS duration
FROM rentals
WHERE rental_days(rental_id) > 4
ORDER BY duration DESC;


-- Exercise 3.1

CREATE OR REPLACE FUNCTION fee_with_discount(
    p_fee NUMERIC,
    p_percent NUMERIC
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN ROUND(p_fee * (1 - p_percent / 100), 2);
END;
$$ LANGUAGE plpgsql;

SELECT fee_with_discount(74.00, 15);


-- Exercise 3.2

CREATE OR REPLACE FUNCTION member_stats(
    p_member_id INT,
    OUT rental_cnt INT,
    OUT total_fee NUMERIC,
    OUT last_start DATE
)
AS $$
BEGIN
    SELECT COUNT(*),
           COALESCE(SUM(fee), 0),
           MAX(start_date)
    INTO rental_cnt, total_fee, last_start
    FROM rentals
    WHERE member_id = p_member_id;
END;
$$ LANGUAGE plpgsql;

SELECT member_stats(3);
SELECT * FROM member_stats(3);
SELECT * FROM member_stats(6);


-- Exercise 3.3

CREATE OR REPLACE FUNCTION apply_late_fee(
    INOUT p_fee NUMERIC
)
AS $$
BEGIN
    p_fee := p_fee + 5.00;
END;
$$ LANGUAGE plpgsql;

SELECT apply_late_fee(fee)
FROM rentals
WHERE rental_id = 1;


-- Exercise 3.4

CREATE OR REPLACE FUNCTION fee_summary(
    VARIADIC p_fees NUMERIC[],
    OUT total NUMERIC,
    OUT average NUMERIC,
    OUT largest NUMERIC
)
AS $$
BEGIN
    SELECT SUM(p_fees[i]),
           ROUND(AVG(p_fees[i]), 2),
           MAX(p_fees[i])
    INTO total, average, largest
    FROM generate_subscripts(p_fees, 1) g(i);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fee_summary(13.50, 35.00, 18.50, 31.50);

SELECT * FROM fee_summary();

SELECT * FROM fee_summary(VARIADIC ARRAY[]::NUMERIC[]);


-- Exercise 4.1

CREATE OR REPLACE FUNCTION total_fees(p_member_id INT)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(fee), 0)
        FROM rentals
        WHERE member_id = p_member_id
    );
END;
$$ LANGUAGE plpgsql;

SELECT total_fees(1);
SELECT total_fees(6);


-- Exercise 4.2

CREATE OR REPLACE FUNCTION total_fees(
    p_member_id INT,
    p_from_date DATE
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(fee), 0)
        FROM rentals
        WHERE member_id = p_member_id
          AND start_date >= p_from_date
    );
END;
$$ LANGUAGE plpgsql;

SELECT total_fees(1, DATE '2024-01-01');
SELECT total_fees(1, DATE '2025-01-01');

SELECT proname,
       pg_get_function_identity_arguments(oid) AS arguments
FROM pg_proc
WHERE proname = 'total_fees';


-- Exercise 4.3

CREATE OR REPLACE FUNCTION total_fees(
    p_member_id INT,
    p_from_date DATE DEFAULT DATE '2025-01-01'
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(fee), 0)
        FROM rentals
        WHERE member_id = p_member_id
          AND start_date >= p_from_date
    );
END;
$$ LANGUAGE plpgsql;

SELECT total_fees(1);


-- Exercise 4.4

DROP FUNCTION total_fees(INTEGER);

SELECT total_fees(1);


-- Exercise 4.5

CREATE OR REPLACE FUNCTION total_fees(
    p_member_name VARCHAR
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(r.fee), 0)
        FROM rentals r
        JOIN members m
            ON r.member_id = m.member_id
        WHERE m.full_name = p_member_name
    );
END;
$$ LANGUAGE plpgsql;

SELECT total_fees('Aisha Nurlanova');
SELECT total_fees(1);


-- Exercise 5.1

CREATE OR REPLACE FUNCTION find_bikes(
    p_pattern VARCHAR
)
RETURNS TABLE (
    found_id INT,
    found_model VARCHAR,
    found_rate NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT b.bike_id,
           b.model,
           b.daily_rate
    FROM bikes b
    WHERE b.model ILIKE p_pattern
    ORDER BY b.bike_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_bikes('%road%');
SELECT * FROM find_bikes('%Mini');
SELECT find_bikes('%road%');


-- Exercise 5.2

CREATE OR REPLACE FUNCTION member_history(
    p_member_id INT
)
RETURNS TABLE (
    rental_id INT,
    bike_model VARCHAR,
    station_name VARCHAR,
    duration INT,
    fee NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT r.rental_id,
           b.model,
           s.station_name,
           r.end_date - r.start_date,
           r.fee
    FROM rentals r
    JOIN bikes b ON r.bike_id = b.bike_id
    JOIN stations s ON b.station_id = s.station_id
    WHERE r.member_id = p_member_id
    ORDER BY r.start_date;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM member_history(3);


-- Exercise 5.3

CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
RETURNS TABLE (
    bike_id INT,
    model VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT bike_id, model
    FROM bikes
    WHERE station_id = p_station_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM bike_list(10);


-- Exercise 5.3.1

DROP FUNCTION bike_list(INT);

CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
RETURNS TABLE (
    found_id INT,
    found_model VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT bike_id, model
    FROM bikes
    WHERE station_id = p_station_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM bike_list(10);


-- Exercise 5.3.2

DROP FUNCTION bike_list(INT);

CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
RETURNS TABLE (
    bike_id INT,
    model VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT b.bike_id, b.model
    FROM bikes b
    WHERE b.station_id = p_station_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM bike_list(10);


-- Exercise 5.4

CREATE OR REPLACE FUNCTION station_board(p_city VARCHAR)
RETURNS TABLE (
    s_name VARCHAR,
    s_bikes INT,
    s_free INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT s.station_name,
           COUNT(b.bike_id),
           s.capacity - COUNT(b.bike_id)
    FROM stations s
    LEFT JOIN bikes b ON s.station_id = b.station_id
    WHERE s.city = p_city
    GROUP BY s.station_id, s.station_name, s.capacity;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM station_board('Almaty');


-- Exercise 5.4.1

CREATE OR REPLACE FUNCTION station_board(p_city VARCHAR)
RETURNS TABLE (
    s_name VARCHAR,
    s_bikes INT,
    s_free INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT s.station_name,
           COUNT(b.bike_id)::INT,
           s.capacity - COUNT(b.bike_id)::INT
    FROM stations s
    LEFT JOIN bikes b ON s.station_id = b.station_id
    WHERE s.city = p_city
    GROUP BY s.station_id, s.station_name, s.capacity
    ORDER BY s.station_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM station_board('Almaty');
SELECT * FROM station_board('Astana');


-- Exercise 6.1

DO $$
<<rental_report>>
DECLARE
    total_rentals INTEGER := 0;
BEGIN
    SELECT COUNT(*)
    INTO total_rentals
    FROM rentals;

    RAISE NOTICE 'The rentals table holds % rows.',
        total_rentals;
END rental_report;
$$;


-- Exercise 6.2

DO $$
<<rental_report>>
DECLARE
    total_rentals INT := 0;
    fee_total NUMERIC;
BEGIN
    SELECT COUNT(*), SUM(fee)
    INTO total_rentals, fee_total
    FROM rentals;

    RAISE NOTICE 'Outer before: %', fee_total;

    DECLARE
        fee_total NUMERIC;
    BEGIN
        SELECT SUM(fee)
        INTO fee_total
        FROM rentals
        WHERE start_date >= DATE '2025-01-01';

        RAISE NOTICE 'Inner: %', fee_total;
        RAISE NOTICE 'Outer inside: %',
            rental_report.fee_total;
    END;

    RAISE NOTICE 'Outer after: %', fee_total;
END rental_report;
$$;


-- Exercise 6.3

DO $$
BEGIN
    DECLARE
        local_value INT := 10;
    BEGIN
        RAISE NOTICE 'First block: %', local_value;
    END;

    BEGIN
        RAISE NOTICE 'Second block: %', local_value;
    END;
END;
$$;


-- Exercise 6.3.1

DO $$
DECLARE
    local_value INT := 10;
BEGIN
    BEGIN
        RAISE NOTICE 'First block: %', local_value;
    END;

    BEGIN
        RAISE NOTICE 'Second block: %', local_value;
    END;
END;
$$;


-- Exercise 6.4

CREATE OR REPLACE FUNCTION fee_split(
    p_from_date DATE,
    OUT before_total NUMERIC,
    OUT after_total NUMERIC
)
AS $$
BEGIN
    SELECT COALESCE(SUM(fee), 0)
    INTO before_total
    FROM rentals
    WHERE start_date < p_from_date;

    SELECT COALESCE(SUM(fee), 0)
    INTO after_total
    FROM rentals
    WHERE start_date >= p_from_date;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fee_split(DATE '2025-01-01');

SELECT before_total + after_total AS combined_total,
       (SELECT SUM(fee) FROM rentals) AS actual_total
FROM fee_split(DATE '2025-01-01');


-- Exercise 7.1

CREATE OR REPLACE FUNCTION station_load(
    p_station_id INT,
    OUT bikes_parked INT,
    OUT capacity_pct NUMERIC
)
AS $$
DECLARE
    station_capacity INT;
BEGIN
    SELECT capacity
    INTO station_capacity
    FROM stations
    WHERE station_id = p_station_id;

    SELECT COUNT(*)
    INTO bikes_parked
    FROM bikes
    WHERE station_id = p_station_id;

    IF station_capacity = 0 THEN
        capacity_pct := NULL;
    ELSE
        capacity_pct := ROUND(
            bikes_parked * 100.0 / station_capacity, 1
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT s.station_id,
       s.station_name,
       l.*
FROM stations s,
LATERAL station_load(s.station_id) l;


-- Exercise 7.2

CREATE OR REPLACE FUNCTION top_members(
    p_limit INT DEFAULT 3
)
RETURNS TABLE (
    member_name VARCHAR,
    rental_count INT,
    total_spent NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT m.full_name,
           COUNT(r.rental_id)::INT,
           COALESCE(SUM(r.fee), 0)
    FROM members m
    LEFT JOIN rentals r ON m.member_id = r.member_id
    GROUP BY m.member_id, m.full_name
    ORDER BY COALESCE(SUM(r.fee), 0) DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM top_members();
SELECT * FROM top_members(6);


-- Exercise 7.3

CREATE OR REPLACE FUNCTION rental_invoice(
    p_rental_id INT
)
RETURNS TABLE (
    member_name VARCHAR,
    bike_model VARCHAR,
    rental_duration INT,
    amount_owed NUMERIC,
    status VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT m.full_name,
           b.model,
           COALESCE(r.end_date, CURRENT_DATE) - r.start_date,
           ROUND(
               (COALESCE(r.end_date, CURRENT_DATE) - r.start_date)
               * b.daily_rate, 2
           ),
           CASE
               WHEN r.end_date IS NULL THEN 'OPEN'
               ELSE 'CLOSED'
           END::VARCHAR
    FROM rentals r
    JOIN members m ON r.member_id = m.member_id
    JOIN bikes b ON r.bike_id = b.bike_id
    WHERE r.rental_id = p_rental_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM rental_invoice(11);
SELECT * FROM rental_invoice(19);


-- Exercise 7.4

CREATE OR REPLACE FUNCTION city_report(
    p_city VARCHAR,
    OUT member_count INT,
    OUT rental_count INT,
    OUT total_revenue NUMERIC
)
AS $$
BEGIN
    SELECT COUNT(DISTINCT m.member_id),
           COUNT(r.rental_id),
           COALESCE(SUM(r.fee), 0)
    INTO member_count, rental_count, total_revenue
    FROM members m
    LEFT JOIN rentals r ON m.member_id = r.member_id
    WHERE m.city = p_city;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM city_report('Almaty');


-- Exercise 7.4.1

CREATE OR REPLACE FUNCTION city_report(
    p_city VARCHAR,
    p_from_date DATE,
    OUT member_count INT,
    OUT rental_count INT,
    OUT total_revenue NUMERIC
)
AS $$
BEGIN
    SELECT COUNT(DISTINCT m.member_id),
           COUNT(r.rental_id),
           COALESCE(SUM(r.fee), 0)
    INTO member_count, rental_count, total_revenue
    FROM members m
    LEFT JOIN rentals r
        ON m.member_id = r.member_id
        AND r.start_date >= p_from_date
    WHERE m.city = p_city;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM city_report('Almaty', DATE '2025-01-01');


-- Exercise 7.4.2

SELECT COUNT(DISTINCT m.member_id) AS member_count,
       COUNT(r.rental_id) AS rental_count,
       COALESCE(SUM(r.fee), 0) AS total_revenue
FROM members m
LEFT JOIN rentals r
    ON m.member_id = r.member_id
WHERE m.city = 'Almaty'
  AND r.start_date >= DATE '2025-01-01';
