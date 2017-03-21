package sourceCode.wireConfiguration.model
{
	[Bindable]	
	[RemoteClass(alias="wireConfiguration.model.Re_fiberintModel")] 
	public class Re_fiberintModel
	{
		public var tnodecode:String;
		public var ocablesection_1:String;
		public var ocablesectionname_1:String;
		public var fiberserial_1:String;
		public var ocablesection_2:String;
		public var ocablesectionname_2:String;
		public var fiberserial_2:String;
		public function Re_fiberintModel()
		{
			tnodecode="";
			ocablesection_1="";
			ocablesectionname_1="";
			fiberserial_1="";
			ocablesection_2="";
			ocablesectionname_2="";
			fiberserial_2="";
		}
		public function clear():void
		{
			tnodecode="";
			ocablesection_1="";
			ocablesectionname_1="";
			fiberserial_1="";
			ocablesection_2="";
			ocablesectionname_2="";
			fiberserial_2="";
		}
	}
}