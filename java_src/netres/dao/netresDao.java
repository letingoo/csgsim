package netres.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


import netres.model.StationModel;

public interface netresDao {


	public Integer getStationCount(StationModel station);

	public List getStation(StationModel station);

	
	public String getFromXTBM(String xtbm);//根据编码获取名称
	public String getProvince();
	
	

}
