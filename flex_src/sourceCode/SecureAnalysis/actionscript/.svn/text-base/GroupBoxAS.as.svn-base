package com.metarnet.mnt.common.views
{
	import flash.display.DisplayObject;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	public class GroupBoxAS extends Canvas
	{
		private static var classConstructed:Boolean = classConstruct();
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
		public function GroupBoxAS()
		{
			super();
			clipContent = false;
		}
		private var _groupLabel:mx.controls.Label;
		private var _groupTitle:String;
		/**
		 * @private
		 */
		private var _groupTitleChanged:Boolean = false;
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
				_groupLabel.x = 20;
				_groupLabel.y = -_groupLabel.getExplicitOrMeasuredHeight()/2;
				_groupTitleChanged = false;
			}
		}
		//--------------------------------------------------------------------------
		//
		// Methods
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

/*＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝GroupBoxStyle ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
package fr.kapit.flex.ui.halo.nsdk
{
	import flash.display.Graphics;
	import flash.text.TextLineMetrics;
	
	import mx.core.UIComponent;
	import mx.skins.ProgrammaticSkin;
	
	public class GroupBoxStyle extends ProgrammaticSkin
	{
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var g:Graphics = graphics;
			var borderColor:Number = getStyle("borderColor");
			var borderThickness:Number = getStyle("borderThickness");
			var groupName:String;
			var line:TextLineMetrics;
			g.clear();
			if(parent)
			{
				groupName = (parent as GroupBox).groupTitle;
				line = (parent as UIComponent).measureText(groupName);
				g.lineStyle(borderThickness, borderColor);
				g.moveTo(0, 0);
				g.lineTo(20, 0);
				g.moveTo(0,0);
				g.lineTo(0, unscaledHeight);
				g.lineTo(unscaledWidth, unscaledHeight);
				g.lineTo(unscaledWidth, 0);
				g.lineTo(20+line.width+5, 0);
			}
		}
	}
	
	
}*/