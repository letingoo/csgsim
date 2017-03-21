package ftp;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.commons.net.ftp.FTPFile;
import java.util.StringTokenizer;
import java.io.OutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

import java.io.InputStream;

import java.io.*;
import org.apache.tools.zip.ZipOutputStream;
import org.apache.tools.zip.ZipEntry;

/**
 * 
 * 该类提供了用ftp协议上传和下载文件的服务
 * 
 * @author MingGAO
 * @version 0.5.0 2005-8-30
 * 
 */
public class FtpTransmitUtil {

	private String serverUrl = null;
	private String user = null;
	private String password = null;
	private FTPClient ftp = null;

	public FtpTransmitUtil(String server_url, String user, String password) {
		this.serverUrl = server_url;
		this.user = user;
		this.password = password;
		this.ftp = new FTPClient();
	}

	/**
	 * 打开连接
	 * 
	 * @throws Exception
	 */
	public void openConnection() throws Exception {
		try {
			int reply = -1;
			ftp.connect(this.serverUrl);
			reply = ftp.getReplyCode();
			if (!FTPReply.isPositiveCompletion(reply)) {
				ftp.disconnect();
				return;
			}
			ftp.login(this.user, this.password);
		} catch (Exception e) {
			if (ftp.isConnected()) {
				try {
					ftp.disconnect();
				} catch (IOException ioe) {
				}
			}
			throw e;
		}
	}

	/**
	 * 关闭连接
	 * 
	 * @throws Exception
	 */
	public void closeConnection() throws Exception {
		try {
			ftp.logout();
		} catch (Exception e) {
			throw e;
		} finally {
			if (ftp.isConnected()) {
				try {
					ftp.disconnect();
				} catch (IOException ioe) {
					// do nothing
				}
			}
		}
	}

	/**
	 * 上传文件到远程服务器
	 * 
	 * @param local_file_name
	 *            待上传的目录或文件
	 * @throws Exception
	 */
	public void uploadFile(File file) throws Exception {
		try {
			FileInputStream fi = new FileInputStream(file);
			BufferedInputStream bi = new BufferedInputStream(fi);
			String fileName = null;
			String local_file_name = file.getName();
			int pos = local_file_name.lastIndexOf("\\");
			if (pos == -1) {
				fileName = local_file_name;
			} else {
				fileName = local_file_name.substring(pos + 1, local_file_name
						.length());
			}
			String fileType = fileName.substring(fileName.lastIndexOf(".") + 1,
					fileName.length());
			String filePath = "report";
			if (fileType.equalsIgnoreCase("jpg")
					|| fileType.equalsIgnoreCase("jpeg")
					|| fileType.equalsIgnoreCase("gif")) {
				filePath = "picture";
			} else if (fileType.equalsIgnoreCase("htm")
					|| fileType.equalsIgnoreCase("html")
					|| fileType.equalsIgnoreCase("swf")) {
				filePath = "report";
			} else {
				filePath = "rpt";
			}

			if (fileType.equalsIgnoreCase("jpg")
					|| fileType.equalsIgnoreCase("jpeg")
					|| fileType.equalsIgnoreCase("gif")
					|| fileType.equalsIgnoreCase("swf")) {
				ftp.setFileType(FTP.IMAGE_FILE_TYPE);
			} else if (fileType.equalsIgnoreCase("htm")
					|| fileType.equalsIgnoreCase("html")
					|| fileType.equalsIgnoreCase("jsp")) {
				ftp.setFileType(FTP.ASCII_FILE_TYPE);
			} else if (fileType.equalsIgnoreCase("txt")) {
				ftp.setFileType(FTP.BINARY_FILE_TYPE);
			} else {
				throw new Exception("文件类型错误！");
			}
			ftp.changeWorkingDirectory(filePath);
			ftp.storeFile(fileName, bi);
			bi.close();
		} catch (Exception e) {
			if (ftp.isConnected()) {
				try {
					ftp.disconnect();
				} catch (IOException ioe) {
					// do nothing
				}
			}
			throw e;
		}
	}

	/**
	 * 向文本文件中写入内容<br>
	 * 
	 * @param path
	 * @param content
	 * @param append
	 */
	public static void writefile(String path, String content, boolean append) {
		BufferedWriter bw;
		File writefile;
		try {
			// 通过这个对象来判断是否向文本文件中追加内容
			boolean addStr = append;

			writefile = new File(path);

			// 如果文本文件不存在则创建它
			if (writefile.exists() == false) {
				writefile.createNewFile();
				writefile = new File(path); // 重新实例化
			}
			FileWriter fw = new FileWriter(writefile, addStr);
			bw = new BufferedWriter(fw);
			fw.write(content);
			fw.flush();
			fw.close();
		} catch (Exception d) {
			System.out.println(d.getMessage());
		}

	}

	public static void main(String[] args) throws Exception {

//		String str = "0 14007 <Sender> hw_tcp_cc08 $ 3 id$className$type$String$String$String$hw_tcp_cc08$domain$physical$\r\n";
//
//		str += "0 14007 <Sender> hw_tcp_cc08 $ 3 id$className$type$String$String$String$hw_tcp_cc08$domain$logical$";
//		FtpTransmitUtil.writefile("D:\\uploadify\\eee.txt", str, false);

		// FtpTransmitUtil util = new FtpTransmitUtil("10.10.2.80", "Anonymous",
		// null);
		FtpTransmitUtil util = new FtpTransmitUtil("188.154.202.69",
				"administrator", "abc123!@#");
		// util.openConnection();
		// util.downloadFileFromFtp("D:\\video_location\\",
		// util.closeConnection();
		// try {
		util.openConnection();
		util.uploadFile(new File("D:\\uploadify\\ff.jpg"));
		util.closeConnection();
		// } catch (Exception e) {
		// e.printStackTrace();
		// try {
		// util.closeConnection();
		// } catch (Exception ex) {
		// }
		// }

	}

	/**
	 * 从远程服务器上下载文件，亦可考虑下载所有文件。
	 * 
	 * @param local_dir
	 *            本地目录
	 * @param remote_file_name
	 *            远程文件名后缀
	 * @throws Exception
	 */
	public void downloadFileFromFtp(String local_dir, String fileName)
			throws Exception {
		try {

			FileOutputStream fo = new FileOutputStream(local_dir + fileName);
			BufferedOutputStream bo = new BufferedOutputStream(fo);
			Thread.currentThread().sleep(10000); // 延时1秒
			try {
				ftp.retrieveFile(fileName, bo); // 从FTP上下载符合条件的文件
				// ftp.deleteFile(fileName); //从FTP上删除已下载文件
			} catch (Exception e) {

			}
			bo.flush();
			bo.close();

		} catch (Exception e) {
			if (ftp.isConnected()) {
				try {
					ftp.disconnect();
				} catch (IOException ioe) {
					// do nothing
				}
			}
			throw e;
		}
	}

	/**
	 * 从远程服务器上下载文件，亦可考虑下载所有文件。
	 * 
	 * @param local_dir
	 *            本地目录
	 * @param remote_file_name
	 *            远程文件名后缀
	 * @throws Exception
	 */
	public void downloadFile(String local_dir, String remote_fileSuffix)
			throws Exception {
		try {
			String fileName = null;

			FTPFile[] files = ftp.listFiles();

			for (int i = 0; i < files.length; i++) {
				fileName = files[i].getName();
				if (fileName.endsWith(remote_fileSuffix)) {
					FileOutputStream fo = new FileOutputStream(local_dir + "\\"
							+ fileName);
					BufferedOutputStream bo = new BufferedOutputStream(fo);

					ftp.retrieveFile(fileName, bo); // 从FTP上下载符合条件的文件
					// ftp.deleteFile(fileName); //从FTP上删除已下载文件
					bo.flush();
					bo.close();
				}
			}
		} catch (Exception e) {
			if (ftp.isConnected()) {
				try {
					ftp.disconnect();
				} catch (IOException ioe) {
					// do nothing
				}
			}
			throw e;
		}
	}

	/**
	 * 从远程服务器上下载文件。
	 * 
	 * @param local_dir
	 *            本地目录
	 * @param remote_file_name
	 *            远程文件名
	 * @throws Exception
	 */
	public boolean downloadFtpFile(HttpServletRequest request,
			HttpServletResponse response, String remote_fileSuffix)
			throws Exception {
		try {
			String fileName = null;
			ArrayList fileList = new ArrayList();
			if (remote_fileSuffix.equals("all")) {
				String tmpFile = "c:\\ftpDowndAll";
				String tmpZip = "c:\\all.zip";
				File f = new File(tmpFile);
				File zf = new File(tmpZip);

				fileList = (ArrayList) request.getSession().getAttribute(
						"allFile");

				OutputStream fo = response.getOutputStream();
				for (int k = 0; k < fileList.size(); k++) {
					String strArray[] = fileList.get(k).toString().split("/");
					for (int i = 4; i < strArray.length - 1; i++) {
						ftp.cwd(strArray[i]);
					}
					fileName = strArray[strArray.length - 1];

					String str = "";
					ftp.setControlEncoding("GBK");
					str = fileName;

					fileName = fileName + ".mp3";

					response.setContentType("application/x-msdownload");
					response.setHeader("Content-Disposition",
							"attachment;filename=all.zip");
					str = new String(str.getBytes("GBK"), "ISO-8859-1");
					if (!f.exists())
						f.mkdir();
					FileOutputStream lo = new FileOutputStream(f + "\\"
							+ fileName);

					BufferedOutputStream bo = new BufferedOutputStream(lo);

					ftp.retrieveFile(str, bo);
					bo.flush();
					bo.close();

					lo.flush();
					lo.close();
					// 从FTP上下载符合条件的文件
					// ftp.deleteFile(fileName); //从FTP上删除已下载文件
				}
				System.out.println("下载完毕-------");
				this.zip(tmpFile, tmpZip);

				if (f.isDirectory()) {
					File[] files = f.listFiles();
					for (int i = 0; i < files.length; i++) {
						files[i].delete();
					}

				} else {
					System.out.println("不是文件夹 !");
				}

				InputStream is = new FileInputStream(zf);
				BufferedInputStream bis = new BufferedInputStream(is);

				byte[] buf = new byte[1024];

				int length = 0;
				while ((length = bis.read(buf)) > 0) {

					fo.write(buf, 0, length);

				}
				// File fff=new File("c:\\all.zip");
				// try
				// {
				// fff.deleteOnExit();
				//
				// }
				// catch (Exception e) {
				// System.out.println("这里出错了!");
				// e.printStackTrace();
				// }

				fo.flush();
				fo.close();
				bis.close();
				is.close();
				fo = null;

			} else {
				String strArray[] = remote_fileSuffix.split("/");
				for (int i = 4; i < strArray.length - 1; i++) {
					ftp.cwd(strArray[i]);
				}
				fileName = strArray[strArray.length - 1];

				String str = "";
				ftp.setControlEncoding("GBK");

				str = fileName;

				fileName = fileName + ".mp3";
				response.setContentType("application/x-msdownload");
				response.setHeader("Content-Disposition",
						"attachment;filename="
								+ new String(fileName.getBytes("GBK"),
										"ISO-8859-1"));
				File file = new File("c:\\");
				OutputStream fo = response.getOutputStream();
				str = new String(str.getBytes("GBK"), "ISO-8859-1");
				ftp.retrieveFile(str, fo);
				// 从FTP上下载符合条件的文件
				// ftp.deleteFile(fileName); //从FTP上删除已下载文件
				fo.flush();
				fo.close();
			}
		} catch (Exception e) {
			if (ftp.isConnected()) {
				try {
					ftp.disconnect();
				} catch (IOException ioe) {
					// do nothing
				}
				return false;
			}
			throw e;
		}
		return true;
	}

	/**
	 * 功能：把 sourceDir 目录下的所有文件进行 zip 格式的压缩，保存为指定 zip 文件 create date:2009- 6- 9
	 * author:Administrator
	 * 
	 * @param sourceDir
	 * @param zipFile
	 *            格式： E:\\stu \\zipFile.zip 注意：加入 zipFile 我们传入的字符串值是 ：
	 *            "E:\\stu \\" 或者 "E:\\stu " 如果 E 盘已经存在 stu 这个文件夹的话，那么就会出现
	 *            java.io.FileNotFoundException: E:\stu ( 拒绝访问。 )
	 *            这个异常，所以要注意正确传参调用本函数哦
	 * 
	 */

	public static void zip(String sourceDir, String zipFile) {

		try {

			OutputStream os = new FileOutputStream(zipFile);
			BufferedOutputStream bos = new BufferedOutputStream(os);
			ZipOutputStream zos = new ZipOutputStream(bos);

			File file = new File(sourceDir);

			String basePath = null;

			if (file.isDirectory()) {
				basePath = file.getPath();
			} else {
				basePath = file.getParent();
			}

			zipFile(file, basePath, zos);
			zos.closeEntry();
			zos.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	// /**
	// *
	// * create date:2009- 6- 9 author:Administrator
	// *
	// * @param source
	// * @param basePath
	// * @param zos
	// * @throws IOException
	// */
	//
	private static void zipFile(File source, String basePath,

	ZipOutputStream zos) {

		File[] files = new File[0];
		if (source.isDirectory()) {
			files = source.listFiles();

		} else {
			files = new File[1];
			files[0] = source;

		}

		String pathName;

		byte[] buf = new byte[1024];

		int length = 0;

		try {

			for (int i = 0; i < files.length; i++) {
				File file = files[i];
				if (file.isDirectory()) {

					pathName = file.getPath().substring(basePath.length() + 1)

					+ "/";

					zos.putNextEntry(new ZipEntry(pathName));

					zipFile(file, basePath, zos);

				} else {

					pathName = file.getPath().substring(basePath.length() + 1);
					InputStream is = new FileInputStream(file);
					BufferedInputStream bis = new BufferedInputStream(is);
					zos.putNextEntry(new ZipEntry(pathName));

					while ((length = bis.read(buf)) > 0) {

						zos.write(buf, 0, length);

					}

					is.close();

				}

			}

		} catch (Exception e) {

			// TODO Auto-generated catch block

			e.printStackTrace();

		}

	}

}
