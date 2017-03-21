create or replace view v_alarmrelatecircuit_affect as
select distinct circuitcode,
                username,
                operationtype circuittype,
                USETIME,
                r.xtxx RATE,
                getPortLabelWithoutEquip(portserialno1) portserialno1,
                getPortLabelWithoutEquip(portserialno2) portserialno2,
                e.alm_number alarmnumber,
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
                decode(a.acktime, null, '未确认', '已确认') isackedzh
  from circuit v, alarminfo a, alarmdefine d, alarm_affection e, xtbm r
 where v.rate = r.xtbm(+)
   and v.CIRCUITCODE = a.belongtsstm4
   and a.probablecause = d.id
   and a.alarmnumber = e.alm_company;

