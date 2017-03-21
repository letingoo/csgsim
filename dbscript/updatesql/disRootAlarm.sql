--一、还原根告警标记位
UPDATE ALARMINFO SET BELONGSUBSHELF = 0;

--二、处理光路告警及伴随告警，判断为根告警

--1 置位光路告警

UPDATE ALARMINFO
   SET BELONGSUBSHELF = 1
 WHERE BELONGTSSTM4 IS NOT NULL
   AND BELONGTSSTM4 LIKE '%#%';
   
--2 处理伴随告警

DECLARE
  V_ZEND VARCHAR2(20);
  V_AEND VARCHAR2(20);
BEGIN
  FOR LINE IN (SELECT ALARMNUMBER ALMNO, BELONGTSVC3 PORT, STARTTIME TIM
                 FROM ALARMINFO
                WHERE BELONGTSSTM4 LIKE '%#%') LOOP
    -- 是否有关联电路
    FOR BRANCH IN (SELECT CIRCUITCODE ID
                     FROM CCTMP
                    WHERE APTP = LINE.PORT
                       OR ZPTP = LINE.PORT) LOOP
      -- 查AZ端口是否发生告警
      SELECT C.PORTSERIALNO1, C.PORTSERIALNO2
        INTO V_AEND, V_ZEND
        FROM CIRCUIT C
       WHERE CIRCUITCODE = BRANCH.ID;
      -- 更新alarminfo表
      UPDATE ALARMINFO A
         SET A.BELONGTSSTM4 = BRANCH.ID
       WHERE BELONGTSVC3 = V_AEND
          OR BELONGTSVC3 = V_ZEND;
      COMMIT;
      -- 插入alarm_affection表
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

--三、处理业务告警，判断为根告警
--1.把电路表 circuit表里的电路编号circuitcode更新到告警表alarminfo的BELONGTSSTM4在满足
--告警表 alarminfo里面belongtsvc3与电路表 circuit里面 portserialno1 portserialno2
--这两个字段相等条件的记录

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
 
--2.更新为根告警，重点业务发生的告警就是根告警
update alarminfo aa set aa.belongsubshelf= '1' where  aa.BELONGTSSTM4 is not null and 
aa.BELONGTSSTM4 not LIKE '%#%'; 
