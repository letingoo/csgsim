package  sourceCode.resManager.resNode.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resNode.model.FrameSlot")] 
	public class FrameSlot
	{
		public var no:String = "";
		public var slotserial:String= "";
		public var frameserial:String= "";
		public var slotname:String= "";
		public var framename:String= "";
		public var equipname:String= "";
		public var y_slotmodel:String= "";
		public var status:String= "";
		public var state:String="";//状态编码
		public var rowno:String= "";
		public var colno:String= "";
		public var panelwidth:String= "";
		public var panellength:String= "";
		public var sync_status:String= "";
		public var sync_code:String="";//同步编码
		public var remark:String= "";
		public var updateperson:String="";
		public var updatedate:String= "";
		public var name_std:String;
		public var isreplace:String;
		public var equipcode:String;
		
		public var updatedate_start:String= "";
		public var updatedate_end:String= "";
		public var start:String= "0";
		public var end:String= "50";
		public var sort:String= "equipcode";
		public var dir:String= "asc";
		public var isNumber:String ="";
		
		public function FrameSlot()
		{   
			
		}
	}
}