create or replace view v_alarmrelatecircuit as
select distinct circuitcode,
                username,
                operationtype circuittype,
                 to_char(usetime,'yyyy-mm-dd') USETIME,
                r.xtxx RATE,
                getportlabelbycode(portserialno1) portserialno1,
                getportlabelbycode(portserialno2) portserialno2,
                getPortStructInfo(portserialno1) portcode1,
                getPortStructInfo(portserialno2) portcode2,
                '告警详细信息'  alarmdetail,
                a.alarmnumber,  --伴随告警
                e.alm_number,   --主要告警
                d.n_alarmlevel as alarmlevel, --告警级别
                decode(d.n_alarmlevel,
                       'critical',
                       '紧急告警',
                       'major',
                       '主要告警',
                       'minor',
                       '次要告警',
                       '提示告警') alarmlevelname,
                nvl(a.belongsubshelf, '0') isrootalarm, --当前告警是否根告警
                decode(a.belongsubshelf, '1', '根告警', '非根告警') isrootalarmzh,
                decode(a.acktime, null, 0, 1) isacked, --是否确认
                decode(a.acktime, null, '未确认', '已确认') isackedzh,
                a.iscleared,
       case when to_number(nvl(station1,0)) > to_number(nvl(station2,0)) then station1
       else station2
       end station1,
       case when to_number(nvl(station1,0)) > to_number(nvl(station2,0)) then station2
       else station1
       end station2,
       v.powerline,
       a.belongtsvc3 portcode
  from circuit v, alarminfo a, alarmdefine d, alarm_affection e, xtbm r
 where v.rate = r.xtbm(+)
   and v.CIRCUITCODE = a.belongtsstm4
   and a.probablecause = d.id
   and d.iscansend = 1
   and a.alarmnumber = e.alm_company;
