create or replace view v_alarm_for_equippannel_port as
select belongtransys,belongequip,belongframe,belongslot,belongpack,belongport,alarmport,min(alarmlevel) alarmlevel,count(*) alarmcount from
(
select alarmnumber,
       w.belongtransys,
       w.belongequip,
       w.belongframe,
       w.belongslot,
       w.belongpack,
       w.belongport,
       w.belongequip || '=' || w.belongframe || '=' || w.belongslot || '=' || w.belongpack || '=' || w.belongport alarmport,
       decode(w.alarmlevel,
              'critical',
              1,
              'major',
              2,
              'minor',
              3,
              'warning',
              4,
              4) alarmlevel
  from alarminfo w
 where w.iscleared = 0
   and  w.belongequip not like '%NotExist%' and w.belongpack is not null and belongport is not null
   ) m group by belongtransys,belongequip,belongframe,belongslot,belongpack,belongport,alarmport
   order by  belongtransys,belongequip,belongframe,belongslot,belongpack,belongport;