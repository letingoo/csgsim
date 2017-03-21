-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:46:01 --
-----------------------------------------------

spool GETPORTSTRUCTINFO.log

prompt
prompt Creating function GETPORTSTRUCTINFO
prompt ===================================
prompt
CREATE OR REPLACE Function getPortStructInfo(portCode in VARCHAR2)
return VARCHAR2
AS

    ret VARCHAR2(100);
begin
            select p.equipcode || '=' ||  p.frameserial || '=' || p.slotserial || '=' || p.packserial || '=' || p.portserial  into ret from equiplogicport p where p.logicport = portCode ;
  if ret = null then
    ret:='ÎÞÃû¶Ë¿Ú:'|| portCode;
    return ret;
  else
    return ret;
  end if;
END ;
/


spool off
