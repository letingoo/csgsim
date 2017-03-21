create or replace view v_alarminfo$oc as
Select a.starttime alarmtime,--����һ�θ澯ʱ��
firststarttime,firststarttime starttime,--�״θ澯����ʱ��
a.belongtransys
,s.stationname,--��վ����
a.belongstation,
--e.nename,
--e.s_sbmc as EQUIPLABEL,
a.ackperson,a.acktime,a.agentname,a.probablecause,
ad.n_alarmdesc as alarmdesc,
ad.n_alarmlevel as alarmlevel,
decode(ad.n_alarmlevel,
              'critical',
              '�����澯',
              'major',
              '��Ҫ�澯',
              'minor',
              '��Ҫ�澯',
              'warning',
              '��ʾ�澯',
              'other',
              '�����澯'
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
--e.Name_Std|| decode(a.belongslot, null,'',','||a.belongslot||'��'||decode(a.belongport,null,'',a.belongport||'�˿�'))
a.observedvalue as alarmobjdesc,
a.belongtsstm16 as carrycircuit,
a.belongtsstm4 as carryid,
a.belongtsvc3 as belongportcode,
a.specialty,
a.ackcontent,
a.dealperson,--��ֵֵ��Ա
a.dealpart,
e.run_unit,--��վ��ά����λ
a.dealresult,
decode(a.isworkcase,null,'δ����',a.isworkcase) isworkcase,
decode(a.bugno,null,'��',a.bugno) as isbugno,
/*decode(a.dutyid,null,'','��תȱ����־') as dutyid*/
decode(a.dutyid,null,decode(a.bugno,null,'','��תȱ����־'),'��תȱ����־') as dutyid,
--decode(exp.alarmnumber,null,'��','��') isdeal,
'��' isdeal,
ead.x_level area,
a.Isfilter,
ad.iscansend,--�Ƿ���澯����
a.firstarrivetime
From alarmInfo a,Station s,equipment e,
--v_alarmdealexpnew_alm exp,
alarmdefine ad,
en_adapter_domain ead
Where a.probablecause=ad.id
  and a.belongequip=e.equipcode(+)
  and a.belongstation=s.stationcode(+)
  -- and a.specialty in ('XT3201','XT3202','XT3204','XT3203','XT3207','XT3214')   --��ʱΪ�˲�������רҵ�ĸ澯ֱ����ʾ������������ԡ�
  and a.agentname=ead.label(+)
   --and a.alarmnumber=exp.alarmnumber(+);

