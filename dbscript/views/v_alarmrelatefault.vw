create or replace view v_alarmrelatefault as
select t.belongtsstm16,
           t.observedvalue,
           ad.n_alarmdesc ALARMDESC,
           t.starttime,
           t.bugno,
           t.dutyid,
           t.alarmlevel as alarmlevel,                                                                                      --�澯����
           decode(t.alarmlevel,
              'critical',
              '�����澯',
              'major',
              '��Ҫ�澯',
              'minor',
              '��Ҫ�澯',
              '��ʾ�澯'
              ) alarmlevelname
      from alarminfo t, alarmdefine ad
     where t.probablecause = ad.id
       and t.bugno is not null
     order by t.starttime desc;

