/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.ui.layout.liquid
{
	import temple.core.CoreSprite;
	import temple.utils.FrameDelay;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * The LiquidSprite extends the CoreMovieClip but has already LiquidBehavior implemented.
	 * All liquid properties are also available on the LiquidSprite.
	 * 
	 * <p>If the LiquidSprite is set as component, all liquid properties can be set in the Component Inspector in the Flash IDE</p>
	 * 
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @includeExample LiquidExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidSprite extends CoreSprite implements ILiquidObject
	{
		private var _liquidBehavior:LiquidBehavior;
		private var _debug:Boolean;

		public function LiquidSprite(relatedObject:ILiquidObject = null, initObject:Object = null)
		{
			super();
			
			this._liquidBehavior = new LiquidBehavior(this, relatedObject, initObject);
			
			// Call init after a framedelay, so all inspetables are already set
			if (!initObject) new FrameDelay(this.initLiquid);
		}

		/**
		 * @inheritDoc
		 */
		public function get left():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.left : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set left(value:Number):void
		{
			this.liquidBehavior.left = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Left", type="String")]
		public function set inspectableLeft(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.left = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get right():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.right : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set right(value:Number):void
		{
			this.liquidBehavior.right = value;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Right", type="String")]
		public function set inspectableRight(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.right = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get horizontalCenter():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.horizontalCenter : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set horizontalCenter(value:Number):void
		{
			this.liquidBehavior.horizontalCenter = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Horizontal center", type="String")]
		public function set inspectableHorizontalCenter(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.horizontalCenter = Number(value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeX():Number
		{
			return this.liquidBehavior.relativeX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeX(value:Number):void
		{
			this.liquidBehavior.relativeX = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Relative X", type="String")]
		public function set inspectableRelativeX(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.relativeX = Number(value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get minimalWidth():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.minimalWidth : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalWidth(value:Number):void
		{
			if (this.liquidBehavior) this.liquidBehavior.minimalWidth = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Minimal width", type="String")]
		public function set inspectableMinimalWidth(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.minimalWidth = Number(value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeWidth():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.relativeWidth : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeWidth(value:Number):void
		{
			if (this.liquidBehavior) this.liquidBehavior.relativeWidth = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Relative Width", type="String")]
		public function set inspectableRelativeWidth(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.liquidBehavior.relativeWidth = Number(value);
			}
			else if (value.indexOf('%'))
			{
				value = value.replace('%', '');
				if (value != '' && !isNaN(Number(value)))
				{
					this.liquidBehavior.relativeWidth = Number(value) * 0.01;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get absoluteWidth():Number 
		{
			return this._liquidBehavior.absoluteWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function set absoluteWidth(value:Number):void 
		{
			this._liquidBehavior.absoluteWidth = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get top():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.top : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set top(value:Number):void
		{
			this.liquidBehavior.top = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Top", type="String")]
		public function set inspectableTop(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.top = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get bottom():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.bottom : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set bottom(value:Number):void
		{
			this.liquidBehavior.bottom = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Bottom", type="String")]
		public function set inspectableBottom(value:String):void
		{
			
			if (value != '' && !isNaN(Number(value)))
			{
				this.bottom = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get verticalCenter():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.verticalCenter : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set verticalCenter(value:Number):void
		{
			this.liquidBehavior.verticalCenter = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Vertical center", type="String")]
		public function set inspectableVerticalCenter(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.verticalCenter = Number(value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeY():Number
		{
			return this.liquidBehavior.relativeY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeY(value:Number):void
		{
			this.liquidBehavior.relativeY = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Relative Y", type="String")]
		public function set inspectableRelativeY(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.relativeY = Number(value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get minimalHeight():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.minimalHeight : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalHeight(value:Number):void
		{
			if (this.liquidBehavior) this.liquidBehavior.minimalHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeHeight():Number
		{
			return this._liquidBehavior ? this._liquidBehavior.relativeHeight : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeHeight(value:Number):void
		{
			if (this.liquidBehavior) this.liquidBehavior.relativeHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get absoluteHeight():Number 
		{
			return this._liquidBehavior.absoluteHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set absoluteHeight(value:Number):void 
		{
			this._liquidBehavior.absoluteHeight = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Relative Height", type="String")]
		public function set inspectableRelativeHeight(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.liquidBehavior.relativeHeight = Number(value);
			}
			else if (value.indexOf('%'))
			{
				value = value.replace('%', '');
				if (value != '' && !isNaN(Number(value)))
				{
					this.liquidBehavior.relativeHeight = Number(value) * 0.01;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get relatedObject():ILiquidRelatedObject
		{
			return this._liquidBehavior ? this._liquidBehavior.relatedObject : null;
		}

		/**
		 * @inheritDoc
		 */
		public function set relatedObject(value:ILiquidRelatedObject):void
		{
			this.liquidBehavior.relatedObject = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function update():void
		{
			if (this._liquidBehavior) this._liquidBehavior.update();
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLiquid():Boolean
		{
			return this._liquidBehavior ? this._liquidBehavior.isLiquid() : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get resetRelatedScale():Boolean
		{
			return this._liquidBehavior ? this._liquidBehavior.resetRelatedScale : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set resetRelatedScale(value:Boolean):void
		{
			if (this._liquidBehavior) this._liquidBehavior.resetRelatedScale = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get offset():Point
		{
			return this._liquidBehavior ? this._liquidBehavior.offset : null;
		}
		
		/**
		 * If set to true all values will be rounded to pixels
		 */
		public function get snapToPixels():Boolean
		{
			return this._liquidBehavior ? this._liquidBehavior.snapToPixels : false;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Snap to pixels", type="Boolean", defaultValue="true")]
		public function set snapToPixels(value:Boolean):void
		{
			if (this._liquidBehavior) this._liquidBehavior.snapToPixels = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get keepAspectRatio():Boolean
		{
			return this._liquidBehavior ? this._liquidBehavior.keepAspectRatio : false;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Keep aspect ratio", type="Boolean", defaultValue="false")]
		public function set keepAspectRatio(value:Boolean):void
		{
			this.liquidBehavior.keepAspectRatio = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get adjustRelated():Boolean
		{
			return this._liquidBehavior ? this._liquidBehavior.adjustRelated : true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set adjustRelated(value:Boolean):void
		{
			this.liquidBehavior.adjustRelated = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		/**
		 * Indicates if the LiquidBehavior is enabled
		 */
		public function get liquidEnabled():Boolean
		{
			return this._liquidBehavior ? this._liquidBehavior.enabled : false;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Liquid enabled", type="Boolean", defaultValue="true")]
		public function set liquidEnabled(value:Boolean):void
		{
			this.liquidBehavior.enabled = value;
		}
		
		/**
		 * Returns a reference of the LiquidBehavior.
		 * The LiquidBehavior is only created when it's actually needed.
		 */
		public function get liquidBehavior():LiquidBehavior
		{
			return this._liquidBehavior;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		public function set debug(value:Boolean):void
		{
			this.liquidBehavior.debug = this._debug = value;
		}
		
		/**
		 * Initializes the liquid behavior
		 */
		protected function initLiquid():void
		{
			if (this.isLiquid())
			{
				this._liquidBehavior.init();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._liquidBehavior = null;
			
			super.destruct();
		}
	}
}