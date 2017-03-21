package netres.dao;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import netres.model.StationModel;


import org.springframework.orm.ibatis.SqlMapClientCallback;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;


import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapExecutor;

public class netresDaoImpl extends SqlMapClientDaoSupport implements  netresDao {
	
	
	public Integer getStationCount(StationModel station) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getStationCount", station);
	}

	public List getStation(StationModel station) {
		return this.getSqlMapClientTemplate().queryForList("getStation", station);
	}

	
	
	public String getFromXTBM(String xtbm){
		String xml = "<names>";
		HashMap<String,String> resultMap = new HashMap<String,String>();
		List<String> list = getXTBMList(xtbm);
		for(Iterator it = list.iterator();it.hasNext();){
			resultMap = (HashMap)it.next();
			String xtbm_t = (String)resultMap.get("XTBM") != null ? (String)resultMap.get("XTBM") : "";
			String xtxx = (String)resultMap.get("XTXX") != null ? (String)resultMap.get("XTXX") : "";
			xml +=  "<name label =\""+xtxx+"\"code=\""+xtbm_t+"\"/>";
		}
		xml +="</names>";
		return xml;
	}
	
	private List<String> getXTBMList(String xtbm){
		return (List<String>)this.getSqlMapClientTemplate().queryForList("getXTBMList1",xtbm);
	}
	
	public String getProvince(){
		String xml = "<names>";
		HashMap<String,String> resultMap = new HashMap<String,String>();
		List<String> list = getprovince();
		for(Iterator it = list.iterator();it.hasNext();){
			resultMap = (HashMap)it.next();
			String province = (String)resultMap.get("PROVINCE") != null ? (String)resultMap.get("PROVINCE") : "";
			String provincename = (String)resultMap.get("PROVINCENAME") != null ? (String)resultMap.get("PROVINCENAME") : "";
			xml +=  "<name label =\""+provincename+"\"code=\""+province+"\"/>";
		}
		xml +="</names>";
		return xml;
	}
	private List<String> getprovince(){
		return (List<String>)this.getSqlMapClientTemplate().queryForList("getProvince");
	}

}
