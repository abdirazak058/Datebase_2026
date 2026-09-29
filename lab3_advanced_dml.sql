-- Part A

CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INTEGER DEFAULT 50000,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);



CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INTEGER,
    manager_id INTEGER
);



CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);


-- Part B

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (1, 'Aibar', 'Abdirazak', 'IT');

SELECT * FROM employees;

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (2, 'Aibar', 'Abdirazak', 'IT');

INSERT INTO employees
(first_name, last_name, department, salary, hire_date, status)
VALUES
('Erkebulan', 'Usen', 'Sales', DEFAULT, '2022-05-10', DEFAULT);


INSERT INTO departments (dept_name, budget, manager_id)
VALUES
('IT', 150000, 1),
('Sales', 120000, 2),
('HR', 90000, 3);

SELECT * FROM departments;

INSERT INTO employees
(first_name, last_name, department, salary, hire_date)
VALUES
('Dias', 'Amanov', 'IT', 50000 * 1.1, CURRENT_DATE);

SELECT * FROM employees;


CREATE TEMP TABLE temp_employees AS
SELECT *
FROM employees
WHERE department = 'IT';

SELECT * FROM temp_employees;



--  Part C

UPDATE employees
SET salary = salary * 1.10;

SELECT * FROM employees;

UPDATE employees
SET status = 'Senior'
WHERE salary > 60000
  AND hire_date < '2020-01-01';

SELECT * FROM employees;


UPDATE employees
SET department =
    CASE
        WHEN salary > 80000 THEN 'Management'
        WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
        ELSE 'Junior'
    END;

SELECT * FROM employees;


UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

SELECT * FROM employees;


UPDATE departments
SET budget = (
    SELECT AVG(salary) * 1.20
    FROM employees
    WHERE employees.department = departments.dept_name
);

SELECT * FROM departments;

UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

SELECT * FROM employees;


-- Part D

DELETE FROM employees
WHERE status = 'Terminated';

SELECT * FROM employees;

DELETE FROM employees
WHERE salary < 40000
  AND hire_date > '2023-01-01'
  AND department IS NULL;

SELECT * FROM employees;

DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT department
    FROM employees
    WHERE department IS NOT NULL
);

SELECT * FROM departments;

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;


-- Part E

INSERT INTO employees
(first_name, last_name, department, salary, hire_date, status)
VALUES
('Ali', 'Sultanov', NULL, NULL, CURRENT_DATE, 'Active');

SELECT * FROM employees;


UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

SELECT * FROM employees;


DELETE FROM employees
WHERE salary IS NULL
   OR department IS NULL;

SELECT * FROM employees;


--Part F

INSERT INTO employees
(first_name, last_name, department, salary, hire_date)
VALUES
('Arman', 'Bekov', 'IT', 60000, CURRENT_DATE)
RETURNING emp_id, first_name || ' ' || last_name AS full_name;

UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id,
          salary - 5000 AS old_salary,
          salary AS new_salary;


DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;


--Part G

INSERT INTO employees
(first_name, last_name, department, salary, hire_date)
SELECT 'Nursultan', 'Amanov', 'IT', 65000, CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1
    FROM employees
    WHERE first_name = 'Nursultan'
      AND last_name = 'Amanov'
);

SELECT * FROM employees;

UPDATE employees
SET salary = salary *
    CASE
        WHEN (
            SELECT budget
            FROM departments
            WHERE dept_name = employees.department
        ) > 100000
        THEN 1.10
        ELSE 1.05
    END;

SELECT * FROM employees;

INSERT INTO employees
(first_name, last_name, department, salary, hire_date)
VALUES
('Ayan', 'Serikov', 'IT', 50000, CURRENT_DATE),
('Madi', 'Askarov', 'IT', 55000, CURRENT_DATE),
('Daniyar', 'Aliyev', 'Sales', 60000, CURRENT_DATE),
('Adil', 'Nurlanov', 'HR', 45000, CURRENT_DATE),
('Dias', 'Bekov', 'Sales', 65000, CURRENT_DATE);

UPDATE employees
SET salary = salary * 1.10
WHERE first_name IN ('Ayan', 'Madi', 'Daniyar', 'Adil', 'Dias');

SELECT * FROM employees;


CREATE TABLE employee_archive AS
SELECT *
FROM employees
WHERE 1 = 0;

INSERT INTO employee_archive
SELECT *
FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';

SELECT * FROM employee_archive;



UPDATE projects
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND dept_id IN (
      SELECT d.dept_id
      FROM departments d
      JOIN employees e
        ON d.dept_name = e.department
      GROUP BY d.dept_id
      HAVING COUNT(e.emp_id) > 3
  );

SELECT * FROM projects;
