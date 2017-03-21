create or replace view v_mnt_alarm_sys_equipment as
select a."BELONGTRANSYS",a."BELONGEQUIP",a."ALARMLEVEL",a."ALARMCOUNT", nvl(b.cnt, 0) rootalarm
  from v_alarm_for_sys_equipment a, v_mnt_alarmforsysmap b
 where a.belongtransys = b.belongtransys(+)
   and a.belongequip = b.belongequip(+);