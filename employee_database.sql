-- =============================================
-- PROJECT: Employee Database SQL
-- AUTHOR: Balaji Nikkam
-- GitHub: balajinikkam-cloud
-- PURPOSE: HR Database simulation for
--          Application Support portfolio
-- =============================================

-- TABLES
CREATE TABLE departments (dept_id INT PRIMARY KEY, dept_name VARCHAR(50), location VARCHAR(50));
CREATE TABLE employees (emp_id INT PRIMARY KEY, emp_name VARCHAR(100), dept_id INT, salary DECIMAL(10,2), hire_date DATE, status VARCHAR(20), FOREIGN KEY (dept_id) REFERENCES departments(dept_id));
CREATE TABLE attendance (att_id INT PRIMARY KEY IDENTITY(1,1), emp_id INT, att_date DATE, status VARCHAR(10), FOREIGN KEY (emp_id) REFERENCES employees(emp_id));
CREATE TABLE audit_log (log_id INT PRIMARY KEY IDENTITY(1,1), emp_id INT, old_salary DECIMAL(10,2), new_salary DECIMAL(10,2), changed_on DATETIME DEFAULT GETDATE());

-- INSERT DEPARTMENTS
INSERT INTO departments VALUES (1,'IT Support','Pune'),(2,'HR','Mumbai'),(3,'Finance','Bangalore'),(4,'Operations','Hyderabad');

-- INSERT EMPLOYEES
INSERT INTO employees VALUES (101,'Balaji Nikkam',1,45000,'2023-06-01','Active');
INSERT INTO employees VALUES (102,'Priya Sharma',2,55000,'2022-03-15','Active');
INSERT INTO employees VALUES (103,'Rahul Verma',1,40000,'2023-09-01','Active');
INSERT INTO employees VALUES (104,'Sneha Patil',3,70000,'2021-11-20','Active');
INSERT INTO employees VALUES (105,'Amit Joshi',4,35000,'2024-01-10','Active');
INSERT INTO employees VALUES (106,'Neha Kulkarni',2,60000,'2020-07-05','Inactive');
INSERT INTO employees VALUES (107,'Vijay Desai',3,80000,'2019-04-12','Active');
INSERT INTO employees VALUES (108,'Pooja Rao',1,42000,'2023-12-01','Active');

-- INSERT ATTENDANCE
INSERT INTO attendance (emp_id,att_date,status) VALUES
(101,'2024-04-01','Present'),(101,'2024-04-02','Present'),
(102,'2024-04-01','Absent'),(103,'2024-04-01','Present'),
(104,'2024-04-01','Present'),(105,'2024-04-02','Absent'),
(106,'2024-04-01','Present'),(107,'2024-04-02','Present');

-- QUERY 1: All employees with department
SELECT e.emp_id, e.emp_name, d.dept_name, e.salary, e.status FROM employees e JOIN departments d ON e.dept_id = d.dept_id;

-- QUERY 2: Top 3 highest paid
SELECT TOP 3 emp_name, salary FROM employees ORDER BY salary DESC;

-- QUERY 3: Department wise average salary
SELECT d.dept_name, AVG(e.salary) AS avg_salary FROM employees e JOIN departments d ON e.dept_id = d.dept_id GROUP BY d.dept_name;

-- QUERY 4: Employee count per department
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees FROM employees e JOIN departments d ON e.dept_id = d.dept_id GROUP BY d.dept_name;

-- QUERY 5: Inactive employees
SELECT emp_name, salary, hire_date FROM employees WHERE status = 'Inactive';

-- QUERY 6: Employees hired after 2023
SELECT emp_name, hire_date, status FROM employees WHERE hire_date >= '2023-01-01' ORDER BY hire_date;

-- QUERY 7: Absent employees
SELECT e.emp_name, a.att_date, a.status FROM attendance a JOIN employees e ON a.emp_id = e.emp_id WHERE a.status = 'Absent';

-- STORED PROCEDURE: 10% salary hike
CREATE PROCEDURE GiveSalaryHike @dept_id INT AS
BEGIN
    UPDATE employees SET salary = salary * 1.10 WHERE dept_id = @dept_id;
    PRINT 'Salary hike applied!';
END;

-- TRIGGER: Auto log salary changes
CREATE TRIGGER trg_salary_audit ON employees AFTER UPDATE AS
BEGIN
    INSERT INTO audit_log (emp_id, old_salary, new_salary)
    SELECT d.emp_id, d.salary, i.salary
    FROM deleted d JOIN inserted i ON d.emp_id = i.emp_id
    WHERE d.salary <> i.salary;
END;
