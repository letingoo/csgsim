package fiberwire.model;

import java.util.List;

public class OcableRoutInfoData {
	private String systemName;
	private List<String> stationNames;
	private List<ChannelRoutModel> channelRoutModelData;
	/**
	 * @return the channelRoutModelData
	 */
	public List<ChannelRoutModel> getChannelRoutModelData() {
		return channelRoutModelData;
	}
	/**
	 * @param channelRoutModelData the channelRoutModelData to set
	 */
	public void setChannelRoutModelData(List<ChannelRoutModel> channelRoutModelData) {
		this.channelRoutModelData = channelRoutModelData;
	}
	/**
	 * @return the stationNames
	 */
	public List<String> getStationNames() {
		return stationNames;
	}
	/**
	 * @param stationNames the stationNames to set
	 */
	public void setStationNames(List<String> stationNames) {
		this.stationNames = stationNames;
	}
	public void setSystemName(String systemName) {
		this.systemName = systemName;
	}
	public String getSystemName() {
		return systemName;
	}
	
}
