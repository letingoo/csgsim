package sourceCode.sysGraph.model
{
	
		
		import mx.utils.ObjectUtil;
		
		/*
		* 参照java.util.Map接口编写，由于ActionScript和Java的差异，去掉了一些方法。
		* 被去掉的方法有：entrySet()、equals()、hashCode()
		*/
		
		/**
		 * <code>Map</code>映射类型。
		 * 将键映射到值的对象。一个映射不能包含重复的键；每个键最多只能映射到一个值。 
		 * 禁止使用<code>null</code>作为键值，否则抛出异常。
		 * 公开的方法有：
		 * <ul>
		 *  <li><code>clear():void</code></li>
		 *  <li><code>containsKey(key:String):Boolean</code></li>
		 *  <li><code>containsValue(value:Object):Boolean</code></li>
		 *  <li><code>isEmpty():Boolean</code></li>
		 *  <li><code>keySet():Array</code></li>
		 *  <li><code>put(key:String,value:Object):Object</code></li>
		 *  <li><code>putAll(map:Map):void</code></li>
		 *  <li><code>get(key:String):Object</code></li>
		 *  <li><code>remove(key:String):Object</code></li>
		 *  <li><code>size():int</code></li>
		 *  <li><code> values():Array</code></li>
		 * </ul>
		 * @version 1.0 2013/11/21
		 * @author dongliyang 
		 */
		public class Map {
			
			private var _dataMap:Object = null;
			
			/**
			 * <code>Map</code>映射类型。
			 * 将键映射到值的对象。一个映射不能包含重复的键；每个键最多只能映射到一个值。 
			 * 禁止使用<code>null</code>作为键值，否则抛出异常。
			 * 公开的方法有：
			 * <ul>
			 *  <li><code>clear():void</code></li>
			 *  <li><code>containsKey(key:String):Boolean</code></li>
			 *  <li><code>containsValue(value:Object):Boolean</code></li>
			 *  <li><code>isEmpty():Boolean</code></li>
			 *  <li><code>keySet():Array</code></li>
			 *  <li><code>put(key:String,value:Object):Object</code></li>
			 *  <li><code>putAll(map:Map):void</code></li>
			 *  <li><code>get(key:String):Object</code></li>
			 *  <li><code>remove(key:String):Object</code></li>
			 *  <li><code>size():int</code></li>
			 *  <li><code> values():Array</code></li>
			 * </ul>
			 */
			public function Map(){
				_dataMap = new Object();
			}
			
			/**
			 * 从此映射中移除所有映射关系
			 */
			public function clear():void {
				for each(var key:String in keys()){
					delete _dataMap[key];
				}
			}
			
			/**
			 * 如果此映射包含指定键的映射关系，则返回<code>true</code>
			 * @param key 测试是否存在于此映射中的键
			 * @return 如果此映射中包含指定键的映射关系，则返回<code>true</code>
			 */
			public function containsKey(key:String):Boolean {
				if(key == null){
					return false;
				}
				return _dataMap.hasOwnProperty(key);
			}
			
			/**
			 * 如果此映射中将一个或多个键映射到指定值，则返回<code>true</code>
			 * @param value 测试是否存在于此映射中的值
			 * @return 如果此映射将一个或多个键映射到指定值，则返回<code>true</code>
			 */
			public function containsValue(value:Object):Boolean {
				for each(var key:String in keys()){
					if(ObjectUtil.compare(_dataMap[key],value) == 0){
						return true;
					}
				}
				return false;
			}
			
			/**
			 * 如果此映射未包含键-值映射关系，则返回<code>true</code>
			 * @return 如果此映射未包含键-值映射关系，则返回 <code>true</code>
			 */
			public function isEmpty():Boolean {
				return keys().length == 0;
			}
			
			/**
			 * 返回此映射中包含的键的<code>Array</code>视图。
			 * @return 此映射中包含的键的<code>Array</code>视图
			 */
			public function keySet():Array {
				return keys();
			}
			
			/**
			 * 将指定的值与此映射中的指定键关联。
			 * 如果此映射以前包含一个该键的映射关系，则用指定值替换旧值。
			 * @param key 与指定值关联的键
			 * @param value 与指定键关联的值 
			 * @return 以前与 key关联的值，如果没有针对 key 的映射关系，则返回 <code>null</code>
			 */
			public function put(key:String,value:Object):Object {
				if(key == null){
					throw new Error("键值Key不能为null");
				}
				if(containsKey(key)){
					var oldValue:Object = _dataMap[key];
					_dataMap[key] = value;
					return oldValue;
				} else {
					_dataMap[key] = value;
					return null;
				}
				
			}
			
			/**
			 * 从指定映射中将所有映射关系复制到此映射中。
			 * 对于指定映射中的每个键key到值value的映射关系，此调用等效于对此映射调用一次 put(key,value)
			 * @param map 要存储在此映射中的映射关系 
			 */
			public function putAll(map:Map):void {
				if(map == null){
					throw new Error("指定的映射Map为null");
				}
				
				for each(var key:String in map.keySet()){
					_dataMap[key] = map.get(key);
				}
			}
			
			/**
			 * 返回指定键所映射的值，如果此映射不包含该键的映射关系，则返回<code>null</code>
			 * @param key 要返回其关联值的键
			 * @return 指定键所映射的值；如果此映射不包含该键的映射关系，则返回 <code>null</code> 
			 */
			public function get(key:String):Object {
				if(containsKey(key)){
					return _dataMap[key];
				} else {
					return null;
				}
			}
			
			/**
			 * 如果存在一个键的映射关系，则将其从此映射中移除。
			 * 返回此映射中以前关联该键的值，如果此映射中不包含该键的
			 * 映射关系，则返回null。
			 * 调用返回后，此映射将不再包含指定键的映射关系。
			 * @param key 从映射中移除其映射关系的键
			 * @return 以前与key关联的值，如果没有key的映射关系，则返回<code>null</code>
			 */
			public function remove(key:String):Object {
				if(containsKey(key)){
					var oldValue:Object = get(key);
					delete _dataMap[key];
					return oldValue;
				} else {
					return null;
				}
			}
			
			/**
			 * 返回此映射中的键-值映射关系数。
			 * @return 此映射中的键-值映射关系数
			 */
			public function size():int {
				return keys().length;
			}
			
			/**
			 * 返回此映射中包含的值得<code>Array</code>视图
			 * @return 此映射中包含的值的<code>Array</code>视图
			 */
			public function values():Array {
				var values:Array = new Array();
				for each(var key:String in keys()){
					values.push(_dataMap[key]);
				}
				return values;
			}
			
			/**
			 * 返回此映射中包含的键的<code>Array</code>视图
			 * @return 返回此映射中包含的键的<code>Array</code>视图
			 */
			private function keys():Array {
				var clsInfo:Object = ObjectUtil.getClassInfo(_dataMap);
				var props:Array = clsInfo["properties"];
				var keys:Array = new Array();
				for each(var q:QName in props){
					keys.push(q.localName);
				}
				return keys;
			}
		}
	
}