package com.metarnet.mnt.subject.main.actionscript
{
	[Bindable]	
	[RemoteClass(alias="com.metarnet.mnt.rootalarm.model.KeyBitMonitor")]
	public class KeyBitMonitor
	{
			public var username:String;   
			public var circuittotal:String;
			public var breakcount:String;
			public var ackingcount:String;
			public var ackedcount:String;
			public function KeyBitMonitor(){
				
			}
	}
}