package indexEvaluation.model;

import indexEvaluation.dao.IndexEvaDAO;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Cell;
import jxl.CellType;
import jxl.DateCell;
import jxl.LabelCell;
import jxl.Sheet;
import jxl.Workbook;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import sysManager.log.dao.LogDao;
import flex.messaging.FlexContext;

public class LoadFile extends HttpServlet {

	private String uploadPath = null;;
	private int maxPostSize = 100 * 1024 * 1024;
	WebApplicationContext ctx = WebApplicationContextUtils
	.getWebApplicationContext(FlexContext.getServletContext());
	private IndexEvaDAO indexEvaDao = (IndexEvaDAO) ctx.getBean("indexEvaDao");
	/**
	 * 
	 */
	private static final long serialVersionUID = 3089316329737765177L;

	public void doGet(HttpServletRequest request, HttpServletResponse resopnse)
			throws IOException {
		doPost(request, resopnse);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse response)
			throws IOException {
		req.setCharacterEncoding("UTF-8");
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(4096);
		ServletFileUpload upload = new ServletFileUpload(factory);
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		String RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
		uploadPath = RealPath + "Ex2Ora/";
		// String filename = req.getParameter("filename");
		File f = new File(uploadPath);
		if (!f.exists()) {
			f.mkdir();
		}
		upload.setSizeMax(maxPostSize);
		try {
			List fileItems = upload.parseRequest(req);
			Iterator iter = fileItems.iterator();
			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				if (!item.isFormField()) {
					String name = item.getName();
					try {
						item.write(new File(uploadPath + name));
//						readExcel(uploadPath + name);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		}

	}

	/**
	 * 读取Excel
	 * 
	 * @param filePath
	 */
	public  void readExcel(String filePath) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		try {
			InputStream is = new FileInputStream(filePath);
			Workbook rwb = Workbook.getWorkbook(is);
			Sheet st = rwb.getSheet("sheet1");
			int rs = st.getColumns();
			int rows = st.getRows();
			rows = 60;
			Cell c0 = st.getCell(0, 2);//列、行
			// 通用的获取cell值的方式,返回字符串
			String time = c0.getContents();
			if (c0.getType() == CellType.DATE) {
				DateCell dc = (DateCell) c0;
				time = sdf.format(dc.getDate());

			}//获取统计时间
			
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
//						strc00 = new BigDecimal(value/(1.0-value)*100).setScale(4, BigDecimal.ROUND_HALF_UP)+"";
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
				this.indexEvaDao.insertIndexValueModel(key);
			}

			// 关闭
			rwb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
