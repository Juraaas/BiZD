CREATE TABLE REGIONS(region_id INT PRIMARY KEY, region_name VARCHAR(50));

CREATE TABLE COUNTRIES(country_id INT PRIMARY KEY, country_name VARCHAR(50), region_id INT, FOREIGN KEY(region_id) REFERENCES REGIONS(region_id) ON DELETE CASCADE);

CREATE TABLE LOCATIONS(location_id INT PRIMARY KEY, street_address VARCHAR(50), postal_code VARCHAR(10), city VARCHAR(50), state_province VARCHAR(50), country_id INT, FOREIGN KEY(country_id) REFERENCES COUNTRIES(country_id) ON DELETE CASCADE);

CREATE TABLE DEPARTMENTS(department_id INT PRIMARY KEY, department_name VARCHAR(50), manager_id INT);

CREATE TABLE JOBS(job_id INT PRIMARY KEY, job_title VARCHAR(50), min_salary INT, max_salary INT);

CREATE TABLE JOB_HISTORY(start_date DATE, employee_id INT, PRIMARY KEY (employee_id, start_date), FOREIGN KEY(employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE, end_date DATE, job_id INT, FOREIGN KEY(job_id) REFERENCES JOBS(job_id) ON DELETE CASCADE, department_id INT, FOREIGN KEY(department_id) REFERENCES DEPARTMENTS(department_id) ON DELETE CASCADE);

CREATE TABLE EMPLOYEES(employee_id INT PRIMARY KEY, first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL, email VARCHAR(50), phone_number VARCHAR(15) NOT NULL, hire_date DATE, job_id INT, FOREIGN KEY(job_id) REFERENCES jobs(job_id) ON DELETE CASCADE, salary INT, commission_pct INT, manager_id INT);

ALTER TABLE DEPARTMENTS
ADD location_id INT;

ALTER TABLE DEPARTMENTS
ADD FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id) ON DELETE CASCADE;

ALTER TABLE EMPLOYEES
ADD department_id INT;

ALTER TABLE EMPLOYEES
ADD FOREIGN KEY(department_id) REFERENCES DEPARTMENTS(department_id) ON DELETE CASCADE;

ALTER TABLE JOBS
ADD CONSTRAINT check_salary CHECK (min_salary < max_salary - 2000);

