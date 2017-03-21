-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:20:02 --
-----------------------------------------------

spool ALARMDEFINESETTINGV2.log

prompt
prompt Creating procedure ALARMDEFINESETTINGV2
prompt =======================================
prompt
create or replace procedure AlarmdefineSettingV2(
       v_sblx in varchar2,
       v_vendor in varchar2,
       v_alarmDesc in  VARCHAR2,
       v_alarmLevel in VARCHAR2,
       v_isTopoPort in VARCHAR2,--�Ƿ��·�˿��ϵĸ澯������ǵĻ�Ҫ��һЩ���⴦��
       v_isRootAlarm out NUMBER,--�Ƿ���澯�ж�����
       v_isFilter out number,--�Ƿ����
       v_alarmDefId out number) is
theIsFilter number(1);--�Ƿ���ˣ�����alarminfo����û�ж�Ӧ�ֶΣ���ʱ��alarmtype��һ���������á�
theTopoAlarm number(1);
myAlarmDesc varchar2(60);

V_ERRINFO varchar2(200);
begin
       v_alarmDefId:=0;
       v_isFilter:=0;
       v_isRootAlarm:=0;
       if v_alarmDesc is null then--�澯����Ϊ�յ��쳣����Ĵ���
          return;
       end if;

         --CATALOG��VENDOR��O_ALARMDESC�������ֶα�֤Ψһ��
           --�����������Ļ���˵����¼�����ڡ�
       myAlarmDesc:=v_alarmDesc;
       if v_isTopoPort=1 then
          select id,ISFILTER,topoalarm,iscansend into v_alarmDefId,theIsFilter,theTopoAlarm,v_isRootAlarm from alarmDefine
                 where NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL') and VENDOR=v_vendor and O_ALARMDESC=myAlarmDesc;
           if theTopoAlarm=1 then--Ҫ���ֹ�·�澯
              myAlarmDesc:='��·'||v_alarmDesc;
              select id,ISFILTER,iscansend into v_alarmDefId,theIsFilter,v_isRootAlarm from alarmDefine
                 where NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL') and VENDOR=v_vendor and O_ALARMDESC=myAlarmDesc;
           end if;
       else
          select id,ISFILTER,iscansend into v_alarmDefId,theIsFilter,v_isRootAlarm from alarmDefine
                where NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL') and VENDOR=v_vendor and O_ALARMDESC=myAlarmDesc;
       end if;

      if theIsFilter<>0 then
         --��Ҫ����
         v_isFilter:=1;
      end if;
  exception when others then
     begin
         select seq_zyid.nextval into v_alarmDefId from dual;
         insert into  alarmdefine (ID,CATALOG,VENDOR,O_ALARMDESC,N_ALARMDESC,O_ALARMLEVEL,n_alarmlevel,UPDATEPERSON,UPDATEDATE)
           values(v_alarmDefId,v_sblx,v_vendor,myAlarmDesc,myAlarmDesc,v_alarmLevel,v_alarmLevel,'Auto',sysdate);
         commit;
     exception when others then
         V_ERRINFO := TO_CHAR(SQLCODE) || SQLERRM||v_sblx||v_vendor||v_alarmDefId||':'||myAlarmDesc;
         insert into dblog values
         (sysdate, 'AlarmdefineSettingV2', 'exception',V_ERRINFO);--��־
     end;



end ;

--add by tyh,20070528
--����AlarmDefine���ض���澯���ԣ�
--�����ѯ�����������һ���¼�¼��
--modify by tyh,2008-3-5
--NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL')
--�����Ƿ��ֳɹ�·�澯�Ĺ��ܣ�Ϊ�˶Ը�ĳЩ����Los�澯�����ֹ�·��֧·
/


spool off
