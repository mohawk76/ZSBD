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

select e.last_name
       || ' '
       || e.salary as wynagrodzenie
  from employees e
 where e.department_id in ( 20,
                            50 )
   and e.salary between 2000 and 7000
 order by e.last_name;

select e.hire_date,
       e.last_name,
       &&kolumna
  from employees e
 where e.manager_id is not null
   and extract(year from e.hire_date) = 2005
 order by &kolumna;

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