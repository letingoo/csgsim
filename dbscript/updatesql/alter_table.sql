
--�ڱ�alarminfo����Ӹ澯���鴦��ID��
  
alter table ALARMINFO add EXPID number(38);
comment on column ALARMINFO.EXPID
  is '�澯���鴦��ʽID';

--�޸ı�alarminfo��ackcontent(���澯������)�ĳ��ȣ�
ALTER TABLE ALARMINFO  MODIFY ACKCONTENT varchar2(800);

alter table ALARMINFO add PRISTINEROOTALARM varchar2(1) default '0';
comment on column ALARMINFO.PRISTINEROOTALARM
  is '���澯ԭʼ��ǣ��ڴ�����澯�ǣ����Դ��ֶ������²�����ֻ����ͳ��ֻ��';

alter table ALARMINFO add ATTENTIONINFO varchar2(50);
comment on column ALARMINFO.ATTENTIONINFO
  is 'Ƶ���澯��ע״̬';


