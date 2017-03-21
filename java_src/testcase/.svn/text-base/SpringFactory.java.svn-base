package testcase;

import java.io.File;
import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class SpringFactory {
	
	//存储Bean的实例
	private Map<String, Object> appMap = new HashMap<String, Object>();
    
	//储存xml配置文件中Bean实例的信息
	private Map<String, String> beans = new HashMap<String, String>();
    
	//存储xml配置文件中Bean的属性的信息
	private Map<String, String> properties = new HashMap<String, String>();

	
    //工厂采用单例模式
	private static SpringFactory df;
    
	//私有构造函数
	private SpringFactory() throws Exception {
		//采用Dom4j对xml文件进行解析
		Document doc = new SAXReader().read(new File("E://work/fiberwire/WebRoot/WEB-INF/spring-context-res.xml"));
		Element root = doc.getRootElement();
		List el = root.elements();
		for (Iterator it = el.iterator(); it.hasNext();) {
			Element em = (Element) it.next();
			String id = em.attributeValue("id");
			String impl = em.attributeValue("class");
			beans.put(id, impl);
			// 开始第2次遍历
			List e2 = em.elements();
			// 储存属性的内容
			StringBuilder s = new StringBuilder();
			boolean flag = false;
			for (Iterator i = e2.iterator(); i.hasNext();) {
				Element em2 = (Element) i.next();
				String name = em2.attributeValue("name");
				String ref = em2.attributeValue("ref");
				String value = em2.attributeValue("value");
				if (ref != null) {
					s.append("ref,").append(name + ",").append(ref + ";");
				} else if (value != null) {
					s.append("value,").append(name + ",").append(value + ";");
				}
				flag = true;
			}
			if (flag == true) {
				properties.put(id, s.toString());
			}
		}
		//实例化Bean并注入Bean的属性
		initBeans();
	}

	private final void initBeans() throws Exception {
		// 初始化Bean
		for (String id : beans.keySet()) {
			try {
				Object o = Class.forName(beans.get(id)).newInstance();
				appMap.put(id, o);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        
		//这里按照配置文件注入Bean中的属性
		for (String id : properties.keySet()) {
			String[] property = properties.get(id).split(";");
			for (int i = 0; i < property.length; i++) {
				String[] part = property[i].split(",");
				String type = part[0];
				String name = part[1];
				String value = part[2];
				// 从已经实例化好的appMap里面取出要设置属性的Object
				Object bean = appMap.get(id);
				// 获取对应的set方法名称
				String methodName = "set" + name.substring(0, 1).toUpperCase()
						+ name.substring(1, name.length());

				Method[] methods = bean.getClass().getMethods();
				for (Method m : methods) {
					if (m.getName().equals(methodName)) {
						Class[] typeParam = m.getParameterTypes();
						// 获取非对象类型的属性转换为对应类型后的值
						Object param = null;
						if (type.equals("ref")) {
							param = appMap.get(value);
						} else {
							param = getParameter(typeParam[0], value);
						}
						//捕捉一下参数类型不正确的异常
						try {
							m.invoke(bean, param);
						} catch (IllegalArgumentException e) {
                            System.out.println("参数<"+name+">类型不正确，依赖注入失败!");
						}
					}
				}
			}
		}
	}

	
	// 输入参数的源对象与值(String类型),转换为正确类型的值(只列出常用的几种)
	public Object getParameter(Class c, String value) {
		String typeName = c.getName();
		if (typeName.equals("int") || typeName.equals("java.lang.Integer")) {
			return Integer.valueOf(value);
		} else if (typeName.equals("java.lang.String")) {
			return value;
		} else if (typeName.equals("java.lang.Boolean")||typeName.equals("boolean")) {
			return Boolean.valueOf(value);
		} else if(typeName.equals("java.lang.Long")||typeName.equals("long")){
			return Long.valueOf(value);
		}
		else if(typeName.equals("java.lang.Double")||typeName.equals("double")){
			return Double.valueOf(value);
		}
		else if(typeName.equals("java.lang.Float")||typeName.equals("float")){
			return Float.valueOf(value);
		}
		//捕捉SimpleDateFormat转换日期失败的异常
		else if(typeName.equals("java.util.Date")){
			try{
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); 
				return formatter.parse(value);
			}catch(ParseException e){
				System.out.println("日期参数转换类型失败!请输入\"yyyy-MM-dd\"的格式");
				return null;
			}
		}
		////捕捉ava.sql.Date转换日期失败的异常
		else if(typeName.equals("java.sql.Date")){
			try{
				return java.sql.Date.valueOf(value);
			}
			catch(IllegalArgumentException e){
				System.out.println("日期参数转换类型失败!请输入\"yyyy-MM-dd\"的格式");
				return null;
			}
		}
		else{
			return null;
		}		
	}

	// 返回SpringFactory的实例
	public static synchronized SpringFactory getInstance() throws Exception {
		if (df == null) {
			df = new SpringFactory();
		}
		return df;
	}

	// 获取Map中实例的方法
	public Object getBean(String id) {
		return appMap.get(id);
	}
}

