package ocableResources.dwr;

import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jxl.write.WriteException;

import netres.model.ComboxDataModel;
import ocableResources.component.CustomizedExcel;
import ocableResources.component.ExportExcel;
import ocableResources.component.ZipExcel;
import ocableResources.dao.OcableResourcesDAO;
import ocableResources.model.CarryingBusinessModel;
import ocableResources.model.ChannelRoutModel;
import ocableResources.model.En_Ocable_Res_Link;
import ocableResources.model.Fiber;
import ocableResources.model.FiberDetailsBusiness;
import ocableResources.model.FiberDetailsModel;
import ocableResources.model.FiberDetailsResultModel;
import ocableResources.model.MapCoordinate;
import ocableResources.model.OcableRoutInfoData;
import ocableResources.model.OcableSection;
import ocableResources.model.OcablesectionGeoModel;
import ocableResources.model.OcablesectionInfoModel;
import ocableResources.model.OcablesectionModel;
import ocableResources.model.Re_Ocable_Ressite;
import ocableResources.model.ResultModel;
import ocableResources.model.StationModel;
import ocableResources.model.TnodeModel;
import ocableResources.util.SysConsts;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import carryOpera.model.CarryOperaModel;

import sysManager.log.dao.LogDao;
import sysManager.user.model.UserModel;
import twaver.Consts;
import twaver.Element;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Link;
import twaver.SerializationSettings;
import twaver.Styles;
import twaver.XMLSerializer;
import db.ForTimeBaseDAO;
import ocableResources.model.ChannelRoutResultModel;
import fiberwire.model.EquInfoModel;
import flex.messaging.FlexContext;

public class OcableResourcesDwr {
	OcableResourcesDAO ocableResourcesDao;

	public OcableResourcesDAO getOcableResourcesDao() {
		return ocableResourcesDao;
	}

	public void setOcableResourcesDao(OcableResourcesDAO ocableResourcesDao) {
		this.ocableResourcesDao = ocableResourcesDao;
	}
	
	/**
	 * @param String 传入参数 volt
	 * @return OcablesectionModel 光缆信息列表
	 * @author zh
	 */
	public List getOcablesectionByVolt(String volt,String type){
		List<OcablesectionModel> list = this.ocableResourcesDao.getOcablesectionByVolt(volt,type);
		return list;
	}
	/**
	 * @param String 传入参数 volt
	 * @return OcablesectionModel 光缆信息列表
	 * @author zh
	 */
	public List getOcablesectionByProvince(String volt,String province){
		List<OcablesectionModel> list = this.ocableResourcesDao.getOcablesectionByProvince(volt,province);
		return list;
	}
	
	/**
	 * 修改站位置
	 * @param StationModel 传入参数 model
	 * @return 
	 * @author zh
	 */
	public void updateStationLocation(MapCoordinate model){
		this.ocableResourcesDao.updateStationLocation(model);
	}
	
	/**
	 * 修改站名称位置
	 * @param StationModel 传入参数 model
	 * @return 
	 * @author zh
	 */
	public void updateStationLabelLocation(MapCoordinate model){
		this.ocableResourcesDao.updateStationLabelLocation(model);
	}
	
//	/**
//	 * 修改中心局站名称的位置
//	 * @param StationModel 传入参数 model
//	 * @return 
//	 * @author WJS
//	 */
//	public void updateStationLabelLocation(StationModel model){
//		this.ocableResourcesDao.updateStationLabelLocation(model);
//	}
	
	/**
	 * 修改地市局站名称的位置
	 * @param StationModel 传入参数 model
	 * @return 
	 * @author WJS
	 */
	public void updateStationCityLabelLocation(StationModel model){
		this.ocableResourcesDao.updateStationCityLabelLocation(model);
	}
	
	public void updateStationLocationByProvince(StationModel model){
		this.ocableResourcesDao.updateStationLocationByProvince(model);
	}
	
	/**
	 * 修改T接点位置
	 * @param TnodeModel 传入参数 model
	 * @return 
	 * @author zh
	 */
	public void updateTnodeLocation(TnodeModel model){
		this.ocableResourcesDao.updateTnodeLocation(model);
	}
	
	/**
	 * 搜索局站和T接点
	 * @param String searchtext 搜索关键字
	 * @return 搜索结果XML
	 * @author zh
	 */
	public String getSearchStation(String searchtext) {
		//System.out.println(searchtext);
		return ocableResourcesDao.getSearchStation(searchtext);
	}
	
	/**
	 * 电源拓扑图搜索局站
	 * @param searchtext
	 * @return xml
	 * @author qy
	 */
	public String getPowerMapSearch(String searchtext) {
		return ocableResourcesDao.getPowerMapSearch(searchtext);
	}
	
	
	/**
	 * 搜索光缆
	 * @param String searchtext 搜索关键字
	 * @return 搜索结果XML
	 * @author zh
	 */
	public String getSearchOcable(String searchtext) {
		//System.out.println(searchtext);
		return ocableResourcesDao.getSearchOcable(searchtext);
	}
	
	
	/**
	 * 搜索光缆
	 * @param String searchtext 搜索关键字
	 * @return 搜索结果XML
	 * @author wjs
	 */
	public String getSearchOneName(String searchtext) {
		//System.out.println(searchtext);
		return ocableResourcesDao.getSearchOneName(searchtext);
	}
	
	public List getOcablesectionVolt(){
		return this.ocableResourcesDao.getOcablesectionVolt();
	}
	/**
	 * 获取T节点属性
	 * @author Haifeng Liu
	 * 2010-12-19上午11:35:25
	 * @param tnodecode
	 * @return TnodeModel 节点属性
	 */
	public TnodeModel getTnodePropertyInfo(String tnodecode){
		return ocableResourcesDao.getTnodeProperty(tnodecode);
	}
	
	/**
	 * 获取光缆拐点信息
	 * @author jinshan Wang
	 * 2011-01-11上午11:00:00
	 * @param ocablecode
	 */
	public List getOcablesectiongeo(String secvolt,String province){
		return ocableResourcesDao.getOcablesectiongeo(secvolt,province);
	}
	
//	/**
//	 * 获取地市光缆拐点信息
//	 * @author jinshan Wang
//	 * 2011-01-11上午11:00:00
//	 * @param ocablecode
//	 */
//	public List getOcablesectiongeoByCity(String secvolt){
//		return ocableResourcesDao.getOcablesectiongeoByCity(secvolt);
//	}
	
	public List getOcablesectionProperty()
	{
		return ocableResourcesDao.getOcablesectionProperty();
	}
	public List getOcablesectionByProperty(String property)
	{
		return ocableResourcesDao.getOcablesectionByProperty(property);
	}
	
	//添加光缆
	public String addOcableSection(OcablesectionInfoModel model,ArrayList<OcablesectionGeoModel> OcableSectionGeoList){
		return ocableResourcesDao.addOcableSection(model,OcableSectionGeoList);//添加光缆
	}
	
	//删除光缆
	public String deleteOcableSectionInfo(String ocableSectionCode){
		String result = SysConsts.RESULT_FAIL;
		try{
			if(ocableSectionCanDelete(ocableSectionCode)){
		        this.ocableResourcesDao.deleteOcableSectionInfo(ocableSectionCode);
                result = SysConsts.RESULT_SUCCESS;
			    HttpServletRequest request = FlexContext.getHttpRequest();
			    WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			    LogDao logDao = (LogDao) ctx.getBean("logDao");
			    logDao.createLogEvent("删除", "光缆接线图", "删除光缆段", "", request);
			}else{
				result = SysConsts.RESULT_CHECK;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
//		this.ocableResourcesDao.deleteOcableSectionInfo(ocableSectionCode);
	}
		/**
	 * 判断光缆是否能删除
	 * @param ocableSectionCode
	 * @return
	 */
	private boolean ocableSectionCanDelete(String ocableSectionCode){
		boolean canDelete = false;
		try{
		    int busyFiberCount = this.getOcableResourcesDao().ocableSectionCanDelete(ocableSectionCode);
		    canDelete = busyFiberCount > 0? false : true;
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return canDelete;
	}
	
	public String addOcableSectionStation(StationModel model){
		return this.ocableResourcesDao.addOcableSectionStation(model);
	}
	
	//删除站点
	public void deleteStation(String code){
		this.ocableResourcesDao.deleteStation(code);
	}
	
	//保存拐点信息
	public void saveOcableSectionGeo(String sectioncode,ArrayList<OcablesectionGeoModel> OcableSectionGeoList){
		System.out.println("保存拐点信息DWR");
		ocableResourcesDao.saveOcableSectionGeo(sectioncode,OcableSectionGeoList);//添加光缆
	}
	
	
	//混合敷设————获取表格数据
	public List getOcablesection_Sub(String sectioncode){
		return this.ocableResourcesDao.getOcablesection_Sub(sectioncode);
	}
	public List getOcablesection_Sub_Statis(String sectioncode){
		return this.ocableResourcesDao.getOcablesection_Sub_Statis(sectioncode);
	}
	//混合敷设----保存
	public String saveMixOcableBuildModel(List lst,String xml,String sectioncode) throws SQLException{
		String result="";
		ForTimeBaseDAO dao = new ForTimeBaseDAO();
		Connection c = null;
	    Statement s = null;
	    ResultSet r = null;
	    c = dao.getConnection();
        c.setAutoCommit(false);
        s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_READ_ONLY);
        
        oracle.sql.CLOB osc = null;
		try{
			this.ocableResourcesDao.insertMixOcableBuildModel(lst);
			String sql="update en_ocablesection set view_separator=empty_clob() where sectioncode='"+sectioncode+"'";
			s.executeUpdate(sql);
			sql = "select view_separator from en_ocablesection where sectioncode='"+sectioncode+"' for update";
			
			r = s.executeQuery(sql);
            if (r.next()) {
                osc = (oracle.sql.CLOB)r.getClob("view_separator");
                Writer w = osc.getCharacterOutputStream();
                w.write(xml);
                w.flush();
                w.close();
                c.commit(); 
            }
            
			result= "success";
		}catch(Exception e){
			result= "failed";
		}finally{
			dao.closeConnection(c, s, r);
			return result;
		}
	}
	public List getRunUnits(){
		return this.ocableResourcesDao.getRunUnits();
	}
	
	public String getXml(String sectioncode){
		String xml = "";
	     ForTimeBaseDAO dao = new ForTimeBaseDAO();
	     Connection c = null;
	     Statement s = null;
	     ResultSet r = null;
	     String sql = "select * from en_ocablesection where sectioncode='"+sectioncode+"'";
	     try {
	            c = dao.getConnection();
	            s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
	                    ResultSet.CONCUR_READ_ONLY);
	            r = s.executeQuery(sql);
	            oracle.sql.CLOB osc = null;//初始化一个空的clob对象
	            if (r.next()) {
	                osc = (oracle.sql.CLOB) r.getClob("view_separator");
	                xml = osc.getSubString((long) 1, (int) osc.length());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            dao.closeConnection(c, s, r);
	        }
	        return xml;
	}
	
	//杆塔、接头盒连线
	public List getEstabList(String sectioncode){
		return this.ocableResourcesDao.getEstabList(sectioncode);
	}
	public List getConnectorbox(String sectioncode){
		return this.ocableResourcesDao.getConnectorbox(sectioncode);
	}
	
	/*
	 * 
	 */
	public String getEstabView(String sectioncode){
		SerializationSettings.registerGlobalClient("id", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("type", Consts.TYPE_INT);
		SerializationSettings.registerGlobalClient("isendpoint", Consts.TYPE_INT);
		String xml="";
		int count=this.ocableResourcesDao.getRessiteCountBySectioncode(sectioncode);
		if(count>=2){
			ElementBox box=new ElementBox();
			XMLSerializer serializer=new XMLSerializer(box);
			try{
			List lstEstab = this.ocableResourcesDao.getEstabsBySectioncode(sectioncode);
			float xpos=0;
			if(lstEstab.size()>0){
				xpos=800/(lstEstab.size()+1);
			}
			for(int i=0;i<lstEstab.size();i++){
				Re_Ocable_Ressite estab=(Re_Ocable_Ressite)lstEstab.get(i);
				Follower follower=new Follower();
				follower.setName(estab.resname);
				follower.setImage("establishment");
				follower.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
				follower.setSize(30, 60);
				follower.setClient("id", estab.rescode);
				follower.setClient("type", estab.restype);
				follower.setClient("isendpoint", estab.isendpoint);
				if(estab.res_x>=0 && estab.res_y>=0){
					follower.setLocation(estab.res_x, estab.res_y);
				}else{
					follower.setLocation(xpos*(i+1), 230);
				}
				box.add(follower);
			}
			
			List lstEndPoint = this.ocableResourcesDao.getEndPointBySectioncode(sectioncode);
			for(int j=0;j<lstEndPoint.size();j++){
				Re_Ocable_Ressite endpoint = (Re_Ocable_Ressite)lstEndPoint.get(j);
				Follower follower=new Follower();
				follower.setName(endpoint.resname);
				if(endpoint.restype==1){
					follower.setImage("station");
					follower.setSize(60,60);
				}else{
					follower.setImage("tnode");
					follower.setSize(30,20);
					if(endpoint.telpolecode!=null && endpoint.telpolecode!=""){
						Follower fwr=getNodeByIdandType(box,endpoint.rescode,endpoint.restype);
						if(fwr!=null){
							follower.setHost(fwr);
							fwr.setHost(follower);
							follower.setLocation(fwr.getX(), fwr.getY()+20);
						}
					}
				}
				follower.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
				follower.setClient("id", endpoint.rescode);
				follower.setClient("type", endpoint.restype);
				follower.setClient("isendpoint", endpoint.isendpoint);
				if(endpoint.res_x>=0 && endpoint.res_y>=0){
					follower.setLocation(endpoint.res_x, endpoint.res_y);
				}else{
					follower.setLocation(800*j+20, 230);
				}
				box.add(follower);
			}
			
			List lstConnector=this.ocableResourcesDao.getConnectorsBySectioncode(sectioncode);
			if(lstEstab.size()>0){
				xpos=800/(lstConnector.size()+1);
			}
			for(int k=0;k<lstConnector.size();k++){
				Re_Ocable_Ressite connector = (Re_Ocable_Ressite)lstConnector.get(k);
				Follower follower=new Follower();
				follower.setName(connector.resname);
				follower.setImage("connectorbox");
				follower.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
				follower.setSize(30,20);
				follower.setClient("id", connector.rescode);
				follower.setClient("type", connector.restype);
				follower.setClient("isendpoint", connector.isendpoint);
				Follower fwr=getNodeByIdandType(box,connector.telpolecode,3);
				if(fwr==null){
					if(connector.res_x>=0 && connector.res_y>=0){
						follower.setLocation(connector.res_x, connector.res_y);
					}else{
						follower.setLocation(xpos*k, 200);
					}
				}else{
					follower.setLocation(fwr.getX(), fwr.getY()-20);
					follower.setHost(fwr);
					fwr.setHost(follower);	
				}
				box.add(follower);
			}
			
			List lstLink = this.ocableResourcesDao.getLinksBySectioncode(sectioncode);
			for(int m=0;m<lstLink.size();m++){
				En_Ocable_Res_Link l=(En_Ocable_Res_Link)lstLink.get(m);
				Follower fromNode=getNodeByIdandType(box, l.a_point, l.a_type);
				Follower toNode=getNodeByIdandType(box, l.z_point, l.z_type);
				if(fromNode!=null && toNode!=null){
					Link link=new Link(fromNode, toNode);
					if((Integer)fromNode.getClient("type")==2){
						link.setStyle(Styles.LINK_FROM_POSITION, Consts.POSITION_BOTTOM);
					}else{
						link.setStyle(Styles.LINK_FROM_POSITION, Consts.POSITION_TOP);
					}
					if((Integer)toNode.getClient("type")==2){
						link.setStyle(Styles.LINK_TO_POSITION, Consts.POSITION_BOTTOM);
					}else{
						link.setStyle(Styles.LINK_TO_POSITION, Consts.POSITION_TOP);
					}
					box.add(link);
				}
			}
			}catch(Exception e){
				System.out.print(e.toString());
			}finally{
				xml = serializer.serialize();
			}
		}
		return xml;
	}
	
	private Follower getNodeByIdandType(ElementBox box,String id,int type){
		Follower follower=null;
		for(int i=0;i<box.getDatas().size();i++){
			Element element=(Element)box.getDatas().get(i);
			if(element.getClient("id").toString().equalsIgnoreCase(id) && Integer.parseInt(element.getClient("type").toString())==type){
				follower=(Follower)element;
				break;
			}
		}
		return follower;
	}
	
	public String saveEstabView(String sectioncode,String xml){
		String result="";
		SerializationSettings.registerGlobalClient("id", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("type", Consts.TYPE_INT);
		SerializationSettings.registerGlobalClient("isendpoint", Consts.TYPE_INT);
		try{
			ElementBox box=new ElementBox();
			XMLSerializer xmlser=new XMLSerializer(box);
			xmlser.deserializeXML(xml);
			
			this.ocableResourcesDao.delEstabView1(sectioncode);
			this.ocableResourcesDao.delEstabView2(sectioncode);
			
			for(int i=0;i<box.getDatas().size();i++){
				Element element=(Element)box.getDatas().get(i);
				if(element instanceof Link){
					En_Ocable_Res_Link link=new En_Ocable_Res_Link();
					link.ocablesectioncode=sectioncode;
					link.a_point=(String)((Link)element).getFromNode().getClient("id");
					link.a_type=Integer.parseInt(((Link)element).getFromNode().getClient("type").toString());
					link.z_point=(String)((Link)element).getToNode().getClient("id");
					link.z_type=Integer.parseInt(((Link)element).getToNode().getClient("type").toString());
					this.ocableResourcesDao.saveEstabView2(link);
				}else if(element instanceof Follower){
					Re_Ocable_Ressite res=new Re_Ocable_Ressite();
					res.ocablesectioncode=sectioncode;
					res.rescode=(String)((Follower)element).getClient("id");
					res.restype=Integer.parseInt(((Follower)element).getClient("type").toString());
					res.res_x=((Follower)element).getX();
					res.res_y=((Follower)element).getY();
					res.isendpoint=Integer.parseInt(((Follower)element).getClient("isendpoint").toString());
					this.ocableResourcesDao.saveEstabView1(res);
				}
			}
			result="success";
		}catch(Exception e){
			result="failed";
		}finally{
			return result;
		}
	}

	//根据code查询光缆长度
	public String getOcableLengthByCode(String sectioncode){
		String length = this.ocableResourcesDao.getOcableLengthByCode(sectioncode);
//		System.out.println("---------------------------"+length);
		return length;
	}
	
	
	//新光缆代码
	
	//获取某地区局站
	public List getStationInfo(String volts,String province){
		List list = this.ocableResourcesDao.getStationInfo(volts,province);
		return list;
	}
	
	//获取T接点
	public List getTnodeInfo(String volts,String province){
		List list = this.ocableResourcesDao.getTnodeInfo(volts,province);
		return list;
	}
	
	//获取某地区光缆
	public List getOcableSectionbystation(String volts,String province){
		List list = this.ocableResourcesDao.getOcableSectionbystation(volts,province);
		return list;
	}
	/**
	 * 获取设备树的数据源
	 * @author wuwenqi
	 * @version 20110920
	 */
	public String getEquipTreedata(String stationcode){
		String xml = "";
		List<HashMap> list = ocableResourcesDao.getEquiptype(stationcode);
		for(HashMap item : list){
			String codestr = item.get("TYPECODE").toString();
			List<HashMap> list1 = ocableResourcesDao.getEquipvendor(stationcode, codestr);
			if(list1.size() != 0){
				xml += "<a code='"+codestr+"' label='"+item.get("TYPENAME").toString()+"' isBranch='true' type='equiptype'>\n";
				for(HashMap item1 : list1){
					String codestr2 = item1.get("VENDORCODE").toString();
					List<HashMap> list2 = ocableResourcesDao.getEquipmodel(stationcode, codestr, codestr2);
					if(list2.size() != 0){
						xml += "<b code='"+codestr2+"' label='"+item1.get("VENDORNAME").toString()+"' isBranch='true' type='equipvendor'>\n";
						for(HashMap item2 : list2){
							xml += "<c code='"+item2.get("EQUIPCODE").toString()+"' ";
							xml += "name='"+item2.get("EQUIPNAME").toString()+"' ";
							xml += "model='"+item2.get("EQUIPMODEL").toString()+"' ";
							xml += "label='"+item2.get("EQUIPNAME").toString()+"' ";
							xml += "isBranch='false' type='equipmodel'/>\n";
						}
						xml += "</b>\n";
					}
				}
				xml += "</a>\n";
			}
		}
//		System.out.println(xml);
		return xml;
	}
	/**
	 * 获取端口信息
	 * @author wuwenqi
	 * @version 20110921
	 */
	public String getPortInfo(String equipcode){
		String xml = "";
		List<HashMap> list = ocableResourcesDao.getPorttype(equipcode);
		for(HashMap item : list){
			String codestr = item.get("TYPECODE").toString();
			List<HashMap> list1 = ocableResourcesDao.getPortrate(equipcode, codestr);
			if(list1.size() != 0){
				xml += "<a code='"+codestr+"' label='"+item.get("TYPENAME").toString()+"' isBranch='true' type='porttype'>\n";
				for(HashMap hm : list1){
					String ratecodestr = hm.get("RATECODE").toString();
					List<HashMap> list2 = ocableResourcesDao.getPortinfo(equipcode, codestr, ratecodestr);
					if(list2.size() != 0){
						xml += "<b code='"+ratecodestr+"' label='"+hm.get("RATENAME").toString()+"' isBranch='true' type='portrate'>\n";
						for(HashMap port : list2){
							if(!port.get("STATUS").equals("占用")){
								String portlabel = port.get("PORTNAME").toString();
								portlabel = portlabel.replace("框", "").replace("槽", "").replace("盘", "").replace("端口", "");
								
								xml += "<c code='"+port.get("PORTCODE").toString()+"' ";
								xml += "name='" + portlabel + "' ";
								xml += "label='" + portlabel + "' ";
								xml += "rate='"+port.get("PORTRATE").toString()+"' ";
								xml += "ratecode='" + ratecodestr + "' ";
								xml += "status='"+port.get("STATUS").toString()+"' ";
								xml += "isBranch='false' type='portinfo'/>\n";
							}
						}
						xml += "</b>\n";
					}
				}
				xml += "</a>\n";
			}
		}
		return xml;
	}
	/**
	 * 获取方式单编号
	 * @author wuwenqi
	 * @version 20111010
	 */
	public String getMaxRequestID(){
		String rs = "";
		Object obj = this.ocableResourcesDao.getMaxRequestID();
		String str = obj.toString().trim();
		String pre = str.substring(0, str.indexOf("第") + 1);
		String no = str.substring(str.indexOf("第") + 1, str.indexOf("号"));
		int i = Integer.parseInt(no) + 1;
		rs = pre + i + "号";
		return rs;
	}
	
	
	public List getProvinceList(){
		List list = ocableResourcesDao.getProvinceList();
		return list;
	}
	
	public List getStationByProvince(String province){
		List list = ocableResourcesDao.getStationByProvince(province);
		return list;
	}
	
	public void addCoordinatesByOcableSection(String stationcode,String province,String modelname,String nodex,String nodey,String labelx,String labely){
		HttpServletRequest request = FlexContext.getHttpRequest();
		HttpSession session = request.getSession();
		UserModel user = (UserModel) session.getAttribute((String) session
				.getAttribute("userid"));
		if(!"XZ01".equals(province)||"".equals(province)){
			if(user!=null&&user.getUser_deptcode()!=null){
				province=user.getUser_deptcode().substring(0, 4);
			}else{
				province="XZ01";
			}
			
		}
		ocableResourcesDao.addCoordinatesByOcableSection(stationcode,province,modelname,nodex,nodey,labelx,labely);
	}
	
	
	public void deleteCoordinatesByOcableSection(String stationcode,String province,String modelname){
		ocableResourcesDao.deleteCoordinatesByOcableSection(stationcode,province,modelname);
	}
	//添加光缆转接点
	public String addTnodebyocablesection(TnodeModel model,String province,String modelname){
		String code = this.ocableResourcesDao.addTnodebyocablesection(model,province,modelname);
		return code;
	}
	
	//删除Tnode
	public void deleteTnode(String code){
		this.ocableResourcesDao.deleteTnode(code);
	}
	/**
	 * 
	* @Title: getLegend 
	* @Description: TODO(获取图例,广西代码移植) 
	* @param @param type
	* @param @param vendor
	* @param @return    设定文件 
	* @return List<HashMap>    返回类型 
	* @throws
	 */
	public List<HashMap> getLegend(String type,String vendor){
		Map map = new HashMap();
		map.put("type", type);
		map.put("vendor", vendor);
		List<HashMap> listLegend=ocableResourcesDao.getLegend(map);
		return listLegend;
	}
	/**
	 * 单位信息
	 */
	private String provinceParam;
	public String getStationOcablesection(String str, String type,String province){
		provinceParam = province;
		return getDomain(str,type);
	}
	/**
	 * 
	* @Title: getDomain 
	* @Description: TODO(获取站点) 
	* @param @param str
	* @param @param type
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	// 树的生成
	@SuppressWarnings("unchecked")
	public String getDomain(String str, String type) {
		StringBuffer xml = new StringBuffer("");
		try{
//		Map resultMap = new HashMap();
		if (type.equalsIgnoreCase("root")) {
			List<HashMap> list = ocableResourcesDao.selectDomainFlex();
			for (HashMap map : list) {
				String domainname = (String) map.get("DOMAINNAME");
				xml.append("\n" + "<folder label='" + domainname + "' code='"
						+ domainname
						+ "' isBranch='true' leaf='false' type='domain' />");
			}
		} else if (type.equalsIgnoreCase("domain")) {
			List<HashMap> childlist = ocableResourcesDao.selectProvinceFlex(str);
			for (HashMap cmap : childlist) {
				String province = (String) cmap.get("PROVINCE");
				String provincename = (String) cmap.get("PROVINCENAME");
				xml.append("\n" + "<folder code='" + province + "' label='"
						+ provincename
						+ "' isBranch='true' leaf='false'  type='city' />");
//						+ "' isBranch='true' leaf='false'  type='province' />");
			}
		} 
		 else if (type.equalsIgnoreCase("province")) {
				List<HashMap> childlist = ocableResourcesDao.selectCityFlex(str);
				for (HashMap cmap : childlist) {
					String city = (String) cmap.get("PROVINCE");
					String cityname = (String) cmap.get("PROVINCENAME");
					xml.append("\n" + "<folder code='" + city + "' label='"
							+ cityname
							+ "' isBranch='true' leaf='false'  type='city' />");
				}
			} 				
		else if (type.equalsIgnoreCase("city")) {
			List<HashMap> leaflist = ocableResourcesDao.selectStationFlex(str);
			for (HashMap lmap : leaflist) {
				String stationname = (String) lmap.get("STATIONNAME");
				String stationcode = (String) lmap.get("STATIONCODE");
				List<HashMap> tempNodeList = new ArrayList<HashMap>();
//				tempNodeList=ocableResourcesDao.selectRoomFlex(stationcode); //没有机房
				if (tempNodeList.isEmpty()) {
					xml.append("\n"
							+ "<folder code='"
							+ stationcode
							+ "' clickable='false' color='#67eeee' selectable=\"false\" disabled=\"disabled\" label='"
							+ stationname
							+ "' isBranch='true' leaf='false' type='station' isHasChild='false' >");
				} else {
					xml.append("\n"
							+ "<folder code='"
							+ stationcode
							+ "' label='"
							+ stationname
							+ "' isBranch='true' leaf='false'  type='station' >");
				}

				xml.append("\n" + "</folder>");
			}
		} else if (type.equalsIgnoreCase("station")) {
			List<HashMap> nodelist = ocableResourcesDao.selectRoomFlex(str);
			for (HashMap nmap : nodelist) {
				String roomcode = (String) nmap.get("ROOMCODE");
				String name_std = (String) nmap.get("NAME_STD");
				xml.append("\n" + "<folder code='" + roomcode + "' label='"
						+ name_std
						+ "' isBranch='false' leaf='true' type='room' >");
				xml.append("\n" + "</folder>");
			}
		}else if(type.equalsIgnoreCase("ocablesectioin")){
			List<HashMap> leaflist = ocableResourcesDao.selectStationFlexByOcalbe(str,provinceParam);
			for (HashMap lmap : leaflist) {
				String stationname = (String) lmap.get("STATIONNAME");
				String stationcode = (String) lmap.get("STATIONCODE");
				String stationtype = (String) lmap.get("STATIONTYPE");
				String stationvolt = (String) lmap.get("STATIONVOLT");
				List<HashMap> tempNodeList = new ArrayList<HashMap>();
//				tempNodeList=ocableResourcesDao.selectRoomFlex(stationcode); //没有机房
				if (tempNodeList.isEmpty()) {
					xml.append("\n"
							+ "<folder code='"
							+ stationcode
							+ "' clickable='false' color='#67eeee' selectable=\"false\" disabled=\"disabled\" label='"
							+ stationname + "' " +
							"stationtype='"+stationtype+"' " +
							"stationvolt='"+stationvolt+"' isBranch='true' leaf='true' type='station' isHasChild='false' >");
				} else {
					xml.append("\n"
							+ "<folder code='"
							+ stationcode
							+ "' label='"
							+ stationname
							+ "' stationtype='"+stationtype+"' stationvolt='"+stationvolt+"' isBranch='false' leaf='true'  type='station' >");
					
				}

				xml.append("\n" + "</folder>");
			}
		}
//		 System.out.print(xml);
		}catch(Exception e){
			e.printStackTrace();
			}
		return xml.toString();
	}
	/**
	 * 在光缆路由图中查询光缆段
	 * 
	 * @param et
	 * @return
	 */
	public ResultModel getOcableSectionByOcableResources(OcableSection et) {
		ResultModel result = new ResultModel();
		try {
			HttpServletRequest request = FlexContext.getHttpRequest();
			HttpSession session = request.getSession();
			UserModel user = (UserModel) session.getAttribute((String) session
					.getAttribute("userid"));
			String user_id = user.getUser_id();
			et.setUser_id(user_id);
			// System.out.println("user_id is:"+user_id);
			result.setTotalCount(ocableResourcesDao.getOcableSectionCountByOcableResources(et));
			result.setOrderList(ocableResourcesDao.getOcableSectionByOcableResources(et));
			WebApplicationContext ctx = WebApplicationContextUtils
					.getWebApplicationContext(FlexContext.getServletContext());
			LogDao logDao = (LogDao) ctx.getBean("logDao");
			logDao.createLogEvent("查询", "台帐模块", "查询光缆段", "", request);
		} catch (Exception e) {
			e.printStackTrace();
			result = null;
		}
		return result;
	}
	/**
	 * 
	* @Title: getUsername 
	* @Description: TODO(获取电路名称) 
	* @param @return    设定文件 
	* @return String    返回类型 
	* @throws
	 */
	public String getUsername() {
		String result = "";
		List<ComboxDataModel> lst = ocableResourcesDao.getUsername();
		for (ComboxDataModel data : lst) {
			result += "<username id=\"" + data.getId() + "\" label=\""
					+ data.getLabel() + "\" isBranch=\"false\"></username>";
		}
		return result;
	}
/**
 * 
* @Title: getRate 
* @Description: TODO(获取速率) 
* @param @return    设定文件 
* @return String    返回类型 
* @author mawj 
* @throws
 */
	public String getRate() {
		String result = "";
		List<ComboxDataModel> lst = ocableResourcesDao.getRate();
		for (ComboxDataModel data : lst) {
			result += "<rate id=\"" + data.getId() + "\" label=\""
					+ data.getLabel() + "\" isBranch=\"false\"></rate>";
		}
		return result;
	}
	/**
	 * 
	* @Title: getCarryBusiness 
	* @Description: TODO(获取承载业务) 
	* @param @param carry
	* @param @param ocablecode
	* @param @return    设定文件 
	* @return ResultModel    返回类型 
	* @author mawj 
	* @throws
	 */
	public ResultModel getCarryBusiness(CarryingBusinessModel carry,String ocablecode) {
		String condition="";
		String opticalport;
		ResultModel result = new ResultModel();
		StringBuilder str = new StringBuilder();
		try{
			List<Fiber> fiberlist = this.ocableResourcesDao.getFiberByOcable(ocablecode);
			for(Fiber fiber:fiberlist){
				opticalport = this.getOpticalPortByFibercode(fiber.getFiberCode());
				if(opticalport != null && !opticalport.equals("")){
					if(opticalport.contains("#")){  //有两个连接光口
						str.append("'"+ opticalport.split("#")[0] + "',");
						str.append("'"+ opticalport.split("#")[1] + "',");
					}else{
						str.append("'"+ opticalport+ "',");
					}
				}	
			}
			if(str !=null && str.length() > 0){
				condition = str.substring(0, str.length()-1);
				Map map = new HashMap();
				map.put("logicport", condition);
				map.put("circuitcode", carry.getCircuitcode());
				map.put("username", carry.getUsername());
				map.put("remark", carry.getRemark());
				map.put("rate", carry.getRate());
				map.put("port_a", carry.getPort_a());
				map.put("port_z", carry.getPort_z());
				map.put("start", carry.getStart());
				map.put("end", carry.getEnd());
		result.setTotalCount(ocableResourcesDao.getCarryBusinessCount(map));
		result.setOrderList(ocableResourcesDao.getCarryBusiness(map));
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}	
	/**
	 * 获取光纤连接的光口
	 * @param fibercode
	 * @return
	 */
	private String getOpticalPortByFibercode(String fibercode){
		String opticalport = this.ocableResourcesDao.getOpticalPortByFibercode(fibercode);
		return opticalport;
	}
	/**
	 * 获取光缆段承载业务
	 * @param ocablecode
	 * @return
	 */
	public ResultModel  getCarryBusinessByOcable(String ocablecode,String start,String end){
//		String condition="";
//		String opticalport;
		ResultModel resultmodel = new ResultModel();
//		StringBuilder str = new StringBuilder();
		try{
			Map map = new HashMap();
			map.put("ocablecode", ocablecode);
			map.put("start", start);
			map.put("end", end);
			//直接查找光路表中，光缆断对应的业务id数目
			List<CarryOperaModel> busidLst = this.ocableResourcesDao.getAllCarryBusinessByOcableCode(map);
			resultmodel.setOrderList(busidLst);
			resultmodel.setTotalCount(this.ocableResourcesDao.getCountCarryBusinessByLogicport(ocablecode));
			
//			List<Fiber> fiberlist = this.ocableResourcesDao.getFiberByOcable(ocablecode);
//			for(Fiber fiber:fiberlist){
//				opticalport = this.getOpticalPortByFibercode(fiber.getFiberCode());
//				if(opticalport != null && !opticalport.equals("")){
//					if(opticalport.contains("#")){  //有两个连接光口
//						str.append("'"+ opticalport.split("#")[0] + "',");
//						str.append("'"+ opticalport.split("#")[1] + "',");
//					}else{
//						str.append("'"+ opticalport+ "',");
//					}
//				}	
//			}
//			if(str !=null && str.length() > 0){
//				condition = str.substring(0, str.length()-1);
//				Map map = new HashMap();
//				map.put("logicport", condition);
//				map.put("start", start);
//				map.put("end", end);
//				resultmodel.setOrderList(this.ocableResourcesDao.getCarryBusinessByLogicport(map));
//				resultmodel.setTotalCount(this.ocableResourcesDao.getCountCarryBusinessByLogicport(map));
//			}
			
		}catch(Exception ex){
			ex.printStackTrace();
			return null;
		}
		return resultmodel;
	}

	/**
	 * 获取光纤所有承载业务(在光缆截面图中的右键)
	 * @param fibercode
	 * @return
	 * @author jtsun
	 */
	public ResultModel getAllCarryBusinessByFibercodeOnly(String fibercode,String start,String end){
		ResultModel resultmodel = new ResultModel();
		try{
			String opticalport =this.getOpticalPortByFibercode(fibercode);
			String condition = "";
			if(opticalport != null && !opticalport.equals("")){
				if(opticalport.contains("#")){  //有两个连接光口
					condition = "'"+ opticalport.split("#")[0] + "','";
					condition =condition+ opticalport.split("#")[1]+"',";
				}else{
					condition = condition+"'"+ opticalport + "',";
				}
			}		
			if(condition !=null && !condition.equals("")){
				condition = condition.substring(0, condition.length()-1);
				
				resultmodel.setOrderList(this.ocableResourcesDao.getAllCarryBusinessByLogicport(condition));
				resultmodel.setTotalCount(this.ocableResourcesDao.getCountAllCarryBusinessByLogicport(condition));
				return resultmodel;
			}else{
				return null;
			}
		}catch(Exception ex){
			ex.printStackTrace();
			return null;
		}
	}
	/**
	 * 根据光纤对象获取光纤详细信息
	 * 
	 * @param FiberDetailsModel
	 *            fdm
	 * @return FiberDetailsResultModel对象
	 * @author luoshuai
	 */
	public FiberDetailsResultModel getFiberDetails(FiberDetailsModel fdm) {
		FiberDetailsResultModel fdrm = new FiberDetailsResultModel();
		List<FiberDetailsModel> list = this.ocableResourcesDao.getFiberDetails(fdm);
		String xml = "<list>";
		int num =0;
		int start = Integer.parseInt(fdm.getStart());
		int end = Integer.parseInt(fdm.getEnd());
		for(int i = start; i < list.size(); i++){
			if(!list.get(i).getIsmerge()){
				String tempxml = "";
				for(int j = i+1;j < list.size();j++){
					if(!"".equals(list.get(i).getAendeqport()) && !"".equals(list.get(j).getAendeqport()) &&
						list.get(i).getAendeqport().equals(list.get(j).getAendeqport()) && 
						list.get(i).getZendeqport().equals(list.get(j).getZendeqport())){
						tempxml += "\n<item ";
						tempxml += "fiberserial=\"" +list.get(i).getFiberserial()+"," + list.get(j).getFiberserial()
						+"\" ocablecode=\"" + list.get(i).getOcablecode()
						+"\" ocablesectionname=\"" + list.get(i).getOcablesectionname()
						+"\" aendeqport=\"" + list.get(i).getAendeqport()
						+"\" aequip=\"" + list.get(i).getAequip()
						+"\" zendeqport=\"" + list.get(i).getZendeqport()
						+"\" zequip=\"" + list.get(i).getZequip()
						+"\" fibercode=\"" + list.get(i).getFibercode()
						+"\" remark=\"" + list.get(i).getRemark();
						tempxml += "\"></item>";
						list.get(j).setIsmerge(true);
						num ++;
						break;
					}
				}
				if("".equals(tempxml)){
					 if(!"".equals(list.get(i).getAequip()) || !"".equals(list.get(i).getZequip())){
						 tempxml += "\n<item ";
							tempxml += "fiberserial=\"" +list.get(i).getFiberserial()
							+"\" ocablecode=\"" + list.get(i).getOcablecode()
							+"\" ocablesectionname=\"" + list.get(i).getOcablesectionname()
							+"\" aendeqport=\"" + list.get(i).getAendeqport()
							+"\" aequip=\"" + list.get(i).getAequip()
							+"\" zendeqport=\"" + list.get(i).getZendeqport()
							+"\" zequip=\"" + list.get(i).getZequip()
							+"\" fibercode=\"" + list.get(i).getFibercode()
							+"\" remark=\"" + list.get(i).getRemark();
							tempxml += "\"></item>";
							xml += tempxml;	
					 }else{
						 num ++;
					 }
				}else{
					xml += tempxml;	
				}
			}
		}
		xml += "\n</list>";
		fdrm.setDatas(xml);
		fdrm.setDatascounts(list.size()-num);
		return fdrm;
	}
	/**
	 * 根据光纤对象获取光纤详细信息
	 * 
	 * @param FiberDetailsModel
	 *            fdm
	 * @return FiberDetailsResultModel对象
	 * @author luoshuai
	 */
	public FiberDetailsResultModel getFiberDetailsInfo(FiberDetailsModel fdm) {
		FiberDetailsResultModel fdrm = new FiberDetailsResultModel();
		List list = this.ocableResourcesDao.getFiberDetailsInfo(fdm);
		int count = this.ocableResourcesDao.getFiberDetailsConnt(fdm);
		fdrm.setAcdatas(list);
		fdrm.setDatascounts(count);
		return fdrm;
	}
	
	public Boolean SaveStationLocation(ArrayList<resManager.resNode.model.StationModel> equiplist) {
		Boolean result = true;
		try {
			ocableResourcesDao.updateStationLocationBylst(equiplist);

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		}
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("修改", "光缆拓扑图", "修改光缆拓扑图", "", request);

		return result;
	}
	
	/**
	 * 
	* @Title: ExportExcelInfo 
	* @Description: TODO(到处光纤) 
	* @param @param labels
	* @param @param titles
	* @param @param fdm
	* @param @return    设定文件 
	* @return String    返回类型 
	* @author mawj 
	* @throws
	 */
	public String ExportExcelInfo(String labels, String titles[],
			FiberDetailsModel fdm) {
		String str = null;
		str = new ExportExcel(this.ocableResourcesDao).ExportExcelInfo(labels, titles, fdm,"FIBER");
		return str;
	}
	//导出光纤
	public String ExportExcel(String labels, String titles[],
			FiberDetailsModel fdm) {
		String str = null;
		str = new ExportExcel(this.ocableResourcesDao).ExportEXCEL(labels, titles, fdm,
				"FIBER");
		return str;
	}
	
	/**
	 * 获取光纤对应的业务信息
	 * 
	 * */
	public ResultModel showFiberBesuniss(String fibercode,String start,String end){
		
		ResultModel result = new ResultModel();
		Map map = new HashMap();
		map.put("fibercode", fibercode);
		map.put("start", start);
		map.put("end", end);
		result.setOrderList(this.ocableResourcesDao.getAllCarryBusinessByFibercode(map));
		result.setTotalCount(this.ocableResourcesDao.getCountCarryBusinessByFibercode(fibercode));
		return result;
	}
	
	/**
	 * 光纤详细信息里获取光缆承载业务
	 * @param ocablecode
	 * @param start
	 * @param end
	 * @return
	 */
	public ResultModel getBusinessByFiberdetails(String ocablecode,String start,String end){
		String condition="";
		String opticalport;
		ResultModel resultmodel = new ResultModel();
		List list = new ArrayList<FiberDetailsBusiness>();
		Map map = new HashMap();
		map.put("ocablecode", ocablecode);
		map.put("start", start);
		map.put("end", end);
		//直接查找光路表中，光缆断对应的业务id数目
		List<CarryOperaModel> busidLst = this.ocableResourcesDao.getAllCarryBusinessByOcableCode(map);
		resultmodel.setOrderList(busidLst);
		resultmodel.setTotalCount(this.ocableResourcesDao.getCountCarryBusinessByLogicport(ocablecode));
		
//		StringBuilder str = new StringBuilder();
//		try{
//			List<Fiber> fiberlist = this.ocableResourcesDao.getFiberByOcable(ocablecode);
//			for(Fiber fiber:fiberlist){
//				opticalport = this.getOpticalPortByFibercode(fiber.getFiberCode());
//				if(opticalport != null && !opticalport.equals("")){
//					if(opticalport.contains("#")){  //有两个连接光口
//						str.append("'"+ opticalport.split("#")[0] + "',");
//						str.append("'"+ opticalport.split("#")[1] + "',");
//					}else{
//						str.append("'"+ opticalport+ "',");
//					}
//				}	
//			}
//			if(str !=null && str.length() > 0){
//				condition = str.substring(0, str.length()-1);
//				Map map = new HashMap();
//				map.put("logicport", condition);
//				map.put("start", start);
//				map.put("end", end);
//				list = this.ocableResourcesDao.getFiberdetailsCarryBusiness(map);
//				
//				
//				resultmodel.setTotalCount(this.ocableResourcesDao.getCountCarryBusinessByLogicport(ocablecode));
//			}
//			resultmodel.setOrderList(list);
//			
//		}catch(Exception ex){
//			ex.printStackTrace();
//			return null;
//		}
		return resultmodel;
	}
	/**
	 * 
	* @Title: getOcableRoutInfoByFiber 
	* @Description: TODO(通过光纤 查询业务) 
	* @param @param ocablecode
	* @param @param fiberserial
	* @param @return    设定文件 
	* @return OcableRoutInfoData    返回类型 
	* @author mawj 
	* @throws
	 */
	 public OcableRoutInfoData getOcableRoutInfoByFiber(String ocablecode,String fiberserial)
	  {
		 OcableRoutInfoData ori = new OcableRoutInfoData();
			ChannelRoutResultModel routdata = new ChannelRoutResultModel();
			String chanRoutName = null;
			String systemcode = null;
			List<ChannelRoutModel> channelRoutData = null;
			List stationNames = null;
			try {
				routdata = this.ocableResourcesDao.getOcableRoutInfoByFiber(ocablecode,fiberserial);
				if (routdata != null) {
					chanRoutName = routdata.getFIBERCHANNELCODE();
					systemcode = routdata.getSYSTEMCODE();
					if (chanRoutName != null) {
						stationNames = this.ocableResourcesDao.getStationNamesByByCRName(chanRoutName);
						channelRoutData = this.ocableResourcesDao.getChannelRoutDataByCRName(chanRoutName);
						ori.setSystemName(systemcode);
						ori.setChannelRoutModelData(channelRoutData);
						ori.setStationNames(stationNames);
					} else {
						return null;
					}

				} else {
					return null;
				}

			} catch (Exception e) {
				e.printStackTrace();
			}

			return ori;
		  
	  }
	 /**
	  * 导出光纤业务信息
	  * 
	  * 
	  * */
	 public String ExportBusinessExcel(String labels, String[] titles,
				String fibercode,int end){
		 Date d = new Date();
			String path = null;// 返回到前台的路径
			List content = null;
			HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
			ServletConfig servletConfig = FlexContext.getServletConfig();
			String RealPath = null;// 绝对路径
			String date = getName();
			String filename = date + ".xls";
			String zipfilePath = null; // 压缩文件夹路径
			content = new ArrayList();
			String condition="";
			String opticalport;
			ResultModel resultmodel = new ResultModel();
			StringBuilder str = new StringBuilder();
			List<FiberDetailsBusiness> datalist = null;
			Map map = new HashMap();
			map.put("ocablecode", fibercode);
			map.put("start", "0");
			map.put("end", end);
			List<CarryOperaModel> busidLst = this.ocableResourcesDao.getAllCarryBusinessByFibercode(map);
			
			if(busidLst != null && busidLst.size() > 0){
				int i=0;
				for(CarryOperaModel model:busidLst){
					List newcolmn = new ArrayList();
					newcolmn.add(i++);
					newcolmn.add(model.getCircuitname()==null?"":model.getCircuitname());
					newcolmn.add(model.getPortserialno1()==null?"":model.getPortserialno1());
					newcolmn.add(model.getPortserialno2()==null?"":model.getPortserialno2());
					newcolmn.add(model.getUsername()==null?"":model.getUsername());
					newcolmn.add(model.getX_purpose()==null?"":model.getX_purpose());
					content.add(newcolmn);
				}
		    }else{
		    	return "";
		    }
			
			if (datalist.size() > 20000)// 每20000条数据写一个EXCEL
			{
				try {
					RealPath = this.getRealPath();
					zipfilePath = RealPath+ date;
					RealPath += date + "/";
					File f = new File(RealPath);
					if (!f.exists()) {
						f.mkdir();
					}
					List list[] = new List[datalist.size() % 20000 == 0 ? datalist.size() / 20000 + 1
							: datalist.size() / 20000 + 2];
					for (int i = 0; i < list.length - 1; i++) {
						CustomizedExcel ce = new CustomizedExcel(servletConfig);
						list[i] = content.subList(i * 20000 + 1,
								(i + 1) * 20000 > content.size() ? content.size()
										: (i + 1) * 20000);
						ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
								labels, titles, list[i]);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				ZipExcel zip = new ZipExcel();
				try {
					zip.zip(zipfilePath, zipfilePath + ".zip", "");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				path = "exportExcel/" 
						+ date + ".zip";
			} else {
				CustomizedExcel ce = new CustomizedExcel(servletConfig);
				RealPath = this.getRealPath();
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				try {
					ce.WriteExcel(RealPath + filename, labels, titles, content);
				} catch (WriteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				path = "exportExcel/" + filename;
			}
			return path;
	 }
	 
	 /**
		 * 导出光缆业务信息
		 * @param labels
		 * @param titles
		 * @param sectioncode
		 * @return
		 */
		public String ExportCircuitExcel(String labels, String[] titles,
				String sectioncode,int end) {
			Date d = new Date();
			String path = null;// 返回到前台的路径
			List content = null;
			HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
			ServletConfig servletConfig = FlexContext.getServletConfig();
			String RealPath = null;// 绝对路径
			String date = getName();
			String filename = date + ".xls";
			String zipfilePath = null; // 压缩文件夹路径
			content = new ArrayList();
			String condition="";
			String opticalport;
			ResultModel resultmodel = new ResultModel();
			StringBuilder str = new StringBuilder();
			Map map = new HashMap();
			map.put("ocablecode", sectioncode);
			map.put("start", "0");
			map.put("end", end);
			List<CarryOperaModel> busidLst = this.ocableResourcesDao.getAllCarryBusinessByOcableCode(map);
			
			if(busidLst != null && busidLst.size() > 0){
				int i=0;
				for(CarryOperaModel model:busidLst){
					List newcolmn = new ArrayList();
					newcolmn.add(i++);
					newcolmn.add(model.getCircuitname()==null?"":model.getCircuitname());
					newcolmn.add(model.getPortserialno1()==null?"":model.getPortserialno1());
					newcolmn.add(model.getPortserialno2()==null?"":model.getPortserialno2());
					newcolmn.add(model.getUsername()==null?"":model.getUsername());
					newcolmn.add(model.getX_purpose()==null?"":model.getX_purpose());
					content.add(newcolmn);
				}
		    }else{
		    	return "";
		    }
			
			if (busidLst.size() > 20000)// 每20000条数据写一个EXCEL
			{
				try {
					RealPath = this.getRealPath();
					zipfilePath = RealPath+ date;
					RealPath += date + "/";
					File f = new File(RealPath);
					if (!f.exists()) {
						f.mkdir();
					}
					List list[] = new List[busidLst.size() % 20000 == 0 ? busidLst.size() / 20000 + 1
							: busidLst.size() / 20000 + 2];
					for (int i = 0; i < list.length - 1; i++) {
						CustomizedExcel ce = new CustomizedExcel(servletConfig);
						list[i] = content.subList(i * 20000 + 1,
								(i + 1) * 20000 > content.size() ? content.size()
										: (i + 1) * 20000);
						ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
								labels, titles, list[i]);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				ZipExcel zip = new ZipExcel();
				try {
					zip.zip(zipfilePath, zipfilePath + ".zip", "");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				path = "exportExcel/" 
						+ date + ".zip";
			} else {
				CustomizedExcel ce = new CustomizedExcel(servletConfig);
				RealPath = this.getRealPath();
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				try {
					ce.WriteExcel(RealPath + filename, labels, titles, content);
				} catch (WriteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				path = "exportExcel/" + filename;
			}
			return path;
		}
		/**
		 * 
		* @Title: ExportCarryBusiness 
		* @Description: TODO(光缆承载业务) 
		* @param @param labels
		* @param @param titles
		* @param @param sectioncode
		* @param @return    设定文件 
		* @return String    返回类型 
		* @author mawj 
		* @throws
		 */
		public String ExportCarryBusiness(String labels, String[] titles,
				String sectioncode) {
			Date d = new Date();
			String path = null;// 返回到前台的路径
			List content = null;
			HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
			ServletConfig servletConfig = FlexContext.getServletConfig();
			String RealPath = null;// 绝对路径
			String date = getName();
			String filename = date + ".xls";
			String zipfilePath = null; // 压缩文件夹路径
			content = new ArrayList();
			List<CarryingBusinessModel>  datalist = this.getAllCarryBusinessByOcable(sectioncode);
			if(datalist != null && datalist.size() > 0){
				for(CarryingBusinessModel model:datalist){
					List newcolmn = new ArrayList();
					newcolmn.add(model.getRequisitionid()==null?"":model.getRequisitionid());
					newcolmn.add(model.getCircuitname()==null?"":model.getCircuitname());
					newcolmn.add(model.getOperationtype()==null?"":model.getOperationtype());
					newcolmn.add(model.getRate()==null?"":model.getRate());
					newcolmn.add(model.getAequiptype()==null?"":model.getAequiptype());
					newcolmn.add(model.getZequiptype()==null?"":model.getZequiptype());
					newcolmn.add(model.getPort_a()==null?"":model.getPort_a());
					newcolmn.add(model.getPort_z()==null?"":model.getPort_z());
					newcolmn.add(model.getRemark()==null?"":model.getRemark());
					newcolmn.add(model.getCircuitcode()==null?"":model.getCircuitcode());
					content.add(newcolmn);
				}
		    }else{
		    	return "";
		    }
			
			if (datalist.size() > 20000)// 每20000条数据写一个EXCEL
			{
				try {
					RealPath = this.getRealPath();
					zipfilePath = RealPath+ date;
					RealPath += date + "/";
					File f = new File(RealPath);
					if (!f.exists()) {
						f.mkdir();
					}
					List list[] = new List[datalist.size() % 20000 == 0 ? datalist.size() / 20000 + 1
							: datalist.size() / 20000 + 2];
					for (int i = 0; i < list.length - 1; i++) {
						CustomizedExcel ce = new CustomizedExcel(servletConfig);
						list[i] = content.subList(i * 20000 + 1,
								(i + 1) * 20000 > content.size() ? content.size()
										: (i + 1) * 20000);
						ce.WriteExcel(RealPath + date + "-part" + i + ".xls",
								labels, titles, list[i]);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				ZipExcel zip = new ZipExcel();
				try {
					zip.zip(zipfilePath, zipfilePath + ".zip", "");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				path = "exportExcel/"  + date + ".zip";
			} else {
				CustomizedExcel ce = new CustomizedExcel(servletConfig);
				RealPath = this.getRealPath();
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				try {
					ce.WriteExcel(RealPath + filename, labels, titles, content);
				} catch (WriteException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				path = "exportExcel/" + filename;
			}
			return path;
		}
		/**
		 * 获取光缆段所有承载业务
		 * @param ocablecode
		 * @return
		 */
		public List<CarryingBusinessModel>  getAllCarryBusinessByOcable(String ocablecode){
			String condition="";
			String opticalport;
			StringBuilder str = new StringBuilder();
			try{
				List<Fiber> fiberlist = this.ocableResourcesDao.getFiberByOcable(ocablecode);
				for(Fiber fiber:fiberlist){
					opticalport = this.getOpticalPortByFibercode(fiber.getFiberCode());
					if(opticalport != null && !opticalport.equals("")){
						if(opticalport.contains("#")){  //有两个连接光口
							str.append("'"+ opticalport.split("#")[0] + "',");
							str.append("'"+ opticalport.split("#")[1] + "',");
						}else{
							str.append("'"+ opticalport+ "',");
						}
					}	
				}
				if(str !=null && !str.equals("")){
					condition = str.substring(0, str.length()-1);
					return this.ocableResourcesDao.getAllCarryBusinessByLogicport(condition);
				}else{
					return null;
				}
			}catch(Exception ex){
				ex.printStackTrace();
				return null;
			}
		}
		/**
		 * 获取时间的函数
		 * */
		public static String getName() {
			SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
			return sDateFormat.format(new java.util.Date());
		}
		/**
		 * 获取文件路径
		 * */
		public String getRealPath() {
			String RealPath = null;// 绝对路径
			String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
			RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));
			RealPath += "exportExcel/";
			return RealPath;
		}
		/**
		 * @param String 传入参数 选定光缆两端局站的编码
		 * @return String 光缆信息列表
		 * @author zh
		 */
		public String getOcableList(String apointcode, String zpointcode) {
			return ocableResourcesDao.getOcableList(apointcode, zpointcode);
		}
		public Boolean addSingleFiber(FiberDetailsModel fiberObj, int fibercount)
		{	
			Boolean result = true;
			
			try
			{
				ocableResourcesDao.addSingleFiber(fiberObj, fibercount);	
			}
			catch(Exception e)
			{
				e.printStackTrace();
				result = false;
			}
			
			return  result;
			
		}
		/**
		 * 
		* @Title: deleteSingleFiber 
		* @Description: TODO(删除) 
		* @param @param fibercode
		* @param @param fiberserial
		* @param @param fiberObj
		* @param @param fibercount
		* @param @return    设定文件 
		* @return Boolean    返回类型 
		* @author mawj 
		* @throws
		 */
		public Boolean deleteSingleFiber(String fibercode,String fiberserial,FiberDetailsModel fiberObj, int fibercount){
			Boolean result = true;
			
			try
			{
				ocableResourcesDao.deleteSingleFiber(fibercode, fiberserial,fiberObj, fibercount);	
			}
			catch(Exception e)
			{
				result = false;
				e.printStackTrace();
			}
			
			return  result;
		}
		/**
		 * @param String 传入参数 光纤编码、光纤序号
		 * @return String 光纤对应的复用段信息
		 * @author zh
		 */
		public String getTopolinkByFiber(String fibercode, String fiberserial) {
			String topoid = "";
			try{
				//根据光纤关联的光路ID查找复用段ID
				String opticalid = ocableResourcesDao.getOpticalIDByFibercode(fibercode,fiberserial);
				if(opticalid!=null&&!"".equals(opticalid)&&!"-1".equals(opticalid)){
					//根据光路ID查找复用段ID
					topoid = ocableResourcesDao.getTopolinkidByOpticalid(opticalid);
				}

			}catch(Exception e){
				e.printStackTrace();
			}
			if(topoid==null){
				topoid="";
			}
			return topoid;
		}
		/**
		 * @param String 传入参数 光缆段编码
		 * @return String 单根光缆信息
		 * @author zh
		 */
		public String getOcableTopoOcableInfo(String sectioncode) {
			String result = ocableResourcesDao.getOcableTopoOcableInfo(sectioncode);
			if(result != null)
				return result;
			else
				return "";
		}
		/**
		 * @param String 传入参数 光缆段编码
		 * @return String 该光缆所包含光纤的信息
		 * @author zh
		 */
		public String getOcableTopoFiberInfo(String sectioncode) {
			return ocableResourcesDao.getOcableTopoFiberInfo(sectioncode);
		}
		
		/**
		 * 查询设备模版数据
		 * 
		 * @return xml
		 * @author mawj
		 */
		public String getStationModel() {
			String xml = "<models>";
			List<HashMap> list = this.ocableResourcesDao.getStationModelList();
			for (HashMap lst : list) {
				String smodel = (String) lst.get("SMODEL");
				String scode = (String) lst.get("SCODE");
				String sindex = (String) lst.get("SINDEX");
				String image_model = scode.replace(" ", "");
				image_model = image_model.replace("/", "");
				if (!smodel.equals("")) {
					String source = image_model + ".png";
					xml += "<model scode='" + scode + "' sindex='" + sindex
							+ "' smodel='" + smodel
							+ "' source='assets/images/ocable/smodel/" + source + "'/>";
				}
			}
			xml += "</models>";
			
			return xml;		
		}
}
