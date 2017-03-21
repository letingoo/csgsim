package fiberwire.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.ibatis.sqlmap.client.SqlMapClient;

import fiberwire.model.ChannelRoutModel;
import fiberwire.model.ChannelRoutResultModel;
import fiberwire.model.EquInfoModel;
import fiberwire.model.SystemInfoModel;
import fiberwire.model.BusinessInfoModel;         //liao
@SuppressWarnings("unchecked")
public class FiberWireDAOImpl extends SqlMapClientDaoSupport implements
		FiberWireDAO {

	public List<SystemInfoModel> getSystemTree() {
		List<SystemInfoModel> systems = this.getSqlMapClientTemplate().queryForList(
				"selectSystems");
		return systems;
	}

	public List<EquInfoModel> getAllEquips(String systemcode,Boolean dock,String userId) {
		if(dock)
		{
			Map map = new HashMap();
			map.put("systemcode", systemcode);
			map.put("alarmman", userId);
			return this.getSqlMapClientTemplate().queryForList("selectAllEquips",
					map);
		}
		else
		{
			Map map = new HashMap();
			map.put("systemcode", systemcode);
			map.put("alarmman", userId);
			return this.getSqlMapClientTemplate().queryForList("getAllEquipsWithoutDocking",
					map);
		}
	}
	//liao
		public List<BusinessInfoModel> getSystemBusiness(Map systemcode){
			return getSqlMapClientTemplate().queryForList("selectSystemBusiness",
					systemcode);
		}
	public List<HashMap> getSystemOcables(Map systemcode) {
		return getSqlMapClientTemplate().queryForList("selectSystemOcables",systemcode);
	}
//	public List<HashMap> getSystemFibers(Map systemcode);{
//		return getSqlMapClientTemplate().queryForList("getSystemFibers",systemcode);
//	}
	
	public List<HashMap> getSystemConnectOcable(String system_a, String system_z) {
		Map paraMap = new HashMap();
		paraMap.put("system1", system_a);
		paraMap.put("system2", system_z);
		List<HashMap> list = this.getSqlMapClientTemplate().queryForList(
				"getSystemEquipsWithEquip", paraMap);
		return list;
	}

	public List<HashMap> getEquipTypeXtxx() {
		return this.getSqlMapClientTemplate().queryForList("getEquipTypeXtxx");
	}

	public List<HashMap> getVendorByEquipType(String equipType) {
		return this.getSqlMapClientTemplate().queryForList("getDistinctXtxx",
				equipType);
	}

	public List<HashMap> getEquipmentByVendor(String equiptype,String vendor) {
		Map map = new HashMap();
		map.put("equiptype", equiptype);
		map.put("vendor", vendor);
		return this.getSqlMapClientTemplate().queryForList("getEquip", map);
	}

	public List<HashMap> getDeviceModelList() {
		return this.getSqlMapClientTemplate()
				.queryForList("getDeviceModelList");

	}

	public void updateSystemEquip(ArrayList<EquInfoModel> equiplist) {
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();	
			for (int j = 0; j < equiplist.size(); j++) 
			{
				EquInfoModel equipinfo = equiplist.get(j);
				String equipcode = equipinfo.getEquipcode();
				String systemcode= equipinfo.getSystemcode();
				String x = equipinfo.getX();
				String y = equipinfo.getY();
				Map map = new HashMap();
				map.put("x", x);
				map.put("y", y);
				map.put("equipcode", equipcode);
				map.put("systemcode", systemcode);		
				int count=(Integer)sqlMap.queryForObject("getCountBySystemAndEquip", map);
				if (count==0)
				{
					sqlMap.insert("insertRe_Sys_Equip", map);
				}
				else
				{
												
					sqlMap.update("updateRe_Sys_Equip", map);

				}
			}
			sqlMap.commitTransaction();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}

	}




	public void addSys(SystemInfoModel systemInfo) {
		this.getSqlMapClientTemplate().insert("addSysFlex", systemInfo);
	}

	public int modSys(SystemInfoModel systemInfo) {
		return getSqlMapClientTemplate().update("modSysFlex", systemInfo);
	}

	public void delSys(String systemcode) {
		this.getSqlMapClientTemplate().delete("delSysFlex", systemcode);
	}
	public List<HashMap> getSystemVendor()
	{
		return this.getSqlMapClientTemplate().queryForList("getSystemVendor");
	}
	public List<SystemInfoModel> getSystemByVendor(String vendor)
	{
		return this.getSqlMapClientTemplate().queryForList("getSystemByVendor", vendor);
	}
	
	public ChannelRoutResultModel getChanRoutNameByTopolinkID(String topolinkID)
	{
		return (ChannelRoutResultModel)this.getSqlMapClientTemplate().queryForObject("getChanRoutNameByTopolinkID",topolinkID);
	}
	
	public ChannelRoutResultModel getOcableRoutInfoByFiber(String ocablecode,String fiberserial)
	{
		ChannelRoutModel crm = new ChannelRoutModel();
		crm.setFIBERSERIAL1(fiberserial);
		crm.setOCABLE1(ocablecode);
		return (ChannelRoutResultModel)this.getSqlMapClientTemplate().queryForObject("getOcableRoutInfoByFiber",crm);
	}
	
	public List<ChannelRoutModel> getChannelRoutDataByCRName(String channelroutname)
	{
		return this.getSqlMapClientTemplate().queryForList("getChannelRoutDataByCRName",channelroutname);
	}
	public List getStationNamesByByCRName(String channelroutname)
	{
		return this.getSqlMapClientTemplate().queryForList("getStationNamesByByCRName",channelroutname);
	}
	public void deleteEquipReSys(String equipcode,String systemcode)
	{
		HashMap map=new HashMap();
		map.put("systemcode", systemcode);
		map.put("equipcode", equipcode);
		this.getSqlMapClientTemplate().delete("deleteEquipReSys", map);
	}
//	public void setVisibleInSystem(String equipcode,String systemcode)
//	{
//		HashMap map=new HashMap();
//		map.put("systemcode", systemcode);
//		map.put("equipcode", equipcode);
//		this.getSqlMapClientTemplate().update("setVisibleInSystem", map);
//	}

	public List<EquInfoModel> getEquipsBySystem(String systemcode)
	{
		return this.getSqlMapClientTemplate().queryForList("getEquipsBySystem", systemcode);
	}
	public void addEquipToSystem(String systemcode,String equipcode)
	{
		HashMap map=new HashMap();
		map.put("systemcode", systemcode);
		map.put("equipcode", equipcode);
		this.getSqlMapClientTemplate().insert("addEquipToSystem", map);
	}
	public List<HashMap> getPortsByLabel(String label)
	{
		return this.getSqlMapClientTemplate().queryForList("getPortsByLabel",label);
	}
	public List getEquipCc(String belongequip,String start,String end){
		Map para=new HashMap();
		para.put("belongequip", belongequip);
		para.put("start", start);
		para.put("end", end);
		return this.getSqlMapClientTemplate().queryForList("getEquipCc",
				para);
	}
	public int getEquipCcCount(String belongequip){
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getEquipCcCount", belongequip);
	}
	public List getPortByEquip(String equip){
		return this.getSqlMapClientTemplate().queryForList("getPortByEquip1",equip);
	}
	 public List searchTasks(String start,String end){
		 Map m = new HashMap();
		 m.put("start", "");
		 m.put("end", "");
		 return this.getSqlMapClientTemplate().queryForList("searchTasks");
	 }
	 public int searchTaskCount(){
		 try {
				return (Integer) this.getSqlMapClientTemplate().queryForObject("searchTaskCount");
			} catch (DataAccessException e) {
				e.printStackTrace();
				return 0;
			}
	 }
	 
	 public void insertTask(Map taskObject,List portList){
		 SqlMapClient sqlMap = this.getSqlMapClient();
			try {
				sqlMap.startTransaction();
				String code = (String)sqlMap.insert("insertTask",taskObject);
				for(int i=0;i<portList.size();i++){
					Map m =(Map) portList.get(i);
					Map para= new HashMap();
					para.put("task_id", code);
					para.put("eq_code", m.get("equip").toString());
					System.out.println(m.get("equip").toString()+"xxx");
					para.put("eq_port", m.get("code").toString());
					para.put("eq_ts", m.get("solt").toString());
					sqlMap.insert("insertTaskObject",para);
				}
				sqlMap.commitTransaction();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				
			}finally{
				try {
					sqlMap.endTransaction();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
	 }
	 
	 public void delTask(String id){
//		 this.getSqlMapClientTemplate().delete("delTask", id);
		 String objId=id;
		 SqlMapClient sqlMap = this.getSqlMapClient();
			try {
				sqlMap.startTransaction();
				sqlMap.delete("delTask", id);
				sqlMap.delete("delTaskObject",objId);
				sqlMap.commitTransaction();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				
			}finally{
				try {
					sqlMap.endTransaction();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
	 }
	 public void updateTask(Map taskObject,List portList){
		 String objId=taskObject.get("task_id").toString();
		 SqlMapClient sqlMap = this.getSqlMapClient();
			try {
				sqlMap.startTransaction();
				sqlMap.delete("delTaskObject", objId);
				sqlMap.update("updateTask", taskObject);
				for(int i=0;i<portList.size();i++){
					Map m =(Map) portList.get(i);
					Map para= new HashMap();
					para.put("task_id", objId);
					para.put("eq_code", m.get("equip"));
					para.put("eq_port", m.get("code"));
					para.put("eq_ts", m.get("solt"));
					sqlMap.insert("insertTaskObject",para);
				}
				sqlMap.commitTransaction();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				
			}finally{
				try {
					sqlMap.endTransaction();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
	 }
	 public String getTypeBycircuitCode(String circuitCode){
		  List list=this.getSqlMapClientTemplate().queryForList("getTypeBycircuitCode",circuitCode);
		  if(list.size()>0){
			 Map m = (Map) list.get(0);
			 Object result = m.get("X_PURPOSE");
			 if(result!=null){
				 return  m.get("X_PURPOSE").toString();
			 }else{
				 //更新电路信息
				 this.getSqlMapClientTemplate().update("updateCircuitX_PURPOSEByMap", circuitCode);
				 return "其它业务";
			 }
			
		  }else{
			  return "";
		  }
	 }

	public int getPortsByEquipcodeCount(String equipcode) {
		if(equipcode.split(",").length==1){
			return Integer.parseInt((this.getSqlMapClientTemplate().queryForObject("getPortsByEquipcodeCount",equipcode).toString()));	
		}else{
			Map map = new HashMap();
			map.put("equipcode", equipcode.split(",")[0]);
			map.put("frameserial", equipcode.split(",")[1]);
			map.put("slotserial", equipcode.split(",")[2]);
			map.put("packserial", equipcode.split(",")[3]);
			return Integer.parseInt(this.getSqlMapClientTemplate().queryForObject("getPortsByEquipcodeInfoBylotCount", map).toString());
		}
		
		
	}
/**
 * 第一种是查网元下的所有端口
 * 第二种是查盘下的端口信息
 * @author jtsun
 * @2013-04-03
 */
	public List getPortsByEquipcodeInfo(String equipcode,String start,String end) {
		if(equipcode.split(",").length==1){
			Map para = new HashMap();
			para.put("equipcode",equipcode);
			para.put("start",start);
			para.put("end",end);
		return this.getSqlMapClientTemplate().queryForList("getPortsByEquipcodeInfo", para);
		}else{
			Map map = new HashMap();
			map.put("equipcode", equipcode.split(",")[0]);
			map.put("frameserial", equipcode.split(",")[1]);
			map.put("slotserial", equipcode.split(",")[2]);
			map.put("packserial", equipcode.split(",")[3]);
			map.put("start",start);
			map.put("end",end);
			return this.getSqlMapClientTemplate().queryForList("getPortsByEquipcodeInfoBylot", map);
		}
		
	}

	@Override
	public List getPortsPerTrend(String logicport,String time,String date) {
		Map para= new HashMap();
		para.put("logicport", logicport);
		para.put("time", time); 
		para.put("date", date);
		if(time.equalsIgnoreCase("24h")){
			return this.getSqlMapClientTemplate().queryForList("getPortsPerTrend_h", para);	
		}else{
			return this.getSqlMapClientTemplate().queryForList("getPortsPerTrend", para);	
		}
		
	}
	public List<EquInfoModel> getAllEquipsByCount(String systemcode,Boolean dock,String userId,String count) {
		if(dock)
		{
			Map map = new HashMap();
			map.put("systemcode", systemcode);
			map.put("alarmman", userId);
			map.put("count", count);
			return this.getSqlMapClientTemplate().queryForList("selectAllEquips",
					map);
		}
		else
		{
			Map map = new HashMap();
			map.put("systemcode", systemcode);
			map.put("alarmman", userId);
			map.put("count", count);
			return this.getSqlMapClientTemplate().queryForList("getAllEquipsWithoutDocking",
					map);
		}
	}
	
	
	public Map selectOcables(String label) {
		Map ob = new HashMap();
		String opticalcode="";
		String ocablecode="";		
		String resid = "";
		//Map temp = new HashMap();
		//Map temp = (HashMap) this.getSqlMapClientTemplate().queryForObject("selectresid",label);		
		//System.out.println(temp.toString());
		//resid=temp.get("RESID").toString();
		
		resid = (String)this.getSqlMapClientTemplate().queryForObject("selectresid",label);
		if(resid!=null&&!"".equals(resid)){
			opticalcode = (String)this.getSqlMapClientTemplate().queryForObject("selectOptical",resid);
			if(opticalcode!=null&&!"".equals(opticalcode)){
				ocablecode = (String)this.getSqlMapClientTemplate().queryForObject("selectOcables",opticalcode);
			}
		}
		
		ob.put("opticalcode", opticalcode);
		ob.put("ocablecode", ocablecode);
		ob.put("resid", resid);
		System.out.println(opticalcode+" "+ocablecode) ;
		return ob;
	}

	@Override
	public List<HashMap> getSystemFibers(Map systemcode) {
		// TODO Auto-generated method stub
		return getSqlMapClientTemplate().queryForList("getSystemFibers",systemcode);
	}
}
