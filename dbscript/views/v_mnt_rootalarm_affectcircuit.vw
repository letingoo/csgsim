create or replace view v_mnt_rootalarm_affectcircuit as
select distinct circuitcode,
                        username,
                        operationtype circuittype,
                        USETIME,
                        r.xtxx RATE,
                        getPortLabelWithoutEquip(portserialno1) portserialno1,
                        getPortLabelWithoutEquip(portserialno2) portserialno2,
                        e.alm_number alarmnumber,
                        nvl(a.belongsubshelf, '0') isrootalarm, --��ǰ�澯�Ƿ���澯
                        decode(a.belongsubshelf, '1', '���澯', '�Ǹ��澯') isrootalarmzh,
                        decode(a.acktime, null, 0, 1) isacked, --�Ƿ�ȷ��
                        decode(a.acktime, null, 'δȷ��', '��ȷ��') isackedzh
          from circuit v, alarminfo a, alarm_affection e, xtbm r
         where v.rate = r.xtbm(+)
           and v.CIRCUITCODE = a.belongtsstm4
           and a.alarmnumber = e.alm_company
           and a.iscleared = 0
           and a.belongsubshelf = 1;

