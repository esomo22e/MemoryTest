package 
{
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import caurina.transitions.Tweener;

	public class MemoryGame extends MovieClip
	{
		private var cards:Vector.<Card > ;
		private var shuffleCards:Vector.<int > ;
		private var posX:Number;
		private var posY:Number;
		private var cardXML:XML;
		private var cardLoader:URLLoader;

		private var firstCard:Card;
		private var secondCard:Card;
		private var currentMatches:Number;
		private var totalMatches:Number;
		public var selectPair:Number;

		private var timer:Timer;
		private var resetButton:ResetButton;
		private var langButton:LangButton;
		private var instructText:TextField = new TextField();
		private var gameOverText:TextField = new TextField();
		private var matchText:TextField = new TextField();
		private var movesText:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		private var isEnglish:Boolean = true;
		private var messNumber:int;
		private var movesNum:int;
		
		public function MemoryGame()
		{


			resetButton = new ResetButton();
			resetButton.buttonMode = true;
			resetButton.mouseChildren = false;
			resetButton.addEventListener( MouseEvent.CLICK, clickReset);

			langButton = new LangButton();
			langButton.buttonMode = true;
			langButton.mouseChildren = false;
			langButton.addEventListener(MouseEvent.CLICK, clickLang);

			cardLoader = new URLLoader();
			cardLoader.load(new URLRequest("CardImageList.xml"));
			cardLoader.addEventListener(Event.COMPLETE, processXML);


			addEventListener( "cardClick" , checkCards);

			selectPair = 0;
			currentMatches = 0;
			totalMatches = 8;

		}

		public function processXML( evt :Event):void
		{
			cardXML = new XML(evt.target.data);

			createCards();
		}

		public function createCards()
		{
			cards = new Vector.<Card>();
			posX = -30;
			posY = -110;

			matches();

			displayMoves();
			movesText.text = "Number of Moves: 0";

			instructions();
			instructText.text = "The cards are randomly placed so with concentration and focus match all 16 cards. When all cards match, the game is over and you win!";

			var imageNum:int = cardXML.cardImages.*.length();
			for (var i:int = 0; i < imageNum; i++)
			{

				var card:Card;
				card = new Card();

				addChild(card);
				card.x = posX+(i%4)*(86);
				card.y = posY + Math.floor(i/4)*(86);

				cards.push(card);


			}

			randomCards();

			addChild(resetButton);
			resetButton.x = -185;
			resetButton.y = 140;

			addChild(langButton);
			langButton.x = -185;
			langButton.y = 90;
			trace("CM" + currentMatches);
			trace("TM" + totalMatches);
		}

		public function randomCards():void
		{
			shuffleCards = new Vector.<int>();
			shuffleCards.push(0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7);

			for (var i:int = 0; i < 16; i++)
			{
				var rand:int = int(Math.floor((16-i) * Math.random()) );
				var currentCard:int = Vector.<int > (shuffleCards.splice(rand,1))[0];
				cards[i].init(cardXML.cardImages.card[currentCard].@image, cardXML.cardImages.card[currentCard].@id);


			}
		}

		public function instructions():void
		{
			addChild(instructText);
			format.font = "Univers 55";
			format.size = 18;
			format.bold = false;
			instructText.defaultTextFormat = format;

			instructText.width = 200;
			instructText.height = 200;
			instructText.x = -280;
			instructText.y = -130;
			instructText.multiline = true;
			instructText.wordWrap = true;
		}

		public function displayMoves():void
		{
			addChild(movesText);
			format.font = "FS Sinclair";
			format.size = 20;
			format.bold = true;
			movesText.defaultTextFormat = format;

			movesText.width = 200;
			movesText.height = 100;
			movesText.x = -320;
			movesText.y = -180;
		}

		public function matches():void
		{
			addChild(matchText);
			format.font = "FS Sinclair";
			format.size = 22;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			matchText.defaultTextFormat = format;

			matchText.width = 180;
			matchText.height = 100;
			matchText.x = 5;
			matchText.y = -180;

		}


		public function checkCards( evt : Event ):void
		{


			if (firstCard == null)
			{
				firstCard = Card(evt.target);

			}
			else if ((secondCard == null) && (firstCard != Card(evt.target)))
			{

				secondCard = Card(evt.target);

				if (firstCard.id == secondCard.id)
				{
					selectPair++;
					
					firstCard.fadeOut();
					secondCard.fadeOut();

					movesText.text = cardXML.matchMessage.cardMessage[2].@english + selectPair;
					
					changeMessage(0);
					timer = new Timer(1000,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, sameTiles);
					timer.start();

					gameOver();
					trace("CM" + currentMatches);
					trace("TM" + totalMatches);

					

				}
				else
				{
					selectPair++;
					//movesText.text = "Number of Moves: " + selectPair;
					
					movesText.text = cardXML.matchMessage.cardMessage[2].@english + selectPair;

					
					changeMessage(1);
					
					timer = new Timer(1000,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, resetTiles);
					timer.start();

					

				}
			}


		}


		public function sameTiles( evt :TimerEvent)
		{

			firstCard.mouseEnabled = false;
			firstCard.mouseChildren = false;

			secondCard.mouseEnabled = false;
			secondCard.mouseChildren = false;

			

			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, sameTiles);

			firstCard = null;
			secondCard = null;

		}

		public function resetTiles( evt : TimerEvent)
		{
			firstCard.square.visible = true;
			secondCard.square.visible = true;

			firstCard.resetBack();
			secondCard.resetBack();

			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetTiles);

			firstCard = null;
			secondCard = null;
		}


		public function gameOver():void
		{
			currentMatches++;
			if (currentMatches >= totalMatches)
			{
				overText();
				gameOverText.text = "GAME OVER!!!";
				gameOverText.visible = true;

			}
		}

		public function overText():void
		{
			addChild(gameOverText);
			format.size = 30;
			format.bold = true;
			gameOverText.defaultTextFormat = format;

			gameOverText.width = 250;
			gameOverText.height = 200;
			gameOverText.x = -30;
			gameOverText.y = -10;


		}

		public function textLang():void
		{
			if (isEnglish)
			{
				gameOverText.text = "GAME OVER!!!";
				movesText.text = "Number of Moves: " + selectPair;
				instructText.text = "The cards are randomly placed so with concentration and focus match all 16 cards. When all cards matched, the game is over and you win!";
				resetButton.resetText.text = "RESET BUTTON";
				langButton.langText.text = "TURKISH";

			}
			else
			{


				gameOverText.text = "OYUN BITTI!!!";
				movesText.text = "Moves Sayısı: " + selectPair;
				instructText.text = "Tüm kartları maç, oyun bitti ve zaman konsantrasyon ve odaklanma maç 16 kartları kazanmak öylesine kartları rastgele yerleştirilir!";
				resetButton.resetText.text = "Sıfırlama Düğmesi";
				resetButton.resetText.multiline = true;
				resetButton.resetText.wordWrap = true;
				langButton.langText.text = "ENGLISH";


			}
		}

		public function changeMessage(mNumber:int = -1):void
		{
			if(mNumber >= 0)
			{
				messNumber = mNumber;
			}
			if(isEnglish)
			{
				matchText.text = cardXML.matchMessage.cardMessage[messNumber].@english ;
				
			}
			else
			{
				matchText.text = cardXML.matchMessage.cardMessage[messNumber].@turkish ;
				
			}
		}
		
		public function changeMoveText(movesNumber:int = -1):void
		{
			if(movesNumber >= 0)
			{
				movesNum = movesNumber;
			}
			if(isEnglish)
			{
				movesText.text = cardXML.matchMessage.cardMessage[2].@english + " " + selectPair;
				
			}
			else
			{
				movesText.text = cardXML.matchMessage.cardMessage[2].@turkish+ " " + selectPair;
				
			}
		}
		public function clickReset( evt : MouseEvent ):void
		{
			gameOverText.visible = false;

			matchText.text = " ";
			changeMessage(0);
			selectPair = 0;
			currentMatches = 0;

			movesText.text = "Number of Moves: " + selectPair;

			randomCards();

			for (var i:int = 0; i < 16; i++)
			{
				cards[i].square.visible = true;

				cards[i].fadeIn();
			}

		}

		public function clickLang( evt :MouseEvent ):void
		{
			isEnglish = ! isEnglish;
			trace("lang");
			textLang();
			changeMessage();
		}
	}
}