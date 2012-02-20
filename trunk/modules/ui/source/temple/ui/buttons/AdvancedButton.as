/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
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
package temple.ui.buttons 
{
	import temple.common.interfaces.IHasValue;
	import temple.ui.form.components.IRadioButton;
	import temple.ui.form.components.IRadioGroup;
	import temple.ui.form.components.ISetValue;
	import temple.ui.form.components.RadioGroup;
	import temple.ui.label.LabelUtils;
	import temple.ui.label.TextFieldLabelBehavior;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * The most advanced button of the Temple.
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see ../../../../readme.html
	 * 
	 * @author Thijs Broerse
	 */
	public class AdvancedButton extends LabelButton implements IHasValue, ISetValue, IRadioButton
	{
		protected var _group:IRadioGroup;
		protected var _data:*;
		protected var _toggle:Boolean;

		public function AdvancedButton() 
		{
			this.addEventListener(MouseEvent.CLICK, this.handleClick);
		}
		
		override protected function init(textField:TextField = null):void
		{
			this._label = textField ? new TextFieldLabelBehavior(textField) : LabelUtils.findLabel(this);
		}
		
		/**
		 *  @inheritDoc
		 */
		public function get groupName():String
		{
			return this._group ? this._group.name : null;
		}

		/**
		 * @inheritDoc
		 */
		public function set groupName(value:String):void
		{
			this.group = RadioGroup.getInstance(value);
		}

		/**
		 * @inheritDoc
		 */
		public function get group():IRadioGroup
		{
			return this._group;
		}

		/**
		 * @inheritDoc
		 */
		public function set group(value:IRadioGroup):void
		{
			if (this._group == value) return;
			
			// remove from group if we already had a group
			if (this._group) this._group.remove(this);
			
			this._group = value;
			if (this._group) this._group.add(this);
		}

		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return this._data;
		}

		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			this._data = value;
		}

		/**
		 * Get or set a data object
		 */
		public function get data():*
		{
			return this._data;
		}

		/**
		 * @private
		 */
		public function set data(value:*):void
		{
			this._data = value;
		}

		/**
		 * Indicates if button can be selected deselect when selected. Default: false
		 */
		public function get toggle():Boolean
		{
			return this._toggle;
		}

		/**
		 * @private
		 */
		public function set toggle(value:Boolean):void
		{
			this._toggle = value;
		}
		
		protected function handleClick(event:MouseEvent):void 
		{
			if (this._toggle)
			{
				this.selected = !this.selected;
			}
			else if (this._group)
			{
				this.selected = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._group)
			{
				var group:IRadioGroup = this._group;
				group.remove(this);
				// check if this is the only button in the group. If so, destruct group
				if (!group.isDestructed && (group.items == null || group.items.length == 0))
				{
					group.destruct();
				}
			}
			
			this._group = null;
			this._data = null;
			
			super.destruct();
		}
	}
}