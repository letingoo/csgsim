package com;

import java.util.HashMap;
import java.util.Map;

import flex.messaging.MessageBroker;
import flex.messaging.messages.AsyncMessage;
import flex.messaging.util.UUIDUtils;

public class Message {
	public static Map map = new HashMap();
	public static Map UserMap = new HashMap();
	public static boolean pushMessage(String message) {
		boolean isDataSent = false;
		MessageBroker msgBroker = MessageBroker.getMessageBroker(null);
		AsyncMessage msg = null;		
		String clientID = UUIDUtils.createUUID();
		msg = new AsyncMessage();
		msg.setDestination("userState");
		msg.setClientId(clientID);
		msg.setMessageId(UUIDUtils.createUUID());
		msg.setTimestamp(System.currentTimeMillis());
		try{
			msg.setBody(message);
			isDataSent = true;
			msgBroker.routeMessageToService(msg, null);	
		}catch(Exception ex){
			ex.printStackTrace();
			return isDataSent;
		}
		return isDataSent;
	}
}
