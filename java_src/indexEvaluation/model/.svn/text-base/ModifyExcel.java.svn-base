package indexEvaluation.model;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
//import org.apache.poi.ss.usermodel.IndexedColors;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServlet;
import java.io.IOException;




/**
 * 说明:
 * 建立时间: 2007-9-6 8:58:06
 *
 * @author: zhangyong
 */


 /*
****************************************************
冲突后全部修改过的版本，张用 07/10/11日，状态：测试通过 ，修改次数：01
****************************************************
*/
    
public class ModifyExcel  extends HttpServlet  {

    public void init() throws ServletException {
    }

    //Process the HTTP Get request
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {



    }


    //Process the HTTP Post request
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        doGet(request, response);
    }

    //Clean up resources
    public void destroy() {
    }


    public  void modify(HSSFWorkbook workbook,int modifyRow, int modifyCell , String modifiyContent) {

        try {
            HSSFSheet sheet;
            HSSFRow row;
            HSSFCell cell;
            sheet = workbook.getSheetAt(0);
            HSSFCellStyle setBorder = workbook.createCellStyle();
            setBorder.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
            setBorder.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
            setBorder.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
            setBorder.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
            setBorder.setWrapText(true);//设置自动换行
            setBorder.setFillForegroundColor((short) 13);// 设置背景色
            row = sheet.getRow(modifyRow);
            if(row == null){
            	row = sheet.createRow(modifyRow);
            	row.setHeight((short) 440);
            }
            cell = row.getCell((short) modifyCell);
            if(cell==null){
            	cell = row.createCell((short) modifyCell);
            }
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellValue(modifiyContent);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //add by wangyk at 2009-7-31 14:20 for
    //重写modify方法，参数是一个sheet，不是整个excle对象。
    public  void modify(HSSFSheet sheet,int modifyRow, int modifyCell , String modifiyContent) {
    	
    	try {    		
    		HSSFRow row;
    		HSSFCell cell;    		
    		row = sheet.getRow(modifyRow);
    		//cell = row.getCell((short) modifyCell);
    		
    		//设置样式
    		HSSFWorkbook workbook=new HSSFWorkbook();
    		HSSFCellStyle style0 = workbook.createCellStyle();
		    HSSFFont font0 = workbook.createFont();
		    font0.setFontName("宋体");
		    font0.setFontHeightInPoints((short) 18);
		    font0.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		    style0.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		    style0.setFont(font0);

    		//if(cell==null ){
    				
    			   cell = row.createCell((short) modifyCell);
    			   cell.setCellStyle(style0);
    		//} 
    		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    		if(modifiyContent==null)
    			cell.setCellValue(" ");
    		else
    			cell.setCellValue(modifiyContent);    	
    		}catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public  void modifyForTitle(HSSFWorkbook workbook,int modifyRow, int modifyCell ,int size, String modifiyContent) {
    	
    	try {
    		HSSFSheet sheet;
            HSSFRow row;
            HSSFCell cell;
            sheet = workbook.getSheetAt(0);
            sheet.addMergedRegion(new Region(0,(short)0,0,(short)size));
            
            row = sheet.getRow(modifyRow);
            if(row==null){
            	row=sheet.createRow((short) 0);
            }
            cell = row.getCell((short) modifyCell);
            if(cell==null ){        		
        		cell = row.createCell((short) modifyCell);    		        		
        		}     
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);            
                		    		    		    		
    		//设置样式
    		HSSFCellStyle style0 = workbook.createCellStyle();
    		style0.setFillForegroundColor(HSSFColor.BLUE.index);
    		HSSFFont font0 = workbook.createFont();
    		font0.setFontName("宋体");
    		font0.setFontHeightInPoints((short) 18);
    		font0.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		style0.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		style0.setFont(font0);
    		
    		//if(cell==null ){
    		
    		//cell = row.createCell((short) modifyCell);    		
    		//cell.setCellStyle(style0);
    		//}     		
    		if(modifiyContent==null)
    			cell.setCellValue(" ");
    		else
    			cell.setCellValue(modifiyContent);    	
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
    }

   
    public static void copyRows(HSSFWorkbook wb, String pSourceSheetName,

                                String pTargetSheetName, int pStartRow, int pEndRow, int pPosition) {

        HSSFRow sourceRow = null;
        HSSFRow targetRow = null;
        HSSFCell sourceCell = null;
        HSSFCell targetCell = null;
        HSSFSheet sourceSheet = null;
        HSSFSheet targetSheet = null;
        Region region = null;

        int cType;
        int i;
        short j;
        int targetRowFrom;
        int targetRowTo;

        if ((pStartRow == -1) || (pEndRow == -1)) {
            return;
        }
        sourceSheet = wb.getSheet(wb.getSheetName(0));
        targetSheet = wb.getSheet(wb.getSheetName(0));

        // 拷贝合并的单元格

        for (i = 0; i < sourceSheet.getNumMergedRegions(); i++) {
            region = sourceSheet.getMergedRegionAt(i);
            if ((region.getRowFrom() >= pStartRow)&& (region.getRowTo() <= pEndRow)) {
                targetRowFrom = region.getRowFrom() - pStartRow + pPosition;
                targetRowTo = region.getRowTo() - pStartRow + pPosition;
                region.setRowFrom(targetRowFrom);
                region.setRowTo(targetRowTo);
                targetSheet.addMergedRegion(region);
            }
        }

        // 设置列宽
        for (i = pStartRow; i <= pEndRow; i++) {
            sourceRow = sourceSheet.getRow(i);
            if (sourceRow != null) {
                for (j = sourceRow.getLastCellNum(); j > sourceRow.getFirstCellNum(); j--) {
                    targetSheet.setColumnWidth(j, sourceSheet.getColumnWidth(j));
                   // targetSheet.setColumnHidden(j, false);
                }
                break;
            }
        }

        // 拷贝行并填充数据
        for (; i <= pEndRow; i++) {
            sourceRow = sourceSheet.getRow(i);
            if (sourceRow == null) {
                continue;
            }
            targetRow = targetSheet.createRow(i - pStartRow + pPosition);
            targetRow.setHeight(sourceRow.getHeight());
            for (j = sourceRow.getFirstCellNum(); j < sourceRow.getPhysicalNumberOfCells(); j++) {
                sourceCell = sourceRow.getCell(j);
                if (sourceCell == null) {
                    continue;
                }
                targetCell = targetRow.createCell(j);
                targetCell.setEncoding(sourceCell.getEncoding());
                targetCell.setCellStyle(sourceCell.getCellStyle());
                cType = sourceCell.getCellType();
                targetCell.setCellType(cType);
                switch (cType) {
                    case HSSFCell.CELL_TYPE_BOOLEAN:
                        targetCell.setCellValue(sourceCell.getBooleanCellValue());
                        break;
                    case HSSFCell.CELL_TYPE_ERROR:
                        targetCell.setCellErrorValue(sourceCell.getErrorCellValue());
                        break;
                    case HSSFCell.CELL_TYPE_FORMULA:
                        
                        targetCell.setCellFormula(parseFormula(sourceCell.getCellFormula()));

                        break;
                    case HSSFCell.CELL_TYPE_NUMERIC:
                        targetCell.setCellValue(sourceCell.getNumericCellValue());

                        break;
                    case HSSFCell.CELL_TYPE_STRING:
                        targetCell.setCellValue(sourceCell.getStringCellValue());
                        
                        break;
                }

            }

        }

    }

    private static String parseFormula(String pPOIFormula) {
        final String cstReplaceString = "ATTR(semiVolatile)"; 
        StringBuffer result = null;
        int index;

        result = new StringBuffer();
        index = pPOIFormula.indexOf(cstReplaceString);
        if (index >= 0) {
            result.append(pPOIFormula.substring(0, index));
            result.append(pPOIFormula.substring(index
                    + cstReplaceString.length()));
        } else {
            result.append(pPOIFormula);
        }

        return result.toString();
    }


    /**
     * 合并单元格（行）
     * @param workbook 
     * @param modifyRow 合并开始行号
     * @param modifyCell 列号
     * @param endRow 合并终止行号
     * @param modifiyContent  填充内容
     */
    public  void modifyMerge(HSSFWorkbook workbook,int modifyRow, int modifyCell , int endRow,String modifiyContent) {
        try {
            HSSFSheet sheet;
            HSSFRow row;
            HSSFCell cell;
            sheet = workbook.getSheetAt(0);
            row = sheet.getRow(modifyRow);
            sheet.addMergedRegion(new Region(modifyRow, (short) modifyCell, endRow, (short) modifyCell));  
        	HSSFCellStyle style0 = workbook.createCellStyle();
    		style0.setFillForegroundColor(HSSFColor.BLUE.index);
    		HSSFFont font0 = workbook.createFont();
    		font0.setFontName("宋体");
    		font0.setFontHeightInPoints((short) 11);
    		font0.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		style0.setAlignment(HSSFCellStyle.ALIGN_CENTER);//水平居中   
    		style0.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直居中 
    		style0.setFont(font0);
    		cell = row.getCell((short) modifyCell);
      		cell.setCellStyle(style0);
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellValue(modifiyContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * 字体加粗,带背景颜色
     * @param workbook
     * @param modifyRow
     * @param modifyCell
     * @param modifiyContent
     */
    public  void modifyTitle(HSSFWorkbook workbook,int modifyRow, int modifyCell , String modifiyContent) {
        try {
            HSSFSheet sheet;
            HSSFRow row;
            HSSFCell cell;
            sheet = workbook.getSheetAt(0);
            row = sheet.getRow(modifyRow);
            HSSFCellStyle style0 = workbook.createCellStyle();
    		style0.setFillForegroundColor(HSSFColor.BLUE.index);
    		style0.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
    		style0.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
    		style0.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
    		style0.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
    		HSSFFont font0 = workbook.createFont();
    		font0.setFontName("宋体");
    		font0.setFontHeightInPoints((short) 11);
    		font0.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		style0.setAlignment(HSSFCellStyle.ALIGN_CENTER);//水平居中   
    		style0.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直居中 
//    		style0.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());// 设置背景色
    		style0.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
    		style0.setFont(font0);
    		cell = row.getCell((short) modifyCell);
      		cell.setCellStyle(style0);
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellValue(modifiyContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 字体加粗，无背景
     * @param workbook
     * @param modifyRow
     * @param modifyCell
     * @param modifiyContent
     */
    public  void modifyTitleNoCol(HSSFWorkbook workbook,int modifyRow, int modifyCell , String modifiyContent) {
        try {
            HSSFSheet sheet;
            HSSFRow row;
            HSSFCell cell;
            sheet = workbook.getSheetAt(0);
            row = sheet.getRow(modifyRow);
            HSSFCellStyle style0 = workbook.createCellStyle();
    		style0.setFillForegroundColor(HSSFColor.BLUE.index);
    		style0.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
    		style0.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
    		style0.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
    		style0.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
    		HSSFFont font0 = workbook.createFont();
    		font0.setFontName("宋体");
    		font0.setFontHeightInPoints((short) 11);
    		font0.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		style0.setAlignment(HSSFCellStyle.ALIGN_CENTER);//水平居中   
    		style0.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//垂直居中 
    		style0.setFont(font0);
    		cell = row.getCell((short) modifyCell);
      		cell.setCellStyle(style0);
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellValue(modifiyContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}