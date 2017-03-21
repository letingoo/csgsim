package channelroute.metarnet;

import java.util.Comparator;

import channelroute.model.ChannelPort;
/**
 * 用来给portsList按照端口位置排序
 * @author jtsun
 *
 */
public class ComparatorPort implements Comparator<ChannelPort> {

	@Override
	public int compare(ChannelPort o1, ChannelPort o2) {
		if(Math.abs(o1.getPosition())>Math.abs(o2.getPosition()))
			return 1;
		else
			return 0;
	}
}
