create or replace view v_expert_alarmrelateport as
select distinct a.alarmnumber, p.systemcode,
                a.objclass,
                p.equipcode,
                a.belongframe,
                a.belongslot,
                a.belongpack,
                e.portserial belongport,
                substr(a.objectcode,
                       instr(a.objectcode, '=', -1, 2) + 1,
                       instr(a.objectcode, '=', -1, 1) -
                       instr(a.objectcode, '=', -1, 2) - 1)
                        belongslottime,
                       a.starttime,
                       e.logicport portcode,
                       a.belongtsstm4
  from ALARMINFO a, RE_SYS_EQUIP p, EQUIPLOGICPORT e
 where a.belongequip = p.equipcode
   and a.objclass = 'timeSlot'
   and e.equipcode = a.belongequip
   and e.frameserial = a.belongframe
   and e.slotserial = a.belongslot
   and e.packserial = a.belongpack
   and e.portserial =a.belongport
   and a.belongslot is not null
       --substr(a.belongport, 1, instr(a.belongport, '-', -1, 1) - 1)

union all

  select distinct a.alarmnumber, p.systemcode,
                  a.objclass,
                  p.equipcode,
                  a.belongframe,
                  a.belongslot,
                  a.belongpack,
                  e.portserial belongport,
                  '' belongslottime,
                  a.starttime,
                  e.logicport portcode,
                  a.belongtsstm4
    from ALARMINFO a, RE_SYS_EQUIP p, EQUIPLOGICPORT e
   where a.belongequip = p.equipcode
     and a.objclass = 'port'
     and e.equipcode = a.belongequip
     and e.frameserial = a.belongframe
     and e.slotserial = a.belongslot
     and e.packserial = a.belongpack
     and e.portserial = a.belongport;
