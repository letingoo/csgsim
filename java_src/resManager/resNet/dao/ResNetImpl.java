package resManager.resNet.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import netres.model.ComboxDataModel;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import resManager.resNet.model.CCModel;

import com.ibatis.sqlmap.client.SqlMapClient;

import resManager.resNet.model.Equipment;
import resManager.resNet.model.LogicPort;
import resManager.resNet.model.TopoLink;

public class ResNetImpl  extends SqlMapClientDaoSupport implements ResNetDao {

	@Override
	public List<ComboxDataModel> getEquipmentX_Model(String vendor) {
		Map map = new HashMap();
		map.put("vendor", vendor);
		return this.getSqlMapClientTemplate().queryForList("getEquipmentX_Model", map);
	}

	@Override
	public int getEquipmentCount(Equipment model) {
		return (Integer) this.getSqlMapClientTemplate().queryForObject("getEquipmentCount", model);
	}

	@Override
	public List<Equipment> getEquipmentLst(Equipment model) {
		return this.getSqlMapClientTemplate().queryForList("getEquipmentLst", model);
	}
	
	@Override
	public List<String> QueryRoutebyEquip(String sql){
		return (this.getSqlMapClientTemplate()).queryForList("QueryRoutebyEquip",sql);
		
	}

	/**
	 * 删除设备信息
	 */
	public void delEquipmentByModel(String equipcode) {
		
		try {
			this.getSqlMapClientTemplate().delete("delEquipmentByModel", equipcode);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	/* (non-Javadoc)
	 * @see resManager.resNet.dao.ResNetDao#getX_VendorLst()
	 */
	@Override
	public List<ComboxDataModel> getX_VendorLst() {
		return this.getSqlMapClientTemplate().queryForList("getX_VendorLst");
	}

	@Override
	public String getX_VendorNameById(String x_vendor) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getX_VendorNameById", x_vendor);
	}

	@Override
	public List<ComboxDataModel> getSysNameLst() {
		return this.getSqlMapClientTemplate().queryForList("getSysNameLst");
	}

	@Override
	public String getSysNameById(String system_name) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getSysNameById", system_name);
	}

//	@Override
//	public List<ComboxDataModel> getX_equiptypeLst() {
//		return this.getSqlMapClientTemplate().queryForList("getX_equiptypeLst");
//	}

	@Override
	public String getEquiptypeById(String equiptype) {
		return (String) this.getSqlMapClientTemplate().queryForObject("getEquiptypeById", equiptype);
	}
	
	
	// LogicPort 端口 order by yangzhong 2013-7-11 
		public List getPortType() {
			return this.getSqlMapClientTemplate().queryForList("getPort_Type");
		}

		public List getPortRate() {
			return this.getSqlMapClientTemplate().queryForList("getPort_Rate");
		}

		public List ExportLogicPort() {
			return null;
		}
		/**
		 * @Description: 修改端口信息
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public int ModfyLogicPort(LogicPort logicPort) {
			return this.getSqlMapClientTemplate().update("ModifyLogic_Port", logicPort);
		}

		public int getAllLogicPortCount() {
			return (Integer) (this.getSqlMapClientTemplate()
					.queryForObject("getAllLogicPort_Count"));
		}
		
		/**
		 * @Description:  获取的端口数量
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public int GetLogicPortCount(LogicPort logicPort) {
			return (Integer) (this.getSqlMapClientTemplate()
					.queryForObject("GetLogicPort_Count",logicPort));
		}
		
		
		/**
		 * @Description:  获取的端口信息
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public List GetLogicPort(LogicPort logicPort) {
			return this.getSqlMapClientTemplate()
					.queryForList("GetLogic_Port", logicPort);
		}

		/**
		 * @Description:  获取的端口数量
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public List getAllLogicPort() {
			return this.getSqlMapClientTemplate().queryForList("getAllLogic_Port");
		}
		
		/**
		 * @Description: 添加端口信息
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public void addLogicPort(LogicPort logicPort) {
			this.getSqlMapClientTemplate().insert("addLogic_Port", logicPort);
		}
		
		/**
		 * @Description: 删除端口信息
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public void delLogicPort(LogicPort logicPort) {
			this.getSqlMapClientTemplate().delete("deleteLogic_Port", logicPort);
		}
		
		
		/**
		 * @Description: 获取端口状态
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public List getPortStatus(){
			return (List)this.getSqlMapClientTemplate().queryForList("getPort_Status");
		}
		
		/**
		 * @Description: 更新端口状态
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public void updatePortStatus(Object obj){
			this.getSqlMapClientTemplate().update("updatePortStatus",obj);
		}

		// 端口 end by yangzhong
		
		//复用段 start by yangzhong
		/**
		 * @Description: 获取复用段的数量
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public int GetAllTopoLinkCount() {
			return (Integer) (this.getSqlMapClientTemplate()
					.queryForObject("getAllTopoLinkCount"));
		}
		
		/**
		 * @Description: 获取复用段的数量
		 * @author yangzhong
		 * @tmie 2013-7-15
		 */
		public int GetTopoLinkCount(TopoLink topoLink) {
			return (Integer) (this.getSqlMapClientTemplate().queryForObject(
					"getTopoLinkCount", topoLink));
		}

		/**
		 * @Description: 获取复用段信息
		 * @author yangzhong
		 * @tmie 2013-7-17
		 */
		public List GetAllTopoLink() {
			return this.getSqlMapClientTemplate().queryForList("getAllTopoLink");
		}
		
		/**
		 * @Description: 获取复用段信息
		 * @author yangzhong
		 * @tmie 2013-7-17
		 */
		public List GetTopoLink(TopoLink topoLink) {
			return this.getSqlMapClientTemplate().queryForList("getTopoLink", topoLink);
		}

		/**
		 * @Description: 添加复用段信息
		 * @author yangzhong
		 * @tmie 2013-7-17
		 */
		
		public void AddTopoLink(TopoLink topolink) {
			this.getSqlMapClientTemplate().insert("addTopoLink", topolink);
		}
		
		/**
		 * @Description: 删除复用段信息
		 * @author yangzhong
		 * @tmie 2013-7-17
		 */
		
		public int delTopoLink(TopoLink topolink) {
			return this.getSqlMapClientTemplate().delete("deleteTopoLink", topolink
					.getLabel());
		}
		
		/**
		 * @Description: 修改复用信息
		 * @author yangzhong
		 * @tmie 2013-7-17
		 */
		public int ModifyTopoLink(TopoLink topolink) {
			return this.getSqlMapClientTemplate().update("ModifyTopoLink", topolink);
		}
		
		/**
		 * @Description: 获取传输系统
		 * @author yangzhong
		 * @tmie 2013-7-17
		 */
		public List getTransSystem() {
			return this.getSqlMapClientTemplate().queryForList("getTranssystem");
		}
		
		/**
		 * @Description: 获取复用段速率
		 * @author yangzhong
		 * @tmie 2013-7-17
		 */
		public List getLineRate() {
			return this.getSqlMapClientTemplate().queryForList("getLineRate");
		}
		// 复用段 end  by yangzhong
		/**
		 * 复用段的添加功能--选择设备
		 * order by yangzhong
		 */
		public List getEquipBytopolinksearch(Map map) {
			
			return this.getSqlMapClientTemplate().queryForList("getEquipBytopolinksearch",map);
		}

		/**
		 * 添加功能--选择设备
		 * order by yangzhong
		 */
		public List getEquipByeqsearch(Map map) {
			return this.getSqlMapClientTemplate().queryForList("getEquipByeqsearch",map);
		}
		
		/**
		 * 获取交叉连接的数量
		 * @param topoLink
		 * @return
		 */
		public int getCCCount(CCModel model){
			return (Integer)this.getSqlMapClientTemplate().queryForObject("getCCCount",model);
		}
		
		
		/**
		 * 获取交叉连接的信息
		 * @param topoLink
		 * @return
		 */
		public List getCCList(CCModel model){
			return this.getSqlMapClientTemplate().queryForList("getCCList",model);
		}
		
		public void delCCByid(String id){
			this.getSqlMapClientTemplate().delete("delCCByid",id);
		}

		@Override
		public List<LogicPort> checkPortSerial(Map map) {
			return  this.getSqlMapClientTemplate().queryForList("checkPortSerial",map);
		}

		@Override
		public List<LogicPort> checkPortUse(String portcode) {
			return this.getSqlMapClientTemplate().queryForList("checkPortUse", portcode);
		}

		@Override
		public List getTopolinkByEquipsearch(Map map) {
			return this.getSqlMapClientTemplate().queryForList("getTopolinkByEquipsearch",map);
		}

		@Override
		public TopoLink getToplinkByID(String linkid) {
			return (TopoLink) this.getSqlMapClientTemplate().queryForObject("getToplinkByID", linkid);
		}

		@Override
		public String getSystemcodesByEquipcode(String equipcode) {
			return (String) this.getSqlMapClientTemplate().queryForObject("getSystemcodesByEquipcode", equipcode);
		}
}
