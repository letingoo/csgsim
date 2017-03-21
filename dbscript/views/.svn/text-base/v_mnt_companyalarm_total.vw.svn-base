create or replace view v_mnt_companyalarm_total as
select alm_number alarmnumber, count(alm_number) companyalarmcnt
  from alarm_affection a
 where a.alm_number <> a.alm_company
 group by alm_number
 --added by slzh at 2011-08-29 °éËæ¸æ¾¯Í³¼Æ£»
