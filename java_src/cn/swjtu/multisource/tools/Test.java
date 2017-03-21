package cn.swjtu.multisource.tools;

public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		PasswordDecoder des = new PasswordDecoder();
		String ss = "csg01";
		String s = des.encode(ss);
		System.out.println("==="+s);
	}

}
