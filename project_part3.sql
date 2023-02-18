---- First of first, let's connect to sys as sysdba
connect sys/sys as sysdba;

-- Connect to Scott
@C:\BD2\scott_emp_dept.sql

SPOOL C:\BD2\project_part3_spool.txt
SELECT to_char(sysdate,'DD Month YYYY Day HH:MI"SS') FROM dual;

-- QUESTION 1

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE part3_q1 (emp_no NUMBER) AS
	t_dname VARCHAR(40);
	t_ename VARCHAR(40);
	t_sal NUMBER(8,2);
	t_comm NUMBER(8,2);

	BEGIN
		SELECT dname, ename, sal, comm
		INTO t_dname, t_ename, t_sal, t_comm
		FROM dept d, emp e
		WHERE d.deptno = e.deptno AND emp_no = empno;

		IF t_comm <> 0 THEN
		DBMS_OUTPUT.PUT_LINE('Employee number ' || emp_no || ' is ' || T_ename || '. He/she works at department ' || t_dname || ', earning $' ||
		(t_sal*12) || ' a year and a commission of $' || t_comm || ' making the total of $' || (t_comm+12*t_sal) || '.');
		ELSE
		DBMS_OUTPUT.PUT_LINE('Employee number ' || emp_no || ' is ' || T_ename || '. He/she works at department ' || t_dname || ', earning $' ||
		(t_sal*12) || ' a year.');
		END IF;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Employee number, ' || emp_no || ' does not exist!');
			WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Something is wrong. Try again!');


	END;
/

EXEC part3_q1(7654)
EXEC part3_q1(7876)
EXEC part3_q1(7000)

-- QUESTION 2

connect sys/sys as sysdba;
DROP USER des02 CASCADE;
@C:\BD1\7clearwater.sql

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE part3_q2 (in_inv_id IN NUMBER) AS
	t_item_desc VARCHAR2(40);
	t_inv_price NUMBER(8,2);
	t_color VARCHAR2(40);
	t_inv_qoh NUMBER(8); 

	BEGIN
		SELECT item_desc, inv_price, color, inv_qoh
		INTO t_item_desc, t_inv_price, t_color, t_inv_qoh
		FROM item i, inventory iv
		WHERE i.item_id = iv.item_id AND inv_id = in_inv_id;

		DBMS_OUTPUT.PUT_LINE('Item description: ' || t_item_desc || '.');
		DBMS_OUTPUT.PUT_LINE('Inventory price: $' || t_inv_price || '.');
		DBMS_OUTPUT.PUT_LINE('Color: ' || t_color || '.');
		DBMS_OUTPUT.PUT_LINE('Quantity on hand: ' || t_inv_qoh ||'.');
		DBMS_OUTPUT.PUT_LINE('Inventory value: $' || ROUND((t_inv_price * t_inv_qoh),2) ||'.');



		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Inventory number, ' || in_inv_id || ' does not exist!');
			WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Something is wrong. Try again!');	
	END;
/

EXEC part3_q2(100)
EXEC part3_q2(23)


-- QUESTION 3

connect sys/sys as sysdba;

DROP USER des03 CASCADE;

@C:\BD1\7Northwoods.sql

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION find_age (in_date IN DATE)
	RETURN NUMBER AS
		out_age NUMBER;
	BEGIN
		out_age := MONTHS_BETWEEN(sysdate, in_date)/12;
	RETURN ROUND(out_age);
	END;
/


SELECT find_age ('83-12-27') FROM DUAL;

CREATE OR REPLACE PROCEDURE part3_q3 (in_sid IN NUMBER) AS
	t_s_last VARCHAR(40);
	t_s_first VARCHAR (40);
	t_s_dob DATE;

	BEGIN
		SELECT s_last, s_first, s_dob
		INTO t_s_last, t_s_first, t_s_dob
		FROM student
		WHERE in_sid = s_id;

		DBMS_OUTPUT.PUT_LINE('Student first name: ' || t_s_first || '.');
		DBMS_OUTPUT.PUT_LINE('Student last name: ' ||t_s_last|| '.');
		DBMS_OUTPUT.PUT_LINE('Student date of birth: ' ||t_s_dob|| '.');
		DBMS_OUTPUT.PUT_LINE('Student age: '|| find_age(t_s_dob) || '.');

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Student number, ' || in_sid || ' does not exist!');
		WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Something is wrong. Try again!');	

	END;
/

EXEC part3_q3(2)
EXEC part3_q3(6)
EXEC part3_q3(12)


-- QUESTION 4

connect sys/sys as sysdba;

DROP USER des04 CASCADE;
 
@C:\BD1\7Software.sql

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION test1 (in_c_id IN NUMBER, in_s_id IN NUMBER, in_cert IN VARCHAR2)
	RETURN NUMBER AS
		tst1 NUMBER;

	temp_c_id NUMBER;
	temp_s_id NUMBER;
	temp_cert VARCHAR2(5);

	BEGIN
		SELECT c_id, skill_id, certification
		INTO temp_c_id, temp_s_id, temp_cert
		FROM consultant_skill
		WHERE c_id = in_c_id AND skill_id = in_s_id AND certification = in_cert;

		tst1 := 1;

		RETURN tst1;

		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		tst1 := 0;
		RETURN tst1;
	END;
/

CREATE OR REPLACE FUNCTION test2 (in_c_id IN NUMBER, in_s_id IN NUMBER)
	RETURN NUMBER AS
		tst2 NUMBER;

	temp_c_id NUMBER;
	temp_s_id VARCHAR2(40);

	BEGIN
		SELECT c_id, skill_id
		INTO temp_c_id, temp_s_id
		FROM consultant_skill
		WHERE skill_id = in_s_id AND c_id = in_c_id;

		tst2 := 1;

		RETURN tst2;

		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		tst2 := 0;
		RETURN tst2;

	END;
/


CREATE OR REPLACE FUNCTION test3 (in_s_id IN NUMBER)
	RETURN NUMBER AS
		tst3 NUMBER;

	temp_s_id NUMBER;

	BEGIN
		SELECT skill_id
		INTO temp_s_id
		FROM skill
		WHERE skill_id = in_s_id;

		tst3 := 1;
		RETURN tst3;

		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Skill ' || in_s_id || ' do not exist.');
		tst3 := 0;
		RETURN tst3;

	END;
/


CREATE OR REPLACE FUNCTION print (in_c_id IN NUMBER, in_skill_id IN NUMBER, in_certification IN VARCHAR2)
	RETURN NUMBER AS
		print NUMBER;

		t_c_last VARCHAR2(40);
		t_c_first VARCHAR2(40);
		t_skill_description VARCHAR2(40);
		t_certification VARCHAR2(40);

		BEGIN

		SELECT c_last, c_first, skill_description, certification
		INTO t_c_last, t_c_first, t_skill_description, t_certification
		FROM consultant c, consultant_skill cs, skill s
		WHERE in_c_id = c.c_id AND in_skill_id = s.skill_id AND c.c_id = cs.c_id AND 
		certification = in_certification AND cs.skill_id = s.skill_id;

		DBMS_OUTPUT.PUT_LINE('Consultant first name: ' || t_c_first || '.');
		DBMS_OUTPUT.PUT_LINE('Consultant last name: ' ||t_c_last|| '.');
		DBMS_OUTPUT.PUT_LINE('Skill Description: ' ||t_skill_description|| '.');
		DBMS_OUTPUT.PUT_LINE('Certification: '|| t_certification || '.');

		RETURN null;

		END;
/


CREATE OR REPLACE PROCEDURE part3_q4 (in_c_id IN NUMBER, in_skill_id IN NUMBER, in_certification IN VARCHAR2) AS

	tst_1 NUMBER;
	tst_2 NUMBER;
	tst_3 NUMBER;
	prt NUMBER;

	BEGIN

		tst_1 := test1(in_c_id, in_skill_id, in_certification);		 		

		IF tst_1 = 1 THEN
			prt := print(in_c_id,in_skill_id,in_certification);
			DBMS_OUTPUT.PUT_LINE('No need to change!!!');

		ELSIF tst_1 = 0 THEN
			tst_2 := test2(in_c_id, in_skill_id);

			IF tst_2 = 1 THEN
					IF (in_certification <> 'Y' OR in_certification <> 'N') THEN
						DBMS_OUTPUT.PUT_LINE('Wrong option. You must insert Y or N.');
					ELSE
						UPDATE consultant_skill SET certification = in_certification
						WHERE c_id = in_c_id AND skill_id = in_skill_id;
						COMMIT;
						prt := print(in_c_id,in_skill_id,in_certification);
						DBMS_OUTPUT.PUT_LINE('Certification Updated!!!');
					END IF;

			ELSIF tst_2 = 0 THEN
				tst_3 := test3(in_skill_id);

				IF tst_3 = 1 THEN
					INSERT INTO consultant_skill(c_id,skill_id,certification)
					VALUES (in_c_id,in_skill_id,in_certification);
					COMMIT;
					prt := print(in_c_id,in_skill_id,in_certification);
					DBMS_OUTPUT.PUT_LINE('Both skill and certification inserted!!!');


					ELSIF tst_3 = 0 THEN
					DBMS_OUTPUT.PUT_LINE('Try again.');
				END IF;
			END IF;
		END IF;
	
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('Consultant number ' || in_c_id || ' do not exist.');
	DBMS_OUTPUT.PUT_LINE('Try again.');

	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('There is something wrong.');
	DBMS_OUTPUT.PUT_LINE('Try again.');
	
	END;
/


EXEC part3_q4(100,1,'Y')
EXEC part3_q4(100,2,'Y')
EXEC part3_q4(101,7,'Y')
EXEC part3_q4(200,1,'Y')
EXEC part3_q4(100,10,'Y')

SPOOL OFF
