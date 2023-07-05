-- Task_1 
SELECT 
    Year(t.from_date) AS Year,
    e.gender,
    COUNT(e.emp_no) AS Number_of_employees
FROM
    employees t
        JOIN
    dept_emp de ON t.emp_no = de.emp_no
GROUP BY Year , e.gender
HAVING Year >= '1990';

#Task_2
SELECT 
d.dept_name,
ee.gender,
dm.emp_no,
dm.from_date,
dm.to_date,
e.calendar_year,
    CASE
        WHEN
            YEAR(dm.to_date) >= e.calendar_year
                AND YEAR(dm.from_date) <= e.calendar_year
        THEN
            1
        ELSE 0
    END AS Active
FROM
    (SELECT 
        Year(hire_date) AS Calendar_year
    FROM
        employees
    GROUP BY calendar_year) e
        CROSS JOIN
    dept_manager dm
        JOIN
    departments d ON dm.dept_no = d.dept_no
        JOIN
    employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no , calendar_year;

#Task_3
SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS Salary,
    YEAR(s.from_date) AS calendar_year
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
        JOIN
    departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= '2002'
ORDER BY d.dept_no;

#TASK_4
DROP PROCEDURE IF EXISTS filter_salary;

DELIMITER $$
CREATE PROCEDURE filter_salary (IN min_salary FLOAT, IN max_salary FLOAT)
BEGIN
SELECT 
    e.gender, d.dept_name, AVG(s.salary) as avg_salary
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
        JOIN
    departments d ON d.dept_no = de.dept_no
    WHERE s.salary BETWEEN min_salary AND max_salary
GROUP BY d.dept_no, e.gender;
END$$
DELIMITER ;
CALL filter_salary(50000, 90000);