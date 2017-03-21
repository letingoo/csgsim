create or replace view v_mnt_alarmdealmethod_total as
select dealresultzh,
       dealresult,
       ackedalarmcount,
       round(decode(totalcount, 0, 0, ackedalarmcount / totalcount) * 100,
             2) || '%' scale
  from v_mnt_alarmdealmethod_mid;