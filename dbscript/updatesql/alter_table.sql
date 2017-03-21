
--在表alarminfo中添加告警经验处理ID。
  
alter table ALARMINFO add EXPID number(38);
comment on column ALARMINFO.EXPID
  is '告警经验处理方式ID';

--修改表alarminfo的ackcontent(根告警的内容)的长度，
ALTER TABLE ALARMINFO  MODIFY ACKCONTENT varchar2(800);

alter table ALARMINFO add PRISTINEROOTALARM varchar2(1) default '0';
comment on column ALARMINFO.PRISTINEROOTALARM
  is '根告警原始标记；在处理根告警是，不对此字段做更新操作，只用来统计只用';

alter table ALARMINFO add ATTENTIONINFO varchar2(50);
comment on column ALARMINFO.ATTENTIONINFO
  is '频闪告警关注状态';


