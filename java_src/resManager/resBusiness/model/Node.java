package resManager.resBusiness.model;

import java.util.ArrayList;

public class Node {

	public String name = null;  
	public ArrayList<Node> relationNodes = new ArrayList<Node>();
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public ArrayList<Node> getRelationNodes() {
		return relationNodes;
	}
	public void setRelationNodes(ArrayList<Node> relationNodes) {
		this.relationNodes = relationNodes;
	}  

}
