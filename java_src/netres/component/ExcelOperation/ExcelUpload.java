package netres.component.ExcelOperation;

import java.io.File;
import java.io.IOException;
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

public class ExcelUpload extends HttpServlet {

	private String uploadPath = null;;
	private int maxPostSize = 100 * 1024 * 1024;

	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(4096);
		ServletFileUpload upload = new ServletFileUpload(factory);
		String fullPath = this.getClass().getResource("").getPath().toString();// 文件所在的路径
		String RealPath = fullPath.substring(1, fullPath.indexOf("WEB-INF"));
		uploadPath = RealPath +"Ex2Ora/";
		String filename  = req.getParameter("filename");
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
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		}

	}
}