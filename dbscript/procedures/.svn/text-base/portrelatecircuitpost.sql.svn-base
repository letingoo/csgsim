-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:52:35 --
-----------------------------------------------

spool PORTRELATECIRCUITPOST.log

prompt
prompt Creating procedure PORTRELATECIRCUITPOST
prompt ========================================
prompt
create or replace procedure portRelateCircuitPost(STRSYSTEM         in varchar2,
                                              V_OBJCLASS        in varchar2,
                                              STREQUIPCODE      in varchar2,
                                              V_BELONGFRAME     in varchar2,
                                              V_BELONGSLOT      in varchar2,
                                              V_BELONGPACK      in varchar2,
                                              V_BELONGPORT      in varchar2,
                                              V_BELONGTIMESLOT  in varchar2,
                                              STRPORTCODE       out varchar2,
                                              STRCIRCUIT        out varchar2,
                                              STRCARRYID        out varchar2,
                                              V_ISROOT          out varchar2,
                                              V_ISTOPOPORTALARM out varchar2) is

  /*IF V_BELONGPORT IS NOT NULL THEN*/
BEGIN
  --需要查询端口编号
  SELECT LOGICPORT
    INTO STRPORTCODE
    FROM EQUIPLOGICPORT
   WHERE EQUIPCODE = STREQUIPCODE
     AND FRAMESERIAL = V_BELONGFRAME
     AND SLOTSERIAL = V_BELONGSLOT
     AND PACKSERIAL = V_BELONGPACK
     AND PORTSERIAL = V_BELONGPORT;

  --首先对于端口告警，需要进行光路告警分析
  IF V_OBJCLASS = 'port' THEN
    BEGIN
      SELECT STRSYSTEM || '/' || getEquipSBMCbyPort(SRC_PORT) || '至' ||
             getEquipSBMCbyPort(DST_PTP) topoName,
             CODE
        INTO STRCIRCUIT, STRCARRYID
        FROM (SELECT T.AENDPTP SRC_PORT, T.ZENDPTP DST_PTP, T.LABEL CODE
                FROM EN_TOPOLINK T
               WHERE T.AENDPTP = STRPORTCODE
              UNION
              SELECT T.ZENDPTP, T.AENDPTP, T.LABEL
                FROM EN_TOPOLINK T
               WHERE T.ZENDPTP = STRPORTCODE);
      -- 光口告警
      V_ISROOT          := '1';
      V_ISTOPOPORTALARM := 1;
    EXCEPTION
      WHEN OTHERS THEN
        -- 不是光路端口，再查询业务电路
        BEGIN

           /*
           SELECT c.CIRCUITCODE || ',' || C.USERNAME,
                 c.CIRCUITCODE,
                 decode(c.OPERATIONTYPE, '生产实时控制业务', '1', '1')   --国网数据库
            INTO STRCIRCUIT, STRCARRYID, V_ISROOT
            FROM  CIRCUIT C,cctmp n
           WHERE c.circuitcode = n.circuitcode
             AND (n.aptp = STRPORTCODE OR
                 n.zptp = STRPORTCODE);
           */

           SELECT c.CIRCUITCODE || ',' || C.USERNAME,
                 c.CIRCUITCODE,
                 decode(c.OPERATIONTYPE, '生产实时控制业务', '1', '1')   --国网数据库
            INTO STRCIRCUIT, STRCARRYID, V_ISROOT
            FROM  CIRCUIT C
           WHERE (c.portserialno1 = STRPORTCODE OR
                 c.portserialno2 = STRPORTCODE);

        EXCEPTION
          WHEN OTHERS THEN
            V_ISROOT:='0';
            NULL; --啥都没找到呀
        END;
    END;
  else
    --除了端口告警剩下就是时隙告警了。就查看有没有过业务电路
    --对于中间时隙的告警就没有必要分析了，一般不会是根告警。
    BEGIN
      /*
      SELECT c.CIRCUITCODE || ',' || C.USERNAME,
             c.CIRCUITCODE,
             decode(c.OPERATIONTYPE, '生产实时控制业务', '1', '1')     --国网数据库
        INTO STRCIRCUIT, STRCARRYID, V_ISROOT
        FROM cctmp N, CIRCUIT C
       WHERE N.CIRCUITCODE = C.CIRCUITCODE
         AND ((n.aptp = STRPORTCODE and n.aslot = V_BELONGTIMESLOT) or
             (n.zptp = STRPORTCODE and n.zslot = V_BELONGTIMESLOT));
         */

       SELECT c.CIRCUITCODE || ',' || C.USERNAME,
             c.CIRCUITCODE,
             decode(c.OPERATIONTYPE, '生产实时控制业务', '1', '1')     --国网数据库
        INTO STRCIRCUIT, STRCARRYID, V_ISROOT
        FROM CIRCUIT C
       WHERE (c.portserialno1 = STRPORTCODE and c.slot1 = V_BELONGTIMESLOT) or
             (c.portserialno2 = STRPORTCODE and c.slot2 = V_BELONGTIMESLOT);

    EXCEPTION
      WHEN OTHERS THEN
        V_ISROOT:='0';
        NULL; --啥都没找到呀
    END;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    STRPORTCODE := NULL;
END portRelateCircuitPost;

  /*      END IF;*/
/


spool off
