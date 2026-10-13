-- Task 1.1

CREATE TABLE employees(
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);



-- Task 1.2

CREATE TABLE products_catalog(
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_prince NUMERIC,
    CONSTRAINT valid_discount CHECK(
        regular_price > 0
        AND discount_prince > 0
        AND discount_prince < regular_price
    )
);



-- Task 1.3

CREATE TABLE bookings(
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK(num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date )
);



-- Task 1.4

INSERT INTO employees
(employee_id, first_name, last_name, age, salary)
VALUES
(101, 'Aibar', 'Abdirazak', 20, 100000),
(102, 'Nurik', 'Krash', 64, 15000);

SELECT * FROM employees;

--Error insert date;
INSERT INTO employees
VALUES (103, 'Dias', 'MEN', 16, 200000);

INSERT INTO employees
VALUES (104, 'Arman', 'Aliyev', 22, -5000);


INSERT INTO products_catalog
(product_id, product_name, regular_price, discount_prince)
VALUES
(101, 'Telefon', 350000, 300000),
(102, 'Noyt', 200000, 180000);

SELECT * FROM products_catalog;

--error insert date;

INSERT INTO products_catalog
VALUES (103, 'Mouse', -5000, 3000);

INSERT INTO products_catalog
VALUES (104, 'Keyboard', 15000, 0);

INSERT INTO products_catalog
VALUES (105, 'Tablet', 100000, 120000);



INSERT INTO bookings
(booking_id, check_in_date, check_out_date, num_guests)
VALUES
(101, '2026-10-15', '2026-10-18', 2),
(102, '2026-10-20', '2026-10-25', 5);

SELECT * FROM bookings;

-- Error inseet date

INSERT INTO bookings
VALUES (103, '2026-10-15', '2026-10-18', 15);

INSERT INTO bookings
VALUES (104, '2026-10-20', '2026-10-15', 3);






-- Task 2.1

CREATE TABLE customers(
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    registration_date DATE NOT NULL
);



-- Task 2.2

CREATE TABLE inventory(
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity >= 0),
    unit_price NUMERIC NOT NULL check(unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

-- Task 2.3 insert date type

INSERT INTO customers
(customer_id, email, phone, registration_date)
VALUES
(101, 'arman@gmail.com', '87011234567', '2026-10-13'),
(102, 'dias@gmail.com', '87019876543', '2026-10-13');

-- error insert date

INSERT INTO customers
VALUES (103, NULL, '87015554433', '2026-10-13');



INSERT INTO inventory
(item_id, item_name, quantity, unit_price, last_updated)
VALUES
(101, 'Laptop', 10, 350000, '2026-10-13 11:00:00'),
(102, 'Mouse', 20, 5000, '2026-10-13 11:10:00');


--error insert date

INSERT INTO inventory
VALUES (103, 'Keyboard', NULL, 15000, '2026-10-13 11:20:00');



-- Task 3.1

CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);



-- Task 3.2


CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);



-- Task 3.3

ALTER TABLE users
RENAME CONSTRAINT users_username_key TO unique_username;

ALTER TABLE users
RENAME CONSTRAINT users_email_key TO unique_email;



-- Task 4.1

CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);


-- insert date

INSERT INTO departments
(dept_id, dept_name, location)
VALUES
(1, 'IT', 'Almaty'),
(2, 'Finance', 'Astana'),
(3, 'HR', 'Aktau');

SELECT * FROM departments;



-- Task 4.2

CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

-- insert date

INSERT INTO student_courses
(student_id, course_id, enrollment_date, grade)
VALUES
(101, 1, '2026-09-01', 'A'),
(101, 2, '2026-09-01', 'B'),
(102, 1, '2026-09-02', 'A'),
(103, 3, '2026-09-03', 'C');


-- Task 4.3

--1. What is the difference between UNIQUE and PRIMARY KEY?
--A PRIMARY KEY uniquely identifies each row in a table. It does not allow duplicate or NULL values.
--A UNIQUE constraint prevents duplicate values in a column. In PostgreSQL, it normally allows NULL values.
--A table can have only one PRIMARY KEY, but it can have multiple UNIQUE constraints.
--2. When should we use a single-column or composite PRIMARY KEY?
--A single-column PRIMARY KEY is used when one column can uniquely identify each row. For example, a student ID.
--A composite PRIMARY KEY is used when two or more columns are needed to identify a row. For example, student_id and course_id in a student_courses table.
--This allows one student to take different courses, but the same student and course combination cannot be repeated.
--. Why can a table have only one PRIMARY KEY but multiple UNIQUE constraints?
--A table can have only one PRIMARY KEY because it is the main key used to identify each row. This PRIMARY KEY can contain one or more columns.
--A table can have multiple UNIQUE constraints because different columns may need unique values.
--For example, in a users table, id can be the PRIMARY KEY, while username and email can have separate UNIQUE constraints.



-- Task 5.1


-- Task 5.1: Basic Foreign Key

CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);


-- insert date

INSERT INTO employees_dept
(emp_id, emp_name, dept_id, hire_date)
VALUES
(101, 'Ali', 1, '2026-01-15'),
(102, 'Ayan', 2, '2026-02-20'),
(103, 'Dias', 3, '2026-03-10');

SELECT * FROM employees_dept;



-- Task 5.2

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

INSERT INTO authors
VALUES
(1, 'Abai Kunanbayuly', 'Kazakhstan'),
(2, 'Mukhtar Auezov', 'Kazakhstan'),
(3, 'J.K. Rowling', 'USA');

SELECT * FROM authors;


CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

INSERT INTO publishers
VALUES
(1, 'Atamura', 'Almaty'),
(2, 'Mektep', 'Almaty'),
(3, 'Bloomsbury', 'London');

SELECT * FROM publishers;


CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);



INSERT INTO books
(book_id, title, author_id, publisher_id, publication_year, isbn)
VALUES
(1, 'Abai Poems', 1, 1, 2020, 'ISBN001'),
(2, 'Abai Zholy', 2, 2, 2019, 'ISBN002'),
(3, 'Harry Potter', 3, 3, 1997, 'ISBN003');

SELECT * FROM books;



-- Task 5.3
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);


INSERT INTO categories
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books');



CREATE TABLE products_fk(
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER
        REFERENCES categories(category_id)
        ON DELETE RESTRICT
);

INSERT INTO products_fk

VALUES
(1, 'Laptop', 1),
(2, 'T-shirt', 2),
(3, 'Notebook', 3);



CREATE TABLE orders(
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);


INSERT INTO orders
VALUES
(101, '2026-10-10'),
(102, '2026-10-11');


CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER
        REFERENCES orders(order_id)
        ON DELETE CASCADE,
    produc_id INTEGER
        REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);


INSERT INTO order_items
VALUES
(1, 101, 1, 2),
(2, 101, 3, 5),
(3, 102, 2, 1);




-- Task 6.1


CREATE SCHEMA IF NOT EXISTS task6;

CREATE TABLE task6.customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE task6.products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE task6.orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL
        REFERENCES task6.customers(customer_id)
        ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (
        status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')
    )
);

CREATE TABLE task6.order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL
        REFERENCES task6.orders(order_id)
        ON DELETE CASCADE,
    product_id INTEGER NOT NULL
        REFERENCES task6.products(product_id)
        ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO task6.customers VALUES
(1, 'Ali', 'ali@gmail.com', '87010000001', '2026-09-01'),
(2, 'Ayan', 'ayan@gmail.com', '87010000002', '2026-09-02'),
(3, 'Dias', 'dias@gmail.com', '87010000003', '2026-09-03'),
(4, 'Arman', 'arman@gmail.com', '87010000004', '2026-09-04'),
(5, 'Dana', 'dana@gmail.com', '87010000005', '2026-09-05');

INSERT INTO task6.products VALUES
(1, 'Laptop', 'Lenovo laptop', 350000, 10),
(2, 'Mouse', 'Wireless mouse', 5000, 50),
(3, 'Keyboard', 'Mechanical keyboard', 15000, 20),
(4, 'Monitor', '24 inch monitor', 80000, 15),
(5, 'Headphones', 'Wireless headphones', 25000, 30);

INSERT INTO task6.orders VALUES
(101, 1, '2026-10-01', 355000, 'pending'),
(102, 2, '2026-10-02', 15000, 'processing'),
(103, 3, '2026-10-03', 80000, 'shipped'),
(104, 4, '2026-10-04', 25000, 'delivered'),
(105, 5, '2026-10-05', 10000, 'cancelled');

INSERT INTO task6.order_details VALUES
(1, 101, 1, 1, 350000),
(2, 101, 2, 1, 5000),
(3, 102, 3, 1, 15000),
(4, 103, 4, 1, 80000),
(5, 104, 5, 1, 25000),
(6, 105, 2, 2, 5000);

SELECT * FROM task6.customers;
SELECT * FROM task6.products;
SELECT * FROM task6.orders;
SELECT * FROM task6.order_details;

-- Test 1: UNIQUE
-- INSERT INTO task6.customers VALUES
-- (6, 'Test', 'ali@gmail.com', NULL, '2026-10-06');

-- Test 2: CHECK (negative price)
-- INSERT INTO task6.products VALUES
-- (6, 'Tablet', 'New tablet', -1000, 5);

-- Test 3: CHECK (negative stock)
-- INSERT INTO task6.products VALUES
-- (7, 'Camera', 'Digital camera', 100000, -5);

-- Test 4: FOREIGN KEY
-- INSERT INTO task6.orders VALUES
-- (106, 99, '2026-10-06', 5000, 'pending');

-- Test 5: CHECK (invalid status)
-- INSERT INTO task6.orders VALUES
-- (107, 1, '2026-10-06', 5000, 'unknown');

-- Test 6: CHECK (zero quantity)
-- INSERT INTO task6.order_details VALUES
-- (7, 101, 1, 0, 350000);

-- Test 7: NOT NULL
-- INSERT INTO task6.customers VALUES
-- (7, NULL, 'test@gmail.com', NULL, '2026-10-06');

-- Test 8: PRIMARY KEY
-- INSERT INTO task6.products VALUES
-- (1, 'Tablet', 'New tablet', 50000, 5);

-- Test 9: ON DELETE RESTRICT
-- DELETE FROM task6.customers WHERE customer_id = 1;

-- Test 10: ON DELETE CASCADE
-- DELETE FROM task6.orders WHERE order_id = 101;
