create table regions (
   region_id   number primary key,
   region_name varchar2(50)
);

create table countries (
   country_id   number primary key,
   country_name varchar2(50)
);

create table locations (
   location_id    number primary key,
   street_address varchar2(50),
   postal_code    varchar2(6),
   city           varchar2(50),
   state_province varchar2(50)
);

create table jobs (
   job_id     number primary key,
   job_title  varchar2(50),
   min_salary number,
   max_salary number,
   check ( min_salary < max_salary )
);

create table departments (
   department_id   number primary key,
   department_name varchar2(50)
);

create table employees (
   employee_id    number primary key,
   first_name     varchar2(50),
   last_name      varchar2(50),
   email          varchar2(50),
   phone_number   varchar2(20),
   hire_date      date,
   salary         number(10,2),
   commission_pct number(2,2)
);

create table job_history (
   employee_id number,
   start_date  date,
   end_date    date,
   primary key ( employee_id,
                 start_date )
);

alter table countries add region_id number;
alter table locations add country_id number;
alter table departments add manager_id number;
alter table departments add location_id number;
alter table employees add job_id number;
alter table employees add manager_id number;
alter table employees add department_id number;
alter table job_history add job_id number;
alter table job_history add department_id number;

alter table countries
   add foreign key ( region_id )
      references regions ( region_id );

alter table locations
   add foreign key ( country_id )
      references countries ( country_id );

alter table departments
   add foreign key ( location_id )
      references locations ( location_id );

alter table departments
   add foreign key ( manager_id )
      references employees ( employee_id );

alter table employees
   add foreign key ( job_id )
      references jobs ( job_id );

alter table employees
   add foreign key ( manager_id )
      references employees ( employee_id );

alter table employees
   add foreign key ( department_id )
      references departments ( department_id );

alter table job_history
   add foreign key ( employee_id )
      references employees ( employee_id );

alter table job_history
   add foreign key ( job_id )
      references jobs ( job_id );

alter table job_history
   add foreign key ( department_id )
      references departments ( department_id );

insert into jobs (
   job_id,
   job_title,
   min_salary,
   max_salary
) values
   ( 1,
     'Dyrektor',
     20000,
     40000 );

insert into jobs (
   job_id,
   job_title,
   min_salary,
   max_salary
) values
   ( 2,
     'Programista',
     4000,
     10000 );

insert into jobs (
   job_id,
   job_title,
   min_salary,
   max_salary
) values
   ( 3,
     'Obsługa działu klienta',
     6000,
     12000 );

insert into jobs (
   job_id,
   job_title,
   min_salary,
   max_salary
) values
   ( 4,
     'HR',
     4000,
     9000 );

insert into employees (
   employee_id,
   first_name,
   last_name,
   email,
   phone_number,
   hire_date,
   salary,
   commission_pct,
   job_id,
   manager_id
) values
   ( 1,
     'Jan',
     'Kowalski',
     'j.kowalski@firma.pl',
     '123123123',
     date '2019-05-15',
     30000,
     null,
     1,
     null );

insert into employees (
   employee_id,
   first_name,
   last_name,
   email,
   phone_number,
   hire_date,
   salary,
   commission_pct,
   job_id,
   manager_id
) values
   ( 2,
     'Anna',
     'Nowak',
     'a.nowak@firma.pl',
     '123123123',
     date '2021-03-10',
     8000,
     null,
     2,
     null );

insert into employees (
   employee_id,
   first_name,
   last_name,
   email,
   phone_number,
   hire_date,
   salary,
   commission_pct,
   job_id,
   manager_id
) values
   ( 3,
     'Piotr',
     'Wisniewski',
     'p.wisnieski@firma.pl',
     '123123123',
     date '2022-06-01',
     9000,
     0.10,
     3,
     null );

insert into employees (
   employee_id,
   first_name,
   last_name,
   email,
   phone_number,
   hire_date,
   salary,
   commission_pct,
   job_id,
   manager_id
) values
   ( 4,
     'Ewa',
     'Zielinska',
     'e.zielinska@firma.pl',
     '123123123',
     date '2023-09-20',
     6000,
     null,
     4,
     null );

update employees
   set
   manager_id = 1
 where employee_id in ( 2,
                        3 );

update jobs
   set min_salary = min_salary + 500,
       max_salary = max_salary + 500
 where lower(job_title) like '%b%'
    or lower(job_title) like '%s%';

delete from jobs
 where max_salary > 9000;

commit;

drop table job_history;

select object_name,
       original_name,
       type,
       droptime
  from recyclebin;

flashback table job_history to before drop;