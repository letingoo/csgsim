package ocableResources.model;

import java.util.ArrayList;
import java.util.List;

public class OcableGraphicModule {
	private FiberModule FIBER_MODULE_DATA;
	private List<Fiber> FIBER_DATA;
	
	public OcableGraphicModule()
	{
		 this.FIBER_DATA = new ArrayList<Fiber>();
		 this.FIBER_MODULE_DATA = new FiberModule();
	}
	/**
	 * @param fIBER_MODULE_DATA the fIBER_MODULE_DATA to set
	 */
	public void setFIBER_MODULE_DATA(FiberModule fIBER_MODULE_DATA) {
		FIBER_MODULE_DATA = fIBER_MODULE_DATA;
	}
	/**
	 * @return the fIBER_MODULE_DATA
	 */
	public FiberModule getFIBER_MODULE_DATA() {
		return FIBER_MODULE_DATA;
	}
	/**
	 * @param fIBER_DATA the fIBER_DATA to set
	 */
	public void setFIBER_DATA(List<Fiber> fIBER_DATA) {
		FIBER_DATA = fIBER_DATA;
	}
	/**
	 * @return the fIBER_DATA
	 */
	public List<Fiber> getFIBER_DATA() {
		return FIBER_DATA;
	}

	
}
