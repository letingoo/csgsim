create or replace view v_mnt_alarmforsysmap as
select a.belongtransys,a.belongequip,count(belongequip) cnt from v_alarminfonew a
where a.isrootalarm=1 and a.iscleared=0
group by a.belongtransys,a.belongequip order by belongtransys;