-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:53:43 --
-----------------------------------------------

spool GETBREAKCIRCUITCOUNTBYALARMID.log

prompt
prompt Creating function GETBREAKCIRCUITCOUNTBYALARMID
prompt ===============================================
prompt
create or replace function getBreakCircuitCountByAlarmID(aid in varchar2,isRootAlarm in varchar2) return number

is

       breakCircuitCount number;

       v_errInfo varchar2(500);

begin

       breakCircuitCount:=0;

       if isRootAlarm='0' then

          breakCircuitCount:= 0;

       else
         select cnt into breakCircuitCount from (
         select count(distinct belongtsstm4) cnt
           from alarminfo a
          where a.belongtsstm4 is not null
            and a.iscleared = 0
            and a.belongsubshelf=1
            and alarmnumber in (select ALM_COMPANY
                                  from alarm_affection
                                 where alm_number = aid)
                                 );

       end if;

        return breakCircuitCount;

 EXCEPTION
  WHEN OTHERS THEN
    v_errInfo := to_char(SQLCODE) || SQLERRM;
    dbms_output.put_line(v_errInfo);
    return -1;

end getBreakCircuitCountByAlarmID;
/


spool off
