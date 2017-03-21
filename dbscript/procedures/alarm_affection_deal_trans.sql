spool ALARM_AFFECTION_DEAL_TRANS.log

prompt
prompt Creating procedure ALARM_AFFECTION_DEAL_TRANS
prompt ==========================================
prompt

CREATE OR REPLACE PROCEDURE ALARM_AFFECTION_DEAL_TRANS(VAR_ALMID     IN VARCHAR2,--告警id
                                                 VAR_PORTCODE   IN VARCHAR2,--告警端口编号
                                                 VAR_CARRYID   IN VARCHAR2,--告警承载业务或光路code
                                                 VAR_ALARMTIME IN DATE) IS
  TMP_ERR_INFO DBLOG.LOGCONTEXT %TYPE;
BEGIN
  -- 不承载业务
  IF VAR_CARRYID IS NULL THEN
    RETURN;
  END IF;

  -- 承载复用段
  IF INSTR(VAR_CARRYID, '#') > 0 THEN
    INSERT INTO ALARM_AFFECTION
      (ALM_NUMBER, ALM_COMPANY)
      SELECT VAR_ALMID, ALARMNUMBER
        FROM ALARMINFO A
       WHERE A.STARTTIME >= VAR_ALARMTIME - METAR_CONST.RELATION_INTERVAL/1440 -- 之前8小时内的告警
             AND A.STARTTIME <= VAR_ALARMTIME + METAR_CONST.RELATION_INTERVAL/1440 -- 之后1小时内的告警
         AND A.BELONGTSSTM4 IN
             ( -- 必须是该复用段关联的电路
              select circuitcode from cctmp t 
              where t.aptp= VAR_PORTCODE 
                 or 
                    t.zptp=VAR_PORTCODE
               );
  ELSE-- 承载电路
    -- 首先自己是自己的伴随
    INSERT INTO ALARM_AFFECTION
      (ALM_NUMBER, ALM_COMPANY)
    VALUES
      (VAR_ALMID, VAR_ALMID);
    -- 查找该电路可能的光路告警
    INSERT INTO ALARM_AFFECTION
      (ALM_NUMBER, ALM_COMPANY)
      SELECT A.ALARMNUMBER, VAR_ALMID
        FROM ALARMINFO A
       WHERE --A.ISCLEARED = 0  AND -- 必须为当前活跃的
         A.BELONGSUBSHELF = 1 -- 必须是根告警
         AND A.STARTTIME >= VAR_ALARMTIME - METAR_CONST.RELATION_INTERVAL/1440 -- 之前5分钟内的告警
         AND A.STARTTIME <= VAR_ALARMTIME + METAR_CONST.RELATION_INTERVAL/1440 -- 之后1小时内的告警
         AND INSTR(A.BELONGTSSTM4, '#') > 0 -- 必须是复用段
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
  -- 传输专业伴随告警诊断
  -- Modified by Chovard Apr.24 2010
  -- 由于网管告警存在时间误差，修改伴随告警判断条件，将时间限定为上下半天
/
spool off