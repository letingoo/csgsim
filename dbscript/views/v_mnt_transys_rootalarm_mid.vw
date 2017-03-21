create or replace view v_mnt_transys_rootalarm_mid as
select a.belongtransys,
       decode(acktime, null, 0, 1) ackstatus,
       count(decode(acktime, null, 0, 1)) alarmcount
  from alarminfo a
 where a.belongsubshelf = 1
   and iscleared = 0
 group by belongtransys, decode(acktime, null, 0, 1)
 --系统根告警统计 by slzh at 2011-07-08;

