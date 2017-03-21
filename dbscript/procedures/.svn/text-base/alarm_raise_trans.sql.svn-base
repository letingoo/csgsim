-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:10:26 --
-----------------------------------------------

spool ALARM_RAISE_TRANS.log

prompt
prompt Creating procedure ALARM_RAISE_TRANS
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE ALARM_RAISE_TRANS(V_AGENTNAME IN VARCHAR2, --适配器名称
                                              V_ALARMID   IN VARCHAR2, --告警标识

                                              V_OBJDESC  IN VARCHAR2, --告警对象的描述。
                                              V_OBJCLASS IN VARCHAR2, --对象类型

                                              V_ALARMTYPE  IN NUMBER, --数据库设计成数字型。
                                              V_ALARMCAUSE IN NUMBER, --放到BELONGTSSTM64中了，probableCause中被放置为告警原因定义strAlarmDefId了。

                                              V_ALARMLEVEL  IN VARCHAR2, --告警等级
                                              V_ALARMDESC   IN VARCHAR2,
                                              V_ALARMTEXT   IN VARCHAR2, --原始告警里面一些比较有用的信息可以放在这里
                                              V_ALARMTIME   IN DATE, --
                                              V_ALARMREMARK IN VARCHAR2, --

                                              V_NENAME         IN VARCHAR2, --设备id
                                              V_BELONGFRAME    IN VARCHAR2, --如果没有，则为空字符串
                                              V_BELONGSLOT     IN VARCHAR2, --如果没有，则为空字符串
                                              V_BELONGPACK     IN VARCHAR2, --如果没有，则为空字符串
                                              V_BELONGPORT     IN VARCHAR2, --如果没有，则为空字符串
                                              V_BELONGTIMESLOT IN VARCHAR2, --如果没有，则为空字符串
                                              V_BELONGRATE     IN VARCHAR2, --如果没有，则为空字符串
                                              V_RESERVERD      IN VARCHAR2, --保留字段

                                              V_RESULT      OUT INTEGER, --执行结果，正常情况返回'1',否则'0'；处理的告警的告警号，之间用英文逗号分隔；异常情况下返回错误信息。
                                              V_ALARMNUMBER OUT VARCHAR2, --告警编码,v_Result为true的时候有，否则为null
                                              V_ISREPORT    OUT INTEGER, --是否需要上报消息,上报返回'1',否则'0'。v_Result为'1'的时候有，否则为null
                                              V_ERRINFO     OUT VARCHAR2 --执行结果为'0'时输出错误信息，其他情况有可能输出调试信息，也有可能为null。

                                              ) IS
  --定义表示告警对象属性的一些变量
  STREQUIPCODE    EQUIPMENT.EQUIPCODE%TYPE;
  STRPORTCODE     EQUIPLOGICPORT.LOGICPORT%TYPE;
  STREQUIPLABEL   EQUIPMENT.EQUIPLABEL%TYPE;
  STRVENDOR       EQUIPMENT.X_VENDOR%TYPE;
  STRSYSTEM       ALARMINFO.BELONGTRANSYS%TYPE; --系统。
  STRSTATION      EQUIPMENT.STATIONCODE%TYPE;
  STRROOM         EQUIPMENT.ROOMCODE%TYPE;
  STRALARMOBJSHOW ALARMINFO.OBSERVEDVALUE%TYPE; --需要自己组装
  STROBJCODE      ALARMINFO.OBJECTCODE%TYPE;
  STRCIRCUIT      ALARMINFO.BELONGTSSTM16%TYPE;
  STRCURDUTYMAN   ALARMINFO.DEALPERSON%TYPE; --当值值班员

  MY_AGENTNAME ALARMINFO.AGENTNAME%TYPE; --为了对付西门子两个适配器对一个适配器配置对象报告警的问题

  --strSblx equipment.majortype%type;
  /*strTRIGGEREDTHRESHOLD alarminfo.triggeredthreshold%type;*/
  STRALARMDEFID ALARMDEFINE.ID%TYPE := 0;

  --定义CURSOR
  TYPE RC IS REF CURSOR;
  V_RC RC;

  --定义告警频闪判断使用的一些变量
  STRALARMNUMBER ALARMINFO.ALARMNUMBER%TYPE;
  DATESTARTTIME  ALARMINFO.STARTTIME%TYPE;
  DATEENDTIME    ALARMINFO.ENDTIME%TYPE;
  STRCARRYID     ALARMINFO.BELONGTSSTM4%TYPE;

  IISFILTER          ALARMINFO.ISFILTER%TYPE;
  IISACKED           ALARMINFO.ISACKED%TYPE;
  IALARMCOMINGTYPE   NUMBER; --本条告警来源性质：0，新来的；1，频闪的；2，重复上报的，特别是那些同步的告警。
  V_SPECIALTY        VARCHAR2(10); --专业
  V_ISROOT           ALARMINFO.BELONGSUBSHELF %TYPE := 0; -- 是否根告警(默认为不是）
  V_ISROOT_ALARMDESC NUMBER(1);
  V_ISTOPOPORTALARM  NUMBER(1) := 0; --是否光路端口告警
BEGIN
  V_RESULT    := 0;
  STRPORTCODE := '';
  V_SPECIALTY := 'XT3201';
  STRCARRYID  := NULL;
  STRSYSTEM:='';
  MY_AGENTNAME := V_AGENTNAME;

  IF V_ALARMID IS NULL OR V_ALARMDESC IS NULL THEN
    INSERT INTO DBLOG
    VALUES
      (SYSDATE,
       'Alarm_raise_trans',
       'exception',
       '关键值V_ALARMID/V_ALARMDesc为空:' || V_AGENTNAME || V_ALARMID ||
       V_OBJDESC || V_ALARMDESC); --日志
    RETURN;
  END IF;

  --1,告警是否频闪的判断，即确定iAlarmComingType的值
  --
  BEGIN
    IALARMCOMINGTYPE := 0; --赋初始值
    OPEN V_RC FOR
      SELECT ALARMNUMBER, STARTTIME, ENDTIME, ISACKED, ISFILTER
        FROM ALARMINFO
       WHERE SPECIALTY = V_SPECIALTY
         AND AGENTNAME = V_AGENTNAME
         AND ALARMID = V_ALARMID
            --and STARTTIME<=TO_DATE(v_alarmTime,'yyyy-mm-dd hh24:mi:ss')
         AND TRIGGEREDTHRESHOLD = '频闪监控'
         AND V_ALARMTIME < STARTTIME + TRIGGEREDHOUR / 24
       ORDER BY STARTTIME DESC;
    LOOP
      FETCH V_RC
        INTO STRALARMNUMBER, DATESTARTTIME, DATEENDTIME, IISACKED, IISFILTER;
      EXIT WHEN V_RC%NOTFOUND;

      --只要是频闪监控的，就做频闪处理
      IALARMCOMINGTYPE := 1; --频闪
      EXIT;

    END LOOP;
    CLOSE V_RC;
  EXCEPTION
    WHEN OTHERS THEN
      --NULL;
      INSERT INTO DBLOG
      VALUES
        (SYSDATE, 'Alarm_raise_trans', 'debug', '查询频闪出错了');
  END;

  --2，告警入库处理
  BEGIN
    IF IALARMCOMINGTYPE = 1 THEN
      --频闪,或者重复上报
      IF DATESTARTTIME = V_ALARMTIME THEN
        --先更新alarminfo表中的记录,如果新的时间和starttime相等，可以认为是同步上来的告警，频闪不计数
        UPDATE ALARMINFO
           SET ISCLEARED = 0, ENDTIME = NULL
         WHERE ALARMNUMBER = STRALARMNUMBER;
      ELSE
        --
        UPDATE ALARMINFO
           SET ENDTIME   = NULL,
               STARTTIME = V_ALARMTIME,
               ISCLEARED = 0,
               ISACKED   = ISACKED + 1,
               -- belongsubshelf=DECODE(belongsubshelf,'6','1','5','0',belongsubshelf),
               ARRIVETIME = SYSDATE
         WHERE ALARMNUMBER = STRALARMNUMBER;
        --再往alarm_flash表添加记录
        INSERT INTO ALARM_FLASH
          (ALARMNUMBER, ALARMTIME, ALARMSTATUS, LOGTIME, LOGID)
        VALUES
          (STRALARMNUMBER, V_ALARMTIME, 0, SYSDATE, SEQ_TRAILNO.NEXTVAL);
      END IF;
      V_RESULT      := 1;
      V_ALARMNUMBER := STRALARMNUMBER;
      IF IISACKED >= 5 OR IISFILTER > 0 THEN
        --重复频闪太多次或者已经被屏蔽的告警就不用发消息了
        V_ISREPORT := 0;
      ELSE
        V_ISREPORT := 1;
      END IF;
      V_ERRINFO := NULL;
    ELSIF IALARMCOMINGTYPE = 0 THEN
      --正常新告警，从目前结果来看，相对非常少的，因此处理复杂一点也不怎么会影响性能。
      --2.1，查找告警设备在系统库中的属性信息
      BEGIN
        SELECT DISTINCT E.EQUIPCODE,
                        DECODE(E.NAME_STD, NULL, E.EQUIPLABEL, E.NAME_STD),
                        X_VENDOR,
                        STATIONCODE,
                        ROOMCODE
          INTO STREQUIPCODE, STREQUIPLABEL, STRVENDOR, STRSTATION, STRROOM
          FROM EQUIPMENT E
         WHERE E.DOMAIN = MY_AGENTNAME
           AND NENAME = V_NENAME;
      EXCEPTION
        WHEN OTHERS THEN
          STREQUIPCODE  := '==NotExist==';
          STREQUIPLABEL := V_NENAME;
          STRSTATION    := '0'; --默认值
          STRROOM       := '0'; --默认值
      END;

      --2.2 从EN_ADAPTER_DOMAIN获取一些基本信息
      --为了不多查询表，把当值值班员信息也放在这个表里吧。因为别的地方应该不会用到
      if STREQUIPCODE<>'==NotExist==' THEN
         begin
            FOR REC IN(
            SELECT R.SYSTEMCODE
            FROM EQUIPMENT E,RE_SYS_EQUIP R
            WHERE E.EQUIPCODE=R.EQUIPCODE AND E.EQUIPCODE=STREQUIPCODE
            )
            LOOP
            STRSYSTEM:=STRSYSTEM||','||REC.SYSTEMCODE;
            END LOOP;
         end;
     END IF;
     IF STRSYSTEM='' THEN
          BEGIN
          SELECT DEFAULTSYSTEM
            INTO STRSYSTEM
            FROM EN_ADAPTER_DOMAIN
           WHERE LABEL = MY_AGENTNAME;
        EXCEPTION
          WHEN OTHERS THEN
            STRSYSTEM := '0'; --默认值
            STRVENDOR := 'ZY0800'; --真的不知道是哪个厂家。
        END;
     end if;
        BEGIN
          SELECT VENDOR, CURDUTYMAN
            INTO STRVENDOR, STRCURDUTYMAN
            FROM EN_ADAPTER_DOMAIN
           WHERE LABEL = MY_AGENTNAME;
        EXCEPTION
          WHEN OTHERS THEN
            STRSYSTEM := '0'; --默认值
            STRVENDOR := 'ZY0800'; --真的不知道是哪个厂家。
        END;


      --=====对于告警对象为端口及以下，需要做承载业务分析====---
      IF V_BELONGPORT IS NOT NULL THEN
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
              SELECT STRSYSTEM || '/' || GETEQUIPSBMCBYPORT(SRC_PORT) || '至' ||
                     GETEQUIPSBMCBYPORT(DST_PTP) TOPONAME,
                     CODE
                INTO STRCIRCUIT, STRCARRYID
                FROM (SELECT T.AENDPTP SRC_PORT,
                             T.ZENDPTP DST_PTP,
                             T.LABEL   CODE
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
                  --mstp端口存在多条记录的情况
/*                  SELECT MIN(C.CIRCUITCODE || ',' || C.USERNAME),
                         MIN(C.CIRCUITCODE),
                         MAX(c.ismonitored)
                    INTO STRCIRCUIT, STRCARRYID, V_ISROOT
                    FROM CHANNEL N, CIRCUIT C
                   WHERE N.CIRCUITCODE = C.CIRCUITCODE
                     AND (N.PORTSERIALNO1 = STRPORTCODE OR
                         N.PORTSERIALNO2 = STRPORTCODE);*/
           SELECT c.CIRCUITCODE || ',' || C.USERNAME,
                 c.CIRCUITCODE,
                 decode(c.OPERATIONTYPE, '生产实时控制业务', '1', '1')   --国网数据库
            INTO STRCIRCUIT, STRCARRYID, V_ISROOT
            FROM  CIRCUIT C
           WHERE (c.portserialno1 = STRPORTCODE OR
                 c.portserialno2 = STRPORTCODE);
                EXCEPTION
                  WHEN OTHERS THEN
                    NULL; --啥都没找到呀
                END;
            END;
          ELSE
            --除了端口告警剩下就是时隙告警了。就查看有没有过业务电路
            --对于中间时隙的告警就没有必要分析了，一般不会是根告警。
            BEGIN
/*              SELECT C.CIRCUITCODE || ',' || C.USERNAME,
                     C.CIRCUITCODE,
                     c.ismonitored
                INTO STRCIRCUIT, STRCARRYID, V_ISROOT
                FROM CHANNEL N, CIRCUIT C
               WHERE N.CIRCUITCODE = C.CIRCUITCODE
                 AND ((N.PORTSERIALNO1 = STRPORTCODE AND
                     N.SLOT1 = V_BELONGTIMESLOT) OR
                     (N.PORTSERIALNO2 = STRPORTCODE AND
                     N.SLOT2 = V_BELONGTIMESLOT));*/
       SELECT c.CIRCUITCODE || ',' || C.USERNAME,
             c.CIRCUITCODE,
             decode(c.OPERATIONTYPE, '生产实时控制业务', '1', '1')     --国网数据库
        INTO STRCIRCUIT, STRCARRYID, V_ISROOT
        FROM CIRCUIT C
       WHERE (c.portserialno1 = STRPORTCODE and c.slot1 = V_BELONGTIMESLOT) or
             (c.portserialno2 = STRPORTCODE and c.slot2 = V_BELONGTIMESLOT);
            EXCEPTION
              WHEN OTHERS THEN
                NULL; --啥都没找到呀
            END;
          END IF;

        EXCEPTION
          WHEN OTHERS THEN
            STRPORTCODE := NULL;
        END;
      END IF;
      --=============================================================----

      STRALARMOBJSHOW := STREQUIPLABEL;
      STROBJCODE      := STREQUIPCODE;
      IF V_BELONGFRAME IS NOT NULL THEN
        STROBJCODE := STROBJCODE || '=' || V_BELONGFRAME;
        IF V_BELONGSLOT IS NOT NULL THEN
          STROBJCODE      := STROBJCODE || '=' || V_BELONGSLOT;
          STRALARMOBJSHOW := STRALARMOBJSHOW || ',' || V_BELONGSLOT || '盘';
          IF V_BELONGPACK IS NOT NULL THEN
            STROBJCODE := STROBJCODE || '=' || V_BELONGPACK;
            IF V_BELONGPORT IS NOT NULL THEN
              STROBJCODE      := STROBJCODE || '=' || V_BELONGPORT;
              STRALARMOBJSHOW := STRALARMOBJSHOW || V_BELONGPORT || '端口';
              IF V_BELONGTIMESLOT IS NOT NULL THEN
                STROBJCODE := STROBJCODE || '=' || V_BELONGTIMESLOT || '=' ||
                              V_BELONGRATE;
                IF V_BELONGRATE = 'VC4' THEN
                  STRALARMOBJSHOW := STRALARMOBJSHOW || 'VC4-' ||
                                     V_BELONGTIMESLOT;
                ELSE
                  IF TO_NUMBER(V_BELONGTIMESLOT) > 63 THEN
                    STRALARMOBJSHOW := STRALARMOBJSHOW || 'VC4-' ||
                                       CEIL(V_BELONGTIMESLOT / 63) ||
                                       ', VC12-' ||
                                       (MOD((V_BELONGTIMESLOT - 1), 63) + 1);
                  ELSE
                    STRALARMOBJSHOW := STRALARMOBJSHOW || 'VC12-' ||
                                       V_BELONGTIMESLOT;
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
      IF V_AGENTNAME = 'nec_gx_inc100_trans' AND
         STREQUIPCODE = '==NotExist==' THEN
        --在资源未同步的情况下
        STRALARMOBJSHOW := STRSYSTEM || '/' || STREQUIPLABEL || ',' ||
                           V_ALARMREMARK;
      END IF;

      --组装strObjCode---结束
      --根据alarmdefine重定义告警相关属性
      IISFILTER := 0;
      IF STRVENDOR <> 'ZY0800' THEN
        --不是不知道厂家
        ALARMDEFINESETTINGV2(V_SPECIALTY,
                             STRVENDOR,
                             V_ALARMDESC,
                             V_ALARMLEVEL,
                             V_ISTOPOPORTALARM,
                             V_ISROOT_ALARMDESC,
                             IISFILTER,
                             STRALARMDEFID);
      END IF;
      -- 根告警判断
      IF (V_ISROOT = 1 AND V_ISROOT_ALARMDESC = 1) OR
         V_ISROOT_ALARMDESC = 2 THEN
        V_ISROOT := 1;
      ELSE
        V_ISROOT := 0;
      END IF;

      SELECT SEQ_ALARMNUMBER.NEXTVAL INTO STRALARMNUMBER FROM DUAL;
      INSERT INTO ALARMINFO
        (ALARMNUMBER,
         ALARMOBJECT,
         OBJECTCODE,
         OBJCLASS,
         ALARMTYPE,
         PROBABLECAUSE,
         ALARMDESC,
         ALARMTEXT,
         ALARMLEVEL,
         STARTTIME,
         FIRSTSTARTTIME,
         ENDTIME,
         ISCLEARED,
         DEALPERSON, --当值值班员
         ISFILTER, --是否过滤
         VENDOR,
         AGENTNAME,
         BELONGTRANSYS,
         BELONGSTATION,
         BELONGHOUSE,
         BELONGEQUIP,
         BELONGFRAME,
         BELONGSLOT,
         BELONGPACK,
         BELONGPORT,
         BELONGTSVC12,
         ALARMID,
         BELONGTSSTM64,
         OBSERVEDVALUE,
         SPECIALTY,
         REMARK,
         BELONGTSVC3,
         BELONGTSSTM16,
         BELONGTSSTM4,
         ARRIVETIME,
         TRIGGEREDHOUR, --频闪间隔
         BELONGSUBSHELF,
         pristinerootalarm)
      VALUES
        (STRALARMNUMBER,
         V_OBJDESC,
         STROBJCODE,
         V_OBJCLASS,
         V_ALARMTYPE,
         STRALARMDEFID,
         V_ALARMDESC,
         V_ALARMTEXT,
         V_ALARMLEVEL,
         V_ALARMTIME,
         V_ALARMTIME,
         NULL, --结束时间
         0,
         STRCURDUTYMAN,
         IISFILTER,
         STRVENDOR,
         V_AGENTNAME,
         STRSYSTEM,
         STRSTATION,
         STRROOM,
         STREQUIPCODE,
         V_BELONGFRAME,
         V_BELONGSLOT,
         V_BELONGPACK,
         V_BELONGPORT,
         V_BELONGTIMESLOT,
         V_ALARMID,
         V_ALARMCAUSE,
         STRALARMOBJSHOW,
         V_SPECIALTY,
         V_ALARMREMARK,
         STRPORTCODE,
         STRCIRCUIT,
         STRCARRYID,
         SYSDATE,
         METAR_CONST.FLASH_INTERVAL,
         V_ISROOT,
         V_ISROOT);
      V_RESULT      := 1;
      V_ALARMNUMBER := STRALARMNUMBER;
      V_ERRINFO     := NULL;
      --新告警也要往alarm_flash表添加记录
      INSERT INTO ALARM_FLASH
        (ALARMNUMBER, ALARMTIME, ALARMSTATUS, LOGTIME, LOGID)
      VALUES
        (STRALARMNUMBER, V_ALARMTIME, 0, SYSDATE, SEQ_TRAILNO.NEXTVAL);

      COMMIT;

      -- 接着处理伴随告警
      IF STRCARRYID IS NOT NULL THEN
        ALARM_AFFECTION_DEAL_TRANS(STRALARMNUMBER,
                                   STRPORTCODE,
                                   STRCARRYID,
                                   V_ALARMTIME);
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      V_RESULT  := 0;
      V_ERRINFO := V_AGENTNAME || V_OBJDESC || V_ALARMDESC || '::' ||
                   V_ALARMCAUSE || '::' || '::' || STRALARMOBJSHOW || '::' ||
                   TO_CHAR(SQLCODE) || SQLERRM;
      INSERT INTO DBLOG
      VALUES
        (SYSDATE, 'Alarm_raise_trans', 'exception', V_ERRINFO); --日志
  END;

END ALARM_RAISE_TRANS;

  --处理告警发生事件的存储过程v5.0（南方电网版）
  --add by tyh,2007-1-26
  --重大改动：频闪判定规则简单化，只要是频闪监控的就直接判定为频闪。
  --modified by tyh,2007-5-16
  --重大改动：加入告警重定义功能。
  --modified by tyh,2007-5-29
  --ALARMOBJECT,OBJECTCODE暂时设置成一样了（gui现在也说不清到底哪个端口用编号），显示用的strAlarmObjShow挪到OBSERVEDVALUE了
  --modified by tyh,2007-3-26
  --重新定义接口
  -- modified by chovard @2010-02-01 根告警处理
  -- Modified by Chovard Apr.26 2010 修改时隙显示格式为VC4-X, VC12-X
  --根据设备定位告警所属系统
  --modified by shma @2011-5-31
/
spool off
