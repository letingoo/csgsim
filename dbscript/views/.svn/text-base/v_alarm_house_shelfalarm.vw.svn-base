create or replace view v_alarm_house_shelfalarm as
select shelfcode,belonghouse,min(alarmlevelcnt) alarmlevel,count(*) alarmcount from (
select f.shelfcode,a.belonghouse,a.belongequip,decode(a.alarmlevel,
              'critical',
              1,
              'major',
              2,
              'minor',
              3,
              'warning',
              4,
              4) alarmlevelcnt from en_equipshelf f,equipframe r,alarminfo a
where f.shelfcode = r.equipshelfcode and r.equipcode= a.belongequip and a.iscleared='0'
) m group by shelfcode,belonghouse;

