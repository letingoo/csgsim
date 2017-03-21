package sourceCode.rootalarm.model
{
	[Bindable]	
	[RemoteClass(alias="com.metarnet.mnt.rootalarm.model.RootAlarmMgr")] 
	public class RootAlarmMgrModel
	{
		public var belongtransys:String;
		public var alarmlevel:String;
		public var vendor:String;
		public var alarmobjdesc:String;
		public var start:String;
		public var end:String;
		public var isacked :String;
		public var iscleared:String;
		public var laststarttime:String;
		public var acktime:String;
		public var alarmdesc:String;
		public var alarmlevelname:String;
		public var vendorzh:String;
		public var isackedzh :String;
		public var run_unit:String;
		public var dealresult:String;
		public var dealpart:String;
		public var dealperson:String;
		public var dutyid:String;
		public var isbugno:String;
		public var bugno:String;
		public var isworkcase:String;
		public var triggeredthreshold:String;
		public var flashcount:String;
		public var specialtyzh:String;
		public var carrycircuit:String;
		public var ackperson:String;
		public var objclasszh:String;
		public var ackcontent:String;
		public var belongportobject;
		public var alarmnumber;
		public var username;
		public var dealresultzh;
		public var belongequip;
		public var belongpackobject;
		public var belongportcode;
		public var companyalarmcnt;
		public function RootAlarmModel()
		{
			belongtransys="";
			alarmlevel="";
			vendor="";
			alarmobjdesc="";
			isacked="";
			iscleared="";
			start="0";
			end="50";
			laststarttime="";
			acktime="";
			alarmdesc="";
			vendorzh="";
			alarmlevelname="";
			isackedzh="";
			run_unit="";
			dealresult="";
			dealpart="";
			dealperson="";
			dutyid="";
			isbugno="";
			bugno="";
			isworkcase="";
			triggeredthreshold="";
			flashcount="";
			specialtyzh="";
			carrycircuit="";
			ackperson="";
			objclasszh="";
			ackcontent="";
			belongportobject="";
			alarmnumber="";
			username="";
			dealresultzh="";
			belongequip="";
			belongpackobject="";
			belongportcode="";
			companyalarmcnt="";
		}
	}
}