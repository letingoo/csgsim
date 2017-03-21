create or replace view v_mnt_powerline_alarmcount as
select (station1 || '-' || station2) powerlineid,
       station1,
       station2,
       count(alarmnumber) alarmcount
  from v_alarmrelatecircuit t
 where t.station1 is not null
   and t.station2 is not null
 group by t.station1,station2;