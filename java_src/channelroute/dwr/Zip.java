package channelroute.dwr;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;

public class Zip {
	/**
	 * @文件压缩类 压缩单个文件或者某一文件夹。
	 * @param inputFileName eg :"D:\\temp\\test"
	 *            输入一个文件夹
	 * @param zipFileName
	 *            输出一个压缩文件夹，打包后文件名字eg :"D:\\temp\\test.zip"
	 * @param basePath
	 *            文件路径
	 * @throws Exception
	 */
	public void zip(String inputFileName, String zipFileName,String basePath) throws Exception {
		File f = new File(inputFileName);
		if (!f.exists()) {
			System.err.println("System cant' find the path..");
			return;
		} else {
			zip(zipFileName, f,basePath);
		}
	}

	private void zip(String zipFileName, File inputFile,String basePath) throws Exception {
		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(
				zipFileName));
		
		zip(out, inputFile,basePath);
		out.close();
	}

	private void zip(ZipOutputStream out, File f, String base) throws Exception {
		if (f.isDirectory()) {
			File[] fl = f.listFiles();
			ZipEntry zipEntry = new ZipEntry(base + "/");
			out.putNextEntry(zipEntry);
			base = base.length() == 0 ? "" : base + "/";
			for (int i = 0; i < fl.length; i++) {
				if(fl[i].getName()!=null&&!fl[i].getName().contains(".zip")&&!fl[i].getName().contains("circuitExcelTemplate"))
				zip(out, fl[i], base + fl[i].getName());
			}
		} else {
			if(f.getName()!=null&&!f.getName().contains(".zip")&&!f.getName().contains("circuitExcelTemplate")){
			
			out.putNextEntry(new org.apache.tools.zip.ZipEntry(base));
			FileInputStream in = new FileInputStream(f);
			int b = 0;
			while ((b = in.read()) != -1) {
				out.write(b);
			}
			in.close();
			}
		}
	}

	/*
	 * private void zip(ZipOutputStream out, List listFile, String base) throws
	 * Exception {
	 * 
	 * out.putNextEntry(new org.apache.tools.zip.ZipEntry(base + "/")); base =
	 * base.length() == 0 ? "" : base + "/"; File filename = null; for (int i =
	 * 0; i < listFile.size(); i++) { filename = new File((String)
	 * listFile.get(i));
	 * 
	 * out.putNextEntry(new org.apache.tools.zip.ZipEntry(base +
	 * filename.getName())); FileInputStream in = new FileInputStream(filename);
	 * int b; System.out.println(base); while ((b = in.read()) != -1) {
	 * out.write(b); } in.close(); }
	 * 
	 * }
	 */
}
