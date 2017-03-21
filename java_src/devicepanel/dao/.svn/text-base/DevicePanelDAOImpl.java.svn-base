package devicepanel.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import devicepanel.model.*;
import resManager.resNet.model.LogicPort;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.ibatis.sqlmap.client.SqlMapClient;

public class DevicePanelDAOImpl extends SqlMapClientDaoSupport implements DevicePanelDAO{
	
    
    public List getTransSystem(){
    	return this.getSqlMapClientTemplate().queryForList("getTransSystem");
    }
    
    public List getEquipment(String systemcode){
    	return this.getSqlMapClientTemplate().queryForList("getDeviceBySystemcode", systemcode);
    }
    
    public String getDeviceModel(String equipcode){
    	return (String)this.getSqlMapClientTemplate().queryForObject("getDeviceModel", equipcode);
    }
    
    public List getCard(String equipcode,String flag){
    	Map map =new HashMap();
    	map.put("equipcode", equipcode);
    	map.put("flag", flag);
    	return this.getSqlMapClientTemplate().queryForList("getCard", map);
    }
    
    public List getCarryOperaFlex(Map map){
		return this.getSqlMapClientTemplate().queryForList("getCarryOperaFlex",map);
	}
//    public int getCarryOperaSizeFlex(String equipcode)
//	{
//		return (Integer)this.getSqlMapClientTemplate().queryForObject("getCarryOperaSizeFlex",equipcode);
//	}
    
    public List getStatisInfoFlex(Map map){
		return this.getSqlMapClientTemplate().queryForList("getStatisInfoFlex",map);
	}
    
    public List getStatisPieFlex(Map map){
		return this.getSqlMapClientTemplate().queryForList("getStatisPieFlex",map);
	}
    
    public PackInfoModel getPackInfo(Map map) {
		return (PackInfoModel)this.getSqlMapClientTemplate().queryForObject("getPackInfo",map);
	}
    
    public void updateEquipPack(Map map)// 更新一项机盘信息到数据库
	{
		this.getSqlMapClientTemplate().update("updateEquipPack", map);
	}
    
    public List getModelList(){
    	return this.getSqlMapClientTemplate().queryForList("getModelList");
    }
    
    public String getModelByName(Map map){
    	return (String)this.getSqlMapClientTemplate().queryForObject("getModelByName", map);
    }
    
    public void addModel(Map map){
    	this.getSqlMapClientTemplate().insert("addModel", map);
    }
    
    public void updateModel(Map map){
    	this.getSqlMapClientTemplate().update("updateModel", map);
    }
    
    public Integer getModelCountByName(Map map){
    	return (Integer)(this.getSqlMapClientTemplate().queryForObject("getModelCountByName", map));
    }
    
    public void delModelByName(Map map){
    	this.getSqlMapClientTemplate().delete("delModelByName", map);
    }
	
	public List getVendor(){
    	return this.getSqlMapClientTemplate().queryForList("getVendors");
    }
    
    public List getSlotInfo(Map map){
    	return this.getSqlMapClientTemplate().queryForList("getSlotInfo",map);
    }
    
    public List getCarryOperaByPack(Map map){
    	return this.getSqlMapClientTemplate().queryForList("getCarryOperaByPack",map);
    }
    
    public List getEquipTypeByEquipCode(String equipModel){
    	return this.getSqlMapClientTemplate().queryForList("getEquipTypeByEquipCode",equipModel);
    }
    
    public String getFrameserialByEquipCode(Map map){
    	return (String)this.getSqlMapClientTemplate().queryForObject("getFrameserialByEquipCode",map);
    }
    
    @SuppressWarnings("unchecked")
	public void addPack(PackInfoModel model){
    	SqlMapClient sqlMap = this.getSqlMapClient();
		try 
		{
			sqlMap.startTransaction();
			sqlMap.insert("addPack",model);
			String vm=sqlMap.queryForObject("getDeviceModel", model.getEquipname()).toString();
			String vendor=vm.split(",")[0];
			String x_model=vm.split(",")[1];
			Map<String,Object> map1=new HashMap<String,Object>();
			map1.put("vendor", vendor);
			map1.put("equipmodel", x_model);
			map1.put("packmodel",  model.getPackmodel());
			//添加端口
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
					port.setEquipcode(model.getEquipname());
					port.setFrameserial(model.getFrameserial());
					port.setSlotserial(model.getSlotserial());
					port.setPackserial(model.getPackserial());
					port.setPortserial(String.valueOf(i+1));
					port.setY_porttype(porttype);//端口类型由盘决定，目前暂时没建关联表
					port.setX_capability(x_capability);
					port.setConnport("");
					port.setRemark("");
					port.setStatus("ZY13100201");//端口状态
					port.setUpdatedate(model.getUpdatedate());
					port.setUpdateperson(model.getUpdateperson());
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
    
    public List getEquipPackAlarm(Map equipcode){
    	return this.getSqlMapClientTemplate().queryForList("getEquipPackAlarm", equipcode);
    }
    
    public String getNextPorts(String rate,Map map){
    	String tooltip="";
    	List lst=new ArrayList();
    	if(rate.equalsIgnoreCase("ZY070101")||rate.equalsIgnoreCase("ZY070112")||rate.equalsIgnoreCase("ZY070116")){
    		lst=this.getSqlMapClientTemplate().queryForList("getNextPort1", map);
    	}else{
    		lst=this.getSqlMapClientTemplate().queryForList("getNextPort2", map);
    	}
    	for(int i=0;i<lst.size();i++){
    		HashMap m=(HashMap)lst.get(i);
    		tooltip+="<b>端口:</b>"+m.get("PORT").toString()+"  <b>对端端口:</b>"+m.get("NEXTPORT").toString()+"\n";
    	}
    	return "<p>"+tooltip+"</p>";
    }

	@Override
	public String getSlotDirectionByIds(Map map) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getSlotDirectionByIds", map);
	}
}
