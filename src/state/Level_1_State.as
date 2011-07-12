package state 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import component.Card;
	/**
	 * ...
	 * @author Stefan
	 */
	public class Level_1_State extends FlxState 
	{
		private var curr_level:String = "";
		private var Row:uint = 4;
		private var Colum:uint = 5;
		private var MarginLeft:Number = 180;
		private var MarginTop:Number = 100;
		private var CARD_WIDTH:uint = 40;
		private var CARD_HEIGHT:uint = 40;
		private var oldCard:Card;
		private var map:Array;
		private var cardGroup:Array;
		private var updated:Boolean = false; 
		[Embed(source = '../../assets/level1/1.jpg')] public static var Card1:Class;
		[Embed(source = '../../assets/level1/2.jpg')] public static var Card2:Class;
		[Embed(source = '../../assets/level1/3.jpg')] public static var Card3:Class;
		[Embed(source = '../../assets/level1/4.jpg')] public static var Card4:Class;
		[Embed(source = '../../assets/level1/5.jpg')] public static var Card5:Class;
		[Embed(source = '../../assets/level1/6.jpg')] public static var Card6:Class;
		[Embed(source = '../../assets/level1/7.jpg')] public static var Card7:Class;
		[Embed(source = '../../assets/level1/8.jpg')] public static var Card8:Class;
		[Embed(source = '../../assets/level1/9.jpg')] public static var Card9:Class;
		
		
		public function Level_1_State() 
		{
		}
		override public function create():void
		{
			init();
			Registry.map = map;
			Registry.currentState = this;
			Registry.line = new FlxSprite();
		}
		
		private function init():void {
			
			
			var numArray:Array = new Array();
			for (var i:uint = 0; i < Row; i++) 
			{
				numArray[i] = new Array();
				var num:uint = 0;
				for (var j:uint = 0; j < Colum; j++) 
				{
					numArray[i][j] = ++num;
				}
			}
			for (i = 0; i < Row; i++) 
			{
				for (j = 0; j < Colum; j++) 
				{
					var Rani:uint = Math.floor(Math.random() * Row);
					var Ranj:uint = Math.floor(Math.random() * Colum);

					var temp:uint = numArray[i][j];
					numArray[i][j] = numArray[Rani][Ranj];
					numArray[Rani][Ranj] = temp;
				}
			}
			//card map tile exist or no exist
			map = new Array(Row + 2);
			for (i = 0; i < Row + 2; i++) 
			{
				map[i] = new Array(Colum + 2);
				for (j = 0; j < Colum + 2; j++) 
				{
					if (i == 0 || j == 0 || i == Row + 1 || j == Colum + 1) 
					{
						map[i][j] = 0;
					} else {
						map[i][j] = 1;
					}
				}
			}
			//card map hold card
			cardGroup = new Array(Row);
			for (i = 0; i < Row; i++) 
			{
				cardGroup[i] = new Array(Colum);
			}
			//init card coordinate
			for (i = 0; i < Row; i++) 
			{
				for (j = 0; j < Colum; j++) 
				{
					var id:uint = numArray[i][j];
					var card:Card = createCard(id);
					add(card);
					cardGroup[i][j] = card;
					card.x = MarginLeft + j * (card.W + 2);
					card.y = MarginTop + i * (card.H + 2);
					card.setIndex(i + 1, j + 1);
					trace("i=" +card.i + "|" + "j=" + card.j);
				}
			}
		}
		
		private function createCard(id:uint):Card 
		{
			switch(id) 
			{
				case 1: return new Card(id , Card1);
				case 2: return new Card(id , Card2);
				case 3: return new Card(id , Card3)
				case 4: return new Card(id , Card4)
				case 5: return new Card(id , Card5)
				case 6: return new Card(id , Card6)
				case 7: return new Card(id , Card7)
				case 8: return new Card(id , Card8)
				case 9: return new Card(id , Card9)
				default : trace("Can not Create!");
			}
			
			return new Card(id , Card9);
		}
		private function getCard():Card
		{
			var ret:Card = null;
			if (FlxG.mouse.justPressed())
			{
				var x:uint = (FlxG.mouse.screenX - MarginLeft) / (CARD_WIDTH + 2);
				var y:uint = (FlxG.mouse.screenY - MarginTop) / (CARD_HEIGHT + 2);
				trace("X=" + x + "|" + "Y=" + y);
				
				if (x > Colum -1 || y > Row -1)
				{
					
				}
				else
				{
					ret = cardGroup[y][x];
					trace("i=" + ret.i + "|" + "j=" + ret.j+"id="+ret.id);
				}
			}
			return ret;
		}
		
		override public function update():void
		{
			var card:Card = getCard();
			if (card)
			{
				Registry.currentCard = card;
			
				if (Registry.oldCard == null) {
					Registry.oldCard = Registry.currentCard;
					Registry.oldCard.Pressed();
				} 
				else 
				{
					Registry.oldCard.TargetCard = Registry.currentCard;
				}
				
				if (isMatched()) 
				{
					Registry.currentState.add(Registry.line);	
					var node:Object = Registry.oldCard.Path.shift();
					
					Registry.line.x = MarginLeft + node.y * Registry.oldCard.W - Registry.oldCard.W / 2;
					Registry.line.y = MarginTop + node.x * Registry.oldCard.H - Registry.oldCard.H / 2;
					
					var card:Card = Registry.oldCard;
					while (card.Path.length > 0) 
					{
						node = card.Path.shift();
						Registry.line.drawLine(Registry.line.x,Registry.line.y,MarginLeft + node.y * card.W - card.W / 2, MarginTop + node.x * card.H - card.H / 2,0xFFFF0000);
						Registry.line.x = MarginLeft + node.y * card.W - card.W / 2;
						Registry.line.y = MarginTop + node.x * card.H - card.H / 2;
					} 
					map[card.i][card.j] = 0;
					map[card.TargetCard.i][card.TargetCard.j] = 0;
					cardGroup[card.i -1][card.j -1] = null;
					cardGroup[card.TargetCard.i -1][card.TargetCard.j -1] = null;
					remove(card);
					remove(Registry.line);
					remove(card.TargetCard);
					Registry.oldCard.UnPressed();
					Registry.oldCard = null;
				} 
				
			}
			
			
		}
		private function isMatched():Boolean 
		{
			if (Registry.oldCard == null || Registry.oldCard.TargetCard == null)
			{
				return false;
			}
			if (Registry.oldCard == Registry.oldCard.TargetCard || 
				Registry.oldCard.id != Registry.oldCard.TargetCard.id) 
			{
				return false;
			}
			
			var x1:uint = Registry.oldCard.i;
			var y1:uint = Registry.oldCard.j;
			var x2:uint = Registry.oldCard.TargetCard.i;
			var y2:uint = Registry.oldCard.TargetCard.j;
			
			var node:Object = new Object();
			var tempPath:Array = new Array();
			
			for (var i:uint = 0; i < Colum + 2; i++) 
			{
				var count:uint = 0;
				tempPath.splice(0);
				
				var step:int = (y1 > i) ? -1 : 1;
				for (var j:uint = y1; j != i; j += step) 
				{
					count +=Registry.map[x1][j];
					node = {x:x1,y:j};
					tempPath.push(node);
				}

				step = (x1 > x2) ? -1 : 1;
				for (j = x1; j != x2; j += step) 
				{
					count +=Registry.map[j][i];
					node = {x:j,y:i};
					tempPath.push(node);
				}

				step = (i < y2) ? 1 : -1;
				for (j = i; j != y2; j += step) 
				{
					count +=Registry.map[x2][j];
					node = {x:x2,y:j};
					tempPath.push(node);
				}

				if (count == 1) 
				{
					if (Registry.oldCard.Path.length == 0 || tempPath.length < Registry.oldCard.Path.length) 
					{
						Registry.oldCard.Path = tempPath.slice();
					}
				}
			}

			for (i = 0; i < Row + 2; i++) 
			{
				count = 0;
				tempPath.splice(0);

				step = (i < x1) ? -1 : 1;
				for (j = x1; j != i; j += step) 
				{
					count +=Registry.map[j][y1];
					node = {x:j,y:y1};
					tempPath.push(node);
				}
				step = (y2 > y1) ? 1 : -1;
				for (j = y1; j != y2; j += step) 
				{
					count +=Registry.map[i][j];
					node = {x:i,y:j};
					tempPath.push(node);
				}
				step = (x2 > i) ? 1 : -1;
				for (j = i; j != x2; j += step) 
				{
					count +=Registry.map[j][y2];
					node = {x:j,y:y2};
					tempPath.push(node);
				}
				if (count == 1) {
					if (Registry.oldCard.Path.length == 0 || tempPath.length < Registry.oldCard.Path.length) 
					{
						Registry.oldCard.Path = tempPath.slice();
					}
				}
			}
			
			if (Registry.oldCard.Path.length > 0) 
			{
				node = {x:x1, y:y1};
				Registry.oldCard.Path.unshift(node);
				node = {x:x2, y:y2};
				Registry.oldCard.Path.push(node);
				return true;
			}
			return false;
		}
		
	}
}