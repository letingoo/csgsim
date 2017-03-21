create or replace view v_alarm_for_equippannel_pack as
select belongtransys,belongequip,belongframe,belongslot,belongpack,alarmpack,min(alarmlevel) alarmlevel,count(*) alarmcount from
(
select alarmnumber,
       w.belongtransys,
       w.belongequip,
       w.belongframe,
       w.belongslot,
       w.belongpack,
       w.belongequip || '=' || w.belongframe || '=' || w.belongslot || '=' || w.belongpack alarmpack,
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
   and  w.belongequip not like '%NotExist%' and w.belongpack is not null
   ) m group by belongtransys,belongequip,belongframe,belongslot,belongpack,alarmpack
   order by  belongtransys,belongequip,belongframe,belongslot,belongpack;