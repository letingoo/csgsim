 create or replace view v_mnt_modelstatus as
select distinct cc.entityname,
                to_char(max(statuschangetime), 'yyyy-mm-dd hh24:mi:ss') statuschangetime
  from MODULE_STATUS_CHANGE cc
  where cc.ismonitorbyui='Y'
 group by cc.entityname, cc.entityremark
