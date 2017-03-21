
--在XTBM表中插入   告警起因、处理方式的数据
prompt PL/SQL Developer import file
prompt Created on 2011年7月8日 by cl
set feedback off
set define off
prompt Loading XTBM...
delete from xtbm x where x.xtbm like 'RA01__';
delete from xtbm x where x.xtbm like 'RA02__';
delete from xtbm x where x.xtbm in('RA01','RA02');
commit;
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA02', '处理方式', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0201', '转故障流程处理', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0202', '因检修等工作导致转跟踪', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0203', '转普通告警', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0204', '转伴随告警', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0211', '告警已清除，原因不明', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA01', '告警起因', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0101', '通信检修', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0102', '用户设备检修', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0103', '通信故障', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0104', '业务开通', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0105', '故障抢修', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0106', '闪断', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0107', '误告警', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0108', '原因不明或其它', null, null, null, null, null, null);
commit;
prompt 13 records loaded
set feedback on
set define on
prompt Done.


--主题界面初始化数据
prompt PL/SQL Developer import file
prompt Created on 2011年7月20日 by jlhan
set feedback off
set define off
delete from MNT_SUBJECT;
commit;
prompt Loading MNT_SUBJECT...
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('1', '重点业务监视', '重点业务监视', null, 'com.metarnet.mnt.subject.main.views.KeyBitMonitor', '1', '1', 0, 0, .32227, .41547, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('2', '网络状态监视', '网络状态监视', null, 'com.metarnet.mnt.subject.main.views.NetStateMonitor', '1', '2', .32227, 0, .36133, .41547, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('3', '根告警集中监视', '根告警集中监视', null, 'com.metarnet.mnt.subject.main.views.RootAlarmMonitor1', '1', '3', 0, .41547, .32227, .35817, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('4', '根告警处理跟踪监视', '根告警处理跟踪监视', null, 'com.metarnet.mnt.subject.main.views.RootAlarmProMonitor', '1', '4', .32227, .41547, .36133, .35817, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('5', '频闪告警监视', '频闪告警监视', null, 'com.metarnet.mnt.subject.main.views.FlashAlarmMonitor', '1', '5', .68164, -.00143, .31445, .41547, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('6', '根告警流向处理', '根告警流向处理', null, 'com.metarnet.mnt.subject.main.views.RootAlarmFlow', '1', '6', .68359, .41547, .3125, .35817, null, 'N');
commit;
prompt 6 records loaded
prompt Enabling triggers for MNT_SUBJECT...
alter table MNT_SUBJECT enable all triggers;
set feedback on
set define on
prompt Done.

prompt PL/SQL Developer import file
prompt Created on 2011年7月27日 by qiaofeng
set feedback off
set define off
prompt Disabling triggers for V_MNT_DEALALARMMETHOD_TMP...
prompt Deleting V_MNT_DEALALARMMETHOD_TMP...
delete from V_MNT_DEALALARMMETHOD_TMP;
commit;
prompt Loading V_MNT_DEALALARMMETHOD_TMP...
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('黄昱', 10, 8, 8, 10);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('张思拓', 11, 9, 8, 15);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('范俊成', 24, 13, 12, 12);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('吴柳', 13, 10, 10, 8);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('陈旋', 5, 5, 4, 3);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('总数', 63, 45, 42, 48);
commit;
prompt 6 records loaded
prompt Enabling triggers for V_MNT_DEALALARMMETHOD_TMP...
alter table V_MNT_DEALALARMMETHOD_TMP enable all triggers;
set feedback on
set define on
prompt Done.