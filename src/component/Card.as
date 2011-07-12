package component 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Stefan
	 */
	public class Card extends FlxSprite
	{
		public var id:int;
		public var W:Number = 40;
		public var H:Number = 40;
		
		public var i:int;
		public var j:int;
		
		public var TargetCard:Card;

		public var Path:Array = new Array();
		private var pressed:Boolean = false;
		
		public var line:FlxSprite = new FlxSprite();
		public var bmp:BitmapData;
		
		public function Card(id:int, bmp:Class) 
		{
			super(0, 0, bmp);
			this.id = id;
		}

		public function setIndex(a:int, b:int):void {
			i = a;
			j = b;
		}
		public function Pressed():void {
			pressed = true;
		}
		public function UnPressed():void {
			pressed = false;
		}
		private function MouseOver():void 
		{
		}
		private function MouseOut():void 
		{
		}
		
		private function MouseClick():void 
		{
			FlxG.log("Card MouseClick.....");
			Registry.currentCard = this;
			if (Registry.oldCard == null) 
			{
				Registry.oldCard = Registry.currentCard;
				Registry.oldCard.Pressed();
			} 
			else 
			{

				Registry.oldCard.TargetCard = Registry.currentCard;
				
			}
		}
		
	}

}