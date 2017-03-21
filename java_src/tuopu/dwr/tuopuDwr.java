package tuopu.dwr;

import java.text.NumberFormat;
import java.util.ArrayList;

import tuopu.dao.*;

import java.util.HashMap;
import java.util.List;

import ocableResources.model.newStationModel;

import org.apache.activemq.filter.function.inListFunction;
import org.omg.CORBA.PUBLIC_MEMBER;

import login.dao.LoginDAO;
import tuopu.dao.tuopuDAOImpl;
import channelroute.dwr.ChannelRouteAction;
import channelroute.model.ChannelLink;
import channelroute.model.ChannelPort;

public class tuopuDwr {
	public tuopuDAO tuopuDao;

	public tuopuDAO gettuopuDao() {
		return this.tuopuDao;
	}

	public void settuopuDao(tuopuDAO tuopuDao) {
		this.tuopuDao = tuopuDao;
	}

	public tuopuDwr() {
		super();
	}

	public ChannelRouteAction ChannelRouteAction;

	public ChannelRouteAction getChannelRouteAction() {
		return this.ChannelRouteAction;
	}

	public void setChannelRouteAction(ChannelRouteAction ChannelRouteAction) {
		this.ChannelRouteAction = ChannelRouteAction;
	}

	public List<HashMap<Object, Object>> getRrep(String sbmc, String sat) {
		List<HashMap<Object, Object>> list3 = new ArrayList<HashMap<Object, Object>>();
		if (sat.equals("0")) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("REP", "无");
			orl.put("S_SBMC", sbmc);
			orl.put("LOGICPORT", "无");
			orl.put("SUMPORT", "无");
			orl.put("USEPORT", "无");
			orl.put("USEPERCE", "无");
			list3.add(orl);
		} else {
			HashMap map = new HashMap();
			map.put("rate", "155M/s");
			map.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list2 = tuopuDao.getRep(map);// 指定设备名称的端口速率为155M的端口的编号和个数以及该设备名称
			for (int i = 0; i < list2.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list2.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 63) {
					h = 56;
					s3 = "56";
				}
				orl.put("REP", s3);

				String s1 = list2.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list2.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 63;
				orl.put("SUMPORT", s4);

				int s5 = 63 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
		}
		return list3;
	}

	public List<HashMap<Object, Object>> getRrep_vc4(String sbmc, String sat) {
		List<HashMap<Object, Object>> list3 = new ArrayList<HashMap<Object, Object>>();
		if (sat.equals("0")) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("REP", "无");
			orl.put("S_SBMC", sbmc);
			orl.put("LOGICPORT", "无");
			orl.put("SUMPORT", "无");
			orl.put("USEPORT", "无");
			orl.put("USEPERCE", "无");
			list3.add(orl);
		} else {
			HashMap map_10 = new HashMap();
			map_10.put("rate", "10G/s");
			map_10.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_10 = tuopuDao.getRep(map_10);
			HashMap map_25 = new HashMap();
			map_25.put("rate", "2.5G/s");
			map_25.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_25 = tuopuDao.getRep(map_25);
			HashMap map_622 = new HashMap();
			map_622.put("rate", "622M/s");
			map_622.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_622 = tuopuDao.getRep(map_622);
			for (int i = 0; i < list_10.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_10.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 64) {
					h = 56;
					s3 = "56";
				}
				orl.put("REP", s3);

				String s1 = list_10.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_10.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 64;
				orl.put("SUMPORT", s4);

				int s5 = 64 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
			for (int i = 0; i < list_622.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_622.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 4) {
					h = 3;
					s3 = "3";
				}
				orl.put("REP", s3);

				String s1 = list_622.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_622.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 4;
				orl.put("SUMPORT", s4);

				int s5 = 4 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
			for (int i = 0; i < list_25.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_25.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 16) {
					h = 14;
					s3 = "14";
				}
				orl.put("REP", s3);

				String s1 = list_25.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_25.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 16;
				orl.put("SUMPORT", s4);

				int s5 = 16 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
		}
		return list3;
	}

	public List<HashMap<Object, Object>> getRrep_vc3(String sbmc, String sat) {
		List<HashMap<Object, Object>> list3 = new ArrayList<HashMap<Object, Object>>();
		if (sat.equals("0")) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			orl.put("REP", "无");
			orl.put("S_SBMC", sbmc);
			orl.put("LOGICPORT", "无");
			orl.put("SUMPORT", "无");
			orl.put("USEPORT", "无");
			orl.put("USEPERCE", "无");
			list3.add(orl);
		} else {
			HashMap map_10 = new HashMap();
			map_10.put("rate", "10G/s");
			map_10.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_10 = tuopuDao.getRep(map_10);
			HashMap map_100 = new HashMap();
			map_100.put("rate", "100M/s");
			map_100.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_100 = tuopuDao.getRep(map_100);
			HashMap map_155 = new HashMap();
			map_155.put("rate", "155M/s");
			map_155.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_155 = tuopuDao.getRep(map_155);
			HashMap map_25 = new HashMap();
			map_25.put("rate", "2.5G/s");
			map_25.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_25 = tuopuDao.getRep(map_25);
			HashMap map_622 = new HashMap();
			map_622.put("rate", "622M/s");
			map_622.put("sbmc", sbmc);
			List<HashMap<Object, Object>> list_622 = tuopuDao.getRep(map_622);
			for (int i = 0; i < list_10.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_10.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 64) {
					h = 56;
					s3 = "56";
				}
				orl.put("REP", s3);

				String s1 = list_10.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_10.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 64;
				orl.put("SUMPORT", s4);

				int s5 = 64 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
			for (int i = 0; i < list_622.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_622.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 4) {
					h = 3;
					s3 = "3";
				}
				orl.put("REP", s3);

				String s1 = list_622.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_622.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 4;
				orl.put("SUMPORT", s4);

				int s5 = 4 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
			for (int i = 0; i < list_25.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_25.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 16) {
					h = 14;
					s3 = "14";
				}
				orl.put("REP", s3);

				String s1 = list_25.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_25.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 16;
				orl.put("SUMPORT", s4);

				int s5 = 16 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
			for (int i = 0; i < list_155.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_155.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 3) {
					h = 2;
					s3 = "2";
				}
				orl.put("REP", s3);

				String s1 = list_155.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_155.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 3;
				orl.put("SUMPORT", s4);

				int s5 = 3 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
			for (int i = 0; i < list_100.size(); i++) {
				HashMap<Object, Object> orl = new HashMap<Object, Object>();
				String s3 = list_100.get(i).get("REP").toString();
				int h = Integer.parseInt(s3);
				if (h > 2) {
					h = 1;
					s3 = "1";
				}
				orl.put("REP", s3);

				String s1 = list_100.get(i).get("S_SBMC").toString();
				orl.put("S_SBMC", s1);
				String s2 = list_100.get(i).get("LOGICPORT").toString();
				orl.put("LOGICPORT", s2);

				int s4 = 2;
				orl.put("SUMPORT", s4);

				int s5 = 2 - h;
				orl.put("USEPORT", s5);
				float s6 = (float) h / (float) s4;
				NumberFormat nt = NumberFormat.getPercentInstance();
				// 设置百分数精确度2即保留两位小数
				nt.setMinimumFractionDigits(2);
				orl.put("USEPERCE", nt.format(s6));
				list3.add(orl);
			}
		}
		return list3;
	}

	@SuppressWarnings("unused")
	public List<HashMap<Object, Object>> getName(String systemname) {
		List<HashMap<Object, Object>> list2 = new ArrayList<HashMap<Object, Object>>();
		HashMap map = new HashMap();
		map.put("rate", "155M/s");
		map.put("systemname", systemname);
		List<HashMap<Object, Object>> list1 = tuopuDao.getNbmc(map);// 端口速率为155M的设备及其端口速率为155M的端口种类个数
		// List<HashMap<Object,Object>> list1= new
		// ArrayList<HashMap<Object,Object>>();

		List<String> hr = tuopuDao.getEqName(systemname);// 所有设备名称
		for (int h = 0; h < hr.size(); h++) {
			int flag = 0;
			HashMap<Object, Object> orcl = new HashMap<Object, Object>();
			String sbmc1 = hr.get(h).toString();
			for (int i = 0; i < list1.size(); i++) {

				//
				String sbmc = list1.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					String srat = list1.get(i).get("RAT").toString();
					orcl.put("S_SBMC", sbmc);
					orcl.put("RAT", srat);
					flag = 1;
					break;
				}
			}

			if (flag == 0) {
				orcl.put("S_SBMC", sbmc1);
				orcl.put("RAT", 0);
			}

			list2.add(orcl);
		}
		System.out.println("长度" + list2.size());
		return list2;
	}

	public List<HashMap<Object, Object>> getName_vc4(String systemname) {
		List<HashMap<Object, Object>> list2 = new ArrayList<HashMap<Object, Object>>();
		HashMap map_10 = new HashMap();
		map_10.put("rate", "10G/s");
		map_10.put("systemname", systemname);
		List<HashMap<Object, Object>> list_10 = tuopuDao.getNbmc(map_10);
		HashMap map_622 = new HashMap();
		map_622.put("rate", "622M/s");
		map_622.put("systemname", systemname);
		List<HashMap<Object, Object>> list_622 = tuopuDao.getNbmc(map_622);
		HashMap map_25 = new HashMap();
		map_25.put("rate", "2.5G/s");
		map_25.put("systemname", systemname);
		List<HashMap<Object, Object>> list_25 = tuopuDao.getNbmc(map_25);

		List<String> hr = tuopuDao.getEqName(systemname);// 所有设备名称
		for (int h = 0; h < hr.size(); h++) {
			int flag = 0, srat = 0;
			HashMap<Object, Object> orcl = new HashMap<Object, Object>();
			String sbmc1 = hr.get(h).toString();
			for (int i = 0; i < list_10.size(); i++) {

				String sbmc = list_10.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_10.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			for (int i = 0; i < list_25.size(); i++) {

				String sbmc = list_25.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_25.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			for (int i = 0; i < list_622.size(); i++) {

				String sbmc = list_622.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_622.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			orcl.put("RAT", srat);
			if (flag == 0) {
				orcl.put("S_SBMC", sbmc1);
				orcl.put("RAT", 0);
			}

			list2.add(orcl);
		}
		System.out.println("长度" + list2.size());
		return list2;
	}

	public List<HashMap<Object, Object>> getName_vc3(String systemname) {
		List<HashMap<Object, Object>> list2 = new ArrayList<HashMap<Object, Object>>();
		HashMap map_10 = new HashMap();
		map_10.put("rate", "10G/s");
		map_10.put("systemname", systemname);
		List<HashMap<Object, Object>> list_10 = tuopuDao.getNbmc(map_10);
		HashMap map_622 = new HashMap();
		map_622.put("rate", "622M/s");
		map_622.put("systemname", systemname);
		List<HashMap<Object, Object>> list_622 = tuopuDao.getNbmc(map_622);
		HashMap map_25 = new HashMap();
		map_25.put("rate", "2.5G/s");
		map_25.put("systemname", systemname);
		List<HashMap<Object, Object>> list_25 = tuopuDao.getNbmc(map_25);
		HashMap map_100 = new HashMap();
		map_100.put("rate", "100M/s");
		map_100.put("systemname", systemname);
		List<HashMap<Object, Object>> list_100 = tuopuDao.getNbmc(map_100);
		HashMap map_155 = new HashMap();
		map_155.put("rate", "155M/s");
		map_155.put("systemname", systemname);
		List<HashMap<Object, Object>> list_155 = tuopuDao.getNbmc(map_155);

		List<String> hr = tuopuDao.getEqName(systemname);// 所有设备名称
		for (int h = 0; h < hr.size(); h++) {
			int flag = 0, srat = 0;
			HashMap<Object, Object> orcl = new HashMap<Object, Object>();
			String sbmc1 = hr.get(h).toString();
			for (int i = 0; i < list_10.size(); i++) {

				String sbmc = list_10.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_10.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			for (int i = 0; i < list_25.size(); i++) {

				String sbmc = list_25.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_25.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			for (int i = 0; i < list_622.size(); i++) {

				String sbmc = list_622.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_622.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			for (int i = 0; i < list_100.size(); i++) {

				String sbmc = list_100.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_100.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			for (int i = 0; i < list_155.size(); i++) {

				String sbmc = list_155.get(i).get("S_SBMC").toString();
				if (sbmc1.equals(sbmc) || sbmc1 == sbmc)

				{
					srat += Integer.parseInt(list_155.get(i).get("RAT")
							.toString());
					orcl.put("S_SBMC", sbmc);
					flag = 1;
					break;
				}
			}
			orcl.put("RAT", srat);
			if (flag == 0) {
				orcl.put("S_SBMC", sbmc1);
				orcl.put("RAT", 0);
			}

			list2.add(orcl);
		}
		System.out.println("长度" + list2.size());
		return list2;
	}

	public List<HashMap<Object, Object>> getOp() {
		List<HashMap<Object, Object>> list1 = tuopuDao.getOp();

		return list1;

	}

	public List<HashMap<Object, Object>> getOpp(int a, int b) {
		List<HashMap<Object, Object>> list2 = new ArrayList<HashMap<Object, Object>>();
		// List<HashMap<Object,Object>> list3=new
		// ArrayList<HashMap<Object,Object>>() ;
		List<HashMap<Object, Object>> list1 = tuopuDao.getOp();
		java.text.DecimalFormat df = new java.text.DecimalFormat("#.00");
		System.out.println("liste" + list1.size());
		System.out.println("liste" + list1.get(37).get("X_PURPOSE").toString());
		for (int i = a; i < b; i++) {
			HashMap<Object, Object> orl = new HashMap<Object, Object>();
			// System.out.println("i+"+i);
			/*
			 * if(list1.get(i).get("X_PURPOSE").toString()=="") {
			 * orl.put("x_purpose","EMS业务"); } else {
			 */
			orl.put("x_purpose", list1.get(i).get("X_PURPOSE").toString());
			// }

			orl.put("username", list1.get(i).get("USERNAME").toString());

			orl.put("delay1", "null");
			orl.put("length", df.format(30 + Math.random() * (80 - 30 + 1))
					.toString());
			// orl.put("length","33.56");
			orl.put("rate", list1.get(i).get("RATE").toString());
			orl.put("yuanyin", "无需优化");
			list2.add(orl);
		}
		System.out.println("list2e" + list1.size());
		return list2;

	}

	public String getID(String name) {
		List<String> names = tuopuDao.getID(name);
		String fff = names.get(0).toString();
		return fff;
	}
}
/*
 * List<HashMap<Object,Object>> list2= tuopuDao.getRep("273-开元变"); for(int
 * i=0;i<list2.size();i++){
 * System.out.println(list2.get(i).get("S_SBMC").toString());
 * System.out.println(list2.get(i).get("LOGICPORT").toString());
 * System.out.println(list2.get(i).get("REP").toString());
 */