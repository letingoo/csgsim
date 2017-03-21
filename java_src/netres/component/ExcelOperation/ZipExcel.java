package netres.component.ExcelOperation;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.List;

import org.apache.tools.zip.ZipOutputStream;

public class ZipExcel {
	/**
	 * @文件压缩类 压缩单个文件或者某一文件夹。
	 * @param inputFileName eg :"D:\\temp\\test"
	 *            输入一个文件夹
	 * @param zipFileName
	 *            输出一个压缩文件夹，打包后文件名字eg :"D:\\temp\\test.zip"
	 * @param basePath
	 *            文件路径
	 * @throws Exception
	 * 
	 * @author LuoShuai
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
			out.putNextEntry(new org.apache.tools.zip.ZipEntry(base + "/"));
			base = base.length() == 0 ? "" : base + "/";
			for (int i = 0; i < fl.length; i++) {
				zip(out, fl[i], base + fl[i].getName());
			}
		} else {
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
