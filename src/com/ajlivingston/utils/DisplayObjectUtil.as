package com.ajlivingston.utils {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
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
		 * Centers a <code>DisplayObject</code> on another <code>DisplayObject</code>.
		 * Not guaranteed to work correctly with parent-child relationships between <code>obj</code> and <code>contain</code>.
		 * 
		 * @param obj The <code>DisplayObject</code> to be centered.
		 * @param contain The <code>DisplayObject</code> for <code>obj</code> to be centered on.
		 * @see #getCenterOn()
		 */
		 public static function centerOn(obj:DisplayObject, contain:DisplayObject):void {
			var object:DisplayObject = obj;
			var point:Point = getCenterOn(object, contain);
			object.x = point.x;
			object.y = point.y;
		 }
		
		
		/**
		 * Centers a <code>DisplayObject</code> on the stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage for any results.
		 * 
		 * @param obj The <code>DisplayObject<code> to be centered.
		 * @return Returns <code>true</code> or <code>false</code> based on the method's success.
		 * @see #getCenterOnStage()
		 */
		 public static function centerOnStage(obj:DisplayObject):Boolean {
			var object:DisplayObject = obj;
			if (object.stage) {
				var point:Point = getCenterOnStage(object);
				object.x = point.x;
				object.y = point.y;
			} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
		 		return false;
		 	}			
			return true;
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
		 * @see #centerOn()
		 * @see #getScaleToFill()
		 */
		 public static function scaleToFill(obj:DisplayObject, contain:DisplayObject = null, center:Boolean = true, addTo:Boolean = false, addToIndex:int = -1):Boolean {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (object.parent) {
					container = object.parent;
				} else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return false;
				}
			}
			// Get scale amount.
			var scale:Number = getScaleToFill(object, container);
			
			// Set the scaleX and scaleY properties.
			object.scaleX = scale;
			object.scaleY = scale;
			
			// If center is true, center obj on container.
			if (center) centerOn(object, container);
			
			// If true is passed to the addTo param, add obj to contain at the index passed for the addToAt param.
			// contain MUST be a DisplayObjectContainer or else throw an Error.
			if (addTo) {
				if (container is DisplayObjectContainer) {
					// Set up the index for addChildAt(). By default (addToIndex < 0), use addChld().
					if (addToIndex < 0) 
						(container as DisplayObjectContainer).addChild(object);
					else
						(container as DisplayObjectContainer).addChildAt(object, addToIndex);
				} else {
					throw new Error("Must pass a DisplayObjectContainer to the contain parameter in order to add obj as a child.");
					return false;
				}
			}
			return true;
		 }
		
		
		/**
		 * Scales a <code>DisplayObject</code> to fill the entire stage.
		 * Unless ratio is exact to the stage, parts of the <code>DisplayObject</code> will be hidden off-stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param center Whether or not the <code>DisplayObject</code> is centered on the stage as well.
		 * @return Returns <code>true</code> or <code>false</code> based on the method's success.
		 * @see #centerOnStage()
		 * @see #getScaleToFillStage()
		 */
		 public static function scaleToFillStage(obj:DisplayObject, center:Boolean = true):Boolean {
		 	var object:DisplayObject = obj;
		 	if(object.stage) {
		 		// Scale amount to apply.
				var scale:Number = getScaleToFillStage(object);
					
				// Set the scaleX and scaleY properties.
				object.scaleX = scale;
				object.scaleY = scale;
				
				// Center obj on the stage if center is set to true.
				if(center) 
					centerOnStage(object);					
		 	} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
		 		return false;
		 	}
		 	return true;
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
		 * @return Returns <code>true</code> or <code>false</code> based on the method's success.
		 * @see #centerOn()
		 * @see #getScaleToFit()
		 */
		 public static function scaleToFit(obj:DisplayObject, contain:DisplayObject = null, center:Boolean = true, addTo:Boolean = false, addToIndex:int = -1):Boolean {
			var object:DisplayObject = obj;
			var container:DisplayObject = contain;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (object.parent) {
					container = object.parent;
				} else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return false;
				}
			}
			// Get scale amount.
			var scale:Number = getScaleToFit(object, container);
			
			// Set the scaleX and scaleY properties.
			object.scaleX = scale;
			object.scaleY = scale;
			
			// If center is true, center obj on container.
			if (center) centerOn(object, container);
			
			// If true is passed to the addTo param, add obj to contain at the index passed for the addToAt param.
			// contain MUST be a DisplayObjectContainer or else throw an Error.
			if (addTo) {
				if (container is DisplayObjectContainer) {
					// Set up the index for addChildAt(). By default (addToIndex < 0), use addChld().
					if (addToIndex < 0) 
						(container as DisplayObjectContainer).addChild(object);
					else
						(container as DisplayObjectContainer).addChildAt(object, addToIndex);
				} else {
					throw new Error("Must pass a DisplayObjectContainer to the contain parameter in order to add obj as a child.");
					return false;
				}
			}
			return true;
		 }
		 
		 
		 /**
		 * Scales a <code>DisplayObject</code> to fit the stage.
		 * Requires the <code>DisplayObject</code> to be on the stage.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param center Whether or not the <code>DisplayObject</code> is centered on the stage as well.
		 * @return Returns <code>true</code> or <code>false</code> based on the method's success.
		 * @see #centerOnStage()
		 * @see #getScaleToFitStage()
		 */
		 public static function scaleToFitStage(obj:DisplayObject, center:Boolean = true):Boolean {
			var object:DisplayObject = obj;
			if (object.stage) {
				// Scale amount to apply.
				var scale:Number = getScaleToFitStage(object);
					
				// Set the scaleX and scaleY properties.
				object.scaleX = scale;
				object.scaleY = scale;
				
				// Center object on the stage if center is set to true.
				if(center) centerOnStage(object);
			} else {
				throw new Error("The DisplayObject must be on the Stage.");
				return false;
			}
			return true;
		 }
		 
		 
		 /**
		 * Scales a <code>DisplayObject</code> to stretch to fill the entire stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param center Whether or not the <code>DisplayObject</code> is centered on the stage as well.
		 * @return Returns <code>true</code> or <code>false</code> based on the method's success.
		 * @see #getStretchToFillStage()
		 * @see #centerOnStage()
		 */
		 public static function stretchToFillStage(obj:DisplayObject, center:Boolean = true):Boolean {
		 	var object:DisplayObject = obj;
		 	if (object.stage) {
		 		//Get and apply scaling.
		 		var scale:Point = getStretchToFillStage(object);
		 		object.scaleX = scale.x;
		 		object.scaleY = scale.y;
		 		// Run centerOnStage to offset any relative-to-parent coordinates.
		 		if (center) centerOnStage(object);
		 	} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
		 		return false;
		 	}
		 	return true;
		 }
		 
		 
		 
		 
		 /**
		 * Returns a <code>Point</code> of coordinates for a <code>DisplayObject</code> to be centered on another <code>DisplayObject</code>.
		 * Not guaranteed to work correctly with parent-child relationships between <code>obj</code> and <code>contain</code>.
		 * 
		 * @param obj The <code>DisplayObject</code> to be centered.
		 * @param contain The <code>DisplayObject</code> for <code>obj</code> to be centered on.
		 * @return The <code>Point</code> with the x and y coordinates for <code>obj</code> to be centered on <code>contain</code>.
		 */
		 public static function getCenterOn(obj:DisplayObject, contain:DisplayObject):Point {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
		 	var point:Point = new Point(object.x, object.y);
		 	point.x = (container.x + container.width * 0.5) - (object.width * 0.5);
		 	point.y = (container.y + container.height * 0.5) - (object.height * 0.5);
		 	return point;
		 }
		 
		 
		 /**
		 * Returns a <code>Point</code> of coordinates for a <code>DisplayObject</code> to be centered on the stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage or its current coordinates will be returned.
		 * 
		 * @param obj The <code>DisplayObject</code> to be centered.
		 * @return The <code>Point</code> with the x and y coordinates for <code>obj</code> to be centered on the stage.
		 */
		 public static function getCenterOnStage(obj:DisplayObject):Point {
			var object:DisplayObject = obj;
			var point:Point = new Point(object.x, object.y);
			if (object.stage) {
				point.x = (object.stage.stageWidth * 0.5) - (object.width * 0.5);
				point.y = (object.stage.stageHeight * 0.5) - (object.height * 0.5);
			} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
		 	}
			return point;
		 }
		 
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fill another <code>DisplayObject</code>. Useful for tweening.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param contain The <code>DisplayObject</code> to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties. Will return <code>obj</code>'s current <code>scaleX</code> property if <code>contain</code> is invalid.
		 */
		 public static function getScaleToFill(obj:DisplayObject, contain:DisplayObject = null):Number {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
		 	var scale:Number = object.scaleX;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (object.parent) {
					container = object.parent;
				} else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return scale;
				}
			}
			// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
			if ((object.width / object.height) >= (container.width / container.height))
				scale = container.height / (object.height / object.scaleY);
			else 
				scale = container.width / (object.width / object.scaleX);
		 	
		 	return scale;
		 }
		 
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fill the entire stage. Useful for tweening.
		 * Requires the <code>DisplayObject</code> to be on the stage for a return value other than its current <code>scaleX</code> property.
		 * 
		 * @param obj The <code>DisplayObject</code> used to calculate return value.
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		 public static function getScaleToFillStage(obj:DisplayObject):Number {
		 	// Capture obj and setup return variable.
		 	var object:DisplayObject = obj;
			var scale:Number = object.scaleX;
			// Check that obj is on the stage to get the new scale amount.
			if(object.stage) {
				// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
				if ((object.width / object.height) >= (object.stage.stageWidth / object.stage.stageHeight))
					scale = object.stage.stageHeight / (object.height / object.scaleY);
				else
					scale = object.stage.stageWidth / (object.width / object.scaleX);
			} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
			}
			return scale;
		 }
		 
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fit another <code>DisplayObject</code>. Useful for tweening.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param contain The <code>DisplayObject</code> to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties. Will return <code>obj</code>'s current <code>scaleX</code> property if <code>contain</code> is invalid.
		 */
		 public static function getScaleToFit(obj:DisplayObject, contain:DisplayObject = null):Number {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
		 	var scale:Number = object.scaleX;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (object.parent) {
					container = object.parent;
				} else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return scale;
				}
			}
			// Check to see if obj's ratio is wider or taller than container, set scale accordingly.
			if ((object.width / object.height) <= (container.width / container.height))
				scale = container.height / (object.height / object.scaleY);
			else 
				scale = container.width / (object.width / object.scaleX);
				
			return scale;
		 }
		 
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fit the stage. Useful for tweening.
		 * Requires the <code>DisplayObject</code> to be on the stage for a return value other than its current <code>scaleX</code> property.
		 * 
		 * @param obj The <code>DisplayObject</code> used to calculate return value.
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		 public static function getScaleToFitStage(obj:DisplayObject):Number {
			// Capture obj and setup return variable.
			var object:DisplayObject = obj;
			var scale:Number = object.scaleX;
			// Check that obj is on the stage to get the new scale amount.
			if (object.stage) {
				// Check to see if object's ratio is wider or taller than the stage, set scale accordingly.
				if ((object.width / object.height) <= (object.stage.stageWidth / object.stage.stageHeight))
					scale = object.stage.stageHeight / (object.height / object.scaleY);
				else
					scale = object.stage.stageWidth / (object.width / object.scaleX);
			} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
			}
			return scale;
		 }
		 
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code> to fill the entire stage. Useful for tweening.
		 * Requires the <code>DisplayObject</code> to be on the stage or else the current scale properties will be returned.
		 * 
		 * @param obj The <code>DisplayObject</code> used to calculate return value.
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		 public static function getStretchToFillStage(obj:DisplayObject):Point {
		 	var object:DisplayObject = obj;
		 	var scale:Point = new Point(object.scaleX, object.scaleY);
		 	// Check to see if obj is on the stage to get values.
		 	if (object.stage) {
		 		scale.x = object.stage.stageWidth / (object.width/object.scaleX);
		 		scale.y = object.stage.stageHeight / (object.height/object.scaleY);
		 	} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
		 	}
		 	return scale;
		 }
		
	}
}