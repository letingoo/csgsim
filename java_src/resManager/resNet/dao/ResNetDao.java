package resManager.resNet.dao;

import java.util.List;
import java.util.Map;

import netres.model.ComboxDataModel;
import resManager.resNet.model.CCModel;
import resManager.resNet.model.Equipment;
import resManager.resNet.model.LogicPort;
import resManager.resNet.model.TopoLink;


public interface ResNetDao {
	
		//查询设备数目
		public int getEquipmentCount(Equipment model);
		//查询设备列表
		public List<Equipment> getEquipmentLst(Equipment model);
		//删除设备BY ID
		public void delEquipmentByModel(String equipcode);
		//获取设备厂商
		public List<ComboxDataModel> getX_VendorLst();
		//查找设备厂商BY ID
		public String getX_VendorNameById(String x_vendor);
		//获取传输系统列表
		public List<ComboxDataModel> getSysNameLst();
		//根据ID查找传输系统
		public String getSysNameById(String system_name);
		//获取设备型号列表
		public List<ComboxDataModel> getEquipmentX_Model(String vendor);
		//获取设备类型
//		public List<ComboxDataModel> getX_equiptypeLst();
		//查询设备类型BY ID
		public String getEquiptypeById(String equiptype);
		//根据站点设备号查询光路
		public List<String>  QueryRoutebyEquip(String sql);
		
		
		// 端口 order by yangzhong 2013-7-11
		public int getAllLogicPortCount();

		/**
		 * 获取的端口数量
		 * 
		 * @param logicPort
		 * @return
		 */
		
		// 复用段 start by yangzhong 
		public int GetLogicPortCount(LogicPort logicPort);

		/**
		 * 获取端口信息
		 * 
		 * @param logicPort
		 * @return
		 */
		public List GetLogicPort(LogicPort logicPort);

		/**
		 * 修改端口信息
		 * 
		 * @param logicPort
		 * @return
		 */
		public int ModfyLogicPort(LogicPort logicPort);

		public List getAllLogicPort();

		/**
		 * 添加端口信息
		 * 
		 * @param logicPort
		 */
		public void addLogicPort(LogicPort logicPort);

		/**
		 * 删除端口信息
		 * 
		 * @param logicPort
		 */
		public void delLogicPort(LogicPort logicPort);

		/**
		 * 获取端口类型
		 * 
		 * @param logicPort
		 */
		public List getPortType();

		/**
		 * 获取端口传输速率
		 * 
		 * @param logicPort
		 */

		public List getPortRate();

		/**
		 * 获取端口状态
		 * 
		 * @param logicPort
		 */
		public List getPortStatus();
		
		/**
		 * 修改端口状态
		 * 
		 * @param logicPort
		 */
		public void updatePortStatus(Object obj);
		
		/**
		 * EXCEL导出端口数据
		 * 
		 * @param logicPort
		 */
		public List ExportLogicPort();

		// 端口 end
		
		// 复用段 start by yangzhong 
		/**
		 * 获取复用段的数量
		 * @param topoLink
		 * @return
		 */
		public int GetAllTopoLinkCount();
		/**
		 * 获取复用段的数量
		 * @param topoLink
		 * @return
		 */
		public int GetTopoLinkCount(TopoLink topoLink);
		
		/**
		 * 获取度用段的信息
		 * @param topoLink
		 * @return
		 */
		public List GetAllTopoLink();
		/**
		 * 获取度用段的信息
		 * @param topoLink
		 * @return
		 */
		public List GetTopoLink(TopoLink topoLink);

		/**
		 * 添加复用段信息
		 * @param topolink
		 * @return
		 */
		public void AddTopoLink(TopoLink topolink);
		/**
		 * 删除复用段信息
		 * @param topolink
		 * @return
		 */
		public int delTopoLink(TopoLink topolink);

		 /**
		  * 修改复用段信息
		  * @param topolink
		  * @return
		  */
		public int ModifyTopoLink(TopoLink topolink);
		
		 /**
		  * 获取复用段速率
		  * @param topolink
		  * @return
		  */
		public List getTransSystem(); 
		
		/**
		  * 获取传输系统
		  * @param topolink
		  * @return
		  */
		public List getLineRate();
		
		/**
		 * 复用段的添加中的选择设备
		 */
		public List getEquipBytopolinksearch(Map map);
		
		/**
		 * 逻辑端口的添加中的选择设备
		 */
		public List getEquipByeqsearch(Map map);
		
		// 复用段 end by yangzhong 

		/**
		 * 获取交叉连接的数量
		 * @param CCModel
		 * @return
		 */
		public int getCCCount(CCModel model);
		
		
		/**
		 * 获取交叉连接的信息
		 * @param CCModel
		 * @return
		 */
		public List getCCList(CCModel model);
		/**
		 * 删除一条交叉连接
		 * @param CCModel
		 * @return
		 */
		public void delCCByid(String id);
		//add by xgyin
		public List<LogicPort> checkPortSerial(Map map);
		public List<LogicPort> checkPortUse(String portcode);
		public List getTopolinkByEquipsearch(Map map);
		public TopoLink getToplinkByID(String linkid);
		public String getSystemcodesByEquipcode(String equipcode);
}
