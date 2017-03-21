package PressureLevel.dwr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;



import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.metarnet.adapter.resource.bean.TopoLink;

import PressureLevel.dao.PressureLevelDAO;
import PressureLevel.model.PressureItem;
import PressureLevel.model.TopolinkItem;


/**
 * 分析复用段的风险指数
 * @author 张敏超
 *
 */
public class PressureLevelDwr {


	
	private PressureLevelDAO dao;
	
	
	public void setDao(PressureLevelDAO dao) {
		this.dao = dao;
	}
	
	
	public PressureLevelDAO getDao() {
		return dao;
	}
	
	
	// 复用段的列表
	private List<TopolinkItem> items = new ArrayList<TopolinkItem>();
	
	
	
	private List<TopolinkItem> level1List = new ArrayList<TopolinkItem>();
	private List<TopolinkItem> level2List = new ArrayList<TopolinkItem>();
	private List<TopolinkItem> level3List = new ArrayList<TopolinkItem>();
	private List<TopolinkItem> level4List = new ArrayList<TopolinkItem>();
	
	
	
	
	/**
	 * 分析复用段压力
	 * @return
	 */
	public List<HashMap<Object, Object>> FxLevel() {
		
		items = dao.getTopoLink();
		
		
		// 先清空缓存表
		dao.clearCacheTable();
		
		try{
		// 再生成缓存表
		dao.produceCacheTable();
		} catch(Exception e) {
			e.printStackTrace();
		}
		for (TopolinkItem item : items) {
			
			// 读取业务的名称列表

			try{
				
				List<String> nameList = dao.getBusInfo(item.getLabel());
				item.setWeight( calculateWeight(nameList) );
				item.setBusNameList(nameList);
				item.setBuz_numbers(nameList.size());
			} catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		 
		
		PressureItem pressure1 = new PressureItem();
		pressure1.setLevel("1级");
		
		PressureItem pressure2 = new PressureItem();
		pressure2.setLevel("2级");
		
		PressureItem pressure3 = new PressureItem();
		pressure3.setLevel("3级");
		
		PressureItem pressure4 = new PressureItem();
		pressure4.setLevel("4级");
		
		
		
		for (TopolinkItem item : items) {
			
			if (item.getWeight() <= 90)
				level4List.add(item);
			
			else if (item.getWeight() > 90 && item.getWeight() <= 200)
				level3List.add(item);
			
			else if (item.getWeight() > 200 && item.getWeight() <= 300)
				level2List.add(item);
			
			else
				level1List.add(item);
		}
		
		
		/*
		 * 1级最严重，2级次之，以此类推
		 */
		
		HashMap<Object, Object> map1 = new HashMap<Object, Object>();
		map1.put("level", "1级");
		map1.put("weight", level1List.size());
		
		HashMap<Object, Object> map2 = new HashMap<Object, Object>();
		map2.put("level", "2级");
		map2.put("weight", level2List.size());
		
		HashMap<Object, Object> map3 = new HashMap<Object, Object>();
		map3.put("level", "3级");
		map3.put("weight", level3List.size());
		
		HashMap<Object, Object> map4 = new HashMap<Object, Object>();
		map4.put("level", "4级");
		map4.put("weight", level4List.size());
	
		
		List<HashMap<Object, Object>> result = new ArrayList<HashMap<Object, Object>>();
		
		result = new ArrayList<HashMap<Object, Object>>();
		result.add(map1);
		result.add(map2);
		result.add(map3);
		result.add(map4);
		
		return result;
		
	}
	
	
	
	
	/**
	 * 返回某一级别风险复用段的信息
	 * @param level
	 * @return
	 */
	public List<TopolinkItem> getLevelTopoLinkItem(String level) {
		
		if (level.equals("1级"))
			return level1List;
		
		else if (level.equals("2级"))
			return level2List;
		
		else if (level.equals("3级"))
			return level3List;
		
		else
			return level4List;
		
	
	}
	
	
	
	
	
	
	
	/**
	 * 计算权重
	 * @param nameList
	 * @return
	 */
	private double calculateWeight(List<String> nameList) {
		
		
		int count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0, count6 = 0, count7 = 0, count8 = 0, count9 = 0;
		for (String name : nameList) {
			
			
			
			if (name.contains("继电保护")) {
				count1++;
			} else if (name.contains("安稳业务")) {
				count2++;
			} else if (name.contains("调度电话")) {
				count3++;
			} else if (name.contains("调度数据网")) {
				count4++;
			} else if (name.contains("会议电视")) {
				count5++;
			} else if (name.contains("行政电话")) {
				count6++;
			} else if (name.contains("综合数据网")) {
				count7++;
			} else if (name.contains("网管业务")
					|| name.contains("故障信息远传业务")
					|| name.contains("MIS业务")
					|| name.contains("通信监控业务")
					|| name.contains("光设备互联业务")
					|| name.contains("通信监测业务")
					|| name.contains("用户用电信息采集")
					|| name.contains("网管业务")) {
				count8++;
			}

			else {
				count9++;
			}
			
			
		}
		
		
		double weight = count1 * 10.0 + count2 * 10.0 + count3 * 9.38 + count4 * 5.98
				+ count5 * 5.05 + count6 * 0.8 + count7 * 2.9 + count8 * 1.5
				+ count9 * 0.62;
		
		
		return weight;
		
	}
	
	
}
