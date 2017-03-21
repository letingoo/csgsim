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
       v_isTopoPort in VARCHAR2,--是否光路端口上的告警，如果是的话要做一些额外处理。
       v_isRootAlarm out NUMBER,--是否根告警判断依据
       v_isFilter out number,--是否过滤
       v_alarmDefId out number) is
theIsFilter number(1);--是否过滤，由于alarminfo表中没有对应字段，暂时用alarmtype按一定规则设置。
theTopoAlarm number(1);
myAlarmDesc varchar2(60);

V_ERRINFO varchar2(200);
begin
       v_alarmDefId:=0;
       v_isFilter:=0;
       v_isRootAlarm:=0;
       if v_alarmDesc is null then--告警描述为空的异常情况的处理
          return;
       end if;

         --CATALOG，VENDOR，O_ALARMDESC这三个字段保证唯一，
           --这样如果出错的话就说明记录不存在。
       myAlarmDesc:=v_alarmDesc;
       if v_isTopoPort=1 then
          select id,ISFILTER,topoalarm,iscansend into v_alarmDefId,theIsFilter,theTopoAlarm,v_isRootAlarm from alarmDefine
                 where NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL') and VENDOR=v_vendor and O_ALARMDESC=myAlarmDesc;
           if theTopoAlarm=1 then--要区分光路告警
              myAlarmDesc:='光路'||v_alarmDesc;
              select id,ISFILTER,iscansend into v_alarmDefId,theIsFilter,v_isRootAlarm from alarmDefine
                 where NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL') and VENDOR=v_vendor and O_ALARMDESC=myAlarmDesc;
           end if;
       else
          select id,ISFILTER,iscansend into v_alarmDefId,theIsFilter,v_isRootAlarm from alarmDefine
                where NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL') and VENDOR=v_vendor and O_ALARMDESC=myAlarmDesc;
       end if;

      if theIsFilter<>0 then
         --需要过滤
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
         (sysdate, 'AlarmdefineSettingV2', 'exception',V_ERRINFO);--日志
     end;



end ;

--add by tyh,20070528
--根据AlarmDefine表重定向告警属性，
--如果查询不到，则插入一条新记录。
--modify by tyh,2008-3-5
--NVL(CATALOG,'NULL')=NVL(v_sblx,'NULL')
--增加是否拆分成光路告警的功能：为了对付某些厂家Los告警不区分光路和支路
/


spool off
