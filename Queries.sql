--creating the table
CREATE TABLE professional (
	professional_id serial primary key,
    first_name VARCHAR(50) ,
    last_name VARCHAR(50) ,
    sex CHAR(1) CHECK (sex IN ('F', 'M')) ,
    doj DATE ,
    currentDate DATE ,
    designation VARCHAR(100) ,
    age INTEGER ,
    salary FLOAT,
    unit VARCHAR(100) ,
    leaves_used INTEGER ,
    leaves_remaining INTEGER ,
    ratings FLOAT ,
    past_exp FLOAT 
);

--copy csv
\copy "Assignment04".professional(first_name, last_name, sex, doj, currentdate, designation, age, salary, unit, leaves_used, leaves_remaining, ratings, past_exp) from 'C:\Users\rasik\Downloads\archive\data.csv' DELIMITER ',' CSV HEADER;


--Q.1

with 
	analyst_salary as (
	select * from professional where designation = 'Analyst'
	
)
select 
	unit , round( avg(salary)) 
from 
	analyst_salary 
group by 
	unit;


--Q.2
with 
	professional_leaves as (
		select * from professional where leaves_used > 10
	)
select first_name, last_name, leaves_used from professional_leaves;



--Views
--Q.3
create view Senior_analyst as 
	select * from professional where designation = 'Senior Analyst';


SELECT *
FROM "Assignment04".senior_analyst;


--Q.4
create materialized view department_count as
	select unit, count(unit) from professional p group by unit ;

SELECT unit, count
FROM "Assignment04".department_count;


--Procedure
--Q.6
CREATE OR REPLACE PROCEDURE update_professional_salary(
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_new_salary DECIMAL(10, 2)
)
LANGUAGE SQL
AS $$
UPDATE professional 
SET salary = p_new_salary
WHERE professional_id = (
	select professional_id 
	from professional 
		where first_name = p_first_name 4
		and last_name = p_last_name 
			limit 1);
$$;

call update_professional_salary('OLIVE', 'ANCY', 80000);


select professional_id ,first_name, last_name, salary from professional p order by professional_id ;


--Q.7
CREATE OR REPLACE PROCEDURE total_leaves_departments()
LANGUAGE SQL
AS $$
	create or replace view  total_leaves as select sum(leaves_used) as total_leaves from professional;
$$;

call total_leaves_departments ();

select * from "Assignment04".total_leaves;







