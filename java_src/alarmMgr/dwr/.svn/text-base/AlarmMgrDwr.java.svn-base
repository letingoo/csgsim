package alarmMgr.dwr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import alarmMgr.dao.AlarmMgrDAOImp;
import alarmMgr.model.AIFResultModel;
import alarmMgr.model.AlarmInfoHistory;
import alarmMgr.model.AlarmModel;
import alarmMgr.model.AlarmObjects;
import alarmMgr.model.AlarmResultModel;
import alarmMgr.model.AlarmTypeModel;

public class AlarmMgrDwr {

	private AlarmMgrDAOImp amd;

	/**
	 * @param amd
	 *            the amd to set
	 */
	public void setAmd(AlarmMgrDAOImp amd) {
		this.amd = amd;
	}

	/**
	 * @return the amd
	 */
	public AlarmMgrDAOImp getAmd() {
		return amd;
	}

	public AIFResultModel getAlarmInfoHistory(AlarmInfoHistory aifh) {
		AIFResultModel aifrm = new AIFResultModel();
		aifrm.setOrderList(amd.GetHisAlarmInfo(aifh));
		aifrm.setTotalCount(amd.GetHisAlarmCount(aifh));
		return aifrm;
	}
	
	public AlarmResultModel getAlarmByConditions(AlarmModel alarmModel){
		AlarmResultModel result = new AlarmResultModel();
		result.setTotalCount(amd.getAlarmNowCount(alarmModel));
		result.setAlarmList(amd.getAlarmByConditions(alarmModel));
		return result;
		
	}
	

	
	public AlarmObjects alarmChartData(String type)
	{
		try 
		{
			HashMap alarmpie=amd.getAlarmChart(type);
		
			String temp_xml = "";
			List datalist = new ArrayList();
			
			if(Integer.parseInt(alarmpie.get("CRITICAL").toString())==0 && 
			   Integer.parseInt(alarmpie.get("MAJOR").toString())==0 &&
			   Integer.parseInt(alarmpie.get("MINOR").toString())==0 && 
			   Integer.parseInt(alarmpie.get("WARNING").toString())==0 &&
			   Integer.parseInt(alarmpie.get("OTHER").toString())==0)
			{
				datalist = null;
			}
			else
			{
				if(Integer.parseInt(alarmpie.get("CRITICAL").toString())!=0)
				{
					AlarmTypeModel alar = new AlarmTypeModel();
					alar.setAlarmtype("紧急");
					alar.setAlarmCount(Integer.parseInt(alarmpie.get("CRITICAL").toString()));
					datalist.add(alar);
				}
				if(Integer.parseInt(alarmpie.get("MAJOR").toString())!=0)
				{
					AlarmTypeModel alar = new AlarmTypeModel();
					alar.setAlarmtype("主要");
					alar.setAlarmCount(Integer.parseInt(alarmpie.get("MAJOR").toString()));
					datalist.add(alar);
				}
				if(Integer.parseInt(alarmpie.get("MINOR").toString())!=0)
				{
					AlarmTypeModel alar = new AlarmTypeModel();
					alar.setAlarmtype("次要");
					alar.setAlarmCount(Integer.parseInt(alarmpie.get("MINOR").toString()));
					datalist.add(alar);
				}
				if(Integer.parseInt(alarmpie.get("WARNING").toString())!=0)
				{
					AlarmTypeModel alar = new AlarmTypeModel();
					alar.setAlarmtype("提示");
					alar.setAlarmCount(Integer.parseInt(alarmpie.get("WARNING").toString()));
					datalist.add(alar);
				}
				if(Integer.parseInt(alarmpie.get("OTHER").toString())!=0)
				{
					AlarmTypeModel alar = new AlarmTypeModel();
					alar.setAlarmtype("其它");
					alar.setAlarmCount(Integer.parseInt(alarmpie.get("OTHER").toString()));
					datalist.add(alar);
				}
			}
			AlarmObjects alars =new AlarmObjects();
			alars.setObj(datalist);

			return alars;
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	public String isNowAlarm(){
		String  flag="0";
		AlarmResultModel result = new AlarmResultModel();
		Map map = new HashMap();
		List list = amd.getNowAlarm(map);
		if(list==null||list.size()<=0){
			flag="0";
		}else{
			flag="1";
		}
		return flag;
	}
}