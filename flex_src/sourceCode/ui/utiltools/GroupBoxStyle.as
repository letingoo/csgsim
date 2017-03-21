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
}