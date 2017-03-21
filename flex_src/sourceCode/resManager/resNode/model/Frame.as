package sourceCode.resManager.resNode.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resNode.model.EquipFrame")] 
	public class Frame
	{   
		public var no:String;
//		public var serialNO:String;
		public var equipcode:String;
//		public var equipname:String;
		public var frameserial:String;
		public var s_framename:String;
		public var framemodel:String;
		public var model_code:String;//型号编码
		public var shelfinfo:String;
		public var equipshelfcode:String;
		public var xfront:String;
		public var yfront:String;
		public var frontwidth:String;
		public var frontheight:String;
		public var frontviewpic:String;
		public var remark:String;
		public var updatedate:String;
		public var updatedate_start:String;
		public var updatedate_end:String;
		public var updateperson:String;
		public var frame_state:String;
		public var state_code:String;//状态编码
		public var start:String = "0";
		public var end:String = "50";
		public var sort:String = "equipcode";
		public var dir:String = "asc";
		public var vendor:String;
		public var projectname:String;
//		public var system:String;
		public var isNumber:String;
//		public var x_vendor:String;
		public function Frame()
		{   
			no = "";
			framemodel="";
			model_code="";
			frontviewpic="";
			equipcode="";
			frameserial="";
			s_framename="";
			shelfinfo="";
			xfront="";
			yfront="";
			frontwidth="";
			frontheight="";
			remark="";
			updatedate="";
			updatedate_start="";
			updatedate_end="";
			updateperson="";
			start="";
			end="";
			sort="equipcode";
			dir="asc";
			vendor="";
			isNumber="";
			equipshelfcode="";
			projectname="";
			frame_state="";
			state_code="";
		}
	}
}