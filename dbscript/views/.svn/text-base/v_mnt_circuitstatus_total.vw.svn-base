create or replace view v_mnt_circuitstatus_total as
select a.username,
       circuittotal,
       nvl(breakcount, 0) breakcount,
       nvl(c.ackingcount, 0) alarmcount,
       nvl(d.ackedcount, 0) ackedcount
  from (select username, count(*) circuittotal
          from circuit
         group by username) a,
       (select username,count(username) breakcount
       from (
            select distinct username,v.circuitcode from v_alarmrelatecircuit v where v.iscleared=0
                   ) group by username) b,
       (select username, count(username) ackingcount
          from (select distinct  username, alarmnumber
                  from v_alarmrelatecircuit where iscleared=0) k
         --where k.isackedzh = '未确认'
         --统计的根告警总数
         group by username) c,
       (select username, count(username) ackedcount
          from (select distinct username, alarmnumber
                  from v_alarmrelatecircuit where iscleared=0 and isackedzh = '未确认') k
         group by username) d
 where a.username = b.username(+)
   and a.username = c.username(+)
   and a.username = d.username(+)
   and a.username is not null
   and a.username in('保护','安稳','自动化','网络部');
--added by slzh  统计当前业务中断业务的状态 at 2011-07-12;