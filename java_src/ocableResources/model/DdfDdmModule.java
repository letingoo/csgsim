package ocableResources.model;

import ocableResources.model.DDFModel;
import java.util.List;

public class DdfDdmModule {
	private DMModel DDFDDM_DATA;
	private List DDFDDMPORT_DATA;
	
	
	public DMModel getDDFDDM_DATA() {
		return DDFDDM_DATA;
	}
	public void setDDFDDM_DATA(DMModel ddfddm_data) {
		DDFDDM_DATA = ddfddm_data;
	}
	public List getDDFDDMPORT_DATA() {
		return DDFDDMPORT_DATA;
	}
	public void setDDFDDMPORT_DATA(List ddfddmport_data) {
		DDFDDMPORT_DATA = ddfddmport_data;
	}
	
	
	
}
