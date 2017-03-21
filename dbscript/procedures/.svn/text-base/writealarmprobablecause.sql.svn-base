-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:54:48 --
-----------------------------------------------

spool WRITEALARMPROBABLECAUSE.log

prompt
prompt Creating procedure WRITEALARMPROBABLECAUSE
prompt ==========================================
prompt
create or replace procedure writeAlarmProbablecause is

  type v_rs is ref cursor;

  rs v_rs;

  V_SPECIALTY       VARCHAR2(10):='XT3201'; --专业

  STRVENDOR       EQUIPMENT.X_VENDOR%TYPE;

  V_ALARMDESC    VARCHAR2(300);

  V_ALARMLEVEL  VARCHAR2(30);

  V_ISTOPOPORTALARM NUMBER(1):=0;--是否光路端口告警

  V_ISROOT_ALARMDESC NUMBER(1);

  IISFILTER         ALARMINFO.ISFILTER%TYPE;

  STRALARMDEFID ALARMDEFINE.ID%TYPE:=0;

  v_alarmnumber varchar2(20);

  v_circuit varchar2(100);



begin

       open rs for select a.alarmnumber,a.vendor,a.alarmdesc,a.alarmlevel,a.belongtsstm16 from alarminfo a ;

       fetch rs into  v_alarmnumber,STRVENDOR,V_ALARMDESC,V_ALARMLEVEL,v_circuit;

       loop

          if v_circuit is null then

             V_ISTOPOPORTALARM:=0;

          else

             if instr(v_circuit,'#',1)>0 then

                V_ISTOPOPORTALARM:=1;

             else

                V_ISTOPOPORTALARM:=0;

             end if;

          end if;

          ALARMDEFINESETTINGV2(V_SPECIALTY,
                             STRVENDOR,
                             V_ALARMDESC,
                             V_ALARMLEVEL,
                             V_ISTOPOPORTALARM,
                             V_ISROOT_ALARMDESC,
                             IISFILTER,
                             STRALARMDEFID);
          update alarminfo o set o.probablecause=STRALARMDEFID,o.isfilter=IISFILTER where o.alarmnumber=v_alarmnumber;

          commit;


          fetch rs into v_alarmnumber,STRVENDOR,V_ALARMDESC,V_ALARMLEVEL,v_circuit;

           exit when rs%notfound;

        end loop;

        close rs;

end writeAlarmProbablecause;
/


spool off
