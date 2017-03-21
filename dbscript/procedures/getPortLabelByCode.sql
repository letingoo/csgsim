-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:48:35 --
-----------------------------------------------

spool GETPORTLABELBYCODE.log

prompt
prompt Creating function GETPORTLABELBYCODE
prompt ====================================
prompt
CREATE OR REPLACE Function getPortLabelByCode(portCode in VARCHAR2)
return VARCHAR2
AS
    ret VARCHAR2(100);
begin

        select nvl(e.name_std,e.equipname) ||'-'|| p.slotserial || '槽-' || p.portserial || '端口'  into ret from equiplogicport p,equipment e
        where p.logicport = portCode and e.equipcode=p.equipcode;

        /*
        select e.equipname||'-'|| p.slotserial || '槽-' || p.portserial || '端口'  into ret from equiplogicport p,equipment e
        where p.logicport = portCode and e.equipcode=p.equipcode;
        */

  if ret = null then
    ret:='无名端口:'|| portCode;
    return ret;
  else
    return ret;
  end if;
END ;
/


spool off
