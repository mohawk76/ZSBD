create or replace view v_wysokie_pensje as
   select *
     from employees e
    where e.salary > 6000;

create or replace view v_wysokie_pensje as
   select *
     from employees e
    where e.salary > 12000;

drop view v_wysokie_pensje;

create or replace view cw3_2 as
   select *
     from employees e
    where e.salary > 6000;
