package ocableResources.model;

import java.util.List;

public class EquipmentModule {
	private Equipment EQUIPMENT_DATA;
	private List EQUIPPACK_MODULE_DATA;
	private List EQUIPPACK_PORT_DATA;
	
	/**
	 * @return the eQUIPPACK_MODULE_DATA
	 */
	public List getEQUIPPACK_MODULE_DATA() {
		return EQUIPPACK_MODULE_DATA;
	}
	/**
	 * @param eQUIPPACKMODULEDATA the eQUIPPACK_MODULE_DATA to set
	 */
	public void setEQUIPPACK_MODULE_DATA(List eQUIPPACKMODULEDATA) {
		EQUIPPACK_MODULE_DATA = eQUIPPACKMODULEDATA;
	}
	/**
	 * @return the eQUIPPACK_PORT_DATA
	 */
	public List getEQUIPPACK_PORT_DATA() {
		return EQUIPPACK_PORT_DATA;
	}
	/**
	 * @param eQUIPPACKPORTDATA the eQUIPPACK_PORT_DATA to set
	 */
	public void setEQUIPPACK_PORT_DATA(List eQUIPPACKPORTDATA) {
		EQUIPPACK_PORT_DATA = eQUIPPACKPORTDATA;
	}
	/**
	 * @param eQUIPMENT_DATA the eQUIPMENT_DATA to set
	 */
	public void setEQUIPMENT_DATA(Equipment eQUIPMENT_DATA) {
		EQUIPMENT_DATA = eQUIPMENT_DATA;
	}
	/**
	 * @return the eQUIPMENT_DATA
	 */
	public Equipment getEQUIPMENT_DATA() {
		return EQUIPMENT_DATA;
	}
	
}
