create or replace view v_mnt_circuit_mid as
select case
         when to_number(nvl(station1, 0)) > to_number(nvl(station2, 0)) then
          station1
         else
          station2
       end station1,
       case
         when to_number(nvl(station1, 0)) > to_number(nvl(station2, 0)) then
          station2
         else
          station1
       end station2,
       username,
       operationtype,
       circuitcode,
       ismonitored,
       powerline
  from (select e1.stationcode station1,
               e2.stationcode station2,
               username,
               c.operationtype,
               circuitcode,
               ismonitored,
               c.powerline
          from circuit        c,
               equiplogicport t1,
               equipment      e1,
               equiplogicport t2,
               equipment      e2
         where c.portserialno1 = t1.logicport
           and t1.equipcode = e1.equipcode
           and c.portserialno2 = t2.logicport
           and t2.equipcode = e2.equipcode
           and c.station1 <> '–È’æµ„'
           and c.station2 <> '–È’æµ„'
           and c.station1 is not null
           and c.station2 is not null) a;
