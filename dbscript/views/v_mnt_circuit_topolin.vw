create or replace view v_mnt_circuit_topolin as
select v."POWERLINE",
       v."STATION1",
       v."STATION2",
       v."USERNAME",
       v."OPERATIONTYPE",
       v."CIRCUITCOUNT",
       v."POWERLINEID",
       nvl(b.breakcircuit, 0) breakcircuit
  from v_mnt_powerline_circuittotal v, v_mnt_powerline_breakcircuit b
 where v.powerlineid = b.powerlineid(+)
       and
       v.powerline=b.powerline(+) ;