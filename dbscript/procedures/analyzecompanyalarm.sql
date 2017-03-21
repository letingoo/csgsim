-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:31:31 --
-----------------------------------------------

spool ANALYZECOMPANYALARM.log

prompt
prompt Creating procedure ANALYZECOMPANYALARM
prompt ======================================
prompt
create or replace procedure analyzecompanyalarm
is
  v_starttime date;
  v_carryid   varchar2(100);
  v_alarmnumber varchar2(20);
  v_portcode varchar2(20);

  type v_rs is ref cursor;

  rs v_rs;

  --added by slzh at 20100824  ·ÖÎö°éËæ¸æ¾¯

begin

       open rs for select alarmnumber,starttime,portcode,belongtsstm4 from v_expert_alarmrelateport;

       fetch rs into v_alarmnumber,v_starttime,v_portcode,v_carryid;

       loop

            exit when rs%notfound;

            if v_carryid is not null then

               ALARM_AFFECTION_DEAL_TRANS(v_alarmnumber,v_portcode, v_carryid, v_starttime);

            end if;

            commit;

            fetch rs into v_alarmnumber,v_starttime,v_portcode,v_carryid;

       end loop;

       close rs;

end analyzecompanyalarm;
/


spool off
