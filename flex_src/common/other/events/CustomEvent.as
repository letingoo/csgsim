package common.other.events { 
	import flash.events.Event; 
	import flash.events.EventDispatcher; 
	public class CustomEvent extends Event 
	{ 
		public var data:Object; /** * 定义一个事件分发器，用于分发事件 */ 
	    public static const dispatcher:EventDispatcher = new EventDispatcher(); /** * 参数说明： * type:String — 事件的类型，就是自己定义的事件的名字 data:Object - 通过此事件传递的参数 bubbles:Boolean (default = false) — 确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。 cancelable:Boolean (default = false) — 确定是否可以取消 Event 对象。默认值为 false。 个人对于自定义事件的理解：分发器dispatcher可以看成是一辆小车，自定义事件构造器中的data是放在这辆小车上的一件物品 当自定义事件被分发出去后（类似于把小车推出去了），由监听该自定义事件的方法捕获（即拿到了小车），然后在处理的方法里面 拿到小车上的物品进行处理 */ 
		public function CustomEvent(type:String,data:Object,bubbles:Boolean=false, cancelable:Boolean=false)
		{ 
			super(type, bubbles, cancelable); this.data = data; } 
		override public function clone():Event{ return new CustomEvent(type,data); 
		} 
	} 
}