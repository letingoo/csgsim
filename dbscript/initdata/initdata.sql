
--��XTBM���в���   �澯���򡢴���ʽ������
prompt PL/SQL Developer import file
prompt Created on 2011��7��8�� by cl
set feedback off
set define off
prompt Loading XTBM...
delete from xtbm x where x.xtbm like 'RA01__';
delete from xtbm x where x.xtbm like 'RA02__';
delete from xtbm x where x.xtbm in('RA01','RA02');
commit;
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA02', '����ʽ', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0201', 'ת�������̴���', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0202', '����޵ȹ�������ת����', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0203', 'ת��ͨ�澯', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0204', 'ת����澯', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0211', '�澯�������ԭ����', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA01', '�澯����', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0101', 'ͨ�ż���', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0102', '�û��豸����', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0103', 'ͨ�Ź���', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0104', 'ҵ��ͨ', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0105', '��������', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0106', '����', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0107', '��澯', null, null, null, null, null, null);
insert into XTBM (XTBM, XTXX, TYPE, DESCRIPTION, REMARK, UPDATEPERSON, UPDATEDATE, ISMAINCODE)
values ('RA0108', 'ԭ����������', null, null, null, null, null, null);
commit;
prompt 13 records loaded
set feedback on
set define on
prompt Done.


--��������ʼ������
prompt PL/SQL Developer import file
prompt Created on 2011��7��20�� by jlhan
set feedback off
set define off
delete from MNT_SUBJECT;
commit;
prompt Loading MNT_SUBJECT...
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('1', '�ص�ҵ�����', '�ص�ҵ�����', null, 'com.metarnet.mnt.subject.main.views.KeyBitMonitor', '1', '1', 0, 0, .32227, .41547, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('2', '����״̬����', '����״̬����', null, 'com.metarnet.mnt.subject.main.views.NetStateMonitor', '1', '2', .32227, 0, .36133, .41547, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('3', '���澯���м���', '���澯���м���', null, 'com.metarnet.mnt.subject.main.views.RootAlarmMonitor1', '1', '3', 0, .41547, .32227, .35817, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('4', '���澯������ټ���', '���澯������ټ���', null, 'com.metarnet.mnt.subject.main.views.RootAlarmProMonitor', '1', '4', .32227, .41547, .36133, .35817, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('5', 'Ƶ���澯����', 'Ƶ���澯����', null, 'com.metarnet.mnt.subject.main.views.FlashAlarmMonitor', '1', '5', .68164, -.00143, .31445, .41547, null, 'N');
insert into MNT_SUBJECT (RSCODE, SUBTITILE, SUBNAME, SUBDESC, SUBCLASS, ISSELE, SORDER, SX, SY, SWIDTH, SHEIGHT, REMARK, ISDRAG)
values ('6', '���澯������', '���澯������', null, 'com.metarnet.mnt.subject.main.views.RootAlarmFlow', '1', '6', .68359, .41547, .3125, .35817, null, 'N');
commit;
prompt 6 records loaded
prompt Enabling triggers for MNT_SUBJECT...
alter table MNT_SUBJECT enable all triggers;
set feedback on
set define on
prompt Done.

prompt PL/SQL Developer import file
prompt Created on 2011��7��27�� by qiaofeng
set feedback off
set define off
prompt Disabling triggers for V_MNT_DEALALARMMETHOD_TMP...
prompt Deleting V_MNT_DEALALARMMETHOD_TMP...
delete from V_MNT_DEALALARMMETHOD_TMP;
commit;
prompt Loading V_MNT_DEALALARMMETHOD_TMP...
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('����', 10, 8, 8, 10);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('��˼��', 11, 9, 8, 15);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('������', 24, 13, 12, 12);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('����', 13, 10, 10, 8);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('����', 5, 5, 4, 3);
insert into V_MNT_DEALALARMMETHOD_TMP (DEALPERSON, ALARMTOTAL, ACKEDALARMCOUNT, ACKEDCONTENT, AVACKEDTIME)
values ('����', 63, 45, 42, 48);
commit;
prompt 6 records loaded
prompt Enabling triggers for V_MNT_DEALALARMMETHOD_TMP...
alter table V_MNT_DEALALARMMETHOD_TMP enable all triggers;
set feedback on
set define on
prompt Done.