-----------------------------------------------
-- Export file for user SDEMU                --
-- Created by qiaofeng on 2011-9-7, 15:10:26 --
-----------------------------------------------

spool ALARM_RAISE_TRANS.log

prompt
prompt Creating procedure ALARM_RAISE_TRANS
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE ALARM_RAISE_TRANS(V_AGENTNAME IN VARCHAR2, --����������
                                              V_ALARMID   IN VARCHAR2, --�澯��ʶ

                                              V_OBJDESC  IN VARCHAR2, --�澯�����������
                                              V_OBJCLASS IN VARCHAR2, --��������

                                              V_ALARMTYPE  IN NUMBER, --���ݿ���Ƴ������͡�
                                              V_ALARMCAUSE IN NUMBER, --�ŵ�BELONGTSSTM64���ˣ�probableCause�б�����Ϊ�澯ԭ����strAlarmDefId�ˡ�

                                              V_ALARMLEVEL  IN VARCHAR2, --�澯�ȼ�
                                              V_ALARMDESC   IN VARCHAR2,
                                              V_ALARMTEXT   IN VARCHAR2, --ԭʼ�澯����һЩ�Ƚ����õ���Ϣ���Է�������
                                              V_ALARMTIME   IN DATE, --
                                              V_ALARMREMARK IN VARCHAR2, --

                                              V_NENAME         IN VARCHAR2, --�豸id
                                              V_BELONGFRAME    IN VARCHAR2, --���û�У���Ϊ���ַ���
                                              V_BELONGSLOT     IN VARCHAR2, --���û�У���Ϊ���ַ���
                                              V_BELONGPACK     IN VARCHAR2, --���û�У���Ϊ���ַ���
                                              V_BELONGPORT     IN VARCHAR2, --���û�У���Ϊ���ַ���
                                              V_BELONGTIMESLOT IN VARCHAR2, --���û�У���Ϊ���ַ���
                                              V_BELONGRATE     IN VARCHAR2, --���û�У���Ϊ���ַ���
                                              V_RESERVERD      IN VARCHAR2, --�����ֶ�

                                              V_RESULT      OUT INTEGER, --ִ�н���������������'1',����'0'������ĸ澯�ĸ澯�ţ�֮����Ӣ�Ķ��ŷָ����쳣����·��ش�����Ϣ��
                                              V_ALARMNUMBER OUT VARCHAR2, --�澯����,v_ResultΪtrue��ʱ���У�����Ϊnull
                                              V_ISREPORT    OUT INTEGER, --�Ƿ���Ҫ�ϱ���Ϣ,�ϱ�����'1',����'0'��v_ResultΪ'1'��ʱ���У�����Ϊnull
                                              V_ERRINFO     OUT VARCHAR2 --ִ�н��Ϊ'0'ʱ���������Ϣ����������п������������Ϣ��Ҳ�п���Ϊnull��

                                              ) IS
  --�����ʾ�澯�������Ե�һЩ����
  STREQUIPCODE    EQUIPMENT.EQUIPCODE%TYPE;
  STRPORTCODE     EQUIPLOGICPORT.LOGICPORT%TYPE;
  STREQUIPLABEL   EQUIPMENT.EQUIPLABEL%TYPE;
  STRVENDOR       EQUIPMENT.X_VENDOR%TYPE;
  STRSYSTEM       ALARMINFO.BELONGTRANSYS%TYPE; --ϵͳ��
  STRSTATION      EQUIPMENT.STATIONCODE%TYPE;
  STRROOM         EQUIPMENT.ROOMCODE%TYPE;
  STRALARMOBJSHOW ALARMINFO.OBSERVEDVALUE%TYPE; --��Ҫ�Լ���װ
  STROBJCODE      ALARMINFO.OBJECTCODE%TYPE;
  STRCIRCUIT      ALARMINFO.BELONGTSSTM16%TYPE;
  STRCURDUTYMAN   ALARMINFO.DEALPERSON%TYPE; --��ֵֵ��Ա

  MY_AGENTNAME ALARMINFO.AGENTNAME%TYPE; --Ϊ�˶Ը�������������������һ�����������ö��󱨸澯������

  --strSblx equipment.majortype%type;
  /*strTRIGGEREDTHRESHOLD alarminfo.triggeredthreshold%type;*/
  STRALARMDEFID ALARMDEFINE.ID%TYPE := 0;

  --����CURSOR
  TYPE RC IS REF CURSOR;
  V_RC RC;

  --����澯Ƶ���ж�ʹ�õ�һЩ����
  STRALARMNUMBER ALARMINFO.ALARMNUMBER%TYPE;
  DATESTARTTIME  ALARMINFO.STARTTIME%TYPE;
  DATEENDTIME    ALARMINFO.ENDTIME%TYPE;
  STRCARRYID     ALARMINFO.BELONGTSSTM4%TYPE;

  IISFILTER          ALARMINFO.ISFILTER%TYPE;
  IISACKED           ALARMINFO.ISACKED%TYPE;
  IALARMCOMINGTYPE   NUMBER; --�����澯��Դ���ʣ�0�������ģ�1��Ƶ���ģ�2���ظ��ϱ��ģ��ر�����Щͬ���ĸ澯��
  V_SPECIALTY        VARCHAR2(10); --רҵ
  V_ISROOT           ALARMINFO.BELONGSUBSHELF %TYPE := 0; -- �Ƿ���澯(Ĭ��Ϊ���ǣ�
  V_ISROOT_ALARMDESC NUMBER(1);
  V_ISTOPOPORTALARM  NUMBER(1) := 0; --�Ƿ��·�˿ڸ澯
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
       '�ؼ�ֵV_ALARMID/V_ALARMDescΪ��:' || V_AGENTNAME || V_ALARMID ||
       V_OBJDESC || V_ALARMDESC); --��־
    RETURN;
  END IF;

  --1,�澯�Ƿ�Ƶ�����жϣ���ȷ��iAlarmComingType��ֵ
  --
  BEGIN
    IALARMCOMINGTYPE := 0; --����ʼֵ
    OPEN V_RC FOR
      SELECT ALARMNUMBER, STARTTIME, ENDTIME, ISACKED, ISFILTER
        FROM ALARMINFO
       WHERE SPECIALTY = V_SPECIALTY
         AND AGENTNAME = V_AGENTNAME
         AND ALARMID = V_ALARMID
            --and STARTTIME<=TO_DATE(v_alarmTime,'yyyy-mm-dd hh24:mi:ss')
         AND TRIGGEREDTHRESHOLD = 'Ƶ�����'
         AND V_ALARMTIME < STARTTIME + TRIGGEREDHOUR / 24
       ORDER BY STARTTIME DESC;
    LOOP
      FETCH V_RC
        INTO STRALARMNUMBER, DATESTARTTIME, DATEENDTIME, IISACKED, IISFILTER;
      EXIT WHEN V_RC%NOTFOUND;

      --ֻҪ��Ƶ����صģ�����Ƶ������
      IALARMCOMINGTYPE := 1; --Ƶ��
      EXIT;

    END LOOP;
    CLOSE V_RC;
  EXCEPTION
    WHEN OTHERS THEN
      --NULL;
      INSERT INTO DBLOG
      VALUES
        (SYSDATE, 'Alarm_raise_trans', 'debug', '��ѯƵ��������');
  END;

  --2���澯��⴦��
  BEGIN
    IF IALARMCOMINGTYPE = 1 THEN
      --Ƶ��,�����ظ��ϱ�
      IF DATESTARTTIME = V_ALARMTIME THEN
        --�ȸ���alarminfo���еļ�¼,����µ�ʱ���starttime��ȣ�������Ϊ��ͬ�������ĸ澯��Ƶ��������
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
        --����alarm_flash����Ӽ�¼
        INSERT INTO ALARM_FLASH
          (ALARMNUMBER, ALARMTIME, ALARMSTATUS, LOGTIME, LOGID)
        VALUES
          (STRALARMNUMBER, V_ALARMTIME, 0, SYSDATE, SEQ_TRAILNO.NEXTVAL);
      END IF;
      V_RESULT      := 1;
      V_ALARMNUMBER := STRALARMNUMBER;
      IF IISACKED >= 5 OR IISFILTER > 0 THEN
        --�ظ�Ƶ��̫��λ����Ѿ������εĸ澯�Ͳ��÷���Ϣ��
        V_ISREPORT := 0;
      ELSE
        V_ISREPORT := 1;
      END IF;
      V_ERRINFO := NULL;
    ELSIF IALARMCOMINGTYPE = 0 THEN
      --�����¸澯����Ŀǰ�����������Էǳ��ٵģ���˴�����һ��Ҳ����ô��Ӱ�����ܡ�
      --2.1�����Ҹ澯�豸��ϵͳ���е�������Ϣ
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
          STRSTATION    := '0'; --Ĭ��ֵ
          STRROOM       := '0'; --Ĭ��ֵ
      END;

      --2.2 ��EN_ADAPTER_DOMAIN��ȡһЩ������Ϣ
      --Ϊ�˲����ѯ���ѵ�ֵֵ��Ա��ϢҲ�����������ɡ���Ϊ��ĵط�Ӧ�ò����õ�
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
            STRSYSTEM := '0'; --Ĭ��ֵ
            STRVENDOR := 'ZY0800'; --��Ĳ�֪�����ĸ����ҡ�
        END;
     end if;
        BEGIN
          SELECT VENDOR, CURDUTYMAN
            INTO STRVENDOR, STRCURDUTYMAN
            FROM EN_ADAPTER_DOMAIN
           WHERE LABEL = MY_AGENTNAME;
        EXCEPTION
          WHEN OTHERS THEN
            STRSYSTEM := '0'; --Ĭ��ֵ
            STRVENDOR := 'ZY0800'; --��Ĳ�֪�����ĸ����ҡ�
        END;


      --=====���ڸ澯����Ϊ�˿ڼ����£���Ҫ������ҵ�����====---
      IF V_BELONGPORT IS NOT NULL THEN
        BEGIN
          --��Ҫ��ѯ�˿ڱ��
          SELECT LOGICPORT
            INTO STRPORTCODE
            FROM EQUIPLOGICPORT
           WHERE EQUIPCODE = STREQUIPCODE
             AND FRAMESERIAL = V_BELONGFRAME
             AND SLOTSERIAL = V_BELONGSLOT
             AND PACKSERIAL = V_BELONGPACK
             AND PORTSERIAL = V_BELONGPORT;

          --���ȶ��ڶ˿ڸ澯����Ҫ���й�·�澯����
          IF V_OBJCLASS = 'port' THEN
            BEGIN
              SELECT STRSYSTEM || '/' || GETEQUIPSBMCBYPORT(SRC_PORT) || '��' ||
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
              -- ��ڸ澯
              V_ISROOT          := '1';
              V_ISTOPOPORTALARM := 1;
            EXCEPTION
              WHEN OTHERS THEN
                -- ���ǹ�·�˿ڣ��ٲ�ѯҵ���·
                BEGIN
                  --mstp�˿ڴ��ڶ�����¼�����
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
                 decode(c.OPERATIONTYPE, '����ʵʱ����ҵ��', '1', '1')   --�������ݿ�
            INTO STRCIRCUIT, STRCARRYID, V_ISROOT
            FROM  CIRCUIT C
           WHERE (c.portserialno1 = STRPORTCODE OR
                 c.portserialno2 = STRPORTCODE);
                EXCEPTION
                  WHEN OTHERS THEN
                    NULL; --ɶ��û�ҵ�ѽ
                END;
            END;
          ELSE
            --���˶˿ڸ澯ʣ�¾���ʱ϶�澯�ˡ��Ͳ鿴��û�й�ҵ���·
            --�����м�ʱ϶�ĸ澯��û�б�Ҫ�����ˣ�һ�㲻���Ǹ��澯��
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
             decode(c.OPERATIONTYPE, '����ʵʱ����ҵ��', '1', '1')     --�������ݿ�
        INTO STRCIRCUIT, STRCARRYID, V_ISROOT
        FROM CIRCUIT C
       WHERE (c.portserialno1 = STRPORTCODE and c.slot1 = V_BELONGTIMESLOT) or
             (c.portserialno2 = STRPORTCODE and c.slot2 = V_BELONGTIMESLOT);
            EXCEPTION
              WHEN OTHERS THEN
                NULL; --ɶ��û�ҵ�ѽ
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
          STRALARMOBJSHOW := STRALARMOBJSHOW || ',' || V_BELONGSLOT || '��';
          IF V_BELONGPACK IS NOT NULL THEN
            STROBJCODE := STROBJCODE || '=' || V_BELONGPACK;
            IF V_BELONGPORT IS NOT NULL THEN
              STROBJCODE      := STROBJCODE || '=' || V_BELONGPORT;
              STRALARMOBJSHOW := STRALARMOBJSHOW || V_BELONGPORT || '�˿�';
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
        --����Դδͬ���������
        STRALARMOBJSHOW := STRSYSTEM || '/' || STREQUIPLABEL || ',' ||
                           V_ALARMREMARK;
      END IF;

      --��װstrObjCode---����
      --����alarmdefine�ض���澯�������
      IISFILTER := 0;
      IF STRVENDOR <> 'ZY0800' THEN
        --���ǲ�֪������
        ALARMDEFINESETTINGV2(V_SPECIALTY,
                             STRVENDOR,
                             V_ALARMDESC,
                             V_ALARMLEVEL,
                             V_ISTOPOPORTALARM,
                             V_ISROOT_ALARMDESC,
                             IISFILTER,
                             STRALARMDEFID);
      END IF;
      -- ���澯�ж�
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
         DEALPERSON, --��ֵֵ��Ա
         ISFILTER, --�Ƿ����
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
         TRIGGEREDHOUR, --Ƶ�����
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
         NULL, --����ʱ��
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
      --�¸澯ҲҪ��alarm_flash����Ӽ�¼
      INSERT INTO ALARM_FLASH
        (ALARMNUMBER, ALARMTIME, ALARMSTATUS, LOGTIME, LOGID)
      VALUES
        (STRALARMNUMBER, V_ALARMTIME, 0, SYSDATE, SEQ_TRAILNO.NEXTVAL);

      COMMIT;

      -- ���Ŵ������澯
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
        (SYSDATE, 'Alarm_raise_trans', 'exception', V_ERRINFO); --��־
  END;

END ALARM_RAISE_TRANS;

  --����澯�����¼��Ĵ洢����v5.0���Ϸ������棩
  --add by tyh,2007-1-26
  --�ش�Ķ���Ƶ���ж�����򵥻���ֻҪ��Ƶ����صľ�ֱ���ж�ΪƵ����
  --modified by tyh,2007-5-16
  --�ش�Ķ�������澯�ض��幦�ܡ�
  --modified by tyh,2007-5-29
  --ALARMOBJECT,OBJECTCODE��ʱ���ó�һ���ˣ�gui����Ҳ˵���嵽���ĸ��˿��ñ�ţ�����ʾ�õ�strAlarmObjShowŲ��OBSERVEDVALUE��
  --modified by tyh,2007-3-26
  --���¶���ӿ�
  -- modified by chovard @2010-02-01 ���澯����
  -- Modified by Chovard Apr.26 2010 �޸�ʱ϶��ʾ��ʽΪVC4-X, VC12-X
  --�����豸��λ�澯����ϵͳ
  --modified by shma @2011-5-31
/
spool off
