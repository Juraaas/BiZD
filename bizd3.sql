DECLARE
  numer_max   NUMBER;
BEGIN
  SELECT MAX(department_id) INTO numer_max
  FROM departments;

  DBMS_OUTPUT.PUT_LINE('Maksymalny numer departamentu: ' || numer_max);

  INSERT INTO departments (department_id, department_name)
  VALUES (numer_max + 10, 'EDUCATION');

  UPDATE departments
  SET location_id = 3000
  WHERE department_id = numer_max + 10;

  COMMIT;
END;
/

CREATE TABLE nowa (
  liczba VARCHAR2(10)
);

BEGIN
  FOR i IN 1..10 LOOP
    IF i NOT IN (4, 6) THEN
      INSERT INTO nowa (liczba) VALUES (TO_CHAR(i));
    END IF;
  END LOOP;
  COMMIT;
END;
/

DECLARE
  v_country countries%ROWTYPE;
BEGIN
  -- Wyciąganie wiersza dla kraju 'CA'
  SELECT * INTO v_country FROM countries WHERE country_id = 'CA';

  -- Wypisanie nazwy kraju i region_id
  DBMS_OUTPUT.PUT_LINE('Country Name: ' || v_country.country_name);
  DBMS_OUTPUT.PUT_LINE('Region ID: ' || v_country.region_id);
END;
/

DECLARE
  CURSOR c_salary IS
    SELECT salary, last_name
    FROM employees
    WHERE department_id = 50;
    
  v_salary employees.salary%TYPE;
  v_last_name employees.last_name%TYPE;
BEGIN
  FOR rec IN c_salary LOOP
    v_salary := rec.salary;
    v_last_name := rec.last_name;
    
    IF v_salary > 3100 THEN
      DBMS_OUTPUT.PUT_LINE(v_last_name || ' nie dawać podwyżki');
    ELSE
      DBMS_OUTPUT.PUT_LINE(v_last_name || ' dać podwyżkę');
    END IF;
  END LOOP;
END;
/

DECLARE
  CURSOR c_employees(p_min_salary IN NUMBER, p_max_salary IN NUMBER, p_name_part IN VARCHAR2) IS
    SELECT salary, first_name, last_name
    FROM employees
    WHERE salary BETWEEN p_min_salary AND p_max_salary
    AND (UPPER(first_name) LIKE UPPER(p_name_part || '%'));

BEGIN
  FOR rec IN c_employees(1000, 5000, 'a') LOOP
    DBMS_OUTPUT.PUT_LINE('Pracownik: ' || rec.first_name || ' ' || rec.last_name || ', Zarobki: ' || rec.salary);
  END LOOP;

  FOR rec IN c_employees(5000, 20000, 'u') LOOP
    DBMS_OUTPUT.PUT_LINE('Pracownik: ' || rec.first_name || ' ' || rec.last_name || ', Zarobki: ' || rec.salary);
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE add_job(p_job_id IN VARCHAR2, p_job_title IN VARCHAR2) AS
BEGIN
  INSERT INTO jobs (job_id, job_title) VALUES (p_job_id, p_job_title);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
    ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE modify_job_title(p_job_id IN VARCHAR2, p_new_title IN VARCHAR2) AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM jobs WHERE job_id = p_job_id;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Brak wiersza do zaktualizowania');
  ELSE
    UPDATE jobs
    SET job_title = p_new_title
    WHERE job_id = p_job_id;
    COMMIT;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nie znaleziono wiersza do aktualizacji.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
    ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE delete_job(p_job_id IN VARCHAR2) AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM jobs WHERE job_id = p_job_id;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Brak wiersza do usunięcia');
  ELSE
    DELETE FROM jobs WHERE job_id = p_job_id;
    COMMIT;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nie znaleziono wiersza do usunięcia.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
    ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE get_employee_salary(p_employee_id IN NUMBER, p_salary OUT NUMBER, p_last_name OUT VARCHAR2) AS
BEGIN
  SELECT salary, last_name INTO p_salary, p_last_name
  FROM employees
  WHERE employee_id = p_employee_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nie znaleziono pracownika.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE add_employee(p_first_name IN VARCHAR2, p_last_name IN VARCHAR2, p_salary IN NUMBER) AS
BEGIN
  IF p_salary > 20000 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Zarobki nie mogą być wyższe niż 20000');
  ELSE
    INSERT INTO employees (first_name, last_name, salary)
    VALUES (p_first_name, p_last_name, p_salary);
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
    ROLLBACK;
END;
/