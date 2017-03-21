package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="sysManager.user.model.UserModel")] 
	public class UserModel
	{
		public var no:String;
		public var user_id:String;
		public var user_name:String;
		public var user_pwd:String;
		public var user_sex:String;
		public var user_dept:String;
		public var user_deptcode:String;
		public var user_post:String;
		public var birthday:String;
		public var education:String;
		public var telephone:String;
		public var mobile:String;
		public var email:String;
		public var address:String;
		public var createtime:String;
		public var remark:String;
		public var start:String;
		public var end:String;
		public var rowid:String;
		public var ip:String;
		public var zby:String;
		public var enable:Boolean;
		public function clear():void
		{
			no="";
			user_id="";
			user_name="";
			user_pwd="";
			user_sex="";
			user_dept="";
			user_deptcode="";
			user_post="";
			birthday="";
			education="";
			telephone="";	
			mobile="";
			email="";
			address="";
			createtime="";
			remark="";
			start="";
			end="";
			rowid="";
			ip="";
			zby="";
			enable=false;
		}
	}
}