create or replace view v_mnt_transys_rootalarm_total as
select a.belongtransys,
       nvl(b.alarmcount, 0) ackingcount,
       nvl(c.alarmcount, 0) ackedcount,
       nvl(b.alarmcount, 0) + nvl(c.alarmcount, 0) as rootalarm
  from (select distinct belongtransys from v_mnt_transys_rootalarm_mid) a,
       (select belongtransys, alarmcount
          from v_mnt_transys_rootalarm_mid
         where ackstatus = 0) b,
       (select belongtransys, alarmcount
          from v_mnt_transys_rootalarm_mid
         where ackstatus = 1) c
 where a.belongtransys = b.belongtransys(+)
   and a.belongtransys = c.belongtransys(+)
--added by slzh at 2011-07-08  根告警统计列表 for 综合监视页面;

