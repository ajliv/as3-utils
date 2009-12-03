/**
 * DisplayObjUtils
 * Copyright (c) 2009 AJ Livingston
*/
package com.ajlivingston.utils {

	import flash.display.DisplayObject;
	
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
		 * Scales a <code>DisplayObject</code> to fit completely within the stage.
		 * Requires the <code>DisplayObject</code> to be on the stage for any results.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param center Whether or not the <code>DisplayObject</code> is centered on the stage as well. True by default.
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
		 * Returns the scale amount for a <code>DisplayObject</code to fit completely within the stage.
		 * Requires the <code>DisplayObject</code> to be on the stage for a return value other than 1.
		 * 
		 * @param obj The <code>DisplayObject</code> used to calculate return value.
		 * 
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		public static function getScaleToFitStage(obj:DisplayObject):Number {
			// Scale amount to apply, default is 1.
			var scale:Number = 1;

			if (obj.stage) {
				// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
				if ((obj.width / obj.height) <= (obj.stage.stageWidth / obj.stage.stageHeight))
					scale = obj.stage.stageHeight / (obj.height / obj.scaleY);
				else if ((obj.width / obj.height) > (obj.stage.stageWidth / obj.stage.stageHeight))
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
		 * @param center Whether or not the <code>DisplayObject</code> is centered on the stage as well. True by default.
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
				if(center) centerOnStage(obj);
		 	}
		 }
		 
		 /**
		 * Returns the scale amount for a <code>DisplayObject</code to fill the entire stage.
		 * Requires the <code>DisplayObject</code> to be on the stage for a return value other than 1.
		 * 
		 * @param obj The <code>DisplayObject</code> used to calculate return value.
		 * 
		 * @return The value to be applied to the <code>scaleX</code> and/or <code>scaleY</code> properties.
		 */
		 public static function getScaleToFillStage(obj:DisplayObject):Number {
		 	// Scale amount to apply, default is 1.
			var scale:Number = 1;
			
			if(obj.stage) {
				// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
				if ((obj.width / obj.height) >= (obj.stage.stageWidth / obj.stage.stageHeight))
					scale = obj.stage.stageHeight / (obj.height / obj.scaleY);
				else if ((obj.width / obj.height) < (obj.stage.stageWidth / obj.stage.stageHeight))
					scale = obj.stage.stageWidth / (obj.width / obj.scaleX);
			}
			
			return scale;
		 }
		 
		 /**
		 * Scales a <code>DisplayObject</code> to fit within another <code>DisplayObjct</code>.
		 * 
		 * @param obj The <code>DisplayObject</code> to be scaled.
		 * @param contain The <code>DisplayObject</code> to scale within. If set to <code>null</code>(default) then <code>obj</code>'s parent will be used.
		 * @param center Whether or not the scaled <code>DisplayObject</code> is to be centered within the container <code>DisplayObject</code>. Default is true.
		 * 
		 * @see #centerOn()
		 */
		 public static function scaleToFit(obj:DisplayObject, contain:DisplayObject = null, center:Boolean = true):void {
			var scale:Number;
			var container:DisplayObject = contain;
			// If container is null, try and set it to obj's parent. Else, throw Error and return.
			if (!container) {
				if (obj.parent) {
					container = obj.parent;
				}
				else {
					throw new Error("Invalid contain parameter.");
					return;
				}
			}
			
			// Check to see if obj's ratio is wider or taller than the stage, set scale accordingly.
			if ((obj.width / obj.height) <= (container.width / container.height))
				scale = container.height / (obj.height / obj.scaleY);
			else 
				scale = container.width / (obj.width / obj.scaleX);
			
			// Set the scaleX and scaleY properties.
			obj.scaleX = scale;
			obj.scaleY = scale;
			
			// If center is true, center obj on container.
			if (center) centerOn(obj, container);
		 }
		
		
		/**
		 * Centers a <code>DisplayObject</code> on the stage.
		 * Requires the <code>DisplayObject</code> passed to be on the stage for any results.
		 * 
		 * @param obj The <code>DisplayObject<code> to be centered.
		 */
		public static function centerOnStage(obj:DisplayObject):void {
			if (obj.stage) {
				// 50% of the stage's width/height minus 50% of obj's width/height.
				obj.x = (obj.stage.stageWidth * 0.5) - (obj.width * 0.5);
				obj.y = (obj.stage.stageHeight * 0.5) - (obj.height * 0.5);
			}
		}
		
		/**
		 * Centers a <code>DisplayObject</code> on another <code>DisplayObject</code>.
		 * 
		 * @param obj The <code>DisplayObject</code> to be centered.
		 * @param contain The <code>DisplayObject</code> for <code>obj</code> to be centered on.
		 */
		public static function centerOn(obj:DisplayObject, contain:DisplayObject):void {
			obj.x = (contain.x + contain.width * 0.5) - (obj.width * 0.5);
			obj.y = (contain.y + contain.height * 0.5) - (obj.height * 0.5);
		}
		
	}
}