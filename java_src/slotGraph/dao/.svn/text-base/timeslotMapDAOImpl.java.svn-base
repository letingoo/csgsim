package slotGraph.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

@SuppressWarnings("unchecked")
public class timeslotMapDAOImpl implements timeslotMapDAO {
	
	private SqlMapClientTemplate sqlMapClientTemplate;

    public SqlMapClientTemplate getSqlMapClientTemplate() {
	   return sqlMapClientTemplate;
    }

    public void setSqlMapClientTemplate(SqlMapClientTemplate sqlMapClientTemplate) {
	   this.sqlMapClientTemplate = sqlMapClientTemplate;
    }

	public List selectTimeSlotRootTreeNode() {
		return this.sqlMapClientTemplate.queryForList("selectTimeSlotRootTreeNode");
	}

	public List<HashMap> getTimeSlotSecondLayerTreeNode(String str) {
		return this.sqlMapClientTemplate.queryForList("selectTimeSlotSecondLayerTreeNode",str);
	}
	public List<HashMap> getThirdLayerTreeNode(String str)
	{	
		List list=null;
		try
		{
			String str1 = str.split("-")[0];
			String str2 = str.split("-")[1];
			Map map = new HashMap();
			map.put("str1", str1);
			map.put("str2", str2);
			list=this.getSqlMapClientTemplate().queryForList("selectThirdLayerTreeNode", map);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			
		}
		return list;
	}



	
}
