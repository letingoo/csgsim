create or replace view v_mnt_transys_currentstatus as
select distinct b.systemcode,
                decode(a.belongstatus, 1, 1, 2, 2, b.belongstatus) sysstatus,
                nvl(a.rootalarm, 0) rootalarm
  from (select t.belongtransys,
               decode(t.ackingcount, 0, 2, 1) belongstatus,
               rootalarm
          from v_mnt_transys_rootalarm_total t) a,
       (select systemcode, 3 belongstatus from transsystem) b
 where b.systemcode = a.belongtransys(+)
 --added by slzh at 20110727  统计系统状态，系统当前的状态信息（1，有未确认根告警；2 存在已确认根告警；3 系统正常）;
 