create or replace view v_mnt_flash_mid as
select alarmnumber,count(*) falshcount from alarm_flash a where a.alarmstatus=0 group by alarmnumber;

