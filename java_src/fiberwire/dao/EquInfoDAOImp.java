package fiberwire.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import netres.model.ComboxDataModel;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.ibatis.sqlmap.client.SqlMapClient;

import fiberwire.model.EquInfoModel;
import fiberwire.model.TopoLinkModel;

public class EquInfoDAOImp extends SqlMapClientDaoSupport implements EquInfoDAO{
    
	
	public EquInfoModel getEquInfoByEquCode(String equCode){
		
		return (EquInfoModel)this.getSqlMapClientTemplate().queryForObject("getEquipmentPropertyForChannelRouteFlex",equCode);
	}
	public void updateEquInfo(EquInfoModel model)
	{
		this.getSqlMapClientTemplate().update("updateEquInfo", model);
	}
	
	public String insertEquInfo(EquInfoModel model){
		String equipcode = "";
		SqlMapClient sqlMap = this.getSqlMapClient();
		try
		{
			sqlMap.startTransaction();
			HashMap map=new HashMap();
			map.put("systemcode", model.getSystemcode());
			map.put("remark", "");
			map.put("updateperson", model.getUpdateperson());
			map.put("updatedate", model.getUpdatedate());
			//map.put("system_name", model.getSystem_name());
			equipcode = (String)sqlMap.insert("insertEquInfo",model);
			map.put("equipcode", equipcode);
			if(model.getSystemcode() != "")
				sqlMap.insert("insertRe_sys_equip", map);
			sqlMap.commitTransaction();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				sqlMap.endTransaction();
			}
			catch(SQLException ex)
			{
				ex.printStackTrace();
			}
		}
		return equipcode;
	}

	
	@SuppressWarnings("unchecked")
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
	@SuppressWarnings("unchecked")
	private List<String> getXTBMList(String xtbm){
		return (List<String>)this.getSqlMapClientTemplate().queryForList("getXTBMList2",xtbm);
	}
	@SuppressWarnings("unchecked")
	public String getSystems(){
		String xml = "<names>";
		HashMap<String,String> resultMap = new HashMap<String,String>();
		List<String> list = getSystemList();
		for(Iterator it = list.iterator();it.hasNext();){
			resultMap = (HashMap)it.next();
			String systemcode = (String)resultMap.get("SYSTEMCODE") != null ? (String)resultMap.get("SYSTEMCODE") : "";
			String sysname = (String)resultMap.get("SYSNAME") != null ? (String)resultMap.get("SYSNAME") : "";
			xml +=  "<name label =\""+sysname+"\"code=\""+systemcode+"\"/>";
		}
		xml +="</names>";
		return xml;
	}
	
	@SuppressWarnings("unchecked")
	private List<String> getSystemList(){
		return (List<String>)this.getSqlMapClientTemplate().queryForList("getSystemList",null);
	}
	
	
	
	public List<HashMap> getCarryOperaN1(String equipcode){
		return this.getSqlMapClientTemplate().queryForList("getCarryOperaN1",equipcode);
	}
	public List<HashMap> getCarryOperaByLogicPortN1(String logicport)//通过设备端口号查看设备业务信息
	{
		return this.getSqlMapClientTemplate().queryForList("getCarryOperaByLogicPortN1",logicport);
	}
	
	public List<HashMap> getCarryOperaByTopolinkN1(String label)
	{
		return this.getSqlMapClientTemplate().queryForList("getCarryOperaByTopoLinkN1",label);
	}
	
	public List<HashMap> hasEquipPack(String equipcode){
		return this.getSqlMapClientTemplate().queryForList("hasEquipPack",equipcode);
	}
	public void delEquip(String equipcode){
		this.getSqlMapClientTemplate().delete("delEquip", equipcode);
	}
	public int getDeviceCountByStationcode(String stationcode){
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getDeviceCountByStationcode",stationcode);
	}
	public List<EquInfoModel> getDeviceList_Flex(String stationcode,int start,int end){
		return this.getSqlMapClientTemplate().queryForList("getListByStationcode",stationcode);
	}
	//获取设备按厂家分类的分析
	public List<HashMap> getDeviceSummaryByVendor(String stationcode){
		return this.getSqlMapClientTemplate().queryForList("getDeviceSummaryByVendor",stationcode);
	}
	public List<HashMap> getDeviceSummaryByType(String stationcode){
		return this.getSqlMapClientTemplate().queryForList("getDeviceSummaryByType",stationcode);
	}
	
	public List<ComboxDataModel> getProvince()
	{
		return this.getSqlMapClientTemplate().queryForList("getProvince");
		
	}
	@Override
	public String getMaxCircuitcode() {
		return (String) this.getSqlMapClientTemplate().queryForObject("getMaxCircuitcode");
	}
}
