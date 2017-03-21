package channelroute.dwr;

import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import jxl.Workbook;
import jxl.biff.ByteArray;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableImage;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import flex.messaging.FlexContext;



public class ExportChannelRouteToExcelByCircuitCode {
        
	/**
	 * @param circuitcode 电路编号
	 * @param sqlMapClientTemplate
	 * @param xml
	 * @param url 前端的路径
	 * @return
	 * @throws Exception
	 */
	public String exportExcel(String circuitcode,SqlMapClientTemplate sqlMapClientTemplate,String xml,String url) throws Exception {
		
		List items = sqlMapClientTemplate.queryForList("getCircuitInfoflex",circuitcode);
		Map resultForRemark = new HashMap();
		String remark="";
		int s = items.size();
		if (s > 0) {
			resultForRemark=(HashMap)items.get(0);
			remark = resultForRemark.get("REMARK").toString();
			if(remark.indexOf(".")!=0){
				remark = remark.replace(".", "_");
			} 
			if(remark.indexOf(">")!=0){
				remark = remark.replace(">", "_");
			}
			if(remark.indexOf("<")!=0){
				remark = remark.replace("<", "_");
			} 
			}
		HttpServletRequest request = FlexContext.getHttpRequest();// 获取Request对象
		String realPath = request.getRealPath("");
		String templateFilePath = realPath
				+ "/assets/excels/template/circuitExcelTemplate.xls";
		String circuitFilePath = realPath
				+ "/assets/excels/expfiles/"
				+ circuitcode+"【"+remark+"】" + ".xls";
		String relativeCircuitFilePath=realPath+"/assets/excels/expfiles/"
		+ circuitcode + ".xls";
		String filepath =realPath+"/assets/excels/expfiles/"; 
		String filename=circuitcode+"【"+remark+"】";
		FileInputStream fin = new FileInputStream(new File(templateFilePath));
		FileOutputStream fout = new FileOutputStream(new File(circuitFilePath));
		int bytesRead;
		byte[] buf = new byte[4 * 1024]; // 4K
		while ((bytesRead = fin.read(buf)) != -1) {
			fout.write(buf, 0, bytesRead);
		}
		fout.flush();
		fout.close();
		fin.close();
		Map resultMap = new HashMap();
		int size = items.size();
		if (size > 0) {
			resultMap=(HashMap)items.get(0);
			try {
				Workbook wb = Workbook.getWorkbook(new File(circuitFilePath));
				WritableWorkbook workbook = Workbook.createWorkbook(new File(
						circuitFilePath), wb);
				WritableSheet sheet = workbook.getSheet(0);
				//以下add by sjt
				Label C4 = (Label) sheet.getWritableCell(2, 3);
				C4.setString(resultMap.get("CIRCUITCODE") ==null ? "" : resultMap.get("CIRCUITCODE").toString());
				Label C5 = (Label) sheet.getWritableCell(2, 4);
				C5.setString(resultMap.get("REQUISITIONID") == null ? "" : resultMap
						.get("REQUISITIONID").toString());
				
				Label E4 = (Label) sheet.getWritableCell(4, 3);
				E4.setString(resultMap.get("USERCOM") == null ? "" : resultMap
						.get("USERCOM").toString());
				
				
				Label E5 =  (Label) sheet.getWritableCell(4,4);
				E5.setString(resultMap.get("REQUESTCOM") == null ? ""
						: resultMap.get("REQUESTCOM").toString());
				Label C6 = (Label) sheet.getWritableCell(2, 5);
				C6.setString(resultMap.get("REMARK") == null ? ""
						: resultMap.get("REMARK").toString());
			
				Label C7 = (Label) sheet.getWritableCell(2, 6);
				C7.setString(resultMap.get("IMPLEMENTATION_UNITS")== null ? ""
						: resultMap.get("IMPLEMENTATION_UNITS").toString());
				Label C8 = (Label) sheet.getWritableCell(2, 7);
				C8.setString(resultMap.get("USERNAME") == null ? "" : resultMap
						.get("USERNAME").toString());
				Label E8 = (Label) sheet.getWritableCell(4, 7);
				E8.setString(resultMap.get("OPERATIONTYPE") == null ? ""
						: resultMap.get("OPERATIONTYPE").toString());
				Label C9 = (Label) sheet.getWritableCell(2, 8);
				C9.setString(resultMap.get("RATE") == null ? "" : resultMap
						.get("RATE").toString());
				Label E9 = (Label) sheet.getWritableCell(4, 8);
				E9.setString(resultMap.get("CIRCUITLEVEL") == null ? ""
						: resultMap.get("CIRCUITLEVEL").toString());
				Label C10 = (Label) sheet.getWritableCell(2, 9);
				C10.setString(resultMap.get("INTERFACETYPE") == null ? ""
						: resultMap.get("INTERFACETYPE").toString());
				Label E10 = (Label) sheet.getWritableCell(4, 9);
				E10.setString(resultMap.get("STATE") == null ? "" : resultMap
						.get("STATE").toString());
				Label C11 = (Label) sheet.getWritableCell(2, 10);
				C11.setString(resultMap.get("STATION1") == null ? ""
						: resultMap.get("STATION1").toString());
				Label E11 = (Label) sheet.getWritableCell(4, 10);
				E11.setString(resultMap.get("STATION2") == null ? ""
						: resultMap.get("STATION2").toString());
				Label C12 = (Label) sheet.getWritableCell(2, 11);
				C12.setString(resultMap.get("EQUIP1") == null ? "" : resultMap
						.get("EQUIP1").toString());
				Label E12 = (Label) sheet.getWritableCell(4, 11);
				E12.setString(resultMap.get("EQUIP2") == null ? "" : resultMap
						.get("EQUIP2").toString());
				Label C13 = (Label) sheet.getWritableCell(2, 12);
				C13.setString(resultMap.get("PORTSERIALNO1") == null ? ""
						: resultMap.get("PORTSERIALNO1").toString());
				Label C14 = (Label) sheet.getWritableCell(2, 13);
				C14.setString(resultMap.get("PORTSERIALNO2") == null ? ""
						: resultMap.get("PORTSERIALNO2").toString());
				Label C15 = (Label) sheet.getWritableCell(2, 14);
				C15.setString(resultMap.get("LEASER") == null ? ""
						: resultMap.get("LEASER").toString());
				Label E15 = (Label) sheet.getWritableCell(4, 14);
				E15.setString(resultMap.get("CREATETIME") == null ? ""
						: resultMap.get("CREATETIME").toString());
				Label C16 = (Label) sheet.getWritableCell(2, 15);
				C16.setString(resultMap.get("REQUESTFINISH_TIME") == null ? "" : resultMap
						.get("REQUESTFINISH_TIME").toString());
				Label E16 = (Label) sheet.getWritableCell(4, 15);
				E16.setString(resultMap.get("USETIME") == null ? "" : resultMap
						.get("USETIME").toString());
				Label C17 = (Label) sheet.getWritableCell(2, 16);
				C17.setString(resultMap.get("CHECK1") == null ? "" : resultMap
						.get("CHECK1").toString());
				Label E17 = (Label) sheet.getWritableCell(4, 16);
				E17.setString(resultMap.get("CHECK2") == null ? "" : resultMap
						.get("CHECK2").toString());
				Label C18 = (Label) sheet.getWritableCell(2, 17);
				C18.setString(resultMap.get("APPROVER") == null ? "" : resultMap
						.get("APPROVER").toString());
				Label C19 = (Label) sheet.getWritableCell(2, 18);
				C19.setString(resultMap.get("BEIZHU") == null ? "" : resultMap
						.get("BEIZHU").toString());			
				WritableSheet sheet1 = workbook.getSheet(1);
				Label sheet1C2=(Label)sheet1.getWritableCell(2, 1);
				sheet1C2.setString(resultMap.get("CIRCUITCODE")==null?"":resultMap.get("CIRCUITCODE").toString());
				Label sheet1L2=(Label)sheet1.getWritableCell(12, 1);
				sheet1L2.setString(resultMap.get("OPERATIONTYPE")==null?"":resultMap.get("OPERATIONTYPE").toString());
				Label sheet1C3=(Label)sheet1.getWritableCell(2, 2);
				sheet1C3.setString(resultMap.get("REMARK")==null?"":resultMap.get("REMARK").toString());
				workbook.write();
				workbook.close();
				this.UpdateExcelImageBySheet(circuitFilePath, 1, request.getRealPath("")
	     				+ "/assets/excels/template/test.png", 1, 4);
				// String path = request.getLocalName();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return filename;
	}
	public String exportChannelRouteImage(String xml,String realPath,ByteArray array)
	{
		
		try
		{
			File file = new File("/expFile/image.png");  
			String imagePath =("/expFile/image.png");
			FileOutputStream fos = new FileOutputStream(file); 
			BufferedOutputStream out= new BufferedOutputStream(fos); 
			BufferedImage bi = new BufferedImage(200, 200, BufferedImage.TYPE_INT_RGB);
			 byte[] imgByte = array.getBytes();   
		        InputStream in = new ByteArrayInputStream(imgByte);   
		        byte[] b = new byte[1024];   
		        int nRead = 0;   
		           
		        FileOutputStream fout = new FileOutputStream(new File(""));
		           
		        while( ( nRead = in.read(b) ) != -1 ){   
		        	fout.write( b, 0, nRead );   
		        }   
		           
		        fout.flush();   
		        fout.close();   
		           
		        in.close();   
//		           System.out.println("######");
			
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return "";
	}
	public void UpdateExcelImageBySheet(String excelfilename,int sheetnum,String imagepath,int imagerow,int imagecol)throws IOException, WriteException{
		 WritableFont wfontLable = new WritableFont(WritableFont.TIMES, 12,
					WritableFont.NO_BOLD, false,
					jxl.format.UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat contentFormat = new WritableCellFormat(wfontLable);
			//contentFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);
			contentFormat.setAlignment(jxl.format.Alignment.LEFT);
			contentFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); 
		 try{
		   Workbook wb  =  Workbook.getWorkbook(new File(excelfilename)); 
		   WritableWorkbook workbook  =  Workbook.createWorkbook( new  File(excelfilename),wb); 
		   WritableSheet sheetpic  =  workbook.getSheet(sheetnum);			
		   File fileImage=new File(imagepath);
		   BufferedImage bi7 = ImageIO.read(new File(imagepath));   
		     int picWidth = bi7.getWidth();   
		     int picHeight = bi7.getHeight(); 
           //	输入参数, 图片显示的位�?
		        double picBeginCol = 1.2;
		        double picBeginRow = 1.2;
		        double picCellWidth = 0.0; 
		        double picCellHeight = 0.0;
		        int _picWidth = picWidth * 32 ; 
		        for(int x=0; x< 1234; x++)
		        {
		            int bc = (int)Math.floor( picBeginCol + x ); 
		            int v = sheetpic.getColumnView( bc ).getSize(); 
		            double _offset0 = 0.0; 
		            if( 0 == x )
		                _offset0 = ( picBeginCol - bc ) * v ; 			           
		            if( 0.0 + _offset0 + _picWidth > v ) 
		            {
		                double _ratio = 1.0;
		                if( 0 == x )
		                    _ratio = ( 0.0 + v - _offset0 ) / v;
		                picCellWidth += _ratio;
		                _picWidth -= (int)( 0.0 + v - _offset0 ); // int
		            }
		            else {
		                double _ratio = 0.0;
		                if( v != 0 )
		                    _ratio = ( 0.0 + _picWidth ) / v;
		                picCellWidth += _ratio;
		                break;
		            }
		            if( x >= 1233 )
		                {}
		        } 
		        // 此时 picCellWidth 
		        int _picHeight = picHeight * 15 ; 
		        for(int x=0; x< 1234; x++)
		        {
		            int bc = (int)Math.floor( picBeginRow + x ); 
		            int v = sheetpic.getRowView( bc ).getSize(); 
		            double _offset0 = 0.0; 
		            if( 0 == x )
		                _offset0 = ( picBeginRow - bc )*v ; 
		            if( 0.0 + _offset0 + _picHeight > v ) 
		            {		
		                double _ratio = 1.0;
		                if( 0 == x )
		                    _ratio = ( 0.0 + v - _offset0 )/v;
		                picCellHeight += _ratio;
		                _picHeight -= (int)( 0.0 + v - _offset0 );
		            }
		            else 
		            {
		                double _ratio = 0.0;
		                if( v != 0 )
		                    _ratio = ( 0.0 + _picHeight )/v;
		                picCellHeight += _ratio;
		                break;
		            }
		            if( x >= 1233 )
		                {}
		        }
		   WritableImage image=new WritableImage(imagerow, imagecol,picCellWidth,picCellHeight,fileImage);
		   sheetpic.addImage(image);
		   workbook.write(); 
		   workbook.close(); 
		 }catch (Exception e){ 
//	           System.out.println(e); 
			 e.printStackTrace();
	        } 
		 
	 } 
}
