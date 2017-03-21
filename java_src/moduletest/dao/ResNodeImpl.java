package moduletest.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import netres.model.ComboxDataModel;

import org.springframework.orm.ibatis.SqlMapClientCallback;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import resManager.resNet.model.LogicPort;
import resManager.resNode.model.EquipFrame;
import resManager.resNode.model.EquipPack;
import resManager.resNode.model.FiberModel;
import resManager.resNode.model.FrameSlot;
import resManager.resNode.model.OcableModel;
import resManager.resNode.model.StationModel;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapExecutor;

import devicepanel.model.PackInfoModel;
public class ResNodeImpl  extends SqlMapClientDaoSupport implements ResNodeDao {


	
	public void modifyEquipFrame(EquipFrame frame) {

		this.getSqlMapClientTemplate().update("modifyEquipFrame", frame);
	}

	public Integer getStationCount(StationModel station) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getStationCount", station);
	}

	public List getStation(StationModel station) {
		return this.getSqlMapClientTemplate().queryForList("getStation", station);
	}
	

	public int delStation(String stationcode) {

		Map map=new HashMap();
		map.put("stationcode", stationcode);
		map.put("modelname", "光缆路由图"); 
		this.getSqlMapClientTemplate().delete("deleteCoordinatesByStationcode", map);
		//删除光缆拓扑图中的数据
		return this.getSqlMapClientTemplate().delete("deleteStation", stationcode);
	}
	

	public List getStationType()
	{
	    return this.getSqlMapClientTemplate().queryForList("getStationType");
	}
	
	public String getStationCodeByName(String stationName){
		return (String)this.getSqlMapClientTemplate().queryForObject("getStationCodeByName",stationName);
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
		
		System.out.println("--------------"+xtbm);
		return (List<String>)this.getSqlMapClientTemplate().queryForList("getXTBMList",xtbm);
	}
	
	/**
	 * 获取电压值
	 */
	public List getVoltValue(){
		return this.getSqlMapClientTemplate().queryForList("getVoltValue");
	}
	
	public void updateStationNameStd(String stationcode) {
        this.getSqlMapClientTemplate().update("updateStationNameStd", stationcode);		
	}

	
	public int delOcable(String ocablecode) {

		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().delete("delOcable", ocablecode);
	}


	public List getOcable(OcableModel ocable) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getOcable", ocable);
	}

	
	public Integer getOcableCount(OcableModel ocable) {
		// TODO Auto-generated method stub
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getOcableCount", ocable);
	}

	
	public int updateOcableNameStd(String ocablecode) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().update("updateOcableNameStd", ocablecode);
	}

	public OcableModel getEnOcableByCode(String ocablecode){
		// TODO Auto-generated method stub
		return (OcableModel)this.getSqlMapClientTemplate().queryForObject("getEnOcableByCode", ocablecode);
	} 
	
	public int getFibercountByOcableCode(String ocablecode){
		// TODO Auto-generated method stub
		return (Integer)this.getSqlMapClientTemplate().queryForObject("getFibercountByOcableCode", ocablecode);
	} 
	
	public void addFibers(final List lst) {
		this.getSqlMapClientTemplate().execute(new SqlMapClientCallback() {
			public Object doInSqlMapClient(SqlMapExecutor executor)
					throws SQLException {
				executor.startBatch();
				for (int i = 0; i < lst.size(); i++) {
					FiberModel evDto = (FiberModel) lst.get(i);
					executor.insert("addFibersbyOcable", evDto);
				}
				executor.executeBatch();
				return null;
			}

			
		});

	}
	
	@Override
	public int delFiber(String fibercode) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().delete("delFiber", fibercode);
	}

	@Override
	public List getFiber(FiberModel fiber) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getFiber", fiber);
	}

	@Override
	public Integer getFiberCount(FiberModel fiber) {
		// TODO Auto-generated method stub
		return (Integer) this.getSqlMapClientTemplate().queryForObject("getFiberCount", fiber);
	}
	/**
	 * 获取机盘信息
	 * */
	public List GetEquipPack(EquipPack equipPack) {
		return this.getSqlMapClientTemplate()
				.queryForList("getEquipPack", equipPack);
	}
	/**
	 * 获取机盘数量
	 * */
	public int GetEquipPackCount(EquipPack equipPack) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"GetEquipPackCount", equipPack);
	}
	/**
	 * 添加机盘
	 */
	public void AddEquipPack(EquipPack equipPack) {
		
		SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();
			this.getSqlMapClientTemplate().insert("addEquipPack", equipPack);
			String vm=sqlMap.queryForObject("getDeviceModel", equipPack.getEquipcode()).toString();
			String vendor=vm.split(",")[0];
			String x_model=vm.split(",")[1];
			Map<String,Object> map1=new HashMap<String,Object>();
			map1.put("vendor", vendor);
			map1.put("equipmodel", x_model);
			map1.put("packmodel",  equipPack.getPackmodel());
			//插入端口
			List<PackInfoModel> lst = sqlMap.queryForList("getPackInfoByVendorModel", map1);
			int portnum = 0;
			for(int j=0;j<lst.size();j++){
				portnum = Integer.parseInt(lst.get(j).getPortnum());//端口数量
				String x_capability = lst.get(j).getX_capability();//端口速率
				//只有电支路口，线路口，以太网口和其他
				String porttype="";
				if("ZY070101".equals(x_capability)){
					porttype="ZY03070403";//电路端口
				}else if("ZY070105".equals(x_capability)||"ZY070106".equals(x_capability)||"ZY070107".equals(x_capability)||"ZY070108".equals(x_capability)){
					porttype="ZY03070402";//光路端口
				}else if("ZY070116".equals(x_capability)||"ZY070115".equals(x_capability)||"ZY070117".equals(x_capability)){
					porttype="ZY03070405";//网口
				}else{
					porttype="ZY03070499";//其他
				}
				for(int i=0;i<portnum;i++){
					LogicPort port=new LogicPort();
					port.setEquipcode(equipPack.getEquipcode());
					port.setFrameserial(equipPack.getFrameserial());
					port.setSlotserial(equipPack.getSlotserial());
					port.setPackserial(equipPack.getPackserial());
					port.setPortserial(String.valueOf(i+1));
					port.setY_porttype(porttype);//端口类型由盘决定，目前暂时没建关联表
					port.setX_capability(x_capability);
					port.setConnport("");
					port.setRemark("");
					port.setStatus("ZY13100201");//端口状态
					port.setUpdatedate(equipPack.getUpdatedate());
					port.setUpdateperson("root");
					sqlMap.insert("addLogicPort", port);
				}
			}
			sqlMap.commitTransaction();
		}catch(Exception ex){
			System.out.print(ex.toString());
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

	public int delEquipPack(EquipPack equipPack) {
		return this.getSqlMapClientTemplate().delete("deleteEquipPack", equipPack);
	}
	/**
	 * 修改机盘
	 */
	public int ModifyPack(EquipPack equipPack) {
		SqlMapClient sqlMap = this.getSqlMapClient();
		int result=0;
		try 
		{
			sqlMap.startTransaction();
			//先删除盘下的端口，再插入
			result=  this.getSqlMapClientTemplate().update("ModEquipPack", equipPack);
			sqlMap.delete("deleteEquiplogicPortByModel",equipPack);
			
			String vm=sqlMap.queryForObject("getDeviceModel", equipPack.getGb_equipcode()).toString();
			String vendor=vm.split(",")[0];
			String x_model=vm.split(",")[1];
			Map<String,Object> map1=new HashMap<String,Object>();
			map1.put("vendor", vendor);
			map1.put("equipmodel", x_model);
			map1.put("packmodel",  equipPack.getPackmodel());
			
			List<PackInfoModel> lst = sqlMap.queryForList("getPackInfoByVendorModel", map1);
			int portnum = 0;
			for(int j=0;j<lst.size();j++){
				portnum = Integer.parseInt(lst.get(j).getPortnum());//端口数量
				String x_capability = lst.get(j).getX_capability();//端口速率
				//只有电支路口，光路口，以太网口和其他
				String porttype="";
				if("ZY070101".equals(x_capability)){
					porttype="ZY03070403";//电路端口
				}else if("ZY070105".equals(x_capability)||"ZY070106".equals(x_capability)||"ZY070107".equals(x_capability)||"ZY070108".equals(x_capability)){
					porttype="ZY03070402";//光路端口
				}else if("ZY070116".equals(x_capability)||"ZY070115".equals(x_capability)||"ZY070117".equals(x_capability)){
					porttype="ZY03070405";//网口
				}else{
					porttype="ZY03070499";//逻辑网口
				}
				for(int i=0;i<portnum;i++){
					LogicPort port=new LogicPort();
					port.setEquipcode(equipPack.getGb_equipcode());
					port.setFrameserial(equipPack.getGb_frameserial());
					port.setSlotserial(equipPack.getGb_slotserial());
					port.setPackserial(equipPack.getPackserial());
					port.setPortserial(String.valueOf(i+1));
					port.setY_porttype(porttype);//端口类型由盘决定，目前暂时没建关联表
					port.setX_capability(x_capability);
					port.setConnport("");
					port.setRemark("");
					port.setStatus("ZY13100201");//端口状态
					port.setUpdatedate(equipPack.getUpdatedate());
					port.setUpdateperson("root");
					sqlMap.insert("addLogicPort", port);
				}
			}
			
			sqlMap.commitTransaction();
		}catch(Exception ex){
			System.out.print(ex.toString());
		}finally {
			try {
				sqlMap.endTransaction();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}
	
	public List getPackModel()
	{
		return this.getSqlMapClientTemplate().queryForList("getPackModel");
	}
	
	public List getSystemByVender(String vender) {
		return this.getSqlMapClientTemplate().queryForList("getSystemByVender",
				vender);
	}

	/**
	 * 台账--机框的添加功能--选择设备
	 * 
	 */
	public List getEquipByeqsearch(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getEquipByeqsearch",map);
	}

	@Override
	public int GetEquipFrameCount(EquipFrame equipframe) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject(
				"getEquipFrameCount", equipframe);
	}

	@Override
	public List GetEquipFrame(EquipFrame equipframe) {
		return this.getSqlMapClientTemplate().queryForList("getEquipFrame",
				equipframe);
	}

	@Override
	public List<ComboxDataModel> getVender() {
		return this.getSqlMapClientTemplate().queryForList("getVender", null);
	}

	@Override
	public String getEquipFrameVendorById(String vender) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipFrameVendorById",vender);
	}

	@Override
	public String getEquipFrameStateById(String frame_state) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipFrameStateById", frame_state);
	}

	@Override
	public String getEquipFrameModelById(String framemodel) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipFrameModelById", framemodel);
	}

//	@Override
//	public int delEquipFrame(String equipcode) {
//		return this.getSqlMapClientTemplate().delete("delEquipFrame",equipcode);
//	}

	@Override
	public List<ComboxDataModel> getFrameState() {
		return this.getSqlMapClientTemplate().queryForList("getFrameStateLst", null);
	}

	@Override
	public List<ComboxDataModel> getFrameModel() {
		return this.getSqlMapClientTemplate().queryForList("getFrameModelLst", null);
	}

	@Override
	public List<ComboxDataModel> getFrameSlotStatus() {
		return this.getSqlMapClientTemplate().queryForList("getFrameSlotStatus", null);
	}

	@Override
	public String getSlotStatusById(String status) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getSlotStatusById", status);
	}

	@Override
	public int getFrameSlotCount(FrameSlot model) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject("getFrameSlotCount", model);
	}

	@Override
	public List<FrameSlot> getEFrameSlotLst(FrameSlot model) {
		return this.getSqlMapClientTemplate().queryForList("getEFrameSlotLst", model);
	}

//	@Override
//	public int delFrameSlot(String equipcode) {
//		return this.getSqlMapClientTemplate().delete("delFrameSlot",equipcode);
//	}

	@Override
	public String getShelfinfoNameById(String shelfinfo) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getShelfinfoNameById", shelfinfo);
	}

	@Override
	public String getFramenameById(String framename) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getFramenameById", framename);
	}

	@Override
	public List<ComboxDataModel> getFrameserialByeId(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getFrameserialByeId", equipcode);
	}

	@Override
	public String getFrameserialByeName_std(String id) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getFrameserialByeName_std", id);
	}
	
		public List<HashMap> selectDomainFlex() {
		return getSqlMapClientTemplate().queryForList(
				"selectDomainFlexForNetres");
	}

	public List<HashMap> selectProvinceFlex(Map map) {
		return getSqlMapClientTemplate().queryForList(
				"selectProvinceFlexForNetres", map);
	}
	
	public List<HashMap> selectStationFlex(Map map) {
		return getSqlMapClientTemplate().queryForList(
				"selectStationFlexForNetres", map);
	}

	@Override
	public List<ComboxDataModel> getLogicportserialByEquip(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getLogicportserialByEquip", equipcode);
	}
	
	@Override
	public List<ComboxDataModel> getLogicportserialByEquipNew(String equipcode) {
		return this.getSqlMapClientTemplate().queryForList("getLogicportserialByEquipNew", equipcode);
	}

	@Override
	public FiberModel getFiberByCode(String fibercode) {
		// TODO Auto-generated method stub
		return (FiberModel)this.getSqlMapClientTemplate().queryForObject("getFiberByCode",fibercode);
	}

	@Override
	public void AddEquipFrame(EquipFrame equipframe) {
		this.getSqlMapClientTemplate().insert("addEquipFrame", equipframe);
	}

	@Override
	public void AddEquipSlot(FrameSlot equipslot) {
		this.getSqlMapClientTemplate().insert("addEquipSlot", equipslot);
	}

	@Override
	public List<ComboxDataModel> getPackModels(String equipcode) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getPackModels", equipcode);
	}

	@Override
	public void modifyEquipSlot(FrameSlot slot) {

		this.getSqlMapClientTemplate().update("modifyEquipSlot", slot);
	}

	@Override
	public List<ComboxDataModel> getSlotserialByeIds(Map map) {

		return this.getSqlMapClientTemplate().queryForList("getSlotserialByeIds", map);
	}

	@Override
	public List<ComboxDataModel> getPortseriaByIds(Map map) {
		return this.getSqlMapClientTemplate().queryForList("getPortseriaByIds", map);
	}

	@Override
	public List<EquipPack> checkPackSerial(Map map) {
		return this.getSqlMapClientTemplate().queryForList("checkPackSerial", map);
	}

	public List<HashMap> selectSystemForEquipment(Map map) {
		return getSqlMapClientTemplate().queryForList(
				"selectSystemForEquipment", map);
	}
	
	public List<HashMap> selectEquipmentFlex(Map map) {
		return getSqlMapClientTemplate().queryForList(
				"selectEquipmentFlex", map);
	}

	@Override
	public String getEquipCodeByName(String equipname) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquipCodeByName", equipname);
	}

	@Override
	public String getProvinceByStationcode(String code) {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClientTemplate().queryForObject("getProvinceByStationcode", code);
	}

	@Override
	public List<ComboxDataModel> getOcablesearch(String cond) {
		// TODO Auto-generated method stub
		Map map = new HashMap();
		map.put("cond", cond);
		return this.getSqlMapClientTemplate().queryForList("getOcablesearch", map);
	}

	@Override
	public String getAportAndZportByOcablecode(String ocablecode) {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClientTemplate().queryForObject("getAportAndZportByOcablecode", ocablecode);
	}

	@Override
	public List<ComboxDataModel> getEquipByStationAndeqsearch(Map map) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getEquipByStationAndeqsearch", map);
	}

	@Override
	public List<ComboxDataModel> getFiberPortserialByEquip(String equipcode) {
		// TODO Auto-generated method stub
		return this.getSqlMapClientTemplate().queryForList("getFiberPortserialByEquip", equipcode);
	}

	@Override
	public String getFiberSerialByOcablecode(String ocablecode) {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClientTemplate().queryForObject("getFiberSerialByOcablecode", ocablecode);
	}

}
