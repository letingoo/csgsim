////////////////////////////////////////////////////////////////////////////////
//
//  Kap IT  -  Copyright 2010 Kap IT  -  All Rights Reserved.
//
//  This component is distributed under the GNU LGPL v2.1 
//  (available at : http://www.hnu.org/licences/old-licenses/lgpl-2.1.html)
//
////////////////////////////////////////////////////////////////////////////////
package sourceCode.ui.utiltools
{
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;

	public class GroupBox extends Canvas
	{
		
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
	    private static var classConstructed:Boolean = classConstruct();
	    
		//--------------------------------------------------------------------------
	    //
	    //  Class methods
	    //
	    //--------------------------------------------------------------------------
	     /**
	     * @private
	     */ 
		private static function classConstruct():Boolean 
        {
            if (!StyleManager.getStyleDeclaration("GroupBox"))
            {
            	var myStyles:CSSStyleDeclaration = new CSSStyleDeclaration();
                myStyles.defaultFactory = function():void
                {
	            	this.borderStyle = "solid";
	            	this.borderColor = 0x000000;
	            	this.borderThickness = 1;
	            	this.borderSkin = GroupBoxStyle;
                }
            	StyleManager.setStyleDeclaration("GroupBox", myStyles, true);
            }
            return true;
        }
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		
		public function GroupBox()
		{
			super();
			clipContent = false;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Variables
	    //
	    //--------------------------------------------------------------------------
	    /**
	     *  @private
	     */
	    private var _groupLabel:mx.controls.Label;
		/**
	     *  @private
	     */
		private var _groupTitle:String;
		/**
	     *  @private
	     */
		private var _groupTitleChanged:Boolean = false;
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Properties
	    //
	    //--------------------------------------------------------------------------
	    
    	//--------------------------------------
		//  groupTitle
		//--------------------------------------
		
		public function get groupTitle():String
		{
			return _groupTitle;	
		}
		
		public function set groupTitle(value:String):void
		{
			_groupTitle = value;
			_groupTitleChanged = true;	
			invalidateProperties();
		}
			    
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden Methods
	    //
	    //--------------------------------------------------------------------------
		/**
     	 * @private
     	 */
		override protected function createChildren():void
		{
			super.createChildren();
			_groupLabel = new mx.controls.Label();
			addChild(_groupLabel);
		}
		
		/**
     	 * @private
     	 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			commitGroupTitle();
			invalidateDisplayList();
		}

	    /**
     	 * @private
     	 */		
     	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (_groupTitleChanged)
			{
				_groupLabel.x = 20;//距离groupbox左侧的间距
				_groupLabel.y = -_groupLabel.getExplicitOrMeasuredHeight()/2;//标题的高度
				//标题的背景颜色
				_groupLabel.drawRoundRect(0,0,_groupLabel.width,_groupLabel.height,null,0xF6F6F6,1,null,null,null,null);
				_groupTitleChanged = false;
			}
		}
		
	

		
		//--------------------------------------------------------------------------
	    //
	    //  Methods
	    //
	    //--------------------------------------------------------------------------
	    
	    private function commitGroupTitle():void
	    {
	    	if (_groupTitleChanged)
	    	{
	    		_groupLabel.text = _groupTitle;
	    		updateBorderSkin();
	    	}
	    }
	    
	    private function updateBorderSkin():void 
		{
			if (border) 
			{
				rawChildren.removeChild(DisplayObject(border));
				border = null;
				createBorder();
			}
		}
		
	}
}