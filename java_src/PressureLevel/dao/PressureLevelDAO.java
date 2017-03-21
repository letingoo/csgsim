package PressureLevel.dao;

import java.util.List;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import PressureLevel.model.TopolinkItem;

public class PressureLevelDAO {

	private SqlMapClientTemplate sqlMapClientTemplate;
	
	public void setSqlMapClientTemplate(
			SqlMapClientTemplate sqlMapClientTemplate) {
		this.sqlMapClientTemplate = sqlMapClientTemplate;
	}
	
	public SqlMapClientTemplate getSqlMapClientTemplate() {
		return sqlMapClientTemplate;
	}
	
	
	
	public List<TopolinkItem> getTopoLink() {
		return sqlMapClientTemplate.queryForList("getAllTopoZMC");
	}
	
	
	public List getBusInfo(String label) {
		
		return sqlMapClientTemplate.queryForList("getBusInfozmc", label);
	}
	
	
	/**
	 * 清空topolink_business_cache表
	 */
	public void clearCacheTable() {
		
		sqlMapClientTemplate.delete("clearTopolinkBusinessCacheTable");
	}
	
	
	
	/**
	 * 生成topolink_business_cache表
	 */
	public void produceCacheTable() {
		sqlMapClientTemplate.insert("produceTopolinkBusinessCacheTable");
	}
	
	
}
