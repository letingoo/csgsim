create or replace view v_mnt_powerline_circuittotal as
select c.powerline,
       c.station1 station1,
       c.station2 station2,
       username,
       c.operationtype,
       count(c.circuitcode) circuitcount,
       (station1 || '-' || station2) powerlineid
  from v_mnt_circuit_mid c
 where
   c.ismonitored = 1
   and c.station1 is not null and c.station2 is not null
 group by c.powerline, c.station1, c.station2,username,operationtype
/*select c.powerline,
       c.station1 station1,
       c.station2 station2,
       username,
       c.operationtype,
       count(c.circuitcode) circuitcount,
       (station1 || '-' || station2) powerlineid
  from circuit c
 where
   c.ismonitored = 1
   and c.station1 is not null and c.station2 is not null
 group by c.powerline, c.station1, c.station2,username,operationtype*/
--modified by slzh at 根据局站进行调整;
;