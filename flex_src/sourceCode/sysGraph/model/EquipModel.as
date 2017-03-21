package sourceCode.sysGraph.model
{
	[Bindable]	
	[RemoteClass(alias="bussiness_route.model.equip_model")] 
	public class EquipModel
	{
		public var equipcode:String;
		public var equipname:String;
		public var X:int;
		public var Y:int;
		public function EquipModel()
		{
			equipcode="";
			equipname="";
			X=0;
			Y=0;
		}
//		public function toString():String{
//			return equipcode+equipname;
//		}
	}
}