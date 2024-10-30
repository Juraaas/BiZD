ALTER TABLE COUNTRIES
ADD CONSTRAINT country_id PRIMARY KEY (country_id);

ALTER TABLE REGIONS
ADD CONSTRAINT region_id PRIMARY KEY (region_id);

ALTER TABLE COUNTRIES
ADD FOREIGN KEY (region_id)
REFERENCES REGIONS (region_id);

ALTER TABLE LOCATIONS
ADD CONSTRAINT location_id PRIMARY KEY (location_id);

ALTER TABLE LOCATIONS
ADD FOREIGN KEY (country_id)
REFERENCES COUNTRIES (country_id);

ALTER TABLE DEPARTMENTS
ADD CONSTRAINT department_id PRIMARY KEY (department_id);

ALTER TABLE DEPARTMENTS
ADD FOREIGN KEY (location_id)
REFERENCES LOCATIONS (location_id);

ALTER TABLE EMPLOYEES
ADD CONSTRAINT employee_id PRIMARY KEY (employee_id);

ALTER TABLE EMPLOYEES
ADD FOREIGN KEY (department_id)
REFERENCES DEPARTMENTS (department_id);

ALTER TABLE JOB_HISTORY
ADD CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date);

ALTER TABLE JOB_HISTORY
ADD FOREIGN KEY (department_id)
REFERENCES DEPARTMENTS (department_id);

ALTER TABLE JOBS
ADD CONSTRAINT job_id PRIMARY KEY (job_id);

ALTER TABLE JOB_HISTORY
ADD FOREIGN KEY (job_id)
REFERENCES JOBS (job_id);

SELECT last_name AS wynagrodzenie, salary
FROM employees
WHERE department_id IN (20, 50) 
AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;

SELECT hire_date, last_name
FROM employees
WHERE manager_id IS NOT NULL
AND EXTRACT(YEAR FROM hire_date) = 2005
ORDER BY last_name;

SELECT first_name || ' ' || last_name AS full_name, salary, phone_number
FROM employees
WHERE last_name LIKE '_e%' AND first_name LIKE '_%n%'
ORDER BY first_name DESC, last_name ASC;

SELECT first_name, last_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS months_worked,
       CASE
           WHEN MONTHS_BETWEEN(SYSDATE, hire_date) < 150 THEN salary * 0.1
           WHEN MONTHS_BETWEEN(SYSDATE, hire_date) BETWEEN 150 AND 200 THEN salary * 0.2
           ELSE salary * 0.3
       END AS wysokosc_dodatku
FROM employees
ORDER BY months_worked;

SELECT department_id,
       SUM(salary) AS suma_zarobkow,
       ROUND(AVG(salary)) AS srednia_zarobkow
FROM employees
GROUP BY department_id
HAVING MIN(salary) > 5000;

SELECT e.last_name, e.department_id, d.department_name, e.job_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.location_id IN (SELECT location_id FROM locations WHERE city = 'Toronto');

SELECT e.first_name || ' ' || e.last_name AS full_name, 
       c.first_name || ' ' || c.last_name AS co_worker
FROM employees e
JOIN employees c ON e.manager_id = c.employee_id
WHERE e.first_name = 'Jennifer';

SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

SELECT e.first_name, 
       e.last_name, 
       e.job_id, 
       d.department_name, 
       e.salary, 
       j.grade
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN job_grades j ON e.salary BETWEEN j.min_salary AND j.max_salary;

SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

SELECT DISTINCT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.department_id IN (
    SELECT DISTINCT department_id
    FROM employees
    WHERE last_name LIKE '%u%'
);










