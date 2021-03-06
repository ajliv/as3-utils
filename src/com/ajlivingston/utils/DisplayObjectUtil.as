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
		 * Centers a DisplayObject on another DisplayObject.
		 * 
		 * @param obj The DisplayObject to be centered.
		 * @param contain The DisplayObject for <code>obj</code> to be centered on.
		 * @see #getCenterOn()
		 */
		 public static function centerOn(obj:DisplayObject, contain:DisplayObject):void {
			var object:DisplayObject = obj;
			var point:Point = getCenterOn(object, contain);
			object.x = point.x;
			object.y = point.y;
		 }
		
		
		/**
		 * Centers a DisplayObject on the stage.
		 * Requires the DisplayObject to be on the stage for any results.
		 * 
		 * @param obj The DisplayObject to be centered.
		 * @return Returns true or false based on the method's success.
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
		 * Scales a DisplayObject to fill another DisplayObjct.
		 * Be aware that if <code>obj</code>'s parent is used for the <code>contain</code> parameter, <code>obj</code>'s own width would be a factor in the container's width it is being scaled into if it is out of bounds of the main container body.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param contain The DisplayObject to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @param center Whether or not the scaled DisplayObject is to be centered within the container DisplayObject. Default is true.
		 * @param addTo If true, add <code>obj</code> as a child of <code>contain</code> at the <code>addToIndex</code> parameter's value. 
		 * 	The <code>contain</code> parameter must be passed a <code>DisplayObjectContainer</code>.
		 * @param addToIndex The index to add <code>obj</code> as a child at in <code>contain</code> if <code>addTo</code> is passed as <code>true</code>.
		 * 	The <code>obj</code> will be added at the top(default) if less than 0.
		 * @return Returns true or false based on the method's success.
		 * @see #centerOn()
		 * @see #getScaleToFill()
		 */
		 public static function scaleToFill(obj:DisplayObject, contain:DisplayObject = null, preserveRatio:Boolean = true, center:Boolean = true, addTo:Boolean = false, addToIndex:int = -1):Boolean {
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
			var scale:Point = getScaleToFill(object, container, preserveRatio);
			// Set the scaleX and scaleY properties.
			object.scaleX = scale.x;
			object.scaleY = scale.y;
			// If center is true, center obj on container.
			if (center) centerOn(object, container);
			// If true is passed to the addTo param, add obj to contain at the index passed for the addToAt param.
			// contain MUST be a DisplayObjectContainer or else throw an Error.
			if (addTo) {
				if (container is DisplayObjectContainer) {
					// Set up the index for addChildAt(). By default (addToIndex < 0), use addChld().
					if (addToIndex < 0) (container as DisplayObjectContainer).addChild(object);
					else (container as DisplayObjectContainer).addChildAt(object, addToIndex);
				} else {
					throw new Error("Must pass a DisplayObjectContainer to the contain parameter in order to add obj as a child.");
					return false;
				}
			}
			return true;
		 }
		
		
		/**
		 * Scales a DisplayObject to fill the entire stage.
		 * Unless ratio is exact to the stage, parts of the DisplayObject will be hidden off-stage.
		 * Requires the DisplayObject to be on the stage.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @param center Whether or not the DisplayObject is centered on the stage as well.
		 * @return Returns true or false based on the method's success.
		 * @see #centerOnStage()
		 * @see #getScaleToFillStage()
		 */
		 public static function scaleToFillStage(obj:DisplayObject, preserveRatio:Boolean = true, center:Boolean = true):Boolean {
		 	var object:DisplayObject = obj;
		 	if(object.stage) {
		 		// Scale amount to apply.
				var scale:Point = getScaleToFillStage(object, preserveRatio);
				// Set the scaleX and scaleY properties.
				object.scaleX = scale.x;
				object.scaleY = scale.y;
				// Center obj on the stage if center is set to true.
				if(center) centerOnStage(object);					
		 	} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
		 		return false;
		 	}
		 	return true;
		 }
		 
		 
		 /**
		 * Scales a DisplayObject to fit another DisplayObjct.
		 * Be aware that if <code>obj</code>'s parent is used for the <code>contain</code> parameter, <code>obj</code>'s own width would be a factor in the container's width it is being scaled into if it is out of bounds of the main container body.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param contain The DisplayObject to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @param center Whether or not the scaled DisplayObject is to be centered within the container DisplayObject. Default is true.
		 * @param addTo If true, add <code>obj</code> as a child of <code>contain</code> at the <code>addToIndex</code> parameter's value. 
		 * 	The <code>contain</code> parameter must be passed a <code>DisplayObjectContainer</code>.
		 * @param addToIndex The index to add <code>obj</code> as a child at in <code>contain</code> if <code>addTo</code> is passed as true.
		 * 	The <code>obj</code> will be added at the top(default) if less than 0.
		 * @return Returns true or false based on the method's success.
		 * @see #centerOn()
		 * @see #getScaleToFit()
		 */
		 public static function scaleToFit(obj:DisplayObject, contain:DisplayObject = null, preserveRatio:Boolean = true, center:Boolean = true, addTo:Boolean = false, addToIndex:int = -1):Boolean {
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
			var scale:Point = getScaleToFit(object, container, preserveRatio);
			// Set the scaleX and scaleY properties.
			object.scaleX = scale.y;
			object.scaleY = scale.x;
			// If center is true, center obj on container.
			if (center) centerOn(object, container);
			// If true is passed to the addTo param, add obj to contain at the index passed for the addToAt param.
			// contain MUST be a DisplayObjectContainer or else throw an Error.
			if (addTo) {
				if (container is DisplayObjectContainer) {
					// Set up the index for addChildAt(). By default (addToIndex < 0), use addChld().
					if (addToIndex < 0) (container as DisplayObjectContainer).addChild(object);
					else (container as DisplayObjectContainer).addChildAt(object, addToIndex);
				} else {
					throw new Error("Must pass a DisplayObjectContainer to the contain parameter in order to add obj as a child.");
					return false;
				}
			}
			return true;
		 }
		 
		 
		 /**
		 * Scales a DisplayObject to fit the stage.
		 * Requires the DisplayObject to be on the stage.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @param center Whether or not the DisplayObject is centered on the stage as well.
		 * @return Returns true or false based on the method's success.
		 * @see #centerOnStage()
		 * @see #getScaleToFitStage()
		 */
		 public static function scaleToFitStage(obj:DisplayObject, preserveRatio:Boolean = true, center:Boolean = true):Boolean {
			var object:DisplayObject = obj;
			if (object.stage) {
				// Scale amount to apply.
				var scale:Point = getScaleToFitStage(object, preserveRatio);
				// Set the scaleX and scaleY properties.
				object.scaleX = scale.x;
				object.scaleY = scale.y;
				// Center object on the stage if center is set to true.
				if(center) centerOnStage(object);
			} else {
				throw new Error("The DisplayObject must be on the Stage.");
				return false;
			}
			return true;
		 }
		 
		 
		 /**
		 * Scales a DisplayObject to stretch to fill another DisplayObject entirely. 
		 * Be aware that if <code>obj</code>'s parent is used for the <code>contain</code> parameter, <code>obj</code>'s own width would be a factor in the container's width it is being scaled into if it is out of bounds of the main container body.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param contain The DisplayObject to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param center Whether or not the DisplayObject is centered on the stage as well.
		 * @param addTo If true, add <code>obj</code> as a child of <code>contain</code> at the <code>addToIndex</code> parameter's value. 
		 * 	The <code>contain</code> parameter must be passed a <code>DisplayObjectContainer</code>.
		 * @param addToIndex The index to add <code>obj</code> as a child at in <code>contain</code> if <code>addTo</code> is passed as true.
		 * 	The <code>obj</code> will be added at the top(default) if less than 0.
		 * @return Returns true or false based on the method's success.
		 * @see #getStretchToFill()
		 * @see #centerOn()
		 */
		 public static function stretchToFill(obj:DisplayObject, contain:DisplayObject = null, center:Boolean = true, addTo:Boolean = false, addToIndex:int = -1):Boolean {
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
			var scale:Point = getStretchToFill(object, container);
			// Set the scaleX and scaleY properties.
			object.scaleX = scale.x;
			object.scaleY = scale.y;
			// If center is true, center obj on container.
			if (center) centerOn(object, container);
			// If true is passed to the addTo param, add obj to contain at the index passed for the addToAt param.
			// contain MUST be a DisplayObjectContainer or else throw an Error.
			if (addTo) {
				if (container is DisplayObjectContainer) {
					// Set up the index for addChildAt(). By default (addToIndex < 0), use addChld().
					if (addToIndex < 0) (container as DisplayObjectContainer).addChild(object);
					else (container as DisplayObjectContainer).addChildAt(object, addToIndex);
				} else {
					throw new Error("Must pass a DisplayObjectContainer to the contain parameter in order to add obj as a child.");
					return false;
				}
			}
		 	return true;
		 }
		 
		 
		 /**
		 * Scales a DisplayObject to stretch to fill the entire stage.
		 * Requires the DisplayObject to be on the stage.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param center Whether or not the DisplayObject is centered on the stage as well.
		 * @return Returns true or false based on the method's success.
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
		 * Returns a Point of coordinates for a DisplayObject to be centered on another DisplayObject.
		 * 
		 * @param obj The DisplayObject to be centered.
		 * @param contain The DisplayObject for <code>obj</code> to be centered on.
		 * @return The Point with the x and y coordinates for <code>obj</code> to be centered on <code>contain</code>.
		 */
		 public static function getCenterOn(obj:DisplayObject, contain:DisplayObject):Point {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
		 	// Convert the coordinates to global so DisplayObjects that are not direct children of the stage will still be accurate.
		 	var containPoint:Point = container.localToGlobal(new Point(container.x, container.y));
		 	var objectPoint:Point = new Point(
		 		(containPoint.x + container.width*0.5) - (object.width*0.5),
		 		(containPoint.y + container.height*0.5) - (object.height*0.5) );	
		 	// Convert the coordinates back to local for the return.
		 	return object.globalToLocal(objectPoint);
		 }
		 
		 
		 /**
		 * Returns a Point of coordinates for a DisplayObject to be centered on the stage.
		 * Requires the DisplayObject to be on the stage or its current coordinates will be returned.
		 * 
		 * @param obj The DisplayObject to be centered.
		 * @return The Point with the x and y coordinates for <code>obj</code> to be centered on the stage.
		 */
		 public static function getCenterOnStage(obj:DisplayObject):Point {
			var object:DisplayObject = obj;
			var point:Point = object.localToGlobal(new Point(object.x, object.y));
			if (object.stage) {
				point.x = (object.stage.stageWidth * 0.5) - (object.width * 0.5);
				point.y = (object.stage.stageHeight * 0.5) - (object.height * 0.5);
			} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
		 	}
			return object.globalToLocal(point);
		 }
		 
		 
		 /**
		 * Returns a Point of the scale amounts for a DisplayObject to fill another DisplayObject.
		 * Be aware that if <code>obj</code>'s parent is used for the <code>contain</code> parameter, <code>obj</code>'s own width would be a factor in the container's width it is being scaled into if it is out of bounds of the main container body.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param contain The DisplayObject to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @return A Point containing the values for the <code>scaleX</code> and <code>scaleY</code> properties. Will return <code>obj</code>'s current scale values if <code>contain</code> is invalid.
		 */
		 public static function getScaleToFill(obj:DisplayObject, contain:DisplayObject = null, preserveRatio:Boolean = true):Point {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
		 	var scale:Point = new Point(object.scaleX, object.scaleY);
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (object.parent) {
					container = object.parent;
				} else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return scale;
				}
			}
			// Check the width/height in relation to the container.
			if (preserveRatio) {
				// Scale amounts based off of current ratio.
				if ((object.width / object.height) >= (container.width / container.height)) {
					scale.y = container.height / (object.height/object.scaleY);
					scale.x *= ((container.height / (object.height/object.scaleY)) / object.scaleY);
				} else { 
					scale.x = container.width / (object.width / object.scaleX);
					scale.y *= ((container.width / (object.width / object.scaleX)) / object.scaleX);
				}
			} else {
				// Scale amounts based off a 1:1 ratio.
				if (((object.width/object.scaleX) / (object.height/object.scaleY)) >= (container.width / container.height)) {
					scale.y = container.height / (object.height/object.scaleY);
					scale.x = scale.y;
				} else { 
					scale.x = container.width / (object.width / object.scaleX);
					scale.y = scale.x;
				}
			}
		 	return scale;
		 }
		 
		 
		 /**
		 * Returns a Point of the scale amounts for a DisplayObject to fill the entire stage.
		 * Requires the DisplayObject to be on the stage or the current scale amounts will be returned.
		 * 
		 * @param obj The DisplayObject used to calculate return value.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @return A Point containing the <code>scaleX</code> and <code>scaleY</code> properties. Will return <code>obj</code>'s current scale values if it is not on the stage.
		 */
		 public static function getScaleToFillStage(obj:DisplayObject, preserveRatio:Boolean = true):Point {
		 	// Capture obj and setup return variable.
		 	var object:DisplayObject = obj;
			var scale:Point = new Point(object.scaleX, object.scaleY);
			// Check that obj is on the stage to get the new scale amount.
			if(object.stage) {
				// Check the width/height in relation to the stage.
				if (preserveRatio) {
					// Scale amounts based off of current ratio.
					if ((object.width / object.height) >= (object.stage.stageWidth / object.stage.stageHeight)) {
						scale.y = object.stage.stageHeight / (object.height / object.scaleY);
						scale.x *= ((object.stage.stageHeight / (object.height/object.scaleY)) / object.scaleY);
					} else {
						scale.x = object.stage.stageWidth / (object.width / object.scaleX);
						scale.y *= ((object.stage.stageWidth / (object.width / object.scaleX)) / object.scaleX);
					}
				} else {
					// Scale amounts based off a 1:1 ratio.
					if (((object.width/object.scaleX) / (object.height/object.scaleY)) >= (object.stage.stageWidth / object.stage.stageHeight)) {
						scale.y = object.stage.stageHeight / (object.height / object.scaleY);
						scale.x = scale.y;
					} else {
						scale.x = object.stage.stageWidth / (object.width / object.scaleX);
						scale.y = scale.x;
					}
				}
			} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
			}
			return scale;
		 }
		 
		 
		 /**
		 * Returns a Point of the scale amounts for a DisplayObject to fit another DisplayObject.
		 * Be aware that if <code>obj</code>'s parent is used for the <code>contain</code> parameter, <code>obj</code>'s own width would be a factor in the container's width it is being scaled into if it is out of bounds of the main container body.
		 * 
		 * @param obj The DisplayObject to be scaled.
		 * @param contain The DisplayObject to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties. Will return <code>obj</code>'s current <code>scaleX</code> property if <code>contain</code> is invalid.
		 */
		 public static function getScaleToFit(obj:DisplayObject, contain:DisplayObject = null, preserveRatio:Boolean = true):Point {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
		 	var scale:Point = new Point(object.scaleX, object.scaleY);
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (object.parent) {
					container = object.parent;
				} else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return scale;
				}
			}
			// Check the width/height in relation to the container.
			if (preserveRatio) {
				// Scale amounts based off of current ratio.
				if ((object.width / object.height) <= (container.width / container.height)) {
					scale.y = container.height / (object.height/object.scaleY);
					scale.x *= ((container.height / (object.height/object.scaleY)) / object.scaleY);
				} else { 
					scale.x = container.width / (object.width / object.scaleX);
					scale.y *= ((container.width / (object.width / object.scaleX)) / object.scaleX);
				}
			} else {
				// Scale amounts based off a 1:1 ratio.
				if (((object.width/object.scaleX) / (object.height/object.scaleY)) <= (container.width / container.height)) {
					scale.y = container.height / (object.height/object.scaleY);
					scale.x = scale.y;
				} else { 
					scale.x = container.width / (object.width / object.scaleX);
					scale.y = scale.x;
				}
			}
			return scale;
		 }
		 
		 
		 /**
		 * Returns a Point of the scale amounts for a DisplayObject to fit the stage.
		 * Requires the DisplayObject to be on the stage or the current scale amounts will be returned.
		 * 
		 * @param obj The DisplayObject used to calculate return value.
		 * @param preserveRatio Whether to preserve the current x:y scale ratio of <code>obj</code>(default), or reset it to 1:1.
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		 public static function getScaleToFitStage(obj:DisplayObject, preserveRatio:Boolean = true):Point {
			// Capture obj and setup return variable.
			var object:DisplayObject = obj;
			var scale:Point = new Point(object.scaleX, object.scaleY);
			// Check that obj is on the stage to get the new scale amount.
			if (object.stage) {
				// Check the width/height in relation to the stage.
				if (preserveRatio) {
					// Scale amounts based off of current ratio.
					if ((object.width / object.height) <= (object.stage.stageWidth / object.stage.stageHeight)) {
						scale.y = object.stage.stageHeight / (object.height / object.scaleY);
						scale.x *= ((object.stage.stageHeight / (object.height/object.scaleY)) / object.scaleY);
					} else {
						scale.x = object.stage.stageWidth / (object.width / object.scaleX);
						scale.y *= ((object.stage.stageWidth / (object.width / object.scaleX)) / object.scaleX);
					}
				} else {
					// Scale amounts based off a 1:1 ratio.
					if (((object.width/object.scaleX) / (object.height/object.scaleY)) <= (object.stage.stageWidth / object.stage.stageHeight)) {
						scale.y = object.stage.stageHeight / (object.height / object.scaleY);
						scale.x = scale.y;
					} else {
						scale.x = object.stage.stageWidth / (object.width / object.scaleX);
						scale.y = scale.x;
					}
				}
			} else {
		 		throw new Error("The DisplayObject must be on the Stage.");
			}
			return scale;
		 }
		 
		 /**
		 * Returns a Point of the scale amounts for a DisplayObject to stretch to fill another DisplayObject entirely.
		 * Be aware that if <code>obj</code>'s parent is used for the <code>contain</code> parameter, <code>obj</code>'s own width would be a factor in the container's width it is being scaled into if it is out of bounds of the main container body.
		 * 
		 * @param obj The DisplayObject used to calculate return value.
		 * @param contain The DisplayObject to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @return A Point containing values for the <code>scaleX</code> and <code>scaleY</code> properties. Will return <code>obj</code>'s current scale values if <code>contain</code> is invalid.
		 */
		 public static function getStretchToFill(obj:DisplayObject, contain:DisplayObject = null):Point {
		 	var object:DisplayObject = obj;
		 	var container:DisplayObject = contain;
		 	var scale:Point = new Point(object.scaleX, object.scaleY);
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (object.parent) {
					container = object.parent;
				} else {
					throw new Error("The obj parameter must have a parent if contain is null.");
					return scale;
				}
			}
			scale.x = container.width / (object.width/object.scaleX);
		 	scale.y = container.height / (object.height/object.scaleY);
			
			return scale;
		 }
		 
		 
		 /**
		 * Returns a Point of the scale amounts for a DisplayObject to stretch to fill the stage.
		 * Requires the DisplayObject to be on the stage or else the current scale properties will be returned.
		 * 
		 * @param obj The DisplayObject used to calculate return value.
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