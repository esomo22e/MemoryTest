package
{
	import flash.display.MovieClip;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.Shape;
	public class Card extends MovieClip
	{
		public var image:String;
		public var id:String;
		public var square:Shape;
		public var loader:URLLoader = new URLLoader();
		private var imgLoad:Loader;
		private var cardLoader:Loader = new Loader();
		
		public function Card()
		{
			this.buttonMode = true;
			addEventListener(MouseEvent.CLICK, cardClick);
			square = new Shape();
			
			//square.visible = false;
			square.graphics.clear();
			square.graphics.lineStyle(1,0x000000);
			square.graphics.beginFill(0x007DC3);
			square.graphics.drawRect(0,0,100,100);
			square.graphics.endFill();
			square.width = 80;
			square.height = 80;
			square.x = -40;
			square.y = -40;
			
		}
		
		public function init(_image:String, _id:String) : void
		{
			image = _image;
			id = _id;
					
			cardLoader.load(new URLRequest( _image));
			cardLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			
			
		}
		
		public function imageLoaded( evt : Event ) : void
		{
			imgLoad = Loader(evt.target.loader);
			
			addChild(imgLoad);
			imgLoad.width = 80;
			imgLoad.height = 80;
			imgLoad.x = -40;
			imgLoad.y = -40;		
		
			
			addChild(square);
			
			
		}
		
		
		
		public function cardClick(evt:Event):void
		{
			
			this.dispatchEvent( new Event("cardClick", true) );

			
			square.scaleY = .8;
			imgLoad.scaleY = 0;
			imgLoad.y = 0;
			Tweener.addTween(square, {scaleY:0,y:0 ,time:.25, onComplete:setVisibility, onCompleteParams:[false], transition:"easeInQuad"});
			
			
		}
		
		private function setVisibility(visibility:Boolean){
			square.scaleY = 0;
			//Tweener.addTween(square,{scaleY:0.8, y:-40, time:1, delay:1});
			square.visible = visibility;
			
			Tweener.addTween(imgLoad, {scaleY:.7,y:-40 ,time:.25, transition:"easeOutQuad"});
			
			
		}
		
		public function resetBack():void
		{
			
			imgLoad.scaleY = 0.8;
			square.scaleY = 0;
			square.y = 0;
			Tweener.addTween(imgLoad, { scaleY:0, y:0, time:.25, onComplete:setVisibilityBack, onCompleteParams:[true], transition:"easeOutQuad"});
			
			mouseEnabled = true
			mouseChildren = true;
		}
		
		private function setVisibilityBack(visibility:Boolean){
			imgLoad.scaleY = 0;
			//Tweener.addTween(imgLoad,{scaleY:0.7, y:-40, time:.25, delay:1});
			imgLoad.visible = visibility;
			Tweener.addTween(square, {scaleY:0.8,y:-40 ,time:.25, transition:"easeInQuad"});
			
			
		
		}
		
		public function fadeOut(): void
		{
			var fadeOut:Object = {alpha:0.5,time:.25, delay:.75};
			Tweener.addTween(imgLoad, fadeOut);
			
		}
		
		public function fadeIn(): void
		{
			var fadeIn:Object = {alpha:100,time:.25};
			Tweener.addTween(imgLoad, fadeIn);
			
			this.resetBack();
		}
	}
}