package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import tests.TestsHeader;
	import component.Card;
	public class Registry 
	{
		public static var info:String = "";
		public static var currentSection:String = "";
		public static var currentSectionID:int = 0;
		
		//cross card
		public static var currentCard:Card;
		public static var oldCard:Card;
		public static var currentState:FlxState;
		public static var map:Array;
		public static var line:FlxSprite;
		public function Registry() 
		{
		}
		
	}

}