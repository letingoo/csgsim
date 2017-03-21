package carryOpera.dwr;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import jxl.write.WriteException;
import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import carryOpera.dao.CarryOperaDao;
import carryOpera.model.CarryOperaModel;
import carryOpera.model.ResultModel;
import sysManager.log.dao.LogDao;
import flex.messaging.FlexContext;

public class CarryOperaDwr {
	private CarryOperaDao carryOperaDao;
	public CarryOperaDao getCarryOperaDao() {
		return carryOperaDao;
	}
	public void setCarryOperaDao(CarryOperaDao carryOperaDao) {
		this.carryOperaDao = carryOperaDao;
	}
	public String getSummaryByCodeAndType(String code,String type,int groundOpera)
	{
		
		String xml="";
		try
		{
			if("station".equalsIgnoreCase(type))
			{
				xml=getStationSummaryByType(code,groundOpera)+"#"+getStationSummaryByRate(code,groundOpera);
			}
			else if("equipment".equalsIgnoreCase(type))
			{
				
				xml=getEquipSummaryByType(code,groundOpera)+"#"+getEquipSummaryByRate(code,groundOpera);
			
			}
			else if("topolink".equalsIgnoreCase(type))
			{
				xml=getTopolinkSummaryByType(code,groundOpera)+"#"+getTopolinkSummaryByRate(code,groundOpera);
			}
			else if("logicport".equalsIgnoreCase(type))
			{
				xml=getLogicportSummaryByType(code,groundOpera)+"#"+getLogicportSummaryByRate(code,groundOpera);
			}
			else if("equippack".equalsIgnoreCase(type))
			{
				try
				{
					xml=getEquipPackSummaryByType(code,groundOpera)+"#"+getEquipPackSummaryByRate(code,groundOpera);
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
			}
			else if("ocable".equalsIgnoreCase(type))
			{
				Map map  = new HashMap();
				String sql = " ";
				List<HashMap> portMap=this.carryOperaDao.getPortsByOcable(code);
			    if(portMap.size()==0)
			    {
			    	xml="#";
			    }
			    else
			    {
			    	for(int i=0;i<portMap.size();i++)
			    	{
			    		String aendport="";//A端设备端口
			    		String zendport="";//Z端设备端口
			    		String aendeqport = (String)portMap.get(i).get("AENDEQPORT");
						String aendodfport = (String)portMap.get(i).get("ZENDODFPORT");
						String zendeqport = (String)portMap.get(i).get("ZENDEQPORT");
						String zendodfport = (String)portMap.get(i).get("ZENDODFPORT");
						if(!aendodfport.equalsIgnoreCase(" ")&&!aendodfport.equalsIgnoreCase(null))//说明
						{
							aendport=aendodfport;
						}
						else if(!aendeqport.equalsIgnoreCase(" ")&&!aendeqport.equalsIgnoreCase(null))//说明
						{							
							aendport=aendeqport;
						}
						
						if(!zendodfport.equalsIgnoreCase(" ")&&!zendodfport.equalsIgnoreCase(null))//说明Z端为设备端口
						{
							zendport=zendodfport;
							
						}
						else if(!zendeqport.equalsIgnoreCase(" ")&&!zendeqport.equalsIgnoreCase(null))
						{
							zendport=zendeqport;
						}
						if(!aendport.equalsIgnoreCase("")&&!zendport.equalsIgnoreCase(""))
						{
							xml=getFiberSummaryByType(aendport,zendport,groundOpera)+"#"+getFiberSummaryByRate(aendport,zendport,groundOpera);
							break;
						}
			    	}
			    }
				
				
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return xml;
	}
	//光纤业务按业务类型进行统计分析	
	public String getFiberSummaryByType(String aendport,String zendport,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getFiberCarryOperaSummaryByType(aendport,zendport,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("TYPE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	public String getFiberSummaryByRate(String aendport,String zendport,int groundOpera)
	{
	
		String xml="";
		List<HashMap> list=this.carryOperaDao.getFiberCarryOperaSummaryByRate(aendport,zendport,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("RATE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	//设备业务按业务类型进行统计分析	
	public String getStationSummaryByType(String stationcode,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getStationCarryOperaSummaryByType(stationcode,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("TYPE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	public String getStationSummaryByRate(String stationcode,int groundOpera)
	{
	
		String xml="";
		List<HashMap> list=this.carryOperaDao.getStationCarryOperaSummaryByRate(stationcode,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("RATE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	//设备业务按业务类型进行统计分析	
	public String getEquipSummaryByType(String equipcode,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getCarryOperaSummaryByType(equipcode,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("TYPE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	public String getEquipPackSummaryByType(String equippack,int groundOpera)
	{
		String[] array=equippack.split(",");
		String equipcode=array[0];
		String frameserial=array[1];
		String slotserial=array[2];
		String packserial=array[3];		
		String xml="";
		
		List<HashMap> list=this.carryOperaDao.getEquipPackCarryOperaSummaryByType(equipcode, frameserial, slotserial, packserial,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("TYPE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	public String getEquipPackSummaryByRate(String equippack,int groundOpera)
	{
		String[] array=equippack.split(",");
		String equipcode=array[0];
		String frameserial=array[1];
		String slotserial=array[2];
		String packserial=array[3];		
		String xml="";
		List<HashMap> list=this.carryOperaDao.getEquipPackCarryOperaSummaryByRate(equipcode, frameserial, slotserial, packserial,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("RATE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	//设备业务按业务类型进行统计分析	
	public String getEquipSummaryByRate(String equipcode,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getCarryOperaSummaryByRate(equipcode,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("RATE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	//设备业务按业务类型进行统计分析	
	public String getLogicportSummaryByType(String logicport,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getLogicportCarryOperaSummaryByType(logicport,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("TYPE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	//设备业务按业务类型进行统计分析	
	public String getLogicportSummaryByRate(String logicport,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getLogicportCarryOperaSummaryByRate(logicport,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("RATE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	//设备业务按业务类型进行统计分析	
	public String getTopolinkSummaryByType(String label,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getTopolinkCarryOperaSummaryByType(label,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("TYPE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	//设备业务按业务类型进行统计分析	
	public String getTopolinkSummaryByRate(String label,int groundOpera)
	{
		String xml="";
		List<HashMap> list=this.carryOperaDao.getTopolinkCarryOperaSummaryByRate(label,groundOpera);
		if(list!=null&&list.size()>0){
			xml+="[";
			for(HashMap map:list)
			{
				xml+="{";
				xml+="\"value\":\""+map.get("VALUE")+"\"";
				xml+=",";
				xml+="\"name\":\""+map.get("RATE")+"\"";        
				xml+="},";
			}
			xml = xml.substring(0,xml.length()-1);
			xml+="]";
		}
		return xml;
	}
	public String OperaExportEXCEL(String code,String type,String labels, String[] titles,int groundOpera) {
		HttpServletRequest request = FlexContext.getHttpRequest();
		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(FlexContext.getServletContext());
		LogDao logDao = (LogDao) ctx.getBean("logDao");
		logDao.createLogEvent("导出", labels, "承载业务导出", "", request);
		
		Date d = new Date();
		String path = null;// 返回到前台的路径
		List content=new ArrayList();
	
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		
		
		
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
		String date = sDateFormat.format(new java.util.Date());
		
		if(labels!=null){
			//把labels中的特殊字符给过滤掉
			labels = labels.replaceAll("\t", "");
			labels = labels.replaceAll("/","");
			labels = labels.replaceAll("\n","");
			labels = labels.replaceAll("\\?","");
			labels = labels.replaceAll("\\*","");
			labels = labels.replaceAll(":","");
			labels = labels.replaceAll("<","(");
			labels = labels.replaceAll(">",")");
		}
		String filename = date + ".xls";
		String zipfilePath = null; // 压缩文件夹路径
		// String label="局站信息列表";
		// String[] title = { "局站名称","省份","经度","纬度","备注","更新时间"};
		int count=0;
		List<CarryOperaModel> operalist = null;
		try
		{
			if("station".equalsIgnoreCase(type))
			{
				count=this.carryOperaDao.getCarryOperaCountByStationcode(code,groundOpera);
				operalist=this.carryOperaDao.getCarryOperaByStationcode(code,0,count,groundOpera);
				
			}
			else if("equipment".equalsIgnoreCase(type))//查看设备业务
			{
				count=this.carryOperaDao.getCarryOperaCountByEquipcode(code,groundOpera);
				operalist=this.carryOperaDao.getCarryOpera_Flex(code,0,count,groundOpera);
				
			}
			else if("topolink".equalsIgnoreCase(type))//查看复用段业务
			{
				count=this.carryOperaDao.getCarryOperaCountByTopolink(code,groundOpera);
				operalist=this.carryOperaDao.getCarryOperaByTopolink(code,0,count,groundOpera);
			}
			else if("logicport".equalsIgnoreCase(type))//查看端口业务
			{
				count=this.carryOperaDao.getCarryOperaCountByLogicPort(code,groundOpera);
				operalist=this.carryOperaDao.getCarryOperaByLogicPort(code,0,count,groundOpera);
			}
			else if("equippack".equalsIgnoreCase(type))
			{
				String[] array=code.split(",");
				String equipcode=array[0];
				String frameserial=array[1]; 
				String slotserial=array[2];
				String packserial=array[3];
				count=this.carryOperaDao.getCarryOperaCountByEquipPack(equipcode, frameserial, slotserial, packserial,groundOpera);
				operalist=this.carryOperaDao.getCarryOperaByEquipPack(equipcode, frameserial, slotserial, packserial, 0,count,groundOpera);
				
			}	
			
			for (int i = 0; i < operalist.size(); i++) 
			{
				List newcolmn = new ArrayList();
				newcolmn.add(operalist.get(i).getCircuitcode());
				newcolmn.add(operalist.get(i).getRate());
				newcolmn.add(operalist.get(i).getX_purpose()==null?"":operalist.get(i).getX_purpose());
				newcolmn.add(operalist.get(i).getUsername());
				newcolmn.add(operalist.get(i).getPortserialno1()==null?"":operalist.get(i).getPortserialno1());
				newcolmn.add(operalist.get(i).getPortserialno2()==null?"":operalist.get(i).getPortserialno2());
				content.add(newcolmn);
			}
	
			String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
			RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
			RealPath += "exportExcel/";				
	
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		if (count > 20000)// 每20000条数据写一个EXCEL
		{
			try {
				zipfilePath = RealPath+ date;
				RealPath += date + "/";
			
				File f = new File(RealPath);
				if (!f.exists()) {
					f.mkdir();
				}
				List list[] = new List[count % 20000 == 0 ? count / 20000 + 1
						: count / 20000 + 2];
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
				e.printStackTrace();
			}
			path = "exportExcel/"+ date + ".zip";
		} 
		else
		{
			CustomizedExcel ce = new CustomizedExcel(servletConfig);		
			File f = new File(RealPath);
			if (!f.exists()) {
				f.mkdir();
			}
			try {
				ce.WriteExcel(RealPath + filename, labels, titles, content);
			} catch (WriteException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			path = "exportExcel/" + filename;
		}
		
		return path;
	}
	//查看设备业务
	@SuppressWarnings("unchecked")
	public ResultModel getCarryOperaByCodeAndType(String code,String type,int start,int end,int groundOpera)
	{
		ResultModel result =new ResultModel();
		try
		{
			if("station".equalsIgnoreCase(type))//查看局站业务
			{//目前没有用到
				result.setTotalCount(this.carryOperaDao.getCarryOperaCountByStationcode(code,groundOpera));
				result.setOrderList(this.carryOperaDao.getCarryOperaByStationcode(code,start,end,groundOpera));
				result.setRateList(this.carryOperaDao.getOperaCountByStationCodeAndRate(code,groundOpera));
			}		
			else if("equipment".equalsIgnoreCase(type))//查看设备业务
			{
				result.setTotalCount(this.carryOperaDao.getCarryOperaCountByEquipcode(code,groundOpera));
				result.setOrderList(this.carryOperaDao.getCarryOpera_Flex(code,start,end,groundOpera));
				result.setRateList(this.carryOperaDao.getOperaCountByEquipCodeAndRate(code,groundOpera));
				
			}
			else if("topolink".equalsIgnoreCase(type))//查看复用段业务
			{
				result.setTotalCount(this.carryOperaDao.getCarryOperaCountByTopolink(code,groundOpera));
				result.setOrderList(this.carryOperaDao.getCarryOperaByTopolink(code,start,end,groundOpera));
				result.setRateList(this.carryOperaDao.getOperaCountByTopolinkAndRate(code,groundOpera));
			}
			else if("logicport".equalsIgnoreCase(type))//查看端口业务
			{
				result.setTotalCount(this.carryOperaDao.getCarryOperaCountByLogicPort(code,groundOpera));
				result.setOrderList(this.carryOperaDao.getCarryOperaByLogicPort(code,start,end,groundOpera));
				result.setRateList(this.carryOperaDao.getOperaCountByPortAndRate(code,groundOpera));
			}
			else if("equippack".equalsIgnoreCase(type))
			{//
				String[] array=code.split(",");
				String equipcode=array[0];
				String frameserial=array[1]; 
				String slotserial=array[2];
				String packserial=array[3];
				result.setTotalCount(this.carryOperaDao.getCarryOperaCountByEquipPack(equipcode, frameserial, slotserial, packserial,groundOpera));
				result.setOrderList(this.carryOperaDao.getCarryOperaByEquipPack(equipcode, frameserial, slotserial, packserial, start, end,groundOpera));
				result.setRateList(this.carryOperaDao.getOperaCountByPackAndRate(equipcode, frameserial, slotserial, packserial,groundOpera));
			}
			else if("timeslot".equalsIgnoreCase(type)){//目前没有用到
				String[] array=code.split(",");
				String portcode=array[0];
				String slotcode=array[1];
				result.setTotalCount(this.carryOperaDao.getCarryOperaCountByLogicPortAndSlot(portcode,slotcode));
				result.setOrderList(this.carryOperaDao.getCarryOperaByLogicPortAndSlot(portcode,slotcode,start,end));
				result.setRateList(this.carryOperaDao.getOperaCountByPortAndRateAndSlot(portcode,slotcode));
			}
			else if("ocable".equalsIgnoreCase(type))
			{
				
			    //目前没有用到
				Map map  = new HashMap();
				String sql = " ";
				List<HashMap> portMap=this.carryOperaDao.getPortsByOcable(code);
			    if(portMap.size()==0)
			    {
			    	result=null;
			    }
			    else
			    {
			    	for(int i=0;i<portMap.size();i++)
			    	{
			    		String aendport="";//A端设备端口
			    		String zendport="";//Z端设备端口
			    		String aendeqport = (String)portMap.get(i).get("AENDEQPORT");
						String aendodfport = (String)portMap.get(i).get("ZENDODFPORT");
						String zendeqport = (String)portMap.get(i).get("ZENDEQPORT");
						String zendodfport = (String)portMap.get(i).get("ZENDODFPORT");
						if(!aendodfport.equalsIgnoreCase(" ")&&!aendodfport.equalsIgnoreCase(null))//说明
						{
							aendport=aendodfport;
						}
						else if(!aendeqport.equalsIgnoreCase(" ")&&!aendeqport.equalsIgnoreCase(null))//说明
						{							
							aendport=aendeqport;
						}
						
						if(!zendodfport.equalsIgnoreCase(" ")&&!zendodfport.equalsIgnoreCase(null))//说明Z端为设备端口
						{
							zendport=zendodfport;
							
						}
						else if(!zendeqport.equalsIgnoreCase(" ")&&!zendeqport.equalsIgnoreCase(null))
						{
							zendport=zendeqport;
						}
						if(!aendport.equalsIgnoreCase("")&&!zendport.equalsIgnoreCase(""))
						{
							result.setTotalCount(this.carryOperaDao.getCarryOperaCountByTwoPort(aendport,zendport,groundOpera));
							result.setOrderList(this.carryOperaDao.getCarrayOperaByTwoPort(aendport,zendport,start,end,groundOpera));
							result.setRateList(this.carryOperaDao.getOperaCountByPortsAndRate(aendport,zendport,groundOpera));
							break;
						}
			    	}
			    }
				
//				result.setTotalCount(this.carryOperaDao.getCarryOperaCountByEquipPack(equipcode, frameserial, slotserial, packserial,groundOpera));
//				result.setOrderList(this.carryOperaDao.getCarryOperaByEquipPack(equipcode, frameserial, slotserial, packserial, start, end,groundOpera));
//				result.setRateList(this.carryOperaDao.getOperaCountByPackAndRate(equipcode, frameserial, slotserial, packserial,groundOpera));
			}
			
		
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return  result;
		
		
	}
}
