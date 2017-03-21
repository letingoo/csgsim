create or replace view v_mnt_alarmflash as
select "ALARMNUMBER","ALARMOBJDESC","ALARMDESC","LASTSTARTTIME","OBJCLASSZH","FLASHCOUNT","BELONGTRANSYS","VENDORZH","ISROOTALARMZH","EQUIPNAME","CIRCUITCOUNT" from (
select distinct v.alarmnumber,
       v.alarmobjdesc,
       v.alarmdesc,
       v.laststarttime,
       v.objclasszh,
       v.flashcount,
       v.belongtransys,
       v.vendorzh,
       v.isrootalarmzh,
       t.equiplabel equipname,
       decode(v.specialty,'XT3201',getBreakCircuitCountByAlarmID(v.alarmnumber,v.isrootalarm),0) circuitcount
  from  v_alarminfonew v, equipment t where  v.belongequip = t.equipcode(+)
);

