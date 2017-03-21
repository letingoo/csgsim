create or replace view v_mnt_alarmdealmethod_mid as
select x.xtxx dealresultzh,
       dealresult,
       count(dealresult) ackedalarmcount,
       (select count(*) from alarminfo where dealresult is not null) totalcount
  from alarminfo a, xtbm x
 where a.dealresult = x.xtbm
   and a.dealresult is not null
   --and a.pristinerootalarm=1
 group by dealresult, x.xtxx
--added by slzh at 2011-07-12 告警处理方式统计信息;

