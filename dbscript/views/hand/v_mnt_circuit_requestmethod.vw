create or replace view v_mnt_circuit_requestmethod as
select "FORMNUM","FORMNAME","RATE","STATION1","STATIONCODE1","STATION2","STATIONCODE2","PORT1","PORT2","CHANNEL","OLDFORMNUM","CIRSTATUS","USERNAME","POWERLINE" from (
        select cir.circuitcode formNum,
         cir.remark formName,
         xt.xtxx rate,
        decode(st1.stationname,null,' ',st1.stationname) station1,
        cir.station1 stationcode1,
         decode(st2.stationname,null,' ',st2.stationname) station2,
         cir.station2 stationcode2,
         getportlabel(cir.portserialno1) port1,
         getportlabel(cir.portserialno2) port2,
         getchannelpath(cir.circuitcode) channel,
         decode(requisitionid,null,' ',requisitionid) oldFormNum,
         decode(c.circuitcode,null,'normalstatus','alarmstatus') cirstatus,
         cir.username,
         cir.powerline
        from circuit cir, xtbm xt, station st1, station st2,(select * from v_alarmrelatecircuit t where t.iscleared=0) c
       where
       cir.rate = xt.xtbm
       and
       cir.circuitcode=c.circuitcode(+)
       and cir.station1 = st1.stationcode
       and cir.station2 = st2.stationcode
      order by cirstatus,cir.circuitcode
      )
      --added by slzh  at 20110805  ����ͼ��Ҫ�޸�,circuit ���е��ֶ����ڲ���ά���ˣ���ȡ��վҪ��circuit�˿ںͶ˿ڱ��豸�������ȡ
