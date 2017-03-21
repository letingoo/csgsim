--һ����ԭ���澯���λ
UPDATE ALARMINFO SET BELONGSUBSHELF = 0;

--���������·�澯������澯���ж�Ϊ���澯

--1 ��λ��·�澯

UPDATE ALARMINFO
   SET BELONGSUBSHELF = 1
 WHERE BELONGTSSTM4 IS NOT NULL
   AND BELONGTSSTM4 LIKE '%#%';
   
--2 �������澯

DECLARE
  V_ZEND VARCHAR2(20);
  V_AEND VARCHAR2(20);
BEGIN
  FOR LINE IN (SELECT ALARMNUMBER ALMNO, BELONGTSVC3 PORT, STARTTIME TIM
                 FROM ALARMINFO
                WHERE BELONGTSSTM4 LIKE '%#%') LOOP
    -- �Ƿ��й�����·
    FOR BRANCH IN (SELECT CIRCUITCODE ID
                     FROM CCTMP
                    WHERE APTP = LINE.PORT
                       OR ZPTP = LINE.PORT) LOOP
      -- ��AZ�˿��Ƿ����澯
      SELECT C.PORTSERIALNO1, C.PORTSERIALNO2
        INTO V_AEND, V_ZEND
        FROM CIRCUIT C
       WHERE CIRCUITCODE = BRANCH.ID;
      -- ����alarminfo��
      UPDATE ALARMINFO A
         SET A.BELONGTSSTM4 = BRANCH.ID
       WHERE BELONGTSVC3 = V_AEND
          OR BELONGTSVC3 = V_ZEND;
      COMMIT;
      -- ����alarm_affection��
      BEGIN
        INSERT INTO ALARM_AFFECTION
          (ALM_NUMBER, ALM_COMPANY, OP_ACCOUNT)
          SELECT LINE.ALMNO, ALARMNUMBER, 'ANALYSE'
            FROM ALARMINFO
           WHERE BELONGTSVC3 = V_AEND
              OR BELONGTSVC3 = V_ZEND
             AND STARTTIME BETWEEN LINE.TIM - 0.5 / 24 AND
                 LINE.TIM + 0.5 / 24;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  END LOOP;
END;

--��������ҵ��澯���ж�Ϊ���澯
--1.�ѵ�·�� circuit����ĵ�·���circuitcode���µ��澯��alarminfo��BELONGTSSTM4������
--�澯�� alarminfo����belongtsvc3���·�� circuit���� portserialno1 portserialno2
--�������ֶ���������ļ�¼

begin
  for rec in (select e.circuitcode,a.alarmnumber
                from circuit e, alarminfo a
               where e.portserialno1 = a.belongtsvc3
                  or e.portserialno2 = a.belongtsvc3) loop
    update alarminfo
       set BELONGTSSTM4 = rec.circuitcode
     where alarmnumber = rec.alarmnumber;
    end loop;
end;
 
--2.����Ϊ���澯���ص�ҵ�����ĸ澯���Ǹ��澯
update alarminfo aa set aa.belongsubshelf= '1' where  aa.BELONGTSSTM4 is not null and 
aa.BELONGTSSTM4 not LIKE '%#%'; 
