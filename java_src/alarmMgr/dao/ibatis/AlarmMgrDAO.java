package alarmMgr.dao.ibatis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import alarmMgr.model.AlarmInfoHistory;
import alarmMgr.model.AlarmModel;

public interface AlarmMgrDAO {
    /**
     * 接口
     * */
	public int GetHisAlarmCount(AlarmInfoHistory alarminfo);

	public List<AlarmInfoHistory> GetHisAlarmInfo(AlarmInfoHistory alarminfo);

	//public List<AIFResultModel> getAlarmByConditions(AlarmInfoHistory alarminfo);

	public int updateAlarmById(AlarmInfoHistory alarminfo);
	
	public int getAlarmNowCount(AlarmModel alarmModel);

	public List<AlarmModel> getAlarmByConditions(AlarmModel alarminfo);
	
	public HashMap getAlarmChart(String type);
	
	public List getNowAlarm(Map now_time);
}