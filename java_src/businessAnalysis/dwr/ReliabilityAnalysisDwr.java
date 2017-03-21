package businessAnalysis.dwr;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import businessAnalysis.dao.ReliabilityAnalysisDao;
import netres.model.ComboxDataModel;
import businessAnalysis.model.BusinessCircuit;
import businessAnalysis.model.CircuitEquipment;
import businessAnalysis.model.CircuitTwoequip;

public class ReliabilityAnalysisDwr {
	private ReliabilityAnalysisDao busDao;

	public ReliabilityAnalysisDao getBusDao() {
		return busDao;
	}

	public void setBusDao(ReliabilityAnalysisDao busDao) {
		this.busDao = busDao;
	}
	
	public List<HashMap<Object,Object>> getAllBus(){
		return busDao.getAllBus();
	}
	
	public List<HashMap<Object,Object>> getN1Result(
			List<HashMap<Object,Object>> selectedBus){
		List<BusinessCircuit> bcList = busDao.getBCList(selectedBus);
		List<CircuitEquipment> ceList = busDao.getCEList(bcList);
		List<HashMap<Object,Object>> nxList = new ArrayList<HashMap<Object,Object>>();
		
		for(int i = 0; i<bcList.size(); i++){
			String business_id = bcList.get(i).getBusinessId();
			String circuitcode = bcList.get(i).getCircuitcode();
			List<String> equipName = getNameList(circuitcode,ceList);
			
			for(i++;i<bcList.size()&&bcList.get(i).getBusinessId().equals(business_id); i++){
				String circuitcode2 = bcList.get(i).getCircuitcode();
				List<String> equipName2 = getNameList(circuitcode2,ceList);
				equipName = getNameLeft(equipName,equipName2);
			}
			i--;
			for(int k = 0;k<equipName.size();k++){
				int temp = 0;
				for(int j=0; j<nxList.size(); j++){
					if(nxList.get(j).get("equipmentName").toString().equals(equipName.get(k))){
						String busName = nxList.get(j).get("busName").toString();
						busName += ","+bcList.get(i).getBusinessName();
						nxList.get(j).put("busName", busName);
						temp = 1;
						break;
					}
				}
				if(temp == 0){
					HashMap<Object,Object> nx = new HashMap<Object,Object>();
					nx.put("equipmentName", equipName.get(k));
					nx.put("busName", bcList.get(i).getBusinessName());
					nxList.add(nx);
				}
			}
		}
		for(int k = 0;k<nxList.size();k++){
			String busName = nxList.get(k).get("busName").toString();
			String[] nameList = busName.split(",");
			nxList.get(k).put("influenced", nameList.length);
		}
		return nxList;
	}
	
	
	public List<HashMap<Object,Object>> getN2Result(
			List<HashMap<Object,Object>> selectedBus){
		List<BusinessCircuit> bcList = busDao.getBCList(selectedBus);
		List<CircuitTwoequip> ceeList = busDao.getCeeList(bcList);
		List<HashMap<Object,Object>> nxList = new ArrayList<HashMap<Object,Object>>();
		
		for(int i = 0; i<bcList.size(); i++){
			String business_id = bcList.get(i).getBusinessId();
			String circuitcode = bcList.get(i).getCircuitcode();
			List<String[]> equipName = getNameList2(circuitcode,ceeList);
			
			for(i++;i<bcList.size()&&bcList.get(i).getBusinessId().equals(business_id); i++){
				String circuitcode2 = bcList.get(i).getCircuitcode();
				List<String[]> equipName2 = getNameList2(circuitcode2,ceeList);
				equipName = getNameLeft2(equipName,equipName2);
			}
			i--;
			
			for(int k = 0;k<equipName.size();k++){
				String[] nameTemp = equipName.get(k);
				int temp = 0;
				for(int j=0; j<nxList.size(); j++){
					if(nxList.get(j).get("equipment1").toString().equals(nameTemp[0])
							&& nxList.get(j).get("equipment2").toString().equals(nameTemp[1])){
						String busName = nxList.get(j).get("busName").toString();
						busName += ","+bcList.get(i).getBusinessName();
						nxList.get(j).put("busName", busName);
						temp = 1;
						break;
					}
					if(nxList.get(j).get("equipment1").toString().equals(nameTemp[1])
							&& nxList.get(j).get("equipment2").toString().equals(nameTemp[0])){
						String busName = nxList.get(j).get("busName").toString();
						busName += ","+bcList.get(i).getBusinessName();
						nxList.get(j).put("busName", busName);
						temp = 1;
						break;
					}
				}
				if(temp == 0){
					HashMap<Object,Object> nx = new HashMap<Object,Object>();
					nx.put("equipment1", nameTemp[0]);
					nx.put("equipment2", nameTemp[1]);
					nx.put("busName", bcList.get(i).getBusinessName());
					nxList.add(nx);
				}
			}
		}
		for(int k = 0;k<nxList.size();k++){
			nxList.get(k).put("equipmentName",
					nxList.get(k).get("equipment1").toString()+","+nxList.get(k).get("equipment2").toString());
			String busName = nxList.get(k).get("busName").toString();
			String[] nameList = busName.split(",");
			nxList.get(k).put("influenced", nameList.length);
		}
		
		List<HashMap<Object,Object>> n1List = getN1Result(selectedBus);
		for(int k = 0;k<n1List.size();k++){
			n1List.get(k).put("equipmentName",n1List.get(k).get("equipmentName").toString()+",任意设备/复用段");
			nxList.add(n1List.get(k));
		}
		
//		nxList.addAll(n1List);
				
		return nxList;
	}
	
	
	
	private List<String[]> getNameList2(String circuitcode,
			List<CircuitTwoequip> ceeList){
		List<String[]> equipName = new ArrayList<String[]>();
		for(int i=0; i<ceeList.size(); i++){
			if(ceeList.get(i).getCircuitcode().equals(circuitcode)){
				for(;i<ceeList.size()&&ceeList.get(i).getCircuitcode().equals(circuitcode); i++){
					String[] name1 = new String[2];
					name1[0] = ceeList.get(i).getEquipment1();
					name1[1] = ceeList.get(i).getEquipment2();
					equipName.add(name1);
				}
				break;
			}
		}
		return equipName;
	}
	private List<String> getNameList(String circuitcode,
			List<CircuitEquipment> ceList){
		List<String> equipName = new ArrayList<String>();
		for(int i=0; i<ceList.size(); i++){
			if(ceList.get(i).getCircuitcode().equals(circuitcode)){
				equipName.add(ceList.get(i).getEquipmentName());
				for(i++;i<ceList.size()&&ceList.get(i).getCircuitcode().equals(circuitcode); i++){
					equipName.add(ceList.get(i).getEquipmentName());
				}
				break;
			}
		}
		return equipName;
	}
	private List<String[]> getNameLeft2(List<String[]> name1,
			List<String[]> name2){
		/*for(int i=0; i<name1.size();i++){
			int temp = 0;
			String[] nametemp = name1.get(i);
			for(int j=0; j<name2.size();j++){
				String[] nametemp2 = name2.get(j);
				if(nametemp[0].equals(nametemp2[0]) && nametemp[1].equals(nametemp2[1])){
					temp = 1;
					break;
				}
				if(nametemp[0].equals(nametemp2[1]) && nametemp[1].equals(nametemp2[0])){
					temp = 1;
					break;
				}
			}
			if(temp == 0){
				name1.remove(i);
				i--;
			}
		}*/
		
		for(int i=0; i<name2.size();i++){
			int temp = 0;
			String[] nametemp2 = name2.get(i);
			for(int j=0; j<name1.size();j++){
				String[] nametemp1 = name1.get(j);
				if(nametemp2[0].equals(nametemp1[0]) && nametemp2[1].equals(nametemp1[1])){
					temp = 1;
					break;
				}
				if(nametemp2[0].equals(nametemp1[1]) && nametemp2[1].equals(nametemp1[0])){
					temp = 1;
					break;
				}
			}
			if(temp == 0){
				name1.add(name2.get(i));
			}
		}
		return name1;
	}
	private List<String> getNameLeft(List<String> name1,
			List<String> name2){
		/*for(int i=0; i<name1.size();i++){
			int temp = 0;
			for(int j=0; j<name2.size();j++){
				if(name2.get(j).equals(name1.get(i))){
					temp = 1;
					break;
				}
			}
			if(temp == 0){
				name1.remove(i);
				i--;
			}
		}*/
		for(int i=0; i<name2.size();i++){
			int temp = 0;
			for(int j=0; j<name1.size();j++){
				if(name1.get(j).equals(name2.get(i))){
					temp = 1;
					break;
				}
			}
			if(temp == 0){
				name1.add(name2.get(i));
			}
		}
		return name1;
	}
}
