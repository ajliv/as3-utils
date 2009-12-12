package com.ajlivingston.display
{
	import com.ajlivingston.utils.DisplayObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;

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
	 * The <code>MaskImage</code> class is a simple solution for masking a self-loaded image.
	 * <p>Loads an image from the <code>URLRequest</code> passed in the constructor directly into a mask of the passed dimensions (default: 100x100).</p>
	 * <p>The image can be set to scale to fit or fill (depending on the set <code>MaskImageScaleMode</code>). By default no scaling is applied.</p>
	 * <p>The image can be set to be centered within the mask. (depending on the set <code>MaskImageAlignMode</code>). By default the image is aligned to the top-left corner of the mask.</p>
	 * 
	 * @author AJ Livingston
	 * @see MaskImageScaleMode
	 * @see MaskImageAlignMode
	 * @see com.ajlivingston.utils.DisplayObjectUtil
	 */
	public class MaskImage extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _mask:Shape;
		private var _maskWidth:Number;
		private var _maskHeight:Number;
		private var _scaleMode:String;
		private var _alignMode:String;
		
		/**
		 * Creates a new MaskImage instance.
		 * 
		 * @param urlRequest The <code>URLRequest</code> for the image to load.
		 * @param maskWidth The width of the mask.
		 * @param maskHeight The height of the mask.
		 * @param scaleMode The way the image is displayed, can accept any <code>MaskImageScaleMode</code>. By default is <code>MaskImageAlignMode.NO_SCALE</code>.
		 * @param alignMode The way the image is aligned within the box, can accept any <code>MaskImageAlignMode</code>. By default is <code>MaskImageAlignMode.TOP_LEFT</code>.
		 * 
		 * @event Event.COMPLETE Dispatched by the <code>MaskImage</code> when the image is added to the display list after loading.
		 * 
		 * @see MaskImageScaleMode
		 * @see MaskImageAlignMode
		 */
		public function MaskImage(urlRequest:URLRequest, maskWidth:Number = 100, maskHeight:Number = 100, scaleMode:String = null, alignMode:String = null) {
			_maskWidth = maskWidth;
			_maskHeight = maskHeight;
			
			// Set the scale mode.
			switch(scaleMode) {
				case MaskImageScaleMode.FILL: _scaleMode = scaleMode; break;
				case MaskImageScaleMode.FIT : _scaleMode = scaleMode; break;
				default : _scaleMode = MaskImageScaleMode.NO_SCALE; break;
			}
			//Set the align mode.
			switch(alignMode) {
				case MaskImageAlignMode.CENTER : _alignMode = alignMode; break;
				default : _alignMode = MaskImageAlignMode.TOP_LEFT; break;
			}
			
			// Set up the mask.
			_mask = new Shape();
			this.addChild(_mask);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(urlRequest);
		}
		
		/**
		 * The mask's width.
		 */
		public function get maskWidth():Number {
			return _maskWidth;
		}
		public function set maskWidth(value:Number):void {
			_maskWidth = value;
			update();
		}
		
		/**
		 * The mask's height.
		 */
		public function get maskHeight():Number {
			return _maskHeight;
		}
		public function set maskHeight(value:Number):void {
			_maskHeight = value;
			update();
		}
		
		/**
		 * Sets both the width and height of the mask at once.
		 * 
		 * @param size A <code>Point</code> object where (x, y) is used as (width, height).
		 */
		public function setMaskSize(size:Point):void {
			_maskWidth = size.x;
			_maskHeight = size.y;
			update();
		}
		
		private function update():void {
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0, 0, _maskWidth, _maskHeight);
			
			// Scale and center based on set modes.
			switch(_scaleMode) {
				case MaskImageScaleMode.FILL : DisplayObjectUtil.scaleToFill(_bitmap, _mask, (_alignMode == MaskImageAlignMode.CENTER)); break;
				case MaskImageScaleMode.FIT : DisplayObjectUtil.scaleToFit(_bitmap, _mask, (_alignMode == MaskImageAlignMode.CENTER)); break;
				default : break;
			}
		}
		
		private function onComplete(event:Event):void {
			(event.target as Loader).contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_bitmap = Bitmap((event.target as Loader).content);
			_bitmap.mask = _mask;
			this.addChild(_bitmap);
			update();
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}