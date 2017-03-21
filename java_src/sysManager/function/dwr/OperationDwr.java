package sysManager.function.dwr;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sysManager.function.dao.OperationDao;
import sysManager.function.model.OperationModel;

public class OperationDwr {
	
	OperationDao operationDao;
	
	public OperationDao getOperationDao() {
		return operationDao;
	}

	public void setOperationDao(OperationDao operationDao) {
		this.operationDao = operationDao;
	}
	
	//加载树节点信息
	public String getOperations(String parent_id){
		List<OperationModel> opers = null; 
		if(parent_id != "" || parent_id != null)
			 opers = (ArrayList)operationDao.getOperations(parent_id);
		else
			 opers = (ArrayList)operationDao.getOperations("0");
		StringBuffer sb=new StringBuffer("[");
		for(OperationModel oper:opers){
			if(oper.getParent_id().equals("0"))
			{
				sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',icon:'_img/icons/fam/plugin.gif',leaf:false},");
			}
			else
			{
				if(oper.getIschilden()!=null&&oper.getIschilden().equals("1")){
					sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',icon:'_img/icons/fam/plugin.gif',leaf:false},");
				}else{
					sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',icon:'_img/icons/fam/plugin.gif',leaf:true},");
				}
			}
		}
		sb.append("]");
		return sb.toString();
	}
	
	public String getAllFunctions(){
		List<OperationModel> opers = null;
		opers = (ArrayList)operationDao.getOperations("0");
		StringBuffer sb = new StringBuffer("<node id='0' name='功能节点' icon=''>");
		forEachOper(sb,opers);
		sb.append("</node>");
		return sb.toString();
	}
	
	private void forEachOper(StringBuffer str,List<OperationModel> opers){
		for(OperationModel oper:opers){
			str.append("<node id='"+oper.getOper_id()+"' name='"+oper.getOper_name()+"' parentid='"+oper.getParent_id()+"' checked='0' icon='assets/images/sysManager/plugin.gif'>");
			List<OperationModel> childOpers = (ArrayList)operationDao.getOperations(oper.getOper_id());
			if(childOpers.size() > 0){
				forEachOper(str,childOpers);
			}
			str.append("</node>");
		}
	}
	
	//角色管理配置功能模块
	public String configFunction(String conf,String parent_id){
		//加载树节点信息
		String []confs = conf.split(",");
		List<OperationModel> opers = null;
		if(parent_id != "" || parent_id != null)
			 opers = (ArrayList)operationDao.getOperations(parent_id);
		else
			 opers = (ArrayList)operationDao.getOperations("0");
		StringBuffer sb = new StringBuffer("[");
		for(OperationModel oper:opers){
			if(oper.getParent_id().equals("0") || (oper.getIschilden() != null && oper.getIschilden().equals("1"))){
				//判断子孩子的check情况
				List<OperationModel> childOpers = (ArrayList)operationDao.getOperations(oper.getOper_id());
				boolean flag=false;
				boolean pflag=false;
				for(OperationModel childoper:childOpers){
					if(conf.contains(childoper.getOper_name())) 
						flag = true; 
					else {
						flag = false;
						break;
					}
				}
				for(OperationModel childoperp:childOpers){
					if(conf.contains(childoperp.getOper_name())) 
						pflag=true; 
				}
				//check end
				if(flag && pflag)
					sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',cls:'complete',icon:'_img/icons/fam/plugin.gif',checked:"+flag+",expanded:true,leaf:false},");
				else if(!flag && pflag){
					sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',icon:'_img/icons/fam/plugin.gif',checked:"+flag+",expanded:true,leaf:false},");
				} else if(!pflag && !flag) {
					sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',icon:'_img/icons/fam/plugin.gif',checked:"+flag+",leaf:false},");	
				}
			}else{
				boolean ischeck=false;
				for(String check:confs){
					if(check != null && check.equals(oper.getOper_name())){
						ischeck = true;
						break;
					}
				}
				if(ischeck)
					sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',cls:'complete',icon:'_img/icons/fam/plugin.gif',checked:"+ischeck+",leaf:true},");
				else
					sb.append("{id:'"+oper.getOper_id()+"', text:'"+oper.getOper_name()+"',icon:'_img/icons/fam/plugin.gif',checked:"+ischeck+",leaf:true},");
			}
		}
		sb.append("]");
		int length = sb.toString().length();
		String tempSB = sb.toString().substring(0, length-2).concat("]");
		return tempSB;
	}
	
	public void updateOperationByOperId(OperationModel oform){
		operationDao.updateOperationByOperId(oform);
	}
	
	public void insertOper(OperationModel oform){
		operationDao.insertOper(oform);
	}
	
	public void delFunction(String oper_id){
		operationDao.delOper(oper_id);
		List<OperationModel> opers = (ArrayList)operationDao.getOperations(oper_id);
		for(OperationModel operModel:opers){
			operationDao.delOper(operModel.getOper_id());
			List<OperationModel> subOpers = (ArrayList)operationDao.getOperations(operModel.getOper_id());
			for(OperationModel subOperModel:subOpers){
				operationDao.delOper(subOperModel.getOper_id());
			}
		}
	}
}
