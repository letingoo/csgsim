package alarmMgr.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import alarmMgr.dao.ibatis.AlarmMgrDAO;
import alarmMgr.model.AIFResultModel;
import alarmMgr.model.AlarmInfoHistory;
import alarmMgr.model.AlarmModel;

public class AlarmMgrDAOImp implements AlarmMgrDAO {

	private SqlMapClientTemplate sqlMapClientTemplate;

	/**
	 * @param sqlMapClientTemplate
	 *            the sqlMapClientTemplate to set
	 */
	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}

	/**
	 * @return the sqlMapClientTemplate
	 */
	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}

	public int GetHisAlarmCount(AlarmInfoHistory alarminfo) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getHisAlarmCount", alarminfo);
	};

	public List<AlarmInfoHistory> GetHisAlarmInfo(AlarmInfoHistory alarminfo) {
		return this.getSqlMapClientTemplate().queryForList("getHisAlarmInfo",
				alarminfo);
	};

//	public List<AIFResultModel> getAlarmByConditions(AlarmInfoHistory alarminfo) {
//		return getSqlMapClientTemplate().queryForList("getAlarmByConditions",
//				alarminfo);
//	};

	public int updateAlarmById(AlarmInfoHistory alarminfo) {
		return getSqlMapClientTemplate().update("updateAlarmById", alarminfo);
	}
	
	@SuppressWarnings("unchecked")
	public int getAlarmNowCount(AlarmModel alarmModel){
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getAlarmNowCount",alarmModel);
	}
	public List<AlarmModel> getAlarmByConditions(AlarmModel alarmModel) {
//		HashMap map=new HashMap();
//        map.put("arrivetime", arrivetime);
        return getSqlMapClientTemplate().queryForList("getAlarmByConditions",alarmModel);
    }
	@SuppressWarnings("unchecked")
	public HashMap getAlarmChart(String type){
		return (HashMap)getSqlMapClientTemplate().queryForObject("getAlarmChart", type);
	}

	public List getNowAlarm(Map map){
		return this.getSqlMapClientTemplate().queryForList("getNowAlarm", map);
	}
}