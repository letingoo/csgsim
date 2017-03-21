create or replace view v_mnt_powerline_breakcircuit as
select  (station1 || '-' || station2) powerlineid,station1,station2,t.powerline,count(circuitcode) breakcircuit
from (select distinct station1,station2,circuitcode,powerline from  v_alarmrelatecircuit c where c.iscleared=0) t
 where
     t.station1 is not null
 and t.station2 is not null
 group by station1,station2,powerline;