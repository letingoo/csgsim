package netres.component;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class FileUpload extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6873900545709468013L;
	
	private static final Log log = LogFactory.getLog(FileUpload.class);
	
	private static final int MAX_ROOM_FILE_COUNT = 5;
	private static final String ROOM_FILE_DIR = "roomAttachment";
	private static final String POWER_FILE_DIR = "powerAttachment";
	
	private String uploadPath = null;
	private int maxPostSize = 100 * 1024 * 1024;

	@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(4096);
		ServletFileUpload upload = new ServletFileUpload(factory);
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		String RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
		uploadPath = RealPath;
		//String filename  = req.getParameter("filename");
		String filepath=req.getParameter("filepath");
		File f = new File(uploadPath+filepath);
//		System.out.println("path:"+uploadPath+filepath);
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
					//如果是机房
					if(f.getPath().indexOf(ROOM_FILE_DIR) > -1 || f.getPath().indexOf(POWER_FILE_DIR) > -1){
						name = new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "_" + name; 
					}
//					System.out.println("name:"+uploadPath + name);
					try {
						item.write(new File(uploadPath +filepath+ name));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			
			//如果为机房附件  且超过5个时
			if((f.getPath().indexOf(ROOM_FILE_DIR) > -1 || f.getPath().indexOf(POWER_FILE_DIR) > -1) && f.isDirectory()){
				if(f.listFiles().length > MAX_ROOM_FILE_COUNT){
					File [] files = f.listFiles();
					File oldestFile = files[0];
					for(int i=0,n=files.length; i<n; i++){
						if(files[i].lastModified() <= oldestFile.lastModified()){
							oldestFile = files[i];
						}
					}
					if(null != oldestFile){
						if(log.isDebugEnabled()){
							log.debug("delete oldest room attachment! " + oldestFile.getName());
						}
					    oldestFile.delete();
					}
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		}

	}
}