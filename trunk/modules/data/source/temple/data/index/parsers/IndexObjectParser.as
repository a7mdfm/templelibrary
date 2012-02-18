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

package temple.data.index.parsers 
{
	import temple.common.interfaces.IObjectParsable;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.data.index.ClassSubstitute;
	import temple.data.index.IIndexable;
	import temple.data.index.Indexer;
	import temple.utils.types.ObjectUtils;

	/**
	 * The ObjectParser parses an Object (ig JSON) to an other object (ig a typed DataValueObject).
	 * The objects to parse to must be of type IObjectParsable. The ObjectParser calles the 'parseObject'
	 * method on the IObjectParsable and passes the Object that needs to be parsed.
	 * 
	 * @see temple.common.interfaces.IObjectParsable
	 * 
	 * @author Arjan van Wijk
	 */
	public class IndexObjectParser 
	{
		/**
		 * Parses a list (Array) of Objects to a listed of IObjectParsable objects
		 * 
		 * @param list to parse
		 * @param objectClass classname to be instanced; class must implement IObjectParsable
		 * @param ignoreError if true, the return value of parseObject is always added to the array, and the array itself is
		 * returned. Otherwise, an error in parsing will return null.
		 * @param debug if true information is logged if the parsing failed
		 * @return Array of new objects of the specified type, cast to IObjectParsable, or null if parsing returned false.
		 *	
		 * @see temple.common.interfaces.IObjectParsable#parseObject(object)
		 *	
		 */
		public static function parseList(list:Array, objectClass:Class, indexClass:Class = null, key:String = 'id', ignoreError:Boolean = false, debug:Boolean = true):Array 
		{
			var a:Array = new Array();
			
			if (list == null) return a;
			
			var len:int = list.length;
			for (var i:int = 0;i < len; i++) 
			{
				var ipa:IObjectParsable = IndexObjectParser.parseObject(list[i], objectClass, indexClass, key, ignoreError, debug);
				
				if ((ipa == null) && !ignoreError)
				{
					return null;
				}
				else
				{
					a.push(ipa);
				}
			}
			return a;
		}

		/**
		 * Parses a single Object to an IObjectParsable
		 * 
		 * @param object the object to parse
		 * @param objectClass classname to be instanced; class must implement IObjectParsable
		 * @param ignoreError if true, the return value of IObjectParsable is ignored, and the newly created object is always returned
		 * @param debug if true information is logged if the parsing failed
		 * @return a new object of the specified type, cast to IObjectParsable, or null if parsing returned false.
		 *	
		 * @see temple.common.interfaces.IObjectParsable#parseObject(object)
		 */
		public static function parseObject(object:Object, objectClass:Class, indexClass:Class = null, key:String = 'id', ignoreError:Boolean = false, debug:Boolean = false):IObjectParsable 
		{
			if (!object)
			{
				if (debug) Log.error("object is null", IndexObjectParser);
				return null;
			}
			
			var id:String = key in object ? object[key] : String(object);
			
			if (!id)
			{
				if (debug) Log.error("object has no property '" + key + "'\n" + ObjectUtils.traceObject(object, 3, false), IndexObjectParser);
				return null;
			}
			
			if (object is objectClass && object is IObjectParsable && object is IIndexable && IIndexable(object).id == id)
			{
				// Object is an instance of objectClass. There is no need to parse it.
				if (debug) Log.info("Object '" + object + "' is an instance of " + objectClass + ", don't need to parse it.", IndexObjectParser);
				return IObjectParsable(object);
			}
			
			// Check if the object already exists in the Indexer
			var parsable:IObjectParsable;
			// First check on indexClass
			if (indexClass)
			{
				parsable = Indexer.get(indexClass, id) as IObjectParsable;
			}
			// Check if this class has a static 'indexClass()' method which provides the indexClass 
			else if (Indexer.INDEX_CLASS in objectClass && objectClass[Indexer.INDEX_CLASS] is Class)
			{
				parsable = IObjectParsable(Indexer.get(objectClass[Indexer.INDEX_CLASS], id));
			}
			// Check if this class is stored based on the objectClass
			else if (Indexer.has(objectClass, id) as IObjectParsable)
			{
				parsable = IObjectParsable(Indexer.get(objectClass, id));
			}
			// No object found, check if this class has a substitute
			if (parsable == null && ClassSubstitute.hasSubstitute(objectClass))
			{
				objectClass = ClassSubstitute.getSubstitute(objectClass);
				// Check if this substitute class has a static 'indexClass()' method which provides the indexClass 
				if (Indexer.INDEX_CLASS in objectClass && objectClass[Indexer.INDEX_CLASS] is Class)
				{
					parsable = IObjectParsable(Indexer.get(objectClass[Indexer.INDEX_CLASS], id));
				}
				else
				{
					// Check if this class is stored based on the substitute class
					parsable = IObjectParsable(Indexer.get(objectClass, id));
				}
			}
			// Still no object found in Indexer. We create a new one. 
			if (parsable == null)
			{
				parsable = new objectClass() as IObjectParsable;
			}
			
			if (parsable == null)
			{
				throwError(new TempleArgumentError(IndexObjectParser, "Class '" + objectClass + "' does not implement IObjectParsable"));
				return null;
			}
			else if (parsable.parseObject(object) || ignoreError) 
			{
				return parsable;
			}
			if (debug) Log.error("Error parsing object: " + object + " to " + parsable, IndexObjectParser);
				
			return null;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(IndexObjectParser);
		}
	}
}
