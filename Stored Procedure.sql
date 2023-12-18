Write a PL/SQL stored procedure for passing empno as a parameter to display name 
of employee & his salary.

create or replace procedure p1 (p_empno number)
is
v_ename varchar2(10);
v_sal number(10);
begin
select ename,sal into v_ename,v_sal from emp1
where empno=p_empno;
dbms_output.put_line(v_ename||' '||v_sal);
end;

select * from emp1;

Method 1
exec p1(7902);
-----------------
Method 2 Using Annonymous block
begin
p1(7900);
end;
-----------------
Method 3
call p1(0);


================================================================================

Write a PL/SQL stored procedure for passing deptno as a parameter to display
employee details corresponing to that deptno.

Create or replace procedure p1(p_deptno number)
is
cursor c1 is select * from emp1 where deptno=p_deptno;
i emp1%rowtype;
Begin
open c1;
loop 
fetch c1 into i;
exit when c1%notfound;
dbms_output.put_line(i.ename||' '||i.ename||' '||i.deptno);
end loop;
close c1;
end;

------------
set serverout on;
-------------
Method 1
exec p1(10);
----------
Method 2 --Using Annonymous block
begin
p1(20);
end;
----------
Method 3
call p1(30);

================================================================================

Write a PL/SQL stored procedure to insert a record into dept table using "in" Parameter

select * from dept;

create or replace procedure p1(p_deptno in number,p_dname in varchar2,p_loc in varchar2)
is 
begin
insert into dept
values (p_deptno,p_dname,p_loc);
dbms_output.put_line('Record inserted');
end;

exec p1(40,'A','America');

select * from dept;

================================================================================
--Class--

select * from n1;

create sequence seq_empno;

create or replace procedure p_get_empno
(p_ename IN varchar2,
p_sal IN number,
p_job IN varchar2,
p_deptno IN number,
p_empno OUT number,
p_error_code OUT varchar2,
p_message OUT varchar2)

AS
v_empno number;

Begin
v_empno:=seq_empno.nextval;

insert into n1 (empno,ename,sal,job,deptno)
values(v_empno,p_ename,p_sal,p_job,p_deptno);

p_empno:=v_empno;
p_error_code:='1';
p_message:='Registration Successful. Employee No.-->'||v_empno;

dbms_output.put_line(p_message);

Exception
When others then
p_error_code:='0';
p_message:='Registration Failed. Employee No. not generated';
dbms_output.put_line(p_message);
End p_get_empno;

-------------------------

DECLARE
  P_ENAME VARCHAR2(200);
  P_SAL NUMBER;
  P_JOB VARCHAR2(200);
  P_DEPTNO NUMBER;
  P_EMPNO NUMBER;
  P_ERROR_CODE VARCHAR2(200);
  P_MESSAGE VARCHAR2(200);
BEGIN
  P_ENAME := NULL;
  P_SAL := NULL;
  P_JOB := NULL;
  P_DEPTNO := NULL;

  P_GET_EMPNO(
    P_ENAME => 'MANALI',
    P_SAL => 1000,
    P_JOB => 'IT',
    P_DEPTNO => 20,
    P_EMPNO => P_EMPNO,
    P_ERROR_CODE => P_ERROR_CODE,
    P_MESSAGE => P_MESSAGE
  );

DBMS_OUTPUT.PUT_LINE('P_EMPNO = ' || P_EMPNO);

  :P_EMPNO := P_EMPNO;
 
DBMS_OUTPUT.PUT_LINE('P_ERROR_CODE = ' || P_ERROR_CODE);

  :P_ERROR_CODE := P_ERROR_CODE;

DBMS_OUTPUT.PUT_LINE('P_MESSAGE = ' || P_MESSAGE);

  :P_MESSAGE := P_MESSAGE;

END;

set serveroutput on;
select * from n1;
--------------------

-------------------OR-------------------------

create or replace procedure p_get_empno
(p_ename IN varchar2,
p_sal IN number,
p_job IN varchar2,
p_deptno IN number)

AS
v_empno number(10);
p_empno number(10);
p_error_code varchar2(10);
p_message varchar2(100);

Begin
v_empno:=seq_empno.nextval;

insert into n1 (empno,ename,sal,job,deptno)
values(v_empno,p_ename,p_sal,p_job,p_deptno);

p_empno:=v_empno;
p_error_code:='1';
p_message:='Registration Successful. Employee No.-->'||v_empno;

dbms_output.put_line(p_message);

Exception
When others then
p_error_code:='0';
p_message:='Registration Failed. Employee No. not generated';
dbms_output.put_line(p_message);
End p_get_empno;

------------------------------

Begin
p_get_empno('Pam',1001,'Civil',12);
End;

select * from n1;

================================================================================
9/12/23 Class

Requirement: Copy data from emp1 to copy

select * from emp1;
create table copy 
as select * from emp1 
where 1=2;

select * from copy;

create or replace procedure proc_copy
as
Cursor c1 is select * from emp1;
Begin
for i in c1
loop
insert into copy (empno,ename,sal,job)
            values(i.empno,i.ename,i.sal,i.job);
end loop;
commit;
end;

set serveroutput on;

exec proc_copy;

select * from copy;

--Problem: When we execute data will be inserted for each execution

-------------------------------------
-- Put validation

create or replace procedure proc_copy
as
Cursor c1 is select * from emp1;
v_count number;
v_message varchar2(50);

Begin
for i in c1
loop
select count(1) into v_count from copy
where empno=i.empno;

if v_count=0 then
insert into copy (empno,ename,sal,job)
            values(i.empno,i.ename,i.sal,i.job);

end if;
end loop;
commit;
end;

------
exec proc_copy;

select * from copy;

delete from copy;

================================================================================
Requirement: If data already exist then update only deptno.

create or replace procedure proc_copy
as
Cursor c1 is select * from emp1;
v_count number;
v_message varchar2(50);

Begin
for i in c1
loop
select count(1) into v_count from copy
where empno=i.empno;

if v_count=0 then
insert into copy (empno,ename,sal,job)
            values(i.empno,i.ename,i.sal,i.job);
v_message:='Data inserted successfully';
            
else
update copy
set deptno=i.deptno
where empno=i.empno;

end if;
end loop;
commit;
end;

exec proc_copy;

select * from copy;

select * from emp1;

================================================================================
Requirement: Take dept no from user and insert all data of that dept in copy table

create or replace procedure proc_copy(p_deptno number)
as
Cursor c1 is select * from emp1
where deptno=p_deptno;
v_count number;
v_message varchar2(50);

Begin
for i in c1
loop
select count(1) into v_count from copy
where empno=i.empno;

if v_count=0 then
insert into copy (empno,ename,sal,job)
            values(i.empno,i.ename,i.sal,i.job);
            
else
update copy
set deptno=i.deptno
where empno=i.empno;

end if;
end loop;

Exception
When others then
v_message:='Deptno doesent exist. Enter valid deptno';
dbms_output.put_line(v_message);
commit;
end;

---------
exec proc_copy(30);

delete from copy;

select * from copy;

select * from emp1
where deptno=30;

================================================================================

                            Bank Details Update

--------------------------------------------------------------------------------
create table bank_details
(account_no number(20),
full_name varchar2(45),
mobile number(15),
adhar number(20),
pan varchar2(10),
address varchar2(30));

INSERT INTO bank_details VALUES (12345678901234567890, 'Amit Patel', 9876543210, 123456789012, 'ABCDE1234F', '123 Main Street, City');
INSERT INTO bank_details VALUES (23456789012345678901, 'Priya Sharma', 8765432109, 234567890123, 'FGHIJ5678K', '456 Oak Avenue, Town');


select * from bank_details;

update bank_details
set account_no=5678
where full_name='Prnali';

------------------------

CREATE OR REPLACE PROCEDURE proc_bank(
    p_account_no NUMBER,
    p_new_data VARCHAR2,
    p_activity VARCHAR2
) AS
    v_length VARCHAR2(100);
    v_count NUMBER;
    p_message VARCHAR2(100);
BEGIN
    -- Check if the account exists
    SELECT COUNT(1) INTO v_count FROM bank_details WHERE account_no = p_account_no;

    IF v_count <> 0 THEN
        IF p_activity = 'ADDRESS' THEN
            -- Check address length
            SELECT LENGTH(p_new_data) INTO v_length FROM DUAL;

            IF v_length <= 30 THEN
                -- Update address
                UPDATE bank_details SET address = p_new_data WHERE account_no = p_account_no;
                p_message := 'Your address updated successfully!';
                dbms_output.put_line(p_message);
            ELSE
                p_message := 'Address length should be 30 characters or less!';
                dbms_output.put_line(p_message);
            END IF;
        ELSIF p_activity = 'MOBILE' THEN
            -- Check mobile number length
            SELECT LENGTH(p_new_data) INTO v_length FROM DUAL;

            IF v_length <= 10 THEN
                -- Update mobile number
                UPDATE bank_details SET mobile = p_new_data WHERE account_no = p_account_no;
                p_message := 'Your mobile number updated successfully!';
                dbms_output.put_line(p_message);
            ELSE
                p_message := 'Enter a 10-digit mobile number.';
                dbms_output.put_line(p_message);
            END IF;
        
         ELSIF p_activity = 'ADHAR' THEN
            SELECT LENGTH(p_new_data) INTO v_length FROM DUAL;

            IF v_length = 12 THEN
                -- Update Adhar
                UPDATE bank_details 
                SET adhar = p_new_data 
                WHERE account_no = p_account_no;
                p_message := 'Your Adhar updated successfully!';
                dbms_output.put_line(p_message);
            ELSE
                p_message := 'Enter a 12-digit Adhar number.';
                dbms_output.put_line(p_message);
            END IF;
            
           ELSIF p_activity = 'PAN' THEN
            SELECT LENGTH(p_new_data) INTO v_length FROM DUAL;

            IF v_length = 10 THEN
                -- Update Pan
                UPDATE bank_details 
                SET pan = p_new_data 
                WHERE account_no = p_account_no;
                p_message := 'Your PAN updated successfully!';
                dbms_output.put_line(p_message);
            ELSE
                p_message := 'Enter a 10-digit PAN number.';
                dbms_output.put_line(p_message);
            END IF;
        ELSE
            p_message := 'Invalid activity specified!';
             dbms_output.put_line(p_message);
        END IF;
    ELSE
        p_message := 'Account number is invalid. Please try with a valid account number!';
        dbms_output.put_line(p_message);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_message := 'Due to some technical issue, the update was not successful. Please contact the IT department!';
         dbms_output.put_line(p_message);
END;
/

--------------------
set serveroutput on;

exec proc_bank(12345678901234567890,'123455885588','ADHAR');

select * from bank_details;




















