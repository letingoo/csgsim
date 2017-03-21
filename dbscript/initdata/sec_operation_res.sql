delete from  SEC_OPERATION_RES s where s.parent_id='3518' or s.oper_id='3518';
commit;
prompt Loading SEC_OPERATION_RES...
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (3518, '网络监视', 0, '', '1', 'alert_square_red', 'assets/images/mntsubject/mntsubjectmenu/alert_square_red.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45482, '综合监视', 3518, '', '', 'zonghe', 'assets/images/mntsubject/mntsubjectmenu/zonghe.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45483, '根告警管理', 3518, '', '', 'gengaojing', 'assets/images/mntsubject/mntsubjectmenu/gengaojing.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45484, '历史根告警', 3518, '', '', 'lishi', 'assets/images/mntsubject/mntsubjectmenu/lishi.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45485, '告警管理', 3518, '', '', 'gaojingguanli', 'assets/images/mntsubject/mntsubjectmenu/gaojingguanli.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45486, '告警重定义', 3518, '', '', 'gaojingchoongding', 'assets/images/mntsubject/mntsubjectmenu/gaojingchoongding.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45487, '告警处理经验维护', 3518, '', '', 'gaojingchuli', 'assets/images/mntsubject/mntsubjectmenu/gaojingchuli.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45488, '告警配置', 3518, '', '', 'gaojingpeizhi', 'assets/images/mntsubject/mntsubjectmenu/gaojingpeizhi.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45496, '原始告警', 3518, '', '', 'yanshi', 'assets/images/mntsubject/mntsubjectmenu/yanshi.png');
insert into sec_operation_res (OPER_ID, OPER_NAME, PARENT_ID, OPER_DESC, ISCHILDEN, MENUICON, SHORTCUTICON)
values (45497, '当前告警', 3518, '', '', 'alarmIcon', 'assets/images/shortcuts/st_nowalarm.png');
commit;

delete from MNT_ALARM_WATCH_CONFIG;
commit;
prompt Loading MNT_ALARM_WATCH_CONFIG...
insert into MNT_ALARM_WATCH_CONFIG (ID, ENDESC, ZHDESC, ISSTATUS, ISENABLE, UPDATEPERSON, UPDATEDATE, REMARK)
values ('1001', 'alarmsoundset', '告警声音提示', 'N', 'Y', 'slzh', null, null);
commit;
/