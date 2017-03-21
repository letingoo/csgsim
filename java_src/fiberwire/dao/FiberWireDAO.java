package fiberwire.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fiberwire.model.ChannelRoutModel;
import fiberwire.model.ChannelRoutResultModel;
import fiberwire.model.EquInfoModel;
import fiberwire.model.SystemInfoModel;
import fiberwire.model.BusinessInfoModel;   //liao
public interface FiberWireDAO 
{
	/**获取当前系统中所有系统
	 * @return
	 */
	public List<SystemInfoModel> getSystemTree();

	
	/**获取当前系统中的所有设备
	 * @param systemcode 系统编码
	 * @param dock 是否呈现对接设备
	 * @return 设备信息列表
	 */
	public List<EquInfoModel> getAllEquips(String systemcode,Boolean dock,String userId);

	/**获取当前系统中的所有复用段
	 * @param systemcode
	 * @return
	 */
	//liao
		public List<BusinessInfoModel> getSystemBusiness(Map systemcode);
	@SuppressWarnings("unchecked")
	public List<HashMap> getSystemOcables(Map systemcode);
	
	@SuppressWarnings("unchecked")
	public List<HashMap> getSystemFibers(Map systemcode);
	
	@SuppressWarnings("unchecked")
	public List<HashMap> getSystemConnectOcable(String system_a, String system_z);

	// public String getTransDevice(String id,String type);
	@SuppressWarnings("unchecked")
	public List<HashMap> getEquipTypeXtxx();

	@SuppressWarnings("unchecked")
	public List<HashMap> getVendorByEquipType(String equipType);

	@SuppressWarnings("unchecked")
	public List<HashMap> getEquipmentByVendor(String equiptype,String vendor);

	@SuppressWarnings("unchecked")
	public List<HashMap> getDeviceModelList();

	public void updateSystemEquip(ArrayList<EquInfoModel> equiplist);




	public void addSys(SystemInfoModel systemInfo);

	public int modSys(SystemInfoModel systemInfo);

	public void delSys(String systemcode);
	
	@SuppressWarnings("unchecked")
	public List<HashMap> getSystemVendor();
	public List<SystemInfoModel> getSystemByVendor(String vendor);

	public ChannelRoutResultModel getChanRoutNameByTopolinkID(String topolinkID);
	public ChannelRoutResultModel getOcableRoutInfoByFiber(String ocablecode,String fiberserial);
	public List<ChannelRoutModel> getChannelRoutDataByCRName(String channelroutname);
	@SuppressWarnings("unchecked")
	public List getStationNamesByByCRName(String channelroutname);
	public void deleteEquipReSys(String equipcode,String systemcode);
	public List<EquInfoModel> getEquipsBySystem(String systemcode);
	@SuppressWarnings("unchecked")
	public void addEquipToSystem(String systemcode,String equipcode);
	@SuppressWarnings("unchecked")
	public List<HashMap> getPortsByLabel(String label);
	@SuppressWarnings("unchecked")
	public List getEquipCc(String belongequip,String start,String end);
	public int getEquipCcCount(String belongequip);
	@SuppressWarnings("unchecked")
	public List getPortByEquip(String equip);
    @SuppressWarnings("unchecked")
	public List searchTasks(String start,String end);
    public int searchTaskCount();
    @SuppressWarnings("unchecked")
	public void insertTask(Map taskObject,List portList);
    public void delTask(String id);
    @SuppressWarnings("unchecked")
	public void updateTask(Map taskObject,List portList);
    public String getTypeBycircuitCode(String circuitCode);


	public int getPortsByEquipcodeCount(String equipcode);


	public List getPortsByEquipcodeInfo(String equipcode,String start,String end);


	public List getPortsPerTrend(String logicport, String time, String date);
	/**获取当前系统中的所有设备
	 * @param systemcode 系统编码
	 * @param dock 是否呈现对接设备
	 * @return 设备信息列表
	 */
	public List<EquInfoModel> getAllEquipsByCount(String systemcode,Boolean dock,String userId,String count);
	
	public Map selectOcables(String label);

}
