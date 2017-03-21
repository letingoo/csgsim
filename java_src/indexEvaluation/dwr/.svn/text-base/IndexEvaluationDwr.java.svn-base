/**
 * 自愈仿真指标评估前后台交互类
 */
package indexEvaluation.dwr;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;

import jxl.Cell;
import jxl.CellType;
import jxl.DateCell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.write.WriteException;

import indexEvaluation.dao.IndexEvaDAO;
import indexEvaluation.model.AHPComputeWeight;
import indexEvaluation.model.IndexEvaModel;
import indexEvaluation.model.ResultModel;

import netres.component.ExcelOperation.CustomizedExcel;
import netres.component.ExcelOperation.ZipExcel;
import netres.model.ComboxDataModel;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
public class IndexEvaluationDwr {

	private final static Log log = LogFactory.getLog(IndexEvaluationDwr.class);
	ApplicationContext ctx = WebApplicationContextUtils
			.getWebApplicationContext(FlexContext.getServletContext());
	
	private IndexEvaDAO indexEvaDao;

	public IndexEvaDAO getIndexEvaDao() {
		return indexEvaDao;
	}

	public void setIndexEvaDao(IndexEvaDAO indexEvaDao) {
		this.indexEvaDao = indexEvaDao;
	}
	
	
	public List getSETData(IndexEvaModel model){
		return indexEvaDao.getSETData(model);
	}
	
	public List<IndexEvaModel> getIndexEvalNamelst(String dept,String time ){
		IndexEvaModel model = new IndexEvaModel();
		if("".equals(dept)||dept==null){
			dept="广州";
		}
		if("".equals(time)||time==null){
			time = this.indexEvaDao.getMaxTimeByTableUnion();
		}
		model.setDept(dept);
		model.setStarttime(time);
		List<IndexEvaModel> lst = this.getQualityEvaluationData(model);
		return lst;
	}
	
	public String getIndexValueByTime(String dept,String time){
		if("".equals(dept)||dept==null){
			dept="广州";
		}
		if("".equals(time)||time==null){
			time = this.indexEvaDao.getMaxTimeByTableUnion();
		}
		Map map = new HashMap();
		map.put("dept", dept);
		map.put("time", time);
		String value = this.indexEvaDao.getIndexValueBymap(map);
		return dept+"="+time+"="+value;
	}
	
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
	
	public List<IndexEvaModel> getIndexEvalValueLst(IndexEvaModel model){
		return this.indexEvaDao.getIndexEvalValueLst(model);
//		String label = "00000000000000080656#00000000000000063298";
//		String obj = this.indexEvaDao.getRESID(label);
//		System.out.println("-----"+obj);
//		return null;
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
	 * 更新数据
	 *param:id,name,first_level,num
	 *name:setQualityEvaluationData
	 */
	public void setQualityEvaluationData(String id,String first_level,String name,String num){
		indexEvaDao.setQualityEvaluationData(id, first_level, name,num);
	}
	
	/**
	 * use:计算权重
	 * param:接受得分值字符串str,自愈值字符串str1
	 * 得分值不能为空，0需要特殊处理
	 * return:ResultModel
	 */
	public ResultModel calculateWeight(){
		ResultModel model = new ResultModel();
		
		//1、获取输入的得分值
		List<IndexEvaModel> lst = this.getQualityEvaluationData(new IndexEvaModel());
		String[] values = new String[lst.size()] ;
		String[] values1 = new String[lst.size()];
		for(int k=0;k<lst.size();k++){
			values[k]=lst.get(k).getScore();
			values1[k] = lst.get(k).getSelf_healing_value(); 
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
        model.setOrderList(lst);
        model.setScore(V);
        //返回列表和总体评估值
		return model;
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
		String date = getName();
		String excelFilePath = realPath
				+ "/assets/excels/expfiles/"
				+ date + ".xls";
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
			return "success;"+date;
		}catch(Exception e){	
			return "failed";
		}
    }
	
	/**
	 * 数据导入 
	 * importDataProcess
	 **/
	public String importDataProcess(String filename){
		String result="success";
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		String RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
		String uploadPath = RealPath + "Ex2Ora/";
		result = readExcel(uploadPath + filename);
		return result;
	}
	/**
	 * 读取Excel
	 * 
	 * @param filePath
	 */
	public  String  readExcel(String filePath) {
		String result="success";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		String time="";
		try {
			InputStream is = new FileInputStream(filePath);
			Workbook rwb = Workbook.getWorkbook(is);
			Sheet st = rwb.getSheet("sheet1");
			int rs = st.getColumns();
			int rows = st.getRows();
			rows = 60;
			Cell c0 = st.getCell(0, 2);//列、行
			// 通用的获取cell值的方式,返回字符串
			time = c0.getContents();
			if (c0.getType() == CellType.DATE) {
				DateCell dc = (DateCell) c0;
				time = sdf.format(dc.getDate());

			}//获取统计时间
			if(time==null||"".equals(time)){
				result="fail";
				return result;
			}
			
			for (int k = 2; k < rows; k++) {// 行
				List<String> list = new ArrayList<String>();
				for (int i = 0; i < rs; i++) {// 列
					Cell c00 = st.getCell(i, k);
					// 通用的获取cell值的方式,返回字符串
					String strc00 = c00.getContents();
					// excel 类型为时间类型处理;
					if (c00.getType() == CellType.DATE) {
						DateCell dc = (DateCell) c00;
						strc00 = sdf.format(dc.getDate());

					}
					double value = 0.0;
					// excel 类型为百分数值类型处理;
					if(strc00.indexOf("%")!=-1){
						strc00 = strc00.replace("%", "");
						value = Double.valueOf(strc00)/100;
						strc00 =value+"";
					}

					list.add(strc00);

				}
				IndexEvaModel key = new IndexEvaModel();
				key.setDept("广州");
				key.setStarttime(time);
				//通信网络运行质量指标
				if(k==2){
					key.setNetwork("传输网");
					key.setType("规模指标");
					key.setTablename("operation_quality");
				}else if(2<k&&k<6){
					key.setNetwork("传输网");
					key.setType("技术符合度指标");
					key.setTablename("operation_quality");
				}else if(k>=6&&k<19){
					key.setNetwork("传输网");
					key.setType("可靠性指标");
					key.setTablename("operation_quality");
				}else if(k>=19&&k<21){
					key.setNetwork("调度交换网");
					key.setType("技术符合度指标");
					key.setTablename("operation_quality");
				}else if(k>=21&&k<23){
					key.setNetwork("调度交换网");
					key.setType("可靠性指标");
					key.setTablename("operation_quality");
				}else if(k==23){
					key.setNetwork("调度数据网");
					key.setType("规模指标");
					key.setTablename("operation_quality");
				}else if(k>23&&k<28){
					key.setNetwork("调度数据网");
					key.setType("技术符合指标");
					key.setTablename("operation_quality");
				}else if(k>=28&&k<31){
					key.setNetwork("光缆网");
					key.setType("光缆网指标");
					key.setTablename("operation_quality");
				}else if(k>=31&&k<36){
					key.setNetwork("视频会议系统");
					key.setType("视频会议系统指标");
					key.setTablename("operation_quality");
				}else if(k>=36&&k<38){
					key.setNetwork("行政交换网");
					key.setType("技术符合度指标");
					key.setTablename("operation_quality");
				}else if(k>=38&&k<41){
					key.setNetwork("行政交换网");
					key.setType("可靠性指标");
					key.setTablename("operation_quality");
				}else if(k>=41&&k<45){
					key.setNetwork("综合数据网");
					key.setType("综合数据网指标");
					key.setTablename("operation_quality");
				}
				//业通信网络运维质量指标
				else if(k>=45&&k<47){
					key.setType("通信网络运维质量指标");
					key.setTablename("index_evaluation");
				}
				//业务支撑度指标
				else if(k>=47&&k<50){
					key.setType("安稳业务");
					key.setTablename("index_evaluation");
				}else if(k>=50&&k<53){
					key.setType("调度电话业务");
					key.setTablename("index_evaluation");
				}else if(k==53){
					key.setType("视频会议业务");
					key.setTablename("index_evaluation");
				}else if(k>53&&k<59){
					key.setType("线路保护业务");
					key.setTablename("index_evaluation");
				}else{
					key.setType("行政电话业务");
					key.setTablename("index_evaluation");
				}
				key.setName(list.get(4));
				key.setValue(list.get(7));
				key.setRelateType(list.get(5));
				key.setCalculate_method(list.get(6));
				key.setScore(list.get(8));
				//查找当前日期的指标，如果有则更新，否则插入
				List<String> lst = this.indexEvaDao.getIndexEvalNameLst(key);
				if(lst!=null&&lst.size()>0){
					//更新
					this.indexEvaDao.updateIndexEvalModel(key);
				}else{
					this.indexEvaDao.insertIndexValueModel(key);
				}
			}

			// 关闭
			rwb.close();
		} catch (Exception e) {
			e.printStackTrace();
			result="fail";
		}
		return result+";"+time;//还需要返回时间
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
