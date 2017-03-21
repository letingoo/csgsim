package cn.swjtu.multisource.tools;

public class ThreadLocalHolder {
	private static ThreadLocal<String> local = new ThreadLocal<String>();

	public static String get() {
		return local.get();
	}

	public static void set(String name) {
		local.set(name);
	}

	public static void remove(){
		local.remove();
	}
}
