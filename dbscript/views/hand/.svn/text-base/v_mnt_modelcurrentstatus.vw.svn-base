create or replace view v_mnt_modelcurrentstatus as
select distinct m.entityname,m.entityremark,m.ip,m.version,m.statuschangetime,m.fromstatus,m.tostatus from MODULE_STATUS_CHANGE m
where trim(m.entityname)  || trim(to_char(m.statuschangetime,'yyyy-mm-dd hh24:mi:ss'))
 in(select trim(entityname) || trim(statuschangetime)  from v_mnt_modelstatus )
 order by entityname