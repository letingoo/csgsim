package channelroute.dao.ibatis;

import java.util.List;

import netres.model.ComboxDataModel;

import org.springframework.orm.ibatis.SqlMapClientTemplate;


import channelroute.dao.ChannelRouteDAO;
import channelroute.model.ChannelRouteDetailModel;
import channelroute.model.Circuit;
public class ChannelRouteDAOImp implements
		ChannelRouteDAO {
	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }

	public List getChannelRouteNames(String circuitType) {
		return this.getSqlMapClientTemplate().queryForList(
				"getChannelRouteNames", circuitType);
	}
	
	// 国网信通公司通信调度方式单
	public ChannelRouteDetailModel getChannelRouteDetailModel(String itemid) {
		ChannelRouteDetailModel model = (ChannelRouteDetailModel) this.getSqlMapClientTemplate().queryForObject(
				"getChannelRouteDetailModel", itemid);
		return model;
	}
	public void addCircuitmonitoring(String circuitcode){
		this.getSqlMapClientTemplate().delete("addCircuitmonitoring",circuitcode);
	}
	public void delCircuitmonitoring(String circuitcode){
		this.getSqlMapClientTemplate().delete("delCircuitmonitoring",circuitcode);
	}
	

}
