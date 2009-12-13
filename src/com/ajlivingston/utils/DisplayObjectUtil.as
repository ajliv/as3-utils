package com.ajlivingston.utils {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/*
	The MIT License
	
	Copyright (c) 2009 AJ Livingston
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	*/
	
	/**
	 * The DisplayObjectUtil class is a collection of methods for manipulating DisplayObjects.
	 * @author AJ Livingston
	 */
	public class DisplayObjectUtil {
		
		/**
		 * @private
		 */
		public function DisplayObjectUtil() {
			throw new Error("The DisplayObjectUtil class cannot be instantiated.");
		}
		
		/**
		 * Scales a <code>DisplayObject</code> to fit the stage.
		 * Requires the <code>DisplayObject</code> to be on the stage for any results.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param center Whether or not the <code>DisplayObject</code> is centered on the stage as well.
		 * 
		 * @see #centerOnStage()
		 * @see #getScaleToFitStage()
		 */
		public static function scaleToFitStage(obj:DisplayObject, center:Boolean = true):void {
			if (obj.stage) {
				// Scale amount to apply.
				var scale:Number = getScaleToFitStage(obj);
					
				// Set the scaleX and scaleY properties.
				obj.scaleX = scale;
				obj.scaleY = scale;
				
				// Center obj on the stage if center is set to true.
				if(center) centerOnStage(obj);
			}
		}
		
		/**
		 * Returns the scale amount for a <code>DisplayObject</code> to fit the stage. Useful for tweening.
		 * Requires the <code>DisplayObject</code> to be on the stage for a return value other than its current <code>scaleX</code> property.
		 * 
		 * @param obj The <code>DisplayObject</code> used to calculate return value.
		 * 
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		public static function getScaleToFitStage(obj:DisplayObject):Number {
			// Setup return variable.
			var scale:Number = obj.scaleX;

			if (obj.stage) {
				// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
				if ((obj.width / obj.height) <= (obj.stage.stageWidth / obj.stage.stageHeight))
					scale = obj.stage.stageHeight / (obj.height / obj.scaleY);
				else
					scale = obj.stage.stageWidth / (obj.width / obj.scaleX);
			}
			
			return scale;
		}
		
		/**
		 * Scales a <code>DisplayObject</code> to fill the entire stage.
		 * Unless ratio is exact to the stage, parts of the <code>DisplayObject</code> will be hidden off-stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage for any results.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param center Whether or not the <code>DisplayObject</code> is centered on the stage as well.
		 * 
		 * @see #centerOnStage()
		 * @see #getScaleToFillStage()
		 */
		 public static function scaleToFillStage(obj:DisplayObject, center:Boolean = true):void {
		 	if(obj.stage) {
		 		// Scale amount to apply.
				var scale:Number = getScaleToFillStage(obj);
					
				// Set the scaleX and scaleY properties.
				obj.scaleX = scale;
				obj.scaleY = scale;
				
				// Center obj on the stage if center is set to true.
				if(center) 
					centerOnStage(obj);
		 	}
		 }
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fill the entire stage. Useful for tweening.
		 * Requires the <code>DisplayObject</code> to be on the stage for a return value other than its current <code>scaleX</code> property.
		 * 
		 * @param obj The <code>DisplayObject</code> used to calculate return value.
		 * 
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		 public static function getScaleToFillStage(obj:DisplayObject):Number {
		 	// Setup return variable.
			var scale:Number = obj.scaleX;
			
			if(obj.stage) {
				// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
				if ((obj.width / obj.height) >= (obj.stage.stageWidth / obj.stage.stageHeight))
					scale = obj.stage.stageHeight / (obj.height / obj.scaleY);
				else
					scale = obj.stage.stageWidth / (obj.width / obj.scaleX);
			}
			
			return scale;
		 }
		 
		 /**
		 * Scales a <code>DisplayObject</code> to fit another <code>DisplayObjct</code>.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param contain The <code>DisplayObject</code> to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param center Whether or not the scaled <code>DisplayObject</code> is to be centered within the container <code>DisplayObject</code>. Default is true.
		 * @param addTo If true, add <code>obj</code> as a child of <code>contain</code> at the <code>addToIndex</code> parameter's value. 
		 * 	The <code>contain</code> parameter must be passed a <code>DisplayObjectContainer</code>.
		 * @param addToIndex The index to add <code>obj</code> as a child at in <code>contain</code> if <code>addTo</code> is passed as <code>true</code>.
		 * 	The <code>obj</code> will be added at the top(default) if less than 0.
		 * 
		 * @see #centerOn()
		 * @see #getScaleToFit()
		 */
		 public static function scaleToFit(obj:DisplayObject, contain:DisplayObject = null, center:Boolean = true, addTo:Boolean = false, addToIndex:int = -1):void {
			var container:DisplayObject = contain;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (obj.parent) {
					container = obj.parent;
				}
				else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return;
				}
			}
			// Get scale amount.
			var scale:Number = getScaleToFit(obj, container);
			
			// Set the scaleX and scaleY properties.
			obj.scaleX = scale;
			obj.scaleY = scale;
			
			// If center is true, center obj on container.
			if (center) centerOn(obj, container);
			
			// If true is passed to the addTo param, add obj to contain at the index passed for the addToAt param.
			// contain MUST be a DisplayObjectContainer or else throw an Error.
			if (addTo) {
				if (container is DisplayObjectContainer) {
					// Set up the index for addChildAt(). By default or addToIndex < 0, use addChld().
					var index:int = addToIndex;
					if (index < 0) 
						(container as DisplayObjectContainer).addChild(obj);
					else
						(container as DisplayObjectContainer).addChildAt(obj, index);
				}
				else {
					throw new Error("Must pass a DisplayObjectContainer to the contain parameter in order to add obj as a child.");
				}
			}
		 }
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fit another <code>DisplayObject</code>. Useful for tweening.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param contain The <code>DisplayObject</code> to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * 
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties. Will return <code>obj</code>'s current <code>scaleX</code> property if <code>contain</code> is invalid.
		 */
		 public static function getScaleToFit(obj:DisplayObject, contain:DisplayObject = null):Number {
		 	var scale:Number = obj.scaleX;
		 	var container:DisplayObject = contain;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (obj.parent) {
					container = obj.parent;
				}
				else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return scale;
				}
			}
			// Check to see if obj's ratio is wider or taller than container, set scale accordingly.
			if ((obj.width / obj.height) <= (container.width / container.height))
				scale = container.height / (obj.height / obj.scaleY);
			else 
				scale = container.width / (obj.width / obj.scaleX);
				
			return scale;
		 }
		 
		 /**
		 * Scales a <code>DisplayObject</code> to fill another <code>DisplayObjct</code>.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param contain The <code>DisplayObject</code> to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param center Whether or not the scaled <code>DisplayObject</code> is to be centered within the container <code>DisplayObject</code>. Default is true.
		 * @param addTo If true, add <code>obj</code> as a child of <code>contain</code> at the <code>addToIndex</code> parameter's value. 
		 * 	The <code>contain</code> parameter must be passed a <code>DisplayObjectContainer</code>.
		 * @param addToIndex The index to add <code>obj</code> as a child at in <code>contain</code> if <code>addTo</code> is passed as <code>true</code>.
		 * 	The <code>obj</code> will be added at the top(default) if less than 0.
		 * 
		 * @see #centerOn()
		 * @see #getScaleToFill()
		 */
		 public static function scaleToFill(obj:DisplayObject, contain:DisplayObject = null, center:Boolean = true, addTo:Boolean = false, addToIndex:int = -1):void {
		 	var container:DisplayObject = contain;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (obj.parent) {
					container = obj.parent;
				}
				else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return;
				}
			}
			// Get scale amount.
			var scale:Number = getScaleToFill(obj, container);
			
			// Set the scaleX and scaleY properties.
			obj.scaleX = scale;
			obj.scaleY = scale;
			
			// If center is true, center obj on container.
			if (center) centerOn(obj, container);
			
			// If true is passed to the addTo param, add obj to contain at the index passed for the addToAt param.
			// contain MUST be a DisplayObjectContainer or else throw an Error.
			if (addTo) {
				if (container is DisplayObjectContainer) {
					// Set up the index for addChildAt(). By default or addToIndex < 0, use addChld().
					var index:int = addToIndex;
					if (index < 0) 
						(container as DisplayObjectContainer).addChild(obj);
					else
						(container as DisplayObjectContainer).addChildAt(obj, index);
				}
				else {
					throw new Error("Must pass a DisplayObjectContainer to the contain parameter in order to add obj as a child.");
				}
			}
		 }
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fill another <code>DisplayObject</code>. Useful for tweening.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param contain The <code>DisplayObject</code> to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * 
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties. Will return <code>obj</code>'s current <code>scaleX</code> property if <code>contain</code> is invalid.
		 */
		 public static function getScaleToFill(obj:DisplayObject, contain:DisplayObject = null):Number {
		 	var scale:Number = obj.scaleX;
		 	var container:DisplayObject = contain;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (obj.parent) {
					container = obj.parent;
				}
				else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return scale;
				}
			}
			// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
			if ((obj.width / obj.height) >= (container.width / container.height))
				scale = container.height / (obj.height / obj.scaleY);
			else 
				scale = container.width / (obj.width / obj.scaleX);
		 	
		 	return scale;
		 }
		
		
		/**
		 * Centers a <code>DisplayObject</code> on the stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage for any results.
		 * @param obj The <code>DisplayObject<code> to be centered.
		 * @see #getCenterOnStage()
		 */
		public static function centerOnStage(obj:DisplayObject):void {
			if (obj.stage) {
				var point:Point = getCenterOnStage(obj);
				obj.x = point.x;
				obj.y = point.y;
			}
		}
		
		/**
		 * Returns a <code>Point</code> of coordinates for a <code>DisplayObject</code> to be centered on the stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage or its current coordinates will be returned.
		 * @param obj The <code>DisplayObject</code> to be centered.
		 * @return The <code>Point</code> with the x and y coordinates for <code>obj</code> to be centered on the stage.
		 */
		public static function getCenterOnStage(obj:DisplayObject):Point {
			var point:Point = new Point(obj.x, obj.y);
			if (obj.stage) {
				point.x = (obj.stage.stageWidth * 0.5) - (obj.width * 0.5);
				point.y = (obj.stage.stageHeight * 0.5) - (obj.height * 0.5);
			}
			return point;
		}
		
		/**
		 * Centers a <code>DisplayObject</code> on another <code>DisplayObject</code>.
		 * Not guaranteed to work correctly with parent-child relationships between <code>obj</code> and <code>contain</code>.
		 * @param obj The <code>DisplayObject</code> to be centered.
		 * @param contain The <code>DisplayObject</code> for <code>obj</code> to be centered on.
		 * @see #getCenterOn()
		 */
		public static function centerOn(obj:DisplayObject, contain:DisplayObject = null):void {
			var point:Point = getCenterOn(obj, contain);
			obj.x = point.x;
			obj.y = point.y;
		}
		
		/**
		 * Returns a <code>Point</code> of coordinates for a <code>DisplayObject</code> to be centered on another <code>DisplayObject</code>.
		 * Not guaranteed to work correctly with parent-child relationships between <code>obj</code> and <code>contain</code>.
		 * @param obj The <code>DisplayObject</code> to be centered.
		 * @param contain The <code>DisplayObject</code> for <code>obj</code> to be centered on.
		 * @return The <code>Point</code> with the x and y coordinates for <code>obj</code> to be centered on <code>contain</code>.
		 */
		 public static function getCenterOn(obj:DisplayObject, contain:DisplayObject):Point {
		 	var point:Point = new Point(obj.x, obj.y);
		 	point.x = (contain.x + contain.width * 0.5) - (obj.width * 0.5);
		 	point.y = (contain.y + contain.height * 0.5) - (obj.height * 0.5);
		 	return point;
		 }
		
	}
}