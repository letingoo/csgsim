package fiberwire.model;

public class AutoGridModel {
	
	private int start;
	private int end;
	private String json;
	private String tablename;
	private String sortColumn;
	private String sortOrder;
	public AutoGridModel()
	{
	  json = "";
	  tablename = "";
	  sortColumn = "";
	  sortOrder = "";
	}
    
    
	public String getTablename() {
		return tablename;
	}


	public void setTablename(String tablename) {
		this.tablename = tablename;
	}


	public String getJson() {
		return json;
	}


	public void setJson(String json) {
		this.json = json;
	}


	public int getStart() {
		return start;
	}


	public void setStart(int start) {
		this.start = start;
	}


	public int getEnd() {
		return end;
	}


	public void setEnd(int end) {
		this.end = end;
	}


	public String getSortColumn() {
		return sortColumn;
	}


	public void setSortColumn(String sortColumn) {
		this.sortColumn = sortColumn;
	}


	public String getSortOrder() {
		return sortOrder;
	}


	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}
	

}
