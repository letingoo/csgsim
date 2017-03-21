package netres.component.Validators;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigInteger;
import java.security.MessageDigest;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import sysManager.log.dao.LogDao;
import flex.messaging.FlexContext;

import netres.model.StationModel;

/**
 * 此类用于对台帐模块的更新，添加数据进行有效性验证。同时也调用了日志功能。 向库中添加操作的细节信息。
 * **/
public class NetresdataValidator {
	private StationModel sm;
	
	/**
	 * @return the sv
	 */
	public StationValidator getSv() {
		return new StationValidator();
	}

	

	public boolean validatNull(String s) {
		return null == s || "".equals(s);
//		if (s.equals("") || s == null) {
//			return true;
//		} else {
//			return false;
//		}
	}

	public boolean isNumer(String s) {
		CharSequence c = ".";
		//here is a bug
//		if ((s == null) && (s == ""))
		if (null == s || "".equals(s)){
			return false;
		}else if (!s.contains(c)) {
			return s.matches("^[-\\+]?[\\d]*$");
		} else if (s.contains(c)) {
			return s.matches("^[-\\+]?[.\\d]*$");
		} else
			return false;
	}
	
	/**
	 * 验证是否是yyyy-MM-dd日期型字符串
	 * @param str
	 * @return
	 * @boolean
	 */
	public boolean isDateStr(String str){
		if(null == str || "".equals(str)) return false;
		else 
			return str.matches("^((\\d{2}(([02468][048])|([13579][26]))[\\-]?((((0?[13578])|(1[02]))"
					+ "[\\-]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-]?((0?[1-9])|([1-2][0-9])|(30)))"+
					"|(0?2[\\-]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))"
					+"[\\-]?((((0?[13578])|(1[02]))[\\-]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))"
					+"[\\-]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-]?((0?[1-9])|(1[0-9])|(2[0-8]))))))");
	}
	
//	public static void main(String [] args){
//		System.out.println(new NetresdataValidator().isNumer("2"));
//	    System.out.println(new NetresdataValidator().isDateStr("2011-2-15"));
//	    System.out.println(new NetresdataValidator().isDateStr("2000-02-19"));
//	    System.out.println(new NetresdataValidator().isDateStr("2000年02u1"));
//	    System.out.println(new NetresdataValidator().isDateStr("2000年02月12日"));
//	}
	
	public String getFileMD5(File file) {
		if (!file.isFile()) {
			return null;
		}
		MessageDigest digest = null;
		FileInputStream in = null;
		byte buffer[] = new byte[1024];
		int len;
		try {
			digest = MessageDigest.getInstance("MD5");
			in = new FileInputStream(file);
			while ((len = in.read(buffer, 0, 1024)) != -1) {
				digest.update(buffer, 0, len);
			}
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		BigInteger bigInt = new BigInteger(1, digest.digest());
		return bigInt.toString(16);
	}

	
}
