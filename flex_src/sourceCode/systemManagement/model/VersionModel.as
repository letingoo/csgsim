package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="login.model.VersionModel")] 
	public class VersionModel
	{
		public var no:String;
		public var vid:String;
		public var vname:String;
		public var from_vid:String;
		public var from_vname:String;
		public var vdesc:String;
		public var fill_man:String;
		public var fill_man_id:String;
		public var fill_time:String;
		public var oper_id:String;
		public var parent_id:String;
		public var remark:String;
		public var xtbm:String;
		public var xtxx:String;
		public var vtype:String;
		public var start:String= "0";
		public var end:String= "50";
		public var sort:String= "vid";
		public var dir:String= "asc";
		public function clear():void
		{
			no="";
			vid="";
			vname="";
			from_vid="";
			from_vname="";
			vdesc="";
			fill_man="";
			fill_man_id="";
			fill_time="";
			oper_id="";
			parent_id="";
			start="";
			end="";
			remark="";
			xtxx="";
			xtbm="";
			vtype="";
		}
	}
}