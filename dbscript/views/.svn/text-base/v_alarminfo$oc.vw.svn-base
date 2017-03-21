create or replace view v_alarminfo$oc as
Select a.starttime alarmtime,--最新一次告警时间
firststarttime,firststarttime starttime,--首次告警发生时间
a.belongtransys
,s.stationname,--局站名称
a.belongstation,
--e.nename,
--e.s_sbmc as EQUIPLABEL,
a.ackperson,a.acktime,a.agentname,a.probablecause,
ad.n_alarmdesc as alarmdesc,
ad.n_alarmlevel as alarmlevel,
decode(ad.n_alarmlevel,
              'critical',
              '紧急告警',
              'major',
              '主要告警',
              'minor',
              '次要告警',
              'warning',
              '提示告警',
              'other',
              '其他告警'
              ) alarmlevelname,
a.alarmnumber,a.alarmobject,a.alarmtext,a.alarmtype,a.belongequip,
a.belongframe,a.belonghouse,a.belongpack,a.belongport,a.belongslot,
a.clearperson,a.endtime,
decode(a.acktime,null,0,1) isacked,
a.isacked as flashcount,
a.iscleared,
a.iscleared iscleareds,
--sign(a.iscleared) as iscleared,
a.objclass,a.objectcode,a.observedvalue,
a.triggeredthreshold,a.vendor,
a.belongsubshelf,
a.remark,
--e.Name_Std|| decode(a.belongslot, null,'',','||a.belongslot||'盘'||decode(a.belongport,null,'',a.belongport||'端口'))
a.observedvalue as alarmobjdesc,
a.belongtsstm16 as carrycircuit,
a.belongtsstm4 as carryid,
a.belongtsvc3 as belongportcode,
a.specialty,
a.ackcontent,
a.dealperson,--当值值班员
a.dealpart,
e.run_unit,--局站的维护单位
a.dealresult,
decode(a.isworkcase,null,'未分析',a.isworkcase) isworkcase,
decode(a.bugno,null,'无',a.bugno) as isbugno,
/*decode(a.dutyid,null,'','已转缺陷日志') as dutyid*/
decode(a.dutyid,null,decode(a.bugno,null,'','已转缺陷日志'),'已转缺陷日志') as dutyid,
--decode(exp.alarmnumber,null,'无','有') isdeal,
'无' isdeal,
ead.x_level area,
a.Isfilter,
ad.iscansend,--是否根告警描述
a.firstarrivetime
From alarmInfo a,Station s,equipment e,
--v_alarmdealexpnew_alm exp,
alarmdefine ad,
en_adapter_domain ead
Where a.probablecause=ad.id
  and a.belongequip=e.equipcode(+)
  and a.belongstation=s.stationcode(+)
  -- and a.specialty in ('XT3201','XT3202','XT3204','XT3203','XT3207','XT3214')   --临时为了不让其他专业的告警直接显示出来，方便调试。
  and a.agentname=ead.label(+)
   --and a.alarmnumber=exp.alarmnumber(+);

