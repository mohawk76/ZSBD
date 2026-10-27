-- I
select 'DROP TABLE "'
       || table_name
       || '" CASCADE CONSTRAINTS;'
  from user_tables;

drop table "JOBS" cascade constraints;
drop table "EMPLOYEES" cascade constraints;
drop table "COUNTRIES" cascade constraints;
drop table "DEPARTMENTS" cascade constraints;
drop table "JOB_HISTORY" cascade constraints;
drop table "LOCATIONS" cascade constraints;
drop table "REGIONS" cascade constraints;

-- II
create table regions
   as
      select *
        from hr.regions;

create table countries
   as
      select *
        from hr.countries;

create table locations
   as
      select *
        from hr.locations;

create table departments
   as
      select *
        from hr.departments;

create table jobs
   as
      select *
        from hr.jobs;

create table employees
   as
      select *
        from hr.employees;

create table job_history
   as
      select *
        from hr.job_history;


alter table regions add constraint regions_pk primary key ( region_id );

alter table countries add constraint countries_pk primary key ( country_id );
alter table countries
   add constraint countries_region_fk foreign key ( region_id )
      references regions ( region_id );

alter table locations add constraint locations_pk primary key ( location_id );
alter table locations
   add constraint locations_country_fk foreign key ( country_id )
      references countries ( country_id );

alter table departments add constraint departments_pk primary key ( department_id );
alter table departments
   add constraint departments_location_fk foreign key ( location_id )
      references locations ( location_id );

alter table jobs add constraint jobs_pk primary key ( job_id );

alter table employees add constraint employees_pk primary key ( employee_id );
alter table employees
   add constraint employees_job_fk foreign key ( job_id )
      references jobs ( job_id );
alter table employees
   add constraint employees_department_fk foreign key ( department_id )
      references departments ( department_id );
alter table employees
   add constraint employees_manager_fk foreign key ( manager_id )
      references employees ( employee_id );

alter table departments
   add constraint departments_manager_fk foreign key ( manager_id )
      references employees ( employee_id );

alter table job_history add constraint job_history_pk primary key ( employee_id,
                                                                    start_date );
alter table job_history
   add constraint job_history_employee_fk foreign key ( employee_id )
      references employees ( employee_id );
alter table job_history
   add constraint job_history_job_fk foreign key ( job_id )
      references jobs ( job_id );
alter table job_history
   add constraint job_history_department_fk foreign key ( department_id )
      references departments ( department_id );

-- III.1
select e.last_name
       || ' '
       || e.salary as wynagrodzenie
  from employees e
 where e.department_id in ( 20,
                            50 )
   and e.salary between 2000 and 7000
 order by e.last_name;

-- III.2
select e.hire_date,
       e.last_name,
       &&kolumna
  from employees e
 where e.manager_id is not null
   and extract(year from e.hire_date) = 2005
 order by &kolumna;

-- III.3
select e.first_name
       || ' '
       || e.last_name as imie_nazwisko,
       e.salary,
       e.phone_number
  from employees e
 where substr(
      e.last_name,
      3,
      1
   ) = 'e'
   and lower(e.first_name) like '%'
                                || lower('&&czesc_imienia')
                                || '%'
 order by 1 desc,
          2 asc;
          
-- III.4
select e.first_name,
       e.last_name,
       round(months_between(
          sysdate,
          e.hire_date
       )) as liczba_miesiecy,
       case
          when months_between(
             sysdate,
             e.hire_date
          ) < 150 then
             e.salary * 0.1
          when months_between(
             sysdate,
             e.hire_date
          ) < 200 then
             e.salary * 0.2
          else
             e.salary * 0.3
       end as wysokosc_dodatku
  from employees e
 order by liczba_miesiecy;

-- III.5
select e.department_id,
       sum(e.salary) as suma_zarobkow,
       round(avg(e.salary)) as srednia_zarobkow
  from employees e
 group by e.department_id
having min(e.salary) > 5000;

-- III.6
select e.last_name,
       e.department_id,
       d.department_name,
       e.job_id
  from employees e
  join departments d
on e.department_id = d.department_id
  join locations l
on d.location_id = l.location_id
 where l.city = 'Toronto';

-- III.7
select e.first_name
       || ' '
       || e.last_name as pracownik,
       w.first_name
       || ' '
       || w.last_name as wspolpracownik
  from employees e
  join employees w
on e.department_id = w.department_id
   and e.employee_id <> w.employee_id
 where e.first_name = 'Jennifer'
 order by pracownik,
          wspolpracownik;

-- III.8
select d.department_id,
       d.department_name
  from departments d
 where not exists (
   select 1
     from employees e
    where e.department_id = d.department_id
);

-- III.9
create table job_grades (
   grade      varchar2(3) primary key,
   min_salary number,
   max_salary number
);

insert into job_grades values
   ( 'A',
     1000,
     2999 );
insert into job_grades values
   ( 'B',
     3000,
     5999 );
insert into job_grades values
   ( 'C',
     6000,
     9999 );
insert into job_grades values
   ( 'D',
     10000,
     14999 );
insert into job_grades values
   ( 'E',
     15000,
     24999 );
insert into job_grades values
   ( 'F',
     25000,
     40000 );

commit;

select e.first_name,
       e.last_name,
       e.job_id,
       d.department_name,
       e.salary,
       g.grade
  from employees e
  left join departments d
on e.department_id = d.department_id
  join job_grades g
on e.salary between g.min_salary and g.max_salary;

-- III.10
select e.first_name,
       e.last_name,
       e.salary
  from employees e
 where e.salary > (
   select avg(salary)
     from employees
)
 order by e.salary desc;

-- III.11
select e.employee_id,
       e.first_name,
       e.last_name
  from employees e
 where e.department_id in (
   select department_id
     from employees
    where lower(last_name) like '%u%'
);

-- III.12
select e.first_name,
       e.last_name,
       e.hire_date
  from employees e
 where months_between(
   sysdate,
   e.hire_date
) > (
   select avg(months_between(
      sysdate,
      hire_date
   ))
     from employees
);

-- III.13
select d.department_name,
       count(e.employee_id) as liczba_pracownikow,
       round(
          avg(e.salary),
          2
       ) as srednie_wynagrodzenie
  from departments d
  left join employees e
on d.department_id = e.department_id
 group by d.department_name
 order by liczba_pracownikow desc;

-- III.14
select e.first_name,
       e.last_name
  from employees e
 where e.salary < all (
   select e2.salary
     from employees e2
     join departments d
   on e2.department_id = d.department_id
    where d.department_name = 'IT'
);

-- III.15
select d.department_id,
       d.department_name
  from departments d
 where exists (
   select 1
     from employees e
    where e.department_id = d.department_id
      and e.salary > (
      select avg(salary)
        from employees
   )
);

-- III.16
select j.job_title,
       round(
          avg(e.salary),
          2
       ) as srednie_zarobki
  from jobs j
  join employees e
on j.job_id = e.job_id
 group by j.job_title
 order by srednie_zarobki desc
 fetch first 5 rows only;

-- III.17
select r.region_name,
       count(distinct c.country_id) as liczba_krajow,
       count(distinct e.employee_id) as liczba_pracownikow
  from regions r
  left join countries c
on r.region_id = c.region_id
  left join locations l
on c.country_id = l.country_id
  left join departments d
on l.location_id = d.location_id
  left join employees e
on d.department_id = e.department_id
 group by r.region_name;

-- III.18
select e.first_name,
       e.last_name,
       e.salary,
       m.salary as zarobki_menedzera
  from employees e
  join employees m
on e.manager_id = m.employee_id
 where e.salary > m.salary;

-- III.19
select extract(month from e.hire_date) as miesiac,
       count(*) as liczba_pracownikow
  from employees e
 group by extract(month from e.hire_date)
 order by miesiac;

-- III.20
select d.department_name,
       round(
          avg(e.salary),
          2
       ) as srednie_wynagrodzenie
  from departments d
  join employees e
on d.department_id = e.department_id
 group by d.department_name
 order by srednie_wynagrodzenie desc
 fetch first 3 rows only;