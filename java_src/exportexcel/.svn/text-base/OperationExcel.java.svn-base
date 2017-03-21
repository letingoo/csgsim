package exportexcel;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

import javax.imageio.ImageIO;

import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableImage;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

public class OperationExcel {
	   
	//  private WritableWorkbook workbook;
	  public OperationExcel()
	  {
	  }	
	  
	  public void WriteExcel(String filename,String title,String [] labels,List content) throws IOException, WriteException
	  {		
	    WorkbookSettings ws = new WorkbookSettings();
	    ws.setLocale(new Locale("en", "EN"));
	    WritableWorkbook workbook = Workbook.createWorkbook(new File(filename), ws);
	    WritableSheet wsheet = workbook.createSheet("sheet1", 0);
	    WriteTitleSheet(wsheet,title,labels.length);
	    WriteLabelsSheet(wsheet,filename,labels);
	    WriteContentSheet(workbook,wsheet,content);
	    workbook.write();
	    workbook.close();
	  }

	  private void WriteTitleSheet(WritableSheet wsheet,String title,int in) throws IOException,WriteException{
		  WritableFont wfont = new WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,
				 jxl.format.UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.WHITE);
				 WritableCellFormat labelFormat = new WritableCellFormat(wfont);
				 labelFormat.setAlignment(jxl.format.Alignment.CENTRE);
				 labelFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); 
				 labelFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);	
				 labelFormat.setBackground(jxl.format.Colour.DARK_BLUE2);
				 labelFormat.setWrap(true);
				  wsheet.addCell(new Label(0,0,title,labelFormat));		
				  wsheet.mergeCells(0, 0, in-1, 0);	 
				  wsheet.setRowView(0, 450); 
	  } 
	  
	  private void WriteLabelsSheet(WritableSheet wsheet,String filename,String [] labels) throws IOException,WriteException{
		 
		    WritableFont wfont = new WritableFont(WritableFont.TIMES, 9,WritableFont.BOLD, false,
				 jxl.format.UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.WHITE);
			 WritableCellFormat titleFormat = new WritableCellFormat(wfont);
			 titleFormat.setAlignment(jxl.format.Alignment.CENTRE);
			 titleFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); 
			 titleFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);	
			 titleFormat.setBackground(jxl.format.Colour.OCEAN_BLUE);
			 titleFormat.setWrap(true);
		     int len=labels.length;
		     //wsheet.setColumnView(1, 20);
		     wsheet.setRowView(1, 450); 		 
		     for(int k=0;k<labels.length;k++){
		    	 wsheet.addCell(new Label(k,1,labels[k],titleFormat)); 
		     }		  
	  }
	
	  private void WriteContentSheet(WritableWorkbook workbook,WritableSheet wsheet,List content)throws IOException,WriteException{
		  WritableFont wfontLable = new WritableFont(WritableFont.TIMES, 9,
					WritableFont.NO_BOLD, false,
					jxl.format.UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat contentFormat = new WritableCellFormat(wfontLable);
			//contentFormat.setBackground(jxl.format.Colour.WHITE);	
			contentFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);
			contentFormat.setAlignment(jxl.format.Alignment.LEFT);
			contentFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); 
			contentFormat.setWrap(true);
			for(int i=0;i<content.size();i++){
				 //wsheet.setRowView(i+2, 600); //设置行高				
				 String[]strcon=content.get(i).toString().split(",");
				 strcon[0]=strcon[0].substring(1,strcon[0].length());
				 strcon[strcon.length-1]=strcon[strcon.length-1].substring(0,strcon[strcon.length-1].length()-1);
				for(int k=0;k<strcon.length;k++){
			     wsheet.setColumnView(k, 15);
		         wsheet.addCell(new Label(k,i+2,strcon[k],contentFormat));		
				}
		  }
	  }
	 
	  public void UpdateExcel(String filename)throws IOException, WriteException{
		 WritableFont wfontLable = new WritableFont(WritableFont.TIMES, 12,
					WritableFont.NO_BOLD, false,
					jxl.format.UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat contentFormat = new WritableCellFormat(wfontLable);
			contentFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);
			contentFormat.setAlignment(jxl.format.Alignment.LEFT);
			contentFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); 
		 try{
		   Workbook wb  =  Workbook.getWorkbook(new File(filename)); 
		   WritableWorkbook workbook  =  Workbook.createWorkbook( new  File(filename),wb); 
		   WritableSheet sheet  =  workbook.getSheet(0);
		 //以下代码更新excel中的cell如下
		   sheet.addCell(new Label(2,3,"GWXT安控2M-0001",contentFormat));
		   sheet.addCell(new Label(4,3,"国网信通公司",contentFormat));
		   sheet.addCell(new Label(2,4,"三峡左岸至龙泉换流站安控（1） （1＋1切换装置）通道（1） 接入方式",contentFormat));
		 //结束更新excel中的cell
		   workbook.write(); 
		   workbook.close(); 
		 }catch (Exception e){ 
			 e.printStackTrace();
	        } 
		 
	 } 
	 
	  public void UpdateExcelCellBySheet(String filename,int sheetnum)throws IOException, WriteException{
			 WritableFont wfontLable = new WritableFont(WritableFont.TIMES, 12,
						WritableFont.NO_BOLD, false,
						jxl.format.UnderlineStyle.NO_UNDERLINE,
						jxl.format.Colour.BLACK);
				WritableCellFormat contentFormat = new WritableCellFormat(wfontLable);
				contentFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);
				contentFormat.setAlignment(jxl.format.Alignment.LEFT);
				contentFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); 
			 try{
			   Workbook wb  =  Workbook.getWorkbook(new File(filename)); 
			   WritableWorkbook workbook  =  Workbook.createWorkbook( new  File(filename),wb); 
			   WritableSheet sheet  =  workbook.getSheet(sheetnum);
			 //以下代码更新excel中的cell如下
			   sheet.addCell(new Label(2,3,"GWXT安控2M-0001gg",contentFormat));
			   sheet.addCell(new Label(4,3,"国网信通公司",contentFormat));
			   sheet.addCell(new Label(2,4,"三峡左岸至龙泉换流站安控（1）gg （1＋1切换装置）通道（1） 接入方式",contentFormat));
			 //结束更新excel中的cell
			   workbook.write(); 
			   workbook.close(); 
			 }catch (Exception e){ 
				 e.printStackTrace();
		        } 
			 
		 } 
	
	  /** 只支持png类型的图片
	   * para:excelfilename 需要更新的excel的路径
	   * sheetnum 需要更新的第几个tab
	   * imagepath 写入excel的图片来源地址
	   * imagerow imagecol 图片要写到excel的列 行 开始
	   * 
	   */
	  public void UpdateExcelImageBySheet(String excelfilename,int sheetnum,String imagepath,int imagerow,int imagecol)throws IOException, WriteException{
			 WritableFont wfontLable = new WritableFont(WritableFont.TIMES, 12,
						WritableFont.NO_BOLD, false,
						jxl.format.UnderlineStyle.NO_UNDERLINE,
						jxl.format.Colour.BLACK);
				WritableCellFormat contentFormat = new WritableCellFormat(wfontLable);
				contentFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);
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
                //	输入参数, 图片显示的位置
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
				 e.printStackTrace();
		        } 
			 
		 } 
	
	  public void UpdateExcelImageByWidthAndHeight(String excelfilename,int sheetnum,String imagepath,int imagerow,int imagecol,int width,int height)throws IOException, WriteException{
			 WritableFont wfontLable = new WritableFont(WritableFont.TIMES, 12,
						WritableFont.NO_BOLD, false,
						jxl.format.UnderlineStyle.NO_UNDERLINE,
						jxl.format.Colour.BLACK);
				WritableCellFormat contentFormat = new WritableCellFormat(wfontLable);
				contentFormat.setBorder(Border.ALL, BorderLineStyle.THIN,jxl.format.Colour.BLACK);
				contentFormat.setAlignment(jxl.format.Alignment.LEFT);
				contentFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); 
			 try{
			   Workbook wb  =  Workbook.getWorkbook(new File(excelfilename)); 
			   WritableWorkbook workbook  =  Workbook.createWorkbook( new  File(excelfilename),wb); 
			   WritableSheet sheetpic  =  workbook.getSheet(sheetnum);			
			   File fileImage=new File(imagepath);
           
			   WritableImage image=new WritableImage(imagerow, imagecol,width,height,fileImage);
			   sheetpic.addImage(image);
			   workbook.write(); 
			   workbook.close(); 
			 }catch (Exception e){ 
				 e.printStackTrace();
		        } 
			 
		 } 
	
	  
	  
	  public void ReadExcel()throws IOException{
		  //方法体暂时为空
	  }
	  
}
