CREATE OR REPLACE VIEW V_ROOTALARM_SELECT AS
Select
a.alarmnumber,
ad.n_alarmlevel as alarmlevel,                                                                                      --告警级别
decode(ad.n_alarmlevel,
              'critical',
              '紧急告警',
              'major',
              '主要告警',
              '次要告警'
              ) alarmlevelname,                                                                                     --告警级别中文描述
--to_char(a.starttime,'yyyy-mm-dd hh24:mi:ss')
a.starttime laststarttime,                                                                                          --最新一次告警时间
--to_char(a.firststarttime,'yyyy-mm-dd hh24:mi:ss')
 a.firststarttime,                                                                                                     --首次告警发生时间
ad.n_alarmdesc ||decode(a.agentname,'syslog','(SYSLOG)','cisco_nw_snmp_dcn','(SNMP)','') as alarmdesc,              --告警描述
a.alarmtext,                                                                                                        --告警内容
a.observedvalue as alarmobjdesc,                                                                                    --告警对象
a.objectcode,                                                                                                       --告警对象编码
a.belongtsstm16 as carrycircuit,                                                                                    --承载业务
a.belongtsstm4 as carryid,                                                                                          --业务对象
decode(objclass,'managedElement','设备','circuitPack','机盘','port','端口','timeSlot','时隙','其它') as objclasszh, --告警类型
a.objclass,                                                                                                         --告警类型
a.belongtransys,                                                                                                    --所属系统

xvendor.xtxx vendorzh,                                                                                              --所属厂家
a.belongsubshelf isrootalarm,                                                                                       --当前告警是否根告警
decode(a.belongsubshelf,'1','根告警','非根告警') isrootalarmzh,
decode(a.acktime,null,0,1) isacked,                                                                                 --是否确认
decode(a.acktime,null,'未确认','已确认') isackedzh,                                                                 --是否确认
a.ackperson,                                                                                                        --确认人
--to_char(a.acktime,'yyyy-mm-dd hh24:mi:ss')
a.acktime,                                                                                                          --确认时间
a.ackcontent,                                                                                                       --确认内容
a.dealperson,                                                                                                       --当值值班员
a.dealpart,                                                                                                         --处理部门
a.dealresult,                                                                                                       --处理方式
e.run_unit,                                                                                                         --维护单位
a.iscleared,                                                                                                        --是否清除
a.clearperson,                                                                                                      --清除人
--to_char(a.endtime,'yyyy-mm-dd hh24:mi:ss')
a.endtime,                                                                                                          --清除时间
a.specialty,                                                                                                        --专业
spe.xtxx specialtyzh,                                                                                               --专业中文描述
a.isacked as flashcount,                                                                                            --频闪次数
a.triggeredthreshold,                                                                                               --是否频闪监控
decode(a.isworkcase,null,'未分析',a.isworkcase) isworkcase,                                                         --告警原因
decode(a.bugno,null,'无',a.bugno) as isbugno,                                                                       --是否转故障单
bugno,                                                                                                              --故障单号
dutyid,                                                                                                             --是否转缺陷单
a.Isfilter,                                                                                                         --是否过滤
a.vendor,
s.stationname,                                                                                                      --局站名称
a.belongequip,
decode(a.belongpack,null,null,a.belongequip || '=' || a.belongframe || '=' || a.belongslot || '=' || a.belongpack ) belongpackobject,
decode(a.belongport,null,null,a.belongequip || '=' || a.belongframe || '=' || a.belongslot || '=' || a.belongpack || '=' || a.belongport ) belongportobject,
a.belongtsvc3 as belongportcode,

ad.iscansend,                                                                                                       --是否根告警描述

a.alarmobject,
a.alarmtype,
a.belongstation,      --局站编码
a.agentname,          --适配
a.probablecause,      --可能告警原因

a.belongframe,
a.belonghouse,
a.belongpack,
a.belongport,
a.belongslot,
a.iscleared iscleareds,
a.remark,
ead.x_level area,
a.firstarrivetime
From alarmInfo a,Station s,equipment e,
alarmdefine ad,
en_adapter_domain ead,
xtbm xvendor,
xtbm spe
where a.probablecause=ad.id
  and a.vendor=xvendor.xtbm
  and a.specialty=spe.xtbm
  and a.belongequip=e.equipcode(+)
  and a.belongstation=s.stationcode(+)
  and a.agentname=ead.label(+)
  and a.belongsubshelf='1'
  --and a.iscleared=0
  order by  starttime desc;

