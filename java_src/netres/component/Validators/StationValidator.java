package netres.component.Validators;

import java.util.List;

import netres.model.StationModel;

public class StationValidator extends NetresdataValidator {

	public List<StationModel> ClearStation(List<StationModel> sm) {
		for (int i = 0; i < sm.size(); i++) {
			if (!this.validatStation(sm.get(i))) {
				sm.remove(i);
			}
		}
		return sm;
	}

	public int getImvalidatStationNum(List<StationModel> sm) {
		int j = 0;
		for (int i = 0; i < sm.size(); i++) {
			if (!this.validatStation(sm.get(i))) {
				j++;
			}
		}
		return j;
	}

	public boolean validatStation(StationModel sm) {
		if (super.validatNull(sm.getStationname())
				|| super.validatNull(sm.getProvince())
				|| super.validatNull(sm.getLat())
				|| super.validatNull(sm.getLng())
				|| super.validatNull(sm.getUpdateperson())
				|| super.validatNull(sm.getRemark())) {
			return false;
		} else if (!super.isNumer(sm.getLat()) || !super.isNumer(sm.getLng())) {
			return false;
		} else {
			return true;
		}
	}

	public boolean addStationValidate(StationModel station) {
		return true;

	}

	public boolean ModifyStationValidate(StationModel station) {
	
			return true;
	}

}
