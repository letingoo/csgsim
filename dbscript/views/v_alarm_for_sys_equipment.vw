create or replace view v_alarm_for_sys_equipment as
select belongtransys,belongequip,min(alarmlevel) alarmlevel,count(*) alarmcount
from
(
select alarmnumber,
       w.belongtransys,
       w.belongequip,
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
   and w.belongequip is not null and belongtransys is not null and w.belongequip not like '%NotExist%'
) group by belongtransys,belongequip order by belongtransys;