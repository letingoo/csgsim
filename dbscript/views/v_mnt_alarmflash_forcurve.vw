create or replace view v_mnt_alarmflash_forcurve as
select alarmnumber,
       to_char(alarmtime, 'YYYY-MM-DD') ALARMTIME,
       count(alarmnumber) alarmcount
  FROM alarm_flash where alarmstatus = 0
 group by alarmnumber, to_char(alarmtime, 'YYYY-MM-DD')
 order by alarmnumber
--added by slzh at  根告警统计之用;;