package state
{
	import org.flixel.FlxButton;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Stefan
	 */
	public class MainMenuState extends FlxState 
	{
		
		public function MainMenuState() 
		{
			createUI();
		}
		private function createUI():void
		{
			var level_1:FlxButton = new FlxButton(0, 0, "level 1", level_1_Handler);
			level_1.x = (FlxG.width - level_1.width) / 2;
			level_1.y = (FlxG.height - level_1.height) / 2;
			add(level_1);
			
		}
		private function level_1_Handler():void
		{
			FlxG.switchState(new Level_1_State());
		}
	}

}