create or replace view v_alarmrelatefault as
select t.belongtsstm16,
           t.observedvalue,
           ad.n_alarmdesc ALARMDESC,
           t.starttime,
           t.bugno,
           t.dutyid,
           t.alarmlevel as alarmlevel,                                                                                      --告警级别
           decode(t.alarmlevel,
              'critical',
              '紧急告警',
              'major',
              '主要告警',
              'minor',
              '次要告警',
              '提示告警'
              ) alarmlevelname
      from alarminfo t, alarmdefine ad
     where t.probablecause = ad.id
       and t.bugno is not null
     order by t.starttime desc;

