spool ALARM_AFFECTION_DEAL_TRANS.log

prompt
prompt Creating procedure ALARM_AFFECTION_DEAL_TRANS
prompt ==========================================
prompt

CREATE OR REPLACE PROCEDURE ALARM_AFFECTION_DEAL_TRANS(VAR_ALMID     IN VARCHAR2,--�澯id
                                                 VAR_PORTCODE   IN VARCHAR2,--�澯�˿ڱ��
                                                 VAR_CARRYID   IN VARCHAR2,--�澯����ҵ����·code
                                                 VAR_ALARMTIME IN DATE) IS
  TMP_ERR_INFO DBLOG.LOGCONTEXT %TYPE;
BEGIN
  -- ������ҵ��
  IF VAR_CARRYID IS NULL THEN
    RETURN;
  END IF;

  -- ���ظ��ö�
  IF INSTR(VAR_CARRYID, '#') > 0 THEN
    INSERT INTO ALARM_AFFECTION
      (ALM_NUMBER, ALM_COMPANY)
      SELECT VAR_ALMID, ALARMNUMBER
        FROM ALARMINFO A
       WHERE A.STARTTIME >= VAR_ALARMTIME - METAR_CONST.RELATION_INTERVAL/1440 -- ֮ǰ8Сʱ�ڵĸ澯
             AND A.STARTTIME <= VAR_ALARMTIME + METAR_CONST.RELATION_INTERVAL/1440 -- ֮��1Сʱ�ڵĸ澯
         AND A.BELONGTSSTM4 IN
             ( -- �����Ǹø��öι����ĵ�·
              select circuitcode from cctmp t 
              where t.aptp= VAR_PORTCODE 
                 or 
                    t.zptp=VAR_PORTCODE
               );
  ELSE-- ���ص�·
    -- �����Լ����Լ��İ���
    INSERT INTO ALARM_AFFECTION
      (ALM_NUMBER, ALM_COMPANY)
    VALUES
      (VAR_ALMID, VAR_ALMID);
    -- ���Ҹõ�·���ܵĹ�·�澯
    INSERT INTO ALARM_AFFECTION
      (ALM_NUMBER, ALM_COMPANY)
      SELECT A.ALARMNUMBER, VAR_ALMID
        FROM ALARMINFO A
       WHERE --A.ISCLEARED = 0  AND -- ����Ϊ��ǰ��Ծ��
         A.BELONGSUBSHELF = 1 -- �����Ǹ��澯
         AND A.STARTTIME >= VAR_ALARMTIME - METAR_CONST.RELATION_INTERVAL/1440 -- ֮ǰ5�����ڵĸ澯
         AND A.STARTTIME <= VAR_ALARMTIME + METAR_CONST.RELATION_INTERVAL/1440 -- ֮��1Сʱ�ڵĸ澯
         AND INSTR(A.BELONGTSSTM4, '#') > 0 -- �����Ǹ��ö�
         AND A.BELONGTSVC3 IN
             (select p.aptp from cctmp p where p.circuitcode=VAR_CARRYID
                 union 
              select p.zptp from cctmp p where p.circuitcode=VAR_CARRYID
              );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    TMP_ERR_INFO := TO_CHAR(SQLCODE) || ': ' || SQLERRM || ' alarmId: ' ||
                    VAR_ALMID;
    INSERT INTO DBLOG
    VALUES
      (SYSDATE, 'ALARM_AFFECTION_DEAL', 'exception', TMP_ERR_INFO);
END ALARM_AFFECTION_DEAL_TRANS;
-- Created by Chovard 2010
  -- ����רҵ����澯���
  -- Modified by Chovard Apr.24 2010
  -- �������ܸ澯����ʱ�����޸İ���澯�ж���������ʱ���޶�Ϊ���°���
/
spool off