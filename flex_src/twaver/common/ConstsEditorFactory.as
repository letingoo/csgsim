package twaver.common
{
	import mx.core.IFactory;

	public class ConstsEditorFactory implements IFactory
	{
		private var prefix:String;
		
		public function ConstsEditorFactory(prefix:String)
		{
			this.prefix = prefix;
		}

		public function newInstance():*
		{
			var constsEditor:ConstsEditor = new ConstsEditor();
			constsEditor.prefix = prefix;
			return constsEditor;
		}
		
	}
}