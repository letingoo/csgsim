/**
 * 自愈仿真指标评估前后台交互类
 */
package indexEvaluation.dwr;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.write.WriteException;

import indexEvaluation.dao.IndexEvaDAO;
import indexEvaluation.model.AHPComputeWeight;
import indexEvaluation.model.IndexEvaModel;
import indexEvaluation.model.ModifyExcel;
import indexEvaluation.model.ResultModel;
import indexEvaluation.model.SpringContextUtils;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;
import netres.model.ComboxDataModel;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import sysManager.log.dao.LogDao;

import com.sun.org.apache.xml.internal.security.utils.Base64;

import flex.messaging.FlexContext;

/**
 * @author xgyin
 *
 */
public class IndexEvaluationAction extends BaseAction{

//	private final static Log log = LogFactory.getLog(IndexEvaluationAction.class);
//	ApplicationContext ctx = WebApplicationContextUtils
//			.getWebApplicationContext(FlexContext.getServletContext());
//	
//	private IndexEvaDAO indexEvaDao;
//
//	public IndexEvaDAO getIndexEvaDao() {
//		return indexEvaDao;
//	}
//
//	public void setIndexEvaDao(IndexEvaDAO indexEvaDao) {
//		this.indexEvaDao = indexEvaDao;
//	}
//	
//	
	public List getSETData(IndexEvaModel model){
		return indexEvaDao.getSETData(model);
	}
//	private IndexEvaDAO indexEvaDao = null;
//	protected void onInit() {
//		indexEvaDao = (IndexEvaDAO) getBean("indexEvaDao");
//		super.onInit();
//	}
	 private static IndexEvaDAO indexEvaDao = (IndexEvaDAO) SpringContextUtils.getBean("indexEvaDao");
	
	public String getDeptLst() {
		String result = "";
		List<ComboxDataModel> list = indexEvaDao.getDeptLst();
		for (ComboxDataModel data : list) {
			result += "<deptinfo id=\"" + data.getId() + "\"label=\""
					+ data.getLabel()
					+ "\" name=\"deptinfo\" isBranch=\"false\"></deptinfo>";
		}
		return result;
	}
	
	public List getOperationQualityData(IndexEvaModel model){
		return this.indexEvaDao.getOperationQualityData(model);
	}
	
	public List getMaintainQualityData(IndexEvaModel model){
		return this.indexEvaDao.getMaintainQualityData(model);
	}
	
	public List getQualityEvaluationData(IndexEvaModel model){
		List<IndexEvaModel> lst = this.indexEvaDao.getQualityEvaluationData(model);
		//计算自愈值
		for(int i=0;i<lst.size();i++){
			IndexEvaModel key = lst.get(i);
			String relateType = key.getRelateType();
			if("正相关".equals(relateType)){
				//正相关
				String value1 = key.getValue();
				double value = 0.0;
				if(value1.indexOf("%")!=-1){
					value1 = value1.replace("%", "");
					value = Double.valueOf(value1)/100;
				}else{
					value = Double.valueOf(value1);
				}
				//float value = Float.parseFloat(value1)/100;
				if(value<=0.0){
					key.setSelf_healing_value("0");
				}else if(value>=1.0){
					key.setSelf_healing_value("100");
				}else{
					key.setSelf_healing_value(new BigDecimal(value/(1.0-value)*100).setScale(0, BigDecimal.ROUND_HALF_UP)+"");
				}
				
			}else if("负相关".equals(relateType)){
				//负相关
				String value1 = key.getValue();
				double value = 0.0;
				if(value1.indexOf("%")!=-1){
					value1 = value1.replace("%", "");
					value = Double.valueOf(value1)/100;
				}else{
					value = Double.valueOf(value1);
				}
				//float value = Float.parseFloat(value1)/100;
				if(value<=0.0){
					key.setSelf_healing_value("100");
				}else if(value>=1.0){
					key.setSelf_healing_value("0");
				}else{
					
					key.setSelf_healing_value(new BigDecimal(value/(1.0-value)*100).setScale(0, BigDecimal.ROUND_HALF_UP)+"");
				}
			}else{
				//0-1型
				if("是".equals(key.getValue())){
					key.setSelf_healing_value("100");
				}else{
					key.setSelf_healing_value("0");
				}
			}
			if("0".equals(key.getScore())||key.getScore()==null){
				key.setScore("1");
			}
		}
		return lst;
	}
	
	/**
	 * 查询指标
	 * 
	 **/
	public ActionForward qualityEvaluationDataAction(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws IOException{
		
		String dept = request.getParameter("dept");
		String time = request.getParameter("start");
		request.setAttribute("dept", dept);
		request.setAttribute("start", time);
		return new ActionForward("/show.jsp");
	}
	
	/**
	 * 更新基础数据
	 *
	 *updateBasticData
	 */
	public ActionForward updateBasticData(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws IOException{
		String type= request.getParameter("type");
		String dept = request.getParameter("dept");
		String start = request.getParameter("start");
		
		String id[] = request.getParameterValues("id");
		String calculate_method[] = request.getParameterValues("calculate_method");
		String operator_1[] =request.getParameterValues("operator_1");
		String operator_2[] = request.getParameterValues("operator_2");
		String value[] = request.getParameterValues("value");
		String score[] = request.getParameterValues("score");
		
		for(int i=0;i<id.length;i++){
			Map map = new HashMap();
			map.put("id", id[i]);
			if("自动".equals(calculate_method[i])){
				map.put("operator_1", "");
				map.put("operator_2", "");
				map.put("value", value[i]);
			}else{
				map.put("operator_1", operator_1[i]==null?"":operator_1[i]);
				map.put("operator_2", operator_2[i]==null?"":operator_2[i]);
				//当分子分母有为空的时候，直接获取value值
				if(operator_1[i]==null||"".equals(operator_1[i])||operator_2[i]==null||"".equals(operator_2[i])){
					map.put("value", value[i]);
				}else{
					map.put("value", String.valueOf(new BigDecimal(Double.valueOf(operator_1[i])/Double.valueOf(operator_2[i])).setScale(4, BigDecimal.ROUND_HALF_UP)));
				}
			}
			if("2".equals(type)){
				map.put("talename", "operation_quality");
			}else{
				map.put("talename", "index_evaluation");
			}
			map.put("score", score[i]);
			map.put("dept", dept);
			map.put("starttime", start);
			indexEvaDao.updateBasticData(map);
		}

		request.setAttribute("dept", dept);
		request.setAttribute("start", start);
		request.setAttribute("start1", start);
		
		if("1".equals(type)){
			
			return new ActionForward("/businessSuport.jsp");
		}
		else if("2".equals(type)){
			return new ActionForward("/operationQuality.jsp");
		}else{
			return new ActionForward("/maintainQuality.jsp");
		}

	}
	
	/**
	 * 查询基础数据
	 *
	 *updateBasticData
	 */
	public ActionForward queryProjectAccessList(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws IOException{
		String type= request.getParameter("type");
		String dept = request.getParameter("dept");
		String start = request.getParameter("start");
		
		
		request.setAttribute("start1", start);
		request.setAttribute("dept", dept);
		request.setAttribute("start", start);
		if("1".equals(type)){
			return new ActionForward("/businessSuport.jsp");
		}
		else if("2".equals(type)){
			return new ActionForward("/operationQuality.jsp");
		}else{
			return new ActionForward("/maintainQuality.jsp");
		}

	}
	
	/**
	 * 更新数据
	 *param:id,name,first_level,num
	 *name:setQualityEvaluationData
	 */
	public ActionForward setQualityEvaluationData(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws IOException{
		String flag = request.getParameter("flag");
		String id = request.getParameter("id");
		String first_level = request.getParameter("level");
		String name = request.getParameter("name");
		String num = request.getParameter("value");
		String dept = request.getParameter("dept");
		String time = request.getParameter("start");
		
		request.setAttribute("dept", dept);
		request.setAttribute("start", time);
		indexEvaDao.setQualityEvaluationData(id, first_level, name,num);
		if("1".equals(flag)){
			
			return new ActionForward("/show.jsp");
		}
		else{
			return this.calculateWeight(mapping, form, request, response);
		}
	}
	
	/**
	 * 导出操作
	 * exportExcl
	 * @throws IOException 
	 * 
	 **/
	public ActionForward exportExcl(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws IOException{
		
		String modeExcelWebRoot = getServletContext().getRealPath("/");
		String temp = modeExcelWebRoot;
		while (temp.indexOf("\\") != -1) {
			temp = temp.replace('\\', '/');
		}
		modeExcelWebRoot = temp + "exportExcel";
		String type= request.getParameter("type");
		String dept = request.getParameter("dept");
		String start = request.getParameter("start");
		IndexEvaModel model = new IndexEvaModel();
		if(dept==null){
			dept="";
		}
		if(start==null){
			start="";
		}
		
		model.setStarttime(start);
		model.setDept(dept);
		
		String filename = "";
		List<IndexEvaModel> csgYwLst = new ArrayList<IndexEvaModel>();
//		WebApplicationContext ctx = WebApplicationContextUtils
//		.getWebApplicationContext(FlexContext.getServletContext());
//		IndexEvaDAO indexDao = (IndexEvaDAO) ctx.getBean("indexEvaDao");
		
		if("1".equals(type)){
			filename="businessSuport";
			csgYwLst = indexEvaDao.getSETData(model);
		}else if("2".equals(type)){
			filename = "operateQuality";
			csgYwLst = indexEvaDao.getOperationQualityData(model);
		}else if("3".equals(type)){
			filename = "mantainQuality";
			csgYwLst = indexEvaDao.getMaintainQualityData(model);
		}else{
			filename = "indexEvaluation";
			csgYwLst = this.getQualityEvaluationData(model);
		}
		
		OutputStream out = response.getOutputStream();
		String commBugmodeExcelPath = modeExcelWebRoot + "/"+filename+".xls";
		FileInputStream fileIn = new FileInputStream(commBugmodeExcelPath);
		try {
			HSSFWorkbook wb = new HSSFWorkbook(fileIn);
			ModifyExcel m = new ModifyExcel();

			String excelName = filename+".xls";
			String s_attachment = "attachment; filename=" + excelName;
			s_attachment = new String(s_attachment.getBytes("gb2312"),
					"ISO8859-1");
			int location = 1;
			
			if("1".equals(type)||"3".equals(type)){
				for(int i=0;i<csgYwLst.size(); i++){
					if (i != 0)
						location = i+1;
					m.modify(wb, location+1, 0, String.valueOf(location));
					m.modify(wb, location+1, 1, (csgYwLst
							.get(i)).getName());
					m.modify(wb, location+1, 2, (csgYwLst
							.get(i)).getType());
					m.modify(wb, location+1, 3, (csgYwLst
							.get(i)).getCalculate_method());
					m.modify(wb, location+1, 4, (csgYwLst
							.get(i)).getOperator_1());
					m.modify(wb, location+1, 5, (csgYwLst
							.get(i)).getOperator_2());
					m.modify(wb, location+1, 6, (csgYwLst
							.get(i)).getValue());
					m.modify(wb, location+1, 7, (csgYwLst
							.get(i)).getScore());
					m.modify(wb, location+1, 8, (csgYwLst
							.get(i)).getStarttime());
				}
			}
			// 向指定的Excel文件中写入数据
			else if("2".equals(type)){
				for (int i = 0; i < csgYwLst.size(); i++) {
					if (i != 0)
						location = i+1;
					m.modify(wb, location+1, 0, String.valueOf(location));
					m.modify(wb, location+1, 1, (csgYwLst
							.get(i)).getNetwork()); 
					m.modify(wb, location+1, 2, (csgYwLst
							.get(i)).getType()); 
					m.modify(wb, location+1, 3, (csgYwLst
							 .get(i)).getName());
					m.modify(wb, location+1, 4, (csgYwLst
					 .get(i)).getCalculate_method());
					m.modify(wb, location+1, 5, (csgYwLst
							.get(i)).getOperator_1()); 
					m.modify(wb, location+1, 6, (csgYwLst
							.get(i)).getOperator_2());
					m.modify(wb, location+1, 7, (csgYwLst
							.get(i)).getValue());
					m.modify(wb, location+1, 8, (csgYwLst
							.get(i)).getScore());
					m.modify(wb, location+1, 9, (csgYwLst
							.get(i)).getStarttime());
				}
			}else{
				for (int i = 0; i < csgYwLst.size(); i++) {
					if (i != 0)
						location = i+1;
					m.modify(wb, location+1, 0, String.valueOf(location));
					m.modify(wb, location+1, 1, (csgYwLst
							.get(i)).getName()); 
					m.modify(wb, location+1, 2, (csgYwLst
							.get(i)).getFirst_level()); 
					m.modify(wb, location+1, 3, (csgYwLst
							 .get(i)).getNetwork());
					m.modify(wb, location+1, 4, (csgYwLst
					 .get(i)).getType());
					m.modify(wb, location+1, 5, (csgYwLst
							.get(i)).getSelf_healing_value()); 
					m.modify(wb, location+1, 6, (csgYwLst
							.get(i)).getScore());
//					m.modify(wb, location+1, 7, (csgYwLst
//							.get(i)).getWeight()==null?"":(csgYwLst.get(i)).getWeight());
					m.modify(wb, location+1, 7, (csgYwLst
							.get(i)).getStarttime());
				}
			}
			response.setHeader("Content-disposition", s_attachment); // 设定输出文件头
			response.setContentType("application/vnd.ms-excel");// 定义输出类型
			response.setContentType("text/html;charset=GBK");
			out = response.getOutputStream();
			wb.write(out);
			out.flush();
			fileIn.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * use:计算权重
	 * param:接受得分值字符串str,自愈值字符串str1
	 * 得分值不能为空，0需要特殊处理
	 * return:ResultModel
	 */
	public ActionForward calculateWeight(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws IOException{
//		ResultModel model = new ResultModel();
		
		//1、获取输入的得分值
		//查询条件需加时间
		String dept = request.getParameter("dept");
		String time = request.getParameter("start");
		if(dept==null){
			dept="";
		}
		if(time==null){
			time="";
		}
		IndexEvaModel model = new IndexEvaModel();
		model.setDept(dept);
		model.setStarttime(time);
		
		List<IndexEvaModel> lst = this.getQualityEvaluationData(model);
		String[] values = new String[lst.size()] ;
		String[] values1 = new String[lst.size()];
		for(int k=0;k<lst.size();k++){
			values[k]=lst.get(k).getScore().trim();//去空格
			values1[k] = lst.get(k).getSelf_healing_value().trim(); 
		}

		//2、按层次构造矩阵
		//3、计算每个矩阵的特征向量
		
		//list保存每个的权重
		List<Double> list = new ArrayList<Double>();
		
		//运行质量--传输网--技术符合度指标a1
		double[][] a1 = new double[][] { 
				{ 1, new Double(values[1])/new Double(values[2]), new Double(values[1])/new Double(values[3]) },  
                { new Double(values[2]) / new Double(values[1]),1, new Double(values[2])/new Double(values[3]) },  
                { new Double(values[3]) / new Double(values[1]), new Double(values[3]) /new Double(values[2]),1} };  
        int N1 = a1[0].length;  
        double[] weight1 = new double[N1];  //权重向量
        AHPComputeWeight instance = AHPComputeWeight.getInstance();  
        weight1 = instance.weight(a1, weight1, N1);//改写
        //求取新的自愈值，上一层的得分值是其下层的得分值和？
        double newVal1 = 0.0;
        for(int i=0;i<weight1.length;i++){
        	newVal1 += new Double(values1[i+1])*weight1[i];
        }
        int score1 = Integer.parseInt(values[1])+Integer.parseInt(values[2])+Integer.parseInt(values[3]);
        
      //同样构造另外的19个矩阵
      //运行质量--传输网--可靠性指标a2
        double[][] a2 = new double[][]{
        		{1,new Double(values[4])/new Double(values[5]),new Double(values[4])/new Double(values[6]),new Double(values[4])/new Double(values[7]),new Double(values[4])/new Double(values[8]),new Double(values[4])/new Double(values[9]),new Double(values[4])/new Double(values[10]),new Double(values[4])/new Double(values[11]),new Double(values[4])/new Double(values[12]),new Double(values[4])/new Double(values[13]),new Double(values[4])/new Double(values[14]),new Double(values[4])/new Double(values[15]),new Double(values[4])/new Double(values[16])},
        		{new Double(values[5])/new Double(values[4]),1,new Double(values[5])/new Double(values[6]),new Double(values[5])/new Double(values[7]),new Double(values[5])/new Double(values[8]),new Double(values[5])/new Double(values[9]),new Double(values[5])/new Double(values[10]),new Double(values[5])/new Double(values[11]),new Double(values[5])/new Double(values[12]),new Double(values[5])/new Double(values[13]),new Double(values[5])/new Double(values[14]),new Double(values[5])/new Double(values[15]),new Double(values[5])/new Double(values[16])},
        		{new Double(values[6])/new Double(values[4]),new Double(values[6])/new Double(values[5]),1,new Double(values[6])/new Double(values[7]),new Double(values[6])/new Double(values[8]),new Double(values[6])/new Double(values[9]),new Double(values[6])/new Double(values[10]),new Double(values[6])/new Double(values[11]),new Double(values[6])/new Double(values[12]),new Double(values[6])/new Double(values[13]),new Double(values[6])/new Double(values[14]),new Double(values[6])/new Double(values[15]),new Double(values[6])/new Double(values[16])},
        		{new Double(values[7])/new Double(values[4]),new Double(values[7])/new Double(values[5]),new Double(values[7])/new Double(values[6]),1,new Double(values[7])/new Double(values[8]),new Double(values[7])/new Double(values[9]),new Double(values[7])/new Double(values[10]),new Double(values[7])/new Double(values[11]),new Double(values[7])/new Double(values[12]),new Double(values[7])/new Double(values[13]),new Double(values[7])/new Double(values[14]),new Double(values[7])/new Double(values[15]),new Double(values[7])/new Double(values[16])},
        		{new Double(values[8])/new Double(values[4]),new Double(values[8])/new Double(values[5]),new Double(values[8])/new Double(values[6]),new Double(values[8])/new Double(values[7]),1,new Double(values[8])/new Double(values[9]),new Double(values[8])/new Double(values[10]),new Double(values[8])/new Double(values[11]),new Double(values[8])/new Double(values[12]),new Double(values[8])/new Double(values[13]),new Double(values[8])/new Double(values[14]),new Double(values[8])/new Double(values[15]),new Double(values[8])/new Double(values[16])},
        		{new Double(values[9])/new Double(values[4]),new Double(values[9])/new Double(values[5]),new Double(values[9])/new Double(values[6]),new Double(values[9])/new Double(values[7]),new Double(values[9])/new Double(values[8]),1,new Double(values[9])/new Double(values[10]),new Double(values[9])/new Double(values[11]),new Double(values[9])/new Double(values[12]),new Double(values[9])/new Double(values[13]),new Double(values[9])/new Double(values[14]),new Double(values[9])/new Double(values[15]),new Double(values[9])/new Double(values[16])},
        		{new Double(values[10])/new Double(values[4]),new Double(values[10])/new Double(values[5]),new Double(values[10])/new Double(values[6]),new Double(values[10])/new Double(values[7]),new Double(values[10])/new Double(values[8]),new Double(values[10])/new Double(values[9]),1,new Double(values[10])/new Double(values[11]),new Double(values[10])/new Double(values[12]),new Double(values[10])/new Double(values[13]),new Double(values[10])/new Double(values[14]),new Double(values[10])/new Double(values[15]),new Double(values[10])/new Double(values[16])},
        		{new Double(values[11])/new Double(values[4]),new Double(values[11])/new Double(values[5]),new Double(values[11])/new Double(values[6]),new Double(values[11])/new Double(values[7]),new Double(values[11])/new Double(values[8]),new Double(values[11])/new Double(values[9]),new Double(values[11])/new Double(values[10]),1,new Double(values[11])/new Double(values[12]),new Double(values[11])/new Double(values[13]),new Double(values[11])/new Double(values[14]),new Double(values[11])/new Double(values[15]),new Double(values[11])/new Double(values[16])},
        		{new Double(values[12])/new Double(values[4]),new Double(values[12])/new Double(values[5]),new Double(values[12])/new Double(values[6]),new Double(values[12])/new Double(values[7]),new Double(values[12])/new Double(values[8]),new Double(values[12])/new Double(values[9]),new Double(values[12])/new Double(values[10]),new Double(values[12])/new Double(values[11]),1,new Double(values[12])/new Double(values[13]),new Double(values[12])/new Double(values[14]),new Double(values[12])/new Double(values[15]),new Double(values[12])/new Double(values[16])},
        		{new Double(values[13])/new Double(values[4]),new Double(values[13])/new Double(values[5]),new Double(values[13])/new Double(values[6]),new Double(values[13])/new Double(values[7]),new Double(values[13])/new Double(values[8]),new Double(values[13])/new Double(values[9]),new Double(values[13])/new Double(values[10]),new Double(values[13])/new Double(values[11]),new Double(values[13])/new Double(values[12]),1,new Double(values[13])/new Double(values[14]),new Double(values[13])/new Double(values[15]),new Double(values[13])/new Double(values[16])},
        		{new Double(values[14])/new Double(values[4]),new Double(values[14])/new Double(values[5]),new Double(values[14])/new Double(values[6]),new Double(values[14])/new Double(values[7]),new Double(values[14])/new Double(values[8]),new Double(values[14])/new Double(values[9]),new Double(values[14])/new Double(values[10]),new Double(values[14])/new Double(values[11]),new Double(values[14])/new Double(values[12]),new Double(values[14])/new Double(values[13]),1,new Double(values[14])/new Double(values[15]),new Double(values[14])/new Double(values[16])},
        		{new Double(values[15])/new Double(values[4]),new Double(values[15])/new Double(values[5]),new Double(values[15])/new Double(values[6]),new Double(values[15])/new Double(values[7]),new Double(values[15])/new Double(values[8]),new Double(values[15])/new Double(values[9]),new Double(values[15])/new Double(values[10]),new Double(values[15])/new Double(values[11]),new Double(values[15])/new Double(values[12]),new Double(values[15])/new Double(values[13]),new Double(values[15])/new Double(values[14]),1,new Double(values[15])/new Double(values[16])},
        		{new Double(values[16])/new Double(values[4]),new Double(values[16])/new Double(values[5]),new Double(values[16])/new Double(values[6]),new Double(values[16])/new Double(values[7]),new Double(values[16])/new Double(values[8]),new Double(values[16])/new Double(values[9]),new Double(values[16])/new Double(values[10]),new Double(values[16])/new Double(values[11]),new Double(values[16])/new Double(values[12]),new Double(values[16])/new Double(values[13]),new Double(values[16])/new Double(values[14]),new Double(values[16])/new Double(values[15]),1}
        };
        int N2 = a2[0].length;  
        double[] weight2 = new double[N2];  //权重向量
//        AHPComputeWeight instance = AHPComputeWeight.getInstance();  
        weight2 = instance.weight(a2, weight2, N2);//改写
        //求取新的自愈值，上一层的得分值是其下层的得分值和？
        double newVal2 = 0.0;
        for(int i=0;i<weight2.length;i++){
        	newVal2 += new Double(values1[i+4])*weight2[i];
        }
        int score2 = Integer.parseInt(values[4])+Integer.parseInt(values[5])+Integer.parseInt(values[6])+Integer.parseInt(values[7])+
        			Integer.parseInt(values[8])+Integer.parseInt(values[9])+Integer.parseInt(values[10])+Integer.parseInt(values[11])+Integer.parseInt(values[12])+
        			Integer.parseInt(values[13])+Integer.parseInt(values[14])+Integer.parseInt(values[15])+Integer.parseInt(values[16]);
       
        //运行质量---传输网a3
        double[][] a3 = new double[][]{
        		{1,new Double(values[0])/score1,new Double(values[0])/score2},
        		{score1/new Double(values[0]),1,score1/score2},
        		{score2/new Double(values[0]),score2/score1,1}
        };
        int N3 = a3[0].length;
        double[] weight3 = new double[N3];
        weight3 = instance.weight(a3, weight3, N3);
        double newVal3 = weight3[0]*new Double(values1[0])+weight3[1]*newVal1+weight3[2]*newVal2;
        int score3 = Integer.parseInt(values[0])+score1+score2;
        
        //从这里添加权重到list中
        list.add(weight3[0]);
        for(int i=0;i<weight1.length;i++){
        	list.add(weight1[i]);
        }
        for(int j=0;j<weight2.length;j++){
        	list.add(weight2[j]);
        }
        
        
      //运行质量--调度交换网--技术符合度指标a4
        double[][] a4 = new double[][]{
        		{1,new Double(values[17])/new Double(values[18])},
        		{new Double(values[18])/new Double(values[17]),1}
        };
        int N4 = a4[0].length;
        double[] weight4 = new double[N4];
        weight4 = instance.weight(a4, weight4, N4);
        double newVal4 = 0.0;
        for(int i=0;i<weight4.length;i++){
        	newVal4 += weight4[i]* new Double(values1[i+17]);
        	list.add(weight4[i]);//添加到列表中
        }
        int score4 = Integer.parseInt(values[17])+Integer.parseInt(values[18]);
        
        
      //运行质量--调度交换网--可靠性指标a5
        double[][] a5 = new double[][]{
        		{1,new Double(values[19])/new Double(values[20])},
        		{new Double(values[20])/new Double(values[19]),1}
        };
        int N5 = a5[0].length;
        double[] weight5 = new double[N5];
        weight5 = instance.weight(a5, weight5, N5);
        double newVal5 = 0.0;
        for(int i=0;i<weight5.length;i++){
        	newVal5 += weight5[i]* new Double(values1[i+19]);
        	list.add(weight5[i]);
        }
        int score5 = Integer.parseInt(values[19])+Integer.parseInt(values[20]);
        
        //运行质量----调度交换网
        double[][] a8 = new double[][]{
        		{1,score4/score5},
        		{score5/score4,1}
        };
        int N8 = a8[0].length;
        double[] weight8 = new double[N8];
        weight8 = instance.weight(a8, weight8, N8);
        double newVal8 = weight8[0]*newVal4+weight8[1]*newVal5;
        int score8 = score5+score4;
        
        //运行质量--调度数据网---技术符合度指标a6
        double[][] a6 = new double[][]{
        		{1,new Double(values[22])/new Double(values[23]),new Double(values[22])/new Double(values[24]),new Double(values[22])/new Double(values[25])},
        		{new Double(values[23])/new Double(values[22]),1,new Double(values[23])/new Double(values[24]),new Double(values[23])/new Double(values[25])},
        		{new Double(values[24])/new Double(values[22]),new Double(values[24])/new Double(values[23]),1,new Double(values[24])/new Double(values[25])},
        		{new Double(values[25])/new Double(values[22]),new Double(values[25])/new Double(values[23]),new Double(values[25])/new Double(values[24]),1}
        };
        int N6 = a6[0].length;
        double[] weight6 = new double[N6];
        weight6 = instance.weight(a6, weight6, N6);
        double newVal6 = 0.0;
        for(int i=0;i<weight6.length;i++){
        	newVal6 += weight6[i]* new Double(values1[i+22]);
        }
        int score6 = Integer.parseInt(values[22])+Integer.parseInt(values[23])+Integer.parseInt(values[24])+Integer.parseInt(values[25]);
        
        //运行质量----调度数据网a7
        double[][] a7=new double[][]{
        		{1,new Double(values[21])/score6},
        		{score6/new Double(values[21]),1}
        };
        double[] weight7 = new double[a7[0].length];
        weight7 = instance.weight(a7, weight7, a7[0].length);
        double newVal7 = weight7[0]*new Double(values1[21])+weight7[1]*newVal6;
        int score7 = Integer.parseInt(values[21])+score6;
        list.add(weight7[0]);
        for(int i=0;i<weight6.length;i++){
        	list.add(weight6[i]);
        }
        
        
        //运行质量---光缆网a9
        double[][] a9 = new double[][]{
        		{1,new Double(values[26])/new Double(values[27]),new Double(values[26])/new Double(values[28])},
        		{new Double(values[27])/new Double(values[26]),1,new Double(values[27])/new Double(values[28])},
        		{new Double(values[28])/new Double(values[26]),new Double(values[28])/new Double(values[27]),1}
        };
        double[] weight9 = new double[a9[0].length];
        weight9 = instance.weight(a9, weight9, a9[0].length);
        double newVal9 = weight9[0]*new Double(values1[26])+weight9[1]*new Double(values1[27])+weight9[2]*new Double(values1[28]);
        int score9 = Integer.parseInt(values[26])+Integer.parseInt(values[27])+Integer.parseInt(values[28]);
        for(int i=0;i<weight9.length;i++){
        	list.add(weight9[i]);
        }
        
        //运行质量--视频会议系统a10
        double[][] a10 = new double[][]{
        		{1,new Double(values[29])/new Double(values[30]),new Double(values[29])/new Double(values[31]),new Double(values[29])/new Double(values[32]),new Double(values[29])/new Double(values[33])},
        		{new Double(values[30])/new Double(values[29]),1,new Double(values[30])/new Double(values[31]),new Double(values[30])/new Double(values[32]),new Double(values[30])/new Double(values[33])},
        		{new Double(values[31])/new Double(values[29]),new Double(values[31])/new Double(values[30]),1,new Double(values[31])/new Double(values[32]),new Double(values[31])/new Double(values[33])},
        		{new Double(values[32])/new Double(values[29]),new Double(values[32])/new Double(values[30]),new Double(values[32])/new Double(values[31]),1,new Double(values[32])/new Double(values[33])},
        		{new Double(values[33])/new Double(values[29]),new Double(values[33])/new Double(values[30]),new Double(values[33])/new Double(values[31]),new Double(values[33])/new Double(values[32]),1}
        };
        double[] weight10 = new double[a10[0].length];
        weight10 = instance.weight(a10, weight10, a10[0].length);
        double newVal10 = 0.0;
        for(int i=0;i<weight10.length;i++){
        	newVal10 += weight10[i]*new Double(values1[29+i]);
        	list.add(weight10[i]);
        }
        int score10 = Integer.parseInt(values[29])+Integer.parseInt(values[30])+Integer.parseInt(values[31])+Integer.parseInt(values[32])+Integer.parseInt(values[33]);
        
        //运行质量---行政交换网----技术符合度指标a11
        double[][] a11 = new double[][]{
        		{1,new Double(values[34])/new Double(values[35])},
        		{new Double(values[35])/new Double(values[34]),1}
        };
        int N11 = a11[0].length;				
        double[] weight11 = new double[N11];
        weight11 = instance.weight(a11, weight11, N11);
        double newVal11 = 0.0;
        for(int i=0;i<weight11.length;i++){
        	newVal11 += weight11[i]* new Double(values1[i+34]);
        	list.add(weight11[i]);
        }
        int score11 = Integer.parseInt(values[34])+Integer.parseInt(values[35]);
        
        //运行质量---行政交换网----可靠性指标a12
        double[][] a12 = new double[][]{
        		{1,new Double(values[36])/new Double(values[37]),new Double(values[36])/new Double(values[38])},
        		{new Double(values[37])/new Double(values[36]),1,new Double(values[37])/new Double(values[38])},
        		{new Double(values[38])/new Double(values[36]),new Double(values[38])/new Double(values[37]),1}
        };
        int N12 = a12[0].length;
        double[] weight12 = new double[N12];
        weight12 = instance.weight(a12, weight12, N12);
        double newVal12 = 0.0;
        for(int i=0;i<weight12.length;i++){
        	newVal12 += weight12[i]* new Double(values1[i+36]);
        	list.add(weight12[i]);
        }
        int score12 = Integer.parseInt(values[36])+Integer.parseInt(values[37])+Integer.parseInt(values[38]);
        
        //运行质量---行政交换网a13
        double[][] a13=new double[][]{
        		{1,score11/score12},
        		{score12/score11,1}
        };
        double[] weight13 = new double[a13[0].length];
        weight13 = instance.weight(a13, weight13, a13[0].length);
        double newVal13 = weight13[0]*newVal11+weight13[1]*newVal12;
        int score13 = score11+score12;
        
        //运行质量---综合数据网a14
        double[][] a14 = new double[][]{
        		{1,new Double(values[39])/new Double(values[40]),new Double(values[39])/new Double(values[41]),new Double(values[39])/new Double(values[42])},
        		{new Double(values[40])/new Double(values[39]),1,new Double(values[40])/new Double(values[41]),new Double(values[40])/new Double(values[42])},
        		{new Double(values[41])/new Double(values[39]),new Double(values[41])/new Double(values[40]),1,new Double(values[41])/new Double(values[42])},
        		{new Double(values[42])/new Double(values[39]),new Double(values[42])/new Double(values[40]),new Double(values[42])/new Double(values[41]),1}
        };
        int N14 = a14[0].length;
        double[] weight14 = new double[N14];
        weight14 = instance.weight(a14, weight14, N14);
        double newVal14 = 0.0;
        for(int i=0;i<weight14.length;i++){
        	newVal14 += weight14[i]* new Double(values1[i+39]);
        	list.add(weight14[i]);
        }
        int score14 = Integer.parseInt(values[39])+Integer.parseInt(values[40])+Integer.parseInt(values[41])+Integer.parseInt(values[42]);
       
        //运行质量指标b1
        double[][] b1 = new double[][]{
        		{1,score3/score8,score3/score7,score3/score9,score3/score10,score3/score13,score3/score14},
        		{score8/score3,1,score8/score7,score8/score9,score8/score10,score8/score13,score8/score14},
        		{score7/score3,score7/score8,1,score7/score9,score7/score10,score7/score13,score7/score14},
        		{score9/score3,score9/score8,score9/score7,1,score9/score10,score9/score13,score9/score14},
        		{score10/score3,score10/score8,score10/score7,score10/score9,1,score10/score13,score10/score14},
        		{score13/score3,score13/score8,score13/score7,score13/score9,score13/score10,1,score13/score14},
        		{score14/score3,score14/score8,score14/score7,score14/score9,score14/score10,score14/score13,1}
        };
        double[] W1 = new double[b1[0].length];
        W1 = instance.weight(b1, W1, b1[0].length);
        double V1 = W1[0]*newVal3+W1[1]*newVal8+W1[2]*newVal7+W1[3]*newVal9+W1[4]*newVal10+W1[5]*newVal13+W1[6]*newVal14;
        int S1 = score8+score3+score7+score9+score10+score13+score14;
        
        //运维质量指标b2
        double[][] b2 = new double[][]{
        		{1,new Double(values[43])/new Double(values[44])},
        		{new Double(values[44])/new Double(values[43]),1}
        };
        double[] W2 = new double[b2[0].length];
        W2 = instance.weight(b2, W2, b2[0].length);
        double V2 = W2[0]*new Double(values1[43])+W2[1]*new Double(values1[44]);
        int S2 = Integer.parseInt(values[43])+Integer.parseInt(values[44]);
        list.add(W2[0]);
        list.add(W2[1]);
        
        //业务支撑度----线路保护a15
        double[][] a15 = new double[][]{
        		{1,new Double(values[45])/new Double(values[46]),new Double(values[45])/new Double(values[47]),new Double(values[45])/new Double(values[48]),new Double(values[45])/new Double(values[49])},
        		{new Double(values[46])/new Double(values[45]),1,new Double(values[46])/new Double(values[47]),new Double(values[46])/new Double(values[48]),new Double(values[46])/new Double(values[49])},
        		{new Double(values[47])/new Double(values[45]),new Double(values[47])/new Double(values[46]),1,new Double(values[47])/new Double(values[48]),new Double(values[47])/new Double(values[49])},
        		{new Double(values[48])/new Double(values[45]),new Double(values[48])/new Double(values[46]),new Double(values[48])/new Double(values[47]),1,new Double(values[48])/new Double(values[49])},
        		{new Double(values[49])/new Double(values[45]),new Double(values[49])/new Double(values[46]),new Double(values[49])/new Double(values[47]),new Double(values[49])/new Double(values[48]),1}
        };
        double[] weight15 = new double[5];
        weight15 = instance.weight(a15, weight15, 5);
        double newVal15 = 0.0;
        for(int i=0;i<weight15.length;i++){
        	newVal15 += weight15[i]*new Double(values1[45+i]);
        	list.add(weight15[i]);
        }
        int score15 = Integer.parseInt(values[45])+Integer.parseInt(values[46])+Integer.parseInt(values[47])+Integer.parseInt(values[48])+Integer.parseInt(values[49]);
        
        //业务支撑度---安稳业务a16
        double[][] a16 = new double[][]{
        		{1,new Double(values[50])/new Double(values[51]),new Double(values[50])/new Double(values[52])},
        		{new Double(values[51])/new Double(values[50]),1,new Double(values[51])/new Double(values[52])},
        		{new Double(values[52])/new Double(values[50]),new Double(values[52])/new Double(values[51]),1}
        };
        double[] weight16 = new double[3];
        weight16 = instance.weight(a16, weight16, 3);
        double newVal16 = 0.0;
        for(int i=0;i<weight16.length;i++){
        	newVal16 += weight16[i]* new Double(values1[i+50]);
        	list.add(weight16[i]);
        }
        int score16 = Integer.parseInt(values[50])+Integer.parseInt(values[51])+Integer.parseInt(values[52]);
        
        //业务支撑度---调度自动化业务a17
        double[][] a17 = new double[][]{
        		{1,new Double(values[54])/new Double(values[55])},
        		{new Double(values[55])/new Double(values[54]),1}
        };
        double[] weight17 = new double[2];
        weight17 = instance.weight(a17, weight17, 2);
        double newVal17 = 0.0;
        for(int i=0;i<weight17.length;i++){
        	newVal17 += weight17[i]* new Double(values1[i+54]);
        }
        int score17 = Integer.parseInt(values[54])+Integer.parseInt(values[55]);
        
        //业务支撑度指标b3
        double[][] b3 = new double[][]{
        		{1,score15/score16,score15/new Double(values[53]),score15/score17,score15/new Double(values[56]),score15/new Double(values[57])},
        		{score16/score15,1,score16/new Double(values[53]),score16/score17,score16/new Double(values[56]),score16/new Double(values[57])},
        		{new Double(values[53])/score15,new Double(values[53])/score16,1,new Double(values[53])/score17,new Double(values[53])/new Double(values[56]),new Double(values[53])/new Double(values[57])},
        		{score17/score15,score17/score16,score17/new Double(values[53]),1,score17/new Double(values[56]),score17/new Double(values[57])},
        		{new Double(values[56])/score15,new Double(values[56])/score16,new Double(values[56])/new Double(values[53]),new Double(values[56])/score17,1,new Double(values[56])/new Double(values[57])},
        		{new Double(values[57])/score15,new Double(values[57])/score16,new Double(values[57])/new Double(values[53]),new Double(values[57])/score17,new Double(values[57])/new Double(values[56]),1}
        };
        double[] W3 = new double[6];
        W3 = instance.weight(b3, W3, 6);
        double V3 = W3[0]*newVal15+W3[1]*newVal16+W3[2]*new Double(values1[53])+W3[3]*newVal17+W3[4]*new Double(values1[56])+W3[5]*new Double(values1[57]);
        int S3 = score15+score16+score17+Integer.parseInt(values[53])+Integer.parseInt(values[56])+Integer.parseInt(values[57]);
        
        list.add(W3[2]);
        list.add(weight17[0]);
        list.add(weight17[1]);
        list.add(W3[4]);
        list.add(W3[5]);
        
        for(int j=0;j<lst.size();j++){
        	lst.get(j).setWeight(String.valueOf(list.get(j)));
        }
        //系统总体判断矩阵T
        double[][] T = new double[][]{
        		{1,S1/S2,S1/S3},
        		{S2/S1,1,S2/S3},
        		{S3/S1,S3/S2,1}
        };
        double[] W = new double[3];
        W = instance.weight(T, W, 3);
        double V = W[0]*V1+W[1]*V2+W[2]*V3;//总体评估值
        V = instance.round(V, 4);//取小数点后4位
        request.setAttribute("resultLst", lst);
        request.setAttribute("score", V);
        
        request.setAttribute("dept", dept);
        request.setAttribute("start", time);
        //把总体评估值存数据库
        Map mp = new HashMap();
        mp.put("dept", dept);
        mp.put("time", time);
        mp.put("value", V);
       String obj =  this.indexEvaDao.getIndexValueByMap(mp);
       if(obj==null||"".equals(obj)){
    	   this.indexEvaDao.insertIndexValueByMap(mp);
       }else{
    	   this.indexEvaDao.updateIndexValueByMap(mp);
       }
//        model.setOrderList(lst);
//        model.setScore(V);
        //返回列表和总体评估值
//		return model;
        
        return new ActionForward("/showweight.jsp");
	}
	
	/**
	 * 导出
	 * name:exportExcelQualityEva
	 * 
	 */
	public String exportExcelQualityEva(String labels, String[] titles , String types,ArrayList al){
		String path = null;// 返回到前台的路径
		List<String> content = new ArrayList<String>();
		ServletConfig servletConfig = FlexContext.getServletConfig();
		String RealPath = null;// 绝对路径
		String date = getName();
//		String filename = types + "-" + date + ".xls";
		String filename = date + ".xls";
	
		for(int i = 0;i<al.size();i++){
			IndexEvaModel key = (IndexEvaModel) al.get(i);
			String str = "";
			str += i+1+"##";
			str += key.getFirst_level() == null? " ##":key.getFirst_level()+"##";
			str += key.getNetwork() == null ?" ##":key.getNetwork()+"##";
			str += key.getType()==null? " ##":key.getType()+"##";
			str += key.getName()==null? " ##":key.getName()+"##";
			str += key.getSelf_healing_value() == null? " ##":key.getSelf_healing_value()+"##";
			str += key.getScore() == null? " ##":key.getScore()+"##";
			str += key.getWeight() == null? " ##":key.getWeight()+"##";
			content.add(str);
		}
		
		CustomizedExcel oe = new CustomizedExcel(servletConfig);
		try {
			RealPath = this.getRealPath();
			File f = new File(RealPath);
			if (!f.exists()) {
				f.mkdir();
			}
			oe.WriteExcel_Alarm(RealPath + filename, labels, titles, content);
		} catch (Exception e) {
			e.printStackTrace();
		}
		path = "exportExcel/" + filename;
	
		return path;
	}
	
	/**
	 * 导出
	 * @param modelname
	 * @param tabledata
	 * @param imageArray
	 * @param colnum
	 * @return
	 * @throws IOException
	 */
	public String getExcel(String modelname,String tabledata,byte[] imageArray,int colnum) throws  IOException{
    	String realPath ="";
		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		realPath = request.getRealPath("");
		System.out.println("kkkkkkkk>>>>>"+tabledata);
		String excelFilePath = realPath
				+ "/assets/excels/expfiles/"
				+ modelname + ".xls";
//		String adds=Base64.encode(imageArray);
//		System.out.println("kkkkkkkk>>>>>"+adds);
		
		try{
			BufferedReader br=new BufferedReader(new FileReader(realPath+"/assets/Templates/report.txt"));
			String str="";
			String r=br.readLine();
			while(r!=null){
				str+=r+"\n";
				r=br.readLine();
			}
			int w=840/colnum;
			str+=" <col width=3D"+w+" span=3D8 style=3D'mso-width-source:userset'>";
//			str+="<tr height=3D300 style=3D'mso-height-source:userset'>\n";
//			str+=" <td colspan=3D"+colnum+"> <img width=3D840 height=3D300 src=3D'report.files/image002.png'></td>\n";
//			str+="</tr>\n";
			//int w=900/colnum;
			tabledata=tabledata.replaceAll("'", "");
			tabledata=tabledata.replaceAll("\"", "");
			tabledata=tabledata.replaceAll("rowspan=","rowspan=3D");
			tabledata=tabledata.replaceAll("colspan=","colspan=3D");
			tabledata=tabledata.replaceAll("class=normal","class=3Dxl26");
			tabledata=tabledata.replaceAll("class=fixedcolumn","class=3Dxl25");
			tabledata=tabledata.replaceAll("class=fixedrow","class=3Dxl25");
			tabledata=tabledata.replaceAll("class=subtotal","class=3Dxl27");
			str+=tabledata+"\n";
			str+="</table>\n";
			str+="\n";
			str+="</body>\n";
			str+="\n";
			str+="</html>\n\n";
			str+="------=BOUNDARY_9527------\n";
			str+="Content-Location: file:///C:/A257C953/report.files/image002.png\n";
			str+="Content-Transfer-Encoding: base64\n";
			str+="Content-Type:  text/html\n\n";
////			str+=adds+"\n\n";
			str+="------=BOUNDARY_9527--------\n";
			FileOutputStream osi=new FileOutputStream(excelFilePath); 
			osi.write(str.getBytes("UTF-8"));
			osi.flush();   
			osi.close(); 
			return "success";
		}catch(Exception e){	
			return "failed";
		}
    }
	/**
	 * 获取时间的函数
	 * */
	public static String getName() {
		SimpleDateFormat sDateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH.mm.ss");
		return sDateFormat.format(new java.util.Date().getTime());
	}

	/**
	 * 获取文件路径
	 * */
	public String getRealPath() {
		String RealPath = null;// 绝对路径
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		RealPath = fullPath.substring(0, fullPath.indexOf("WEB-INF"));// linux下的情况
		RealPath += "exportExcel/";
		return RealPath;
	}
}
