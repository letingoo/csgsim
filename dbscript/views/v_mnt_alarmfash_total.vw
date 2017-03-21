create or replace view v_mnt_alarmfash_total as
select rownum rowno,
       l."ALARMNUMBER",
       l."ALARMOBJDESC",
       l."ALARMDESC",
       l."FLASHCOUNT",
       l."FIRSTSTARTTIME",
       l."ALARMSTATUS",
       l.iscleared,
       l.attentioninfo,
       isacked
  from (select a.alarmnumber,
               alarmobjdesc,
               a.alarmdesc,
               decode(b.falshcount, null, 0, b.falshcount) flashcount,
               a.firststarttime,
               decode(a.isrootalarm,
                      1,
                      decode(a.isacked, 1, 1, -1),
                      0,
                      decode(a.isacked, 1, 2, -2)) alarmstatus,
               a.iscleared,
               decode(acktime, null, 0, 1) isacked,
               decode(a.isrootalarm,
                      1,
                      '已转根告警处理',
                      decode(attentioninfo,
                             null,
                             '未做关注处理',
                             attentioninfo)) attentioninfo
          from v_alarminfonew a, v_mnt_flash_mid b
         where a.alarmnumber = b.alarmnumber(+)
         order by to_number(flashcount) desc) l;
