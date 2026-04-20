# employee-database-sql
SQL project simulating HR database with queries,sorted procedures and triggers for application support roles

# Employee Database SQL Project

![SQL](https://img.shields.io/badge/SQL-Server-blue)
![Status](https://img.shields.io/badge/Status-Complete-green)

## About
A real-world HR database simulation built using **Microsoft SQL Server**.  
Designed to demonstrate core Application Support and Database skills.

**Author:** Balaji Nikkam  
**Tool:** Azure Data Studio + Azure SQL  

---

## Database Schema
| Table | Description |
|-------|-------------|
| `departments` | Stores department info and locations |
| `employees` | Employee records with salary and status |
| `attendance` | Daily attendance tracking |
| `audit_log` | Auto-logs every salary change via trigger |

---

## Features
- 4 related tables with Foreign Key constraints
- 7 analytical SQL queries (JOINs, GROUP BY, filters)
- Stored Procedure for automated salary hike by department
- Trigger that auto-logs all salary changes with timestamp

---

## Sample Queries
```sql
-- Top 3 highest paid employees
SELECT TOP 3 emp_name, salary 
FROM employees 
ORDER BY salary DESC;

-- Department wise average salary
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

