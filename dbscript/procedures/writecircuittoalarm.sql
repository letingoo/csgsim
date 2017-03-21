-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 10:25:32 --
-----------------------------------------------

spool WRITECIRCUITTOALARM.log

prompt
prompt Creating procedure WRITECIRCUITTOALARM
prompt ==========================================
prompt
create or replace procedure WRITECIRCUITTOALARM
is

  --输出参数
  STRPORTCODE      varchar2(20);
  STRCIRCUIT       varchar2(100);
  STRCARRYID       varchar2(100);
  V_ISROOT         varchar2(10);
  V_ISTOPOPORTALARM  varchar2(10);
  --输入参数
  STRSYSTEM varchar2(50);
  V_OBJCLASS varchar2(50);
  STREQUIPCODE varchar2(20);
  V_BELONGFRAME varchar2(20);
  V_BELONGSLOT varchar2(50);
  V_BELONGPACK varchar2(20);
  V_BELONGPORT varchar2(20);
  V_BELONGTIMESLOT varchar2(20);
  v_alarmnumber varchar2(20);
  v_portcode varchar2(20);
  V_ALARMTIME date;
  v_errInfo varchar2(500);

  cnt number;

  type v_rs is ref cursor;

  rs v_rs;

  --added by slzh at 20100824  分析业务及伴随报警

begin

      cnt:=0;

       delete from ALARM_AFFECTION;

       commit;

       open rs for select alarmnumber,systemcode,objclass,equipcode,nvl(belongframe,0) belongframe,nvl(belongslot,0) belongslot, nvl(belongpack,0) belongpack,nvl(belongport,0) belongport,nvl(belongslottime,0) belongslottime,starttime,portcode from v_expert_alarmrelateport;

       fetch rs into  v_alarmnumber,STRSYSTEM,V_OBJCLASS,STREQUIPCODE,V_BELONGFRAME,V_BELONGSLOT,V_BELONGPACK,V_BELONGPORT,V_BELONGTIMESLOT,V_ALARMTIME,v_portcode;

       loop

           V_ISROOT:='0';

           cnt:=cnt+1;

            portRelateCircuitPost(STRSYSTEM,V_OBJCLASS,STREQUIPCODE,V_BELONGFRAME,V_BELONGSLOT,V_BELONGPACK,V_BELONGPORT,V_BELONGTIMESLOT,STRPORTCODE,STRCIRCUIT,STRCARRYID,V_ISROOT,V_ISTOPOPORTALARM);

            update alarminfo a set a.belongtsstm16=STRCIRCUIT ,a.belongtsstm4=STRCARRYID,a.belongsubshelf=V_ISROOT where a.alarmnumber=v_alarmnumber;

/*            if STRCIRCUIT is not null then

               ALARM_AFFECTION_DEAL_TRANS(v_alarmnumber,v_portcode, STRCARRYID, V_ALARMTIME);

            end if;*/

            commit;

            --dbms_output.put_line( v_alarmnumber || '****' || STRSYSTEM || '****' || V_OBJCLASS || '****' || STREQUIPCODE || '****' || V_BELONGFRAME || '****' || V_BELONGSLOT || '****' || V_BELONGPACK || '****' || V_BELONGPORT || '****' || V_BELONGTIMESLOT || '****' || V_ALARMTIME || '****' || v_portcode );

            fetch rs into v_alarmnumber,STRSYSTEM,V_OBJCLASS,STREQUIPCODE,V_BELONGFRAME,V_BELONGSLOT,V_BELONGPACK,V_BELONGPORT,V_BELONGTIMESLOT,V_ALARMTIME,v_portcode;

            exit when rs%notfound;

       end loop;

       close rs;

       analyzecompanyalarm();

       writeAlarmProbablecause();

       update alarminfo c set c.pristinerootalarm=c.belongsubshelf;

       commit;

         exception
         when others then

         dbms_output.put_line(cnt || ' **** ');
         dbms_output.put_line( v_alarmnumber || '****' || STRSYSTEM || '****' || V_OBJCLASS || '****' || STREQUIPCODE || '****' || V_BELONGFRAME || '****' || V_BELONGSLOT || '****' || V_BELONGPACK || '****' || V_BELONGPORT || '****' || V_BELONGTIMESLOT || '****' || V_ALARMTIME || '****' || v_portcode );
                             --10027083          ****     OMS3200.A     ****     timeSlot       ****    10063201000000026562****       1            ****                       ****          1        ****        1                ****            7             ****      07-4月 -11     ****    00000000000000019774

                             --10027083****OMS3200.A****timeSlot****10063201000000026562****1********1****1****7****07-4月 -11****00000000000000019774
      v_errInfo := to_char(SQLCODE) || SQLERRM;
      dbms_output.put_line(v_errInfo);

end writeCircuitToAlarm;

/


spool off
