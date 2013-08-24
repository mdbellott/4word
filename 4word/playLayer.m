//
//  playLayer.m
//  4word
//
//  Created by Mark Bellott on 10/16/12.
//  Copyright 2012 Mark Bellott. All rights reserved.
//

#import "playLayer.h"


@implementation playLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	playLayer *layer = [playLayer node];
	
	[scene addChild: layer];
    
	return scene;
}

#pragma mark - Init Methods

- (id)init
{
    self = [super init];
    if (self) {
        
        srand(time(NULL));
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        //Initial Allocations
        keyboardTiles = [[NSMutableArray alloc]init];
        wordTiles = [[NSMutableArray alloc]init];
        usedTiles = [[NSMutableArray alloc]init];
        replacementTiles = [[NSMutableArray alloc]init];
        playWord = [[NSMutableString alloc]init];
        lives = [[NSMutableArray alloc]init];
        powerups = [[NSMutableArray alloc]init];
        saveWord = [[NSMutableString alloc]init];
        bestWord = [[NSMutableString alloc]init];
        
        //Load methods
        [self setUpDictionaries];
        [self loadPositions];
        [self loadImages];
        [self loadKeyboardButtons];
        [self loadBars];
        [self loadBlanks];
        [self loadCounter];
        [self loadLives];
        [self loadPause];
        [self loadScoreItems];
        [self loadLetters];
        [self loadKeyboad];
        [self loadFirstLetter];
        
        //Animate Methods
        [self animateLives];
        [self animateBars];
        [self animateKeyboardButtons];
        [self animateInitialKeyboard];
        [self animateFirstLetter];
        [self updateWordBlanks];
        
        //Initial Variables
        currentLength = THREE;
        wCounter = 0; progressCounter = 0;
        currentTimer = 30;
        wordIsBlank = NO;
        keepFlicker = YES;
        gamePaused = NO;
        allowTouches = NO;
        bestWordScore = 0;
        allowPowerUps = YES;
        //Powerup Test
        //[self powerUpTest];
        
        [self schedule:@selector(tick:) interval:1];
        [self runTimerWithTime:currentTimer];
        [self scheduleUpdate];
        self.isTouchEnabled = YES;
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.2], [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)], nil]];
    
    }
    return self;
}

-(void) setUpDictionaries{
    wordListThree = [[NSArray alloc]initWithArray: [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4W_ThreeWordList" ofType:@"txt"] encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];
    wordListFour = [[NSArray alloc]initWithArray: [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4W_FourWordList" ofType:@"txt"] encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];
    wordListFive = [[NSArray alloc]initWithArray: [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4W_FiveWordList" ofType:@"txt"] encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];
    wordListSix = [[NSArray alloc]initWithArray: [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4W_SixWordList" ofType:@"txt"] encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];
    
}

-(void) loadPositions{
    
    CGFloat tmpX = winSize.width/2, tmpY = winSize.height/2 + winSize.height/5;

    //Keyboard Positions
    kpos01 = ccp(tmpX-125,175); kpos02 = ccp(tmpX-75,175); kpos03 = ccp(tmpX-25,175);
    kpos04 = ccp(tmpX+25, 175); kpos05 = ccp(tmpX+75,175); kpos06 = ccp(tmpX+125,175);
    
    
    kpos07 = ccp(tmpX-125,125); kpos08 = ccp(tmpX-75,125); kpos09 = ccp(tmpX-25,125);
    kpos10 = ccp(tmpX+25,125); kpos11 = ccp(tmpX+75,125); kpos12 = ccp(tmpX+125,125);
    
    kpos13 = ccp(tmpX-75,75); kpos14 = ccp(tmpX-25,75); kpos15 = ccp(tmpX+25,75); kpos16 = ccp(tmpX+75,75);
    
    kpos17 = ccp(tmpX-75,25); kpos18 = ccp(tmpX-25,25); kpos19 = ccp(tmpX+25,25); kpos20 = ccp(tmpX+75,25);
    
    //Pay Word Positions
    pos31 = ccp(tmpX-50,tmpY); pos32 = ccp(tmpX,tmpY); pos33 = ccp(tmpX+50,tmpY);
    
    pos41 = ccp(tmpX-75,tmpY); pos42 = ccp(tmpX-25,tmpY);
    pos43 = ccp(tmpX+25,tmpY); pos44 = ccp(tmpX+75,tmpY);
    
    pos51 = ccp(tmpX-100,tmpY); pos52 = ccp(tmpX-50,tmpY); pos53 = ccp(tmpX,tmpY);
    pos54 = ccp(tmpX+50,tmpY); pos55 = ccp(tmpX+100,tmpY);
    
    pos61 = ccp(tmpX-125,tmpY); pos62 = ccp(tmpX-75,tmpY); pos63 = ccp(tmpX-25,tmpY);
    pos64 = ccp(tmpX+25,tmpY); pos65 = ccp(tmpX+75,tmpY); pos66 = ccp(tmpX+125,tmpY);
    
    initialTilePos = ccp(tmpX + 200, tmpY);
    
    //Powerup Positions
    powerPos01 = ccp(winSize.width/2 - 75,270); powerPos02 = ccp(winSize.width/2 - 25,270);
    powerPos03 = ccp(winSize.width/2 + 25,270); powerPos04 = ccp(winSize.width/2 + 75,270);
    
    //Multiplier Positions
    multiPosOn = ccp(18, winSize.height-18);
    multiPosOff = ccp(-50, winSize.height-18);
    
    //Life Dismiss Positions
    lifeDismiss = ccp(winSize.width/2, winSize.height - 60);
    
}

-(void) loadImages{
    backgroundBlue = [[CCTextureCache sharedTextureCache] addImage:@"4WBackground2.png"];
    backgroundRed = [[CCTextureCache sharedTextureCache] addImage:@"4WBackground2Red.png"];
    
    backgroundSprite = [[CCSprite alloc] initWithTexture:backgroundBlue];
    backgroundSprite.position = ccp(160, winSize.height/2);
    [self addChild:backgroundSprite];
}

-(void) loadMultipliers{
    multOne = [[CCSprite alloc] init];
    multOne = [CCSprite spriteWithFile:@"4WMultiplierOne.png"];
    multOne.position = multiPosOff;
    [self addChild:multOne];
    
    multTwo = [[CCSprite alloc] init];
    multTwo = [CCSprite spriteWithFile:@"4WMultiplierTwo.png"];
    multTwo.position = multiPosOff;
    [self addChild:multTwo];
    
    multThree = [[CCSprite alloc] init];
    multThree = [CCSprite spriteWithFile:@"4WMultiplierThree.png"];
    multThree.position = multiPosOff;
    [self addChild:multThree];
    
    multFour = [[CCSprite alloc] init];
    multFour = [CCSprite spriteWithFile:@"4WMultiplierFour.png"];
    multFour.position = multiPosOff;
    [self addChild:multFour];
}

-(void) loadBars{

    //Load Top Bar
    topBar = [[CCSprite alloc] init];
    topBar = [CCSprite spriteWithFile:@"4WTopBar.png"];
    topBar.position = ccp(winSize.width/2, winSize.height+12.5);
    [self addChild:topBar];
    
    [self loadMultipliers];
    
    //Load Timer Bar
    timerBlue = [[CCTextureCache sharedTextureCache] addImage:@"4WTimerBar.png"];
    timerRed = [[CCTextureCache sharedTextureCache] addImage:@"4WTimerBarRed.png"];
    
    timerBar = [[CCSprite alloc]initWithTexture:timerBlue];
    timerBar.position = ccp(-winSize.width/2, 223);
    [self addChild:timerBar];
}

-(void) loadBlanks{
    pBlank01 = [[CCSprite alloc] initWithFile:@"4WPowerupBlank.png"];
    pBlank01.position = powerPos01;
    [self addChild:pBlank01];
    
    pBlank02 = [[CCSprite alloc] initWithFile:@"4WPowerupBlank.png"];
    pBlank02.position = powerPos02;
    [self addChild:pBlank02];
    
    pBlank03 = [[CCSprite alloc] initWithFile:@"4WPowerupBlank.png"];
    pBlank03.position = powerPos03;
    [self addChild:pBlank03];
    
    pBlank04 = [[CCSprite alloc] initWithFile:@"4WPowerupBlank.png"];
    pBlank04.position = powerPos04;
    [self addChild:pBlank04];
    
    tBlank01 = [[CCSprite alloc] initWithFile:@"4WTileBlank.png"];
    tBlank01.position = initialTilePos;
    [self addChild:tBlank01];
    
    tBlank02 = [[CCSprite alloc] initWithFile:@"4WTileBlank.png"];
    tBlank02.position = initialTilePos;
    [self addChild:tBlank02];
    
    tBlank03 = [[CCSprite alloc] initWithFile:@"4WTileBlank.png"];
    tBlank03.position = initialTilePos;
    [self addChild:tBlank03];
    
    tBlank03 = [[CCSprite alloc] initWithFile:@"4WTileBlank.png"];
    tBlank03.position = initialTilePos;
    [self addChild:tBlank03];
    
    tBlank04 = [[CCSprite alloc] initWithFile:@"4WTileBlank.png"];
    tBlank04.position = initialTilePos;
    [self addChild:tBlank04];
    
    tBlank05 = [[CCSprite alloc] initWithFile:@"4WTileBlank.png"];
    tBlank05.position = initialTilePos;
    [self addChild:tBlank05];
    
    tBlank06 = [[CCSprite alloc] initWithFile:@"4WTileBlank.png"];
    tBlank06.position = initialTilePos;
    [self addChild:tBlank06];
    
    
}

-(void) loadLives{
    
    lifeOne = [[CCSprite alloc] init];
    lifeTwo = [[CCSprite alloc] init];
    lifeThree = [[CCSprite alloc] init];
    lifeFour = [[CCSprite alloc] init];
    
    //Draw One
    lifeOne = [CCSprite spriteWithFile: @"4WLife.png"];
    lifeOne.position = ccp(148,winSize.height+12.5);
    [lives addObject:lifeOne];
    [self addChild:lifeOne];
    
    //Draw Two
    lifeTwo = [CCSprite spriteWithFile: @"4WLife.png"];
    lifeTwo.position = ccp(173,winSize.height+12.5);
    [lives addObject:lifeTwo];
    [self addChild:lifeTwo];
    
    //Draw Three
    lifeThree = [CCSprite spriteWithFile: @"4WLife.png"];
    lifeThree.position = ccp(198,winSize.height+12.5);
    [lives addObject:lifeThree];
    [self addChild:lifeThree];
    
    //Draw Four
    lifeFour = [CCSprite spriteWithFile: @"4WLife.png"];
    lifeFour.position = ccp(222.5,winSize.height+12.5);
    [lives addObject:lifeFour];
    [self addChild:lifeFour];
    
}

-(void) loadKeyboardButtons{
    
    keyboardBackground = [[CCSprite alloc] init];
    keyboardBackground = [CCSprite spriteWithFile:@"4WKeyboardBackground.png"];
    keyboardBackground.position = ccp(winSize.width/2,-195);
    [self addChild:keyboardBackground];
    
    backspaceButton = [CCMenuItemImage itemWithNormalImage:@"4WBackspaceNormal.png" selectedImage:@"4WBackspaceSelect.png" target:self selector:@selector(backspacePressed)];
    
    shuffleButton = [CCMenuItemImage itemWithNormalImage:@"4WShuffleNormal.png" selectedImage:@"4WShuffleSelect.png" target:self selector:@selector(shufflePressed)];
    
    keyboardButtonMenu = [CCMenu menuWithItems:shuffleButton, backspaceButton, nil];
    keyboardButtonMenu.position = ccp((winSize.width/2), -252);
    [keyboardButtonMenu alignItemsHorizontallyWithPadding:220];
    [self addChild:keyboardButtonMenu];
}

-(void) loadScoreItems{
    
    scoreDictionaryTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:4];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:scoreDictionaryTag]];
    
    if([tmpHighScores objectForKey:@"forwardScoreOne"] == nil){
        scoreOne = -1;
    }
    else{
        scoreOne = [[tmpHighScores objectForKey:@"forwardScoreOne"] integerValue];
    }
    
    score = 0; multiplier = 1;
    scoreString = [NSString stringWithFormat:@"%d",score];
    
    currentScore = [CCLabelTTF labelWithString:scoreString fontName:@"Code Pro Demo" fontSize:24];
    currentScore.color = ccc3(232,98,81);
    currentScore.position = ccp(90, winSize.height + 27);
    [self addChild: currentScore];
}

-(void) loadLetters{
    keyboardLetters = [[NSMutableArray alloc]init];
    usedLetters = [[NSMutableArray alloc]init];
    letterBank = [[NSMutableArray alloc]init];
    vowelBank = [[NSMutableArray alloc]init];
    firstBank = [[NSMutableArray alloc]init];
    consonantBank = [[NSMutableArray alloc]init];
    
    tmpArray = [NSMutableArray arrayWithObjects:@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"e",@"e",@"e",@"e",@"i",@"i",@"i",@"i",@"i",@"o",@"o",@"o",@"o",@"o",@"o",@"u",@"u",@"u",@"u",@"b",@"b",@"c",@"c",@"d",@"d",@"d",@"d",@"f",@"f",@"g",@"g",@"h",@"h",@"h",@"h",@"h",@"j",@"k",@"l",@"l",@"l",@"l",@"m",@"m",@"m",@"m",@"n",@"n",@"n",@"n",@"p",@"p",@"q",@"r",@"r",@"r",@"r",@"r",@"r",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"v",@"v",@"w",@"w",@"w",@"w",@"w",@"w",@"x",@"y",@"y",@"y",@"z", nil];
    [letterBank addObjectsFromArray:tmpArray];
    [tmpArray removeAllObjects];
    
    tmpArray = [NSMutableArray arrayWithObjects:@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"e",@"e",@"e",@"e",@"i",@"i",@"i",@"i",@"i",@"o",@"o",@"o",@"o",@"o",@"o",@"u",@"u",@"u",@"u",nil];
    [vowelBank addObjectsFromArray:tmpArray];
    [tmpArray removeAllObjects];
    
    tmpArray = [NSMutableArray arrayWithObjects:@"b",@"b",@"c",@"c",@"d",@"d",@"d",@"d",@"f",@"f",@"g",@"g",@"h",@"h",@"h",@"h",@"h",@"j",@"k",@"l",@"l",@"l",@"l",@"m",@"m",@"m",@"m",@"n",@"n",@"n",@"n",@"p",@"p",@"q",@"r",@"r",@"r",@"r",@"r",@"r",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"s",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"t",@"v",@"v",@"w",@"w",@"w",@"w",@"w",@"w",@"x",@"y",@"y",@"y",@"z", nil];
    [consonantBank addObjectsFromArray:tmpArray];
    
    tmpArray = [NSMutableArray arrayWithObjects:@"b",@"c",@"d",@"f",@"h",@"l",@"m",@"n",@"p",@"s",@"t",@"w", nil];
    [firstBank addObjectsFromArray:tmpArray];
    
    [tmpArray removeAllObjects];
    
}

-(void) loadKeyboad{
    NSInteger i,j,x;
    NSNumber *jNum;
    
    tOverseer = [[overseer alloc]init];
    tOverseer.vowelCounter = 0;
    [self addChild:tOverseer];
    
    if([usedLetters count] > 75){
        [usedLetters removeAllObjects];
    }
    
    for(i=0; i<16; i++){
        j = rand() % [letterBank count];
        jNum = [NSNumber numberWithInt:j];
        if(![usedLetters containsObject:jNum]){
            if(0<=j && j<=26){
                tOverseer.vowelCounter++;
            }
            [keyboardLetters addObject:[letterBank objectAtIndex:j]];
            [usedLetters addObject:jNum];
        }
        else{
            i--;
        }
    }
    for(i=16; i<20; i++){
        if(tOverseer.vowelCounter < 4){
            j = rand() % [vowelBank count];
            [keyboardLetters addObject:[vowelBank objectAtIndex:j]];
            tOverseer.vowelCounter++;
        }
        else{
            j = rand() % [letterBank count];
            jNum = [NSNumber numberWithInt:j];
            if(![usedLetters containsObject:jNum]){
                if(0<=j && j<=26){
                    tOverseer.vowelCounter++;
                }
                [keyboardLetters addObject:[letterBank objectAtIndex:j]];
                [usedLetters addObject:jNum];
            }
            else{
                i--;
            }
        }
    }
    
    for(x=0; x<20; x++){
        tile *t = [self makeTile:keyboardLetters[x]];
        t.position = ccp(winSize.width/2,-50);
        t.oIndex = [NSNumber numberWithInt:x];
        
        if(x == 0) t.oPos = kpos01;
        else if(x == 1) t.oPos = kpos02;
        else if(x == 2) t.oPos = kpos03;
        else if(x == 3) t.oPos = kpos04;
        else if(x == 4) t.oPos = kpos05;
        else if(x == 5) t.oPos = kpos06;
        else if(x == 6) t.oPos = kpos07;
        else if(x == 7) t.oPos = kpos08;
        else if(x == 8) t.oPos = kpos09;
        else if(x == 9) t.oPos = kpos10;
        else if(x == 10) t.oPos = kpos11;
        else if(x == 11) t.oPos = kpos12;
        else if(x == 12) t.oPos = kpos13;
        else if(x == 13) t.oPos = kpos14;
        else if(x == 14) t.oPos = kpos15;
        else if(x == 15) t.oPos = kpos16;
        else if(x == 16) t.oPos = kpos17;
        else if(x == 17) t.oPos = kpos18;
        else if(x == 18) t.oPos = kpos19;
        else if(x == 19) t.oPos = kpos20;
        
        
        [self addChild:t];
        [keyboardTiles addObject:t];
    }
}

-(void) loadFirstLetter{
    NSInteger j;
    
    j=rand()%[firstBank count];
    tileFirst = [self makeTile:firstBank[j]];
    tileFirst.position = ccp(360,winSize.height/2 + winSize.height/6);
   
    if(currentLength == THREE) tileFirst.wPos = pos31;
    else if(currentLength == FOUR) tileFirst.wPos = pos41;
    else if(currentLength == FIVE) tileFirst.wPos = pos51;
    else if(currentLength == SIX) tileFirst.wPos = pos61;
    
    [wordTiles addObject:tileFirst];
    [self addChild:tileFirst];
    [playWord appendString:tileFirst.letter];
    
    letterCount = 1; 
}

-(void) loadFirstWithPrevious:(NSString*)f{
    NSInteger j;
    BOOL sameAsPrevious = YES;
    
    while (sameAsPrevious) {
        j=rand()%[firstBank count];
        tileFirst = [self makeTile:firstBank[j]];
        if(tileFirst.letter != f){
            sameAsPrevious = NO;
        }
    }
    
    tileFirst.position = ccp(360,winSize.height/2 + winSize.height/6);
    
    if(currentLength == THREE) tileFirst.wPos = pos31;
    else if(currentLength == FOUR) tileFirst.wPos = pos41;
    else if(currentLength == FIVE) tileFirst.wPos = pos51;
    else if(currentLength == SIX) tileFirst.wPos = pos61;
    
    [wordTiles addObject:tileFirst];
    [self addChild:tileFirst];
    [playWord appendString:tileFirst.letter];
    
    letterCount = 1;
}

#pragma mark - Background Methods

-(void) setBackgroundBlue{
    [backgroundSprite setTexture:backgroundBlue];
}

-(void) setBackgroundRed{
    [backgroundSprite setTexture:backgroundRed];
}

-(void) flickerBackground{
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:.05],
                     [CCCallFunc actionWithTarget:self selector:@selector(setBackgroundRed)],
                     [CCDelayTime actionWithDuration:.05],
                     [CCCallFunc actionWithTarget:self selector:@selector(setBackgroundBlue)],
                     [CCDelayTime actionWithDuration:.05],
                     [CCCallFunc actionWithTarget:self selector:@selector(setBackgroundRed)],
                     [CCDelayTime actionWithDuration:.05],
                     [CCCallFunc actionWithTarget:self selector:@selector(setBackgroundBlue)],
                     [CCDelayTime actionWithDuration:.05],
                     [CCCallFunc actionWithTarget:self selector:@selector(setBackgroundRed)],
                     nil]];
}

#pragma mark - Counter Methods

-(void) loadCounter{
    counterBlank = [[CCSprite alloc] initWithFile:@"4WWordCountBlanks.png"];
    counterBlank.position = ccp(winSize.width/2, winSize.height/2 + winSize.height/3);
    [self addChild:counterBlank];
    
    counterOne = [[CCSprite alloc] initWithFile:@"4WWordCountCircle.png"];
    counterOne.position = ccp(winSize.width/2 - 22.5,winSize.height/2 + winSize.height/3);
    [self addChild:counterOne];
    
    counterTwo = [[CCSprite alloc] initWithFile:@"4WWordCountCircle.png"];
    counterTwo.position = ccp(winSize.width/2 - 7.5,winSize.height/2 + winSize.height/3);
    [self addChild:counterTwo];
    
    counterThree = [[CCSprite alloc] initWithFile:@"4WWordCountCircle.png"];
    counterThree.position = ccp(winSize.width/2 + 7.5,winSize.height/2 + winSize.height/3);
    [self addChild:counterThree];
    
    counterFour = [[CCSprite alloc] initWithFile:@"4WWordCountCircle.png"];
    counterFour.position = ccp(winSize.width/2 + 22.5,winSize.height/2 + winSize.height/3);
    [self addChild:counterFour];
    
    counterOne.visible = NO;
    counterTwo.visible = NO;
    counterThree.visible = NO;
    counterFour.visible = NO;
}

-(void) updateCounter{
    
    if(wCounter == 1){
        counterOne.visible = YES;
        counterTwo.visible = NO;
        counterThree.visible = NO;
        counterFour.visible = NO;
    }
    else if(wCounter == 2){
        counterOne.visible = YES;
        counterTwo.visible = YES;
        counterThree.visible = NO;
        counterFour.visible = NO;
    }
    else if(wCounter == 3){
        counterOne.visible = YES;
        counterTwo.visible = YES;
        counterThree.visible = YES;
        counterFour.visible = NO;
    }
    else if(wCounter == 4){
        counterOne.visible = YES;
        counterTwo.visible = YES;
        counterThree.visible = YES;
        counterFour.visible = YES;
    }
    
}

-(void) resetCounter{
    counterOne.visible = NO;
    counterTwo.visible = NO;
    counterThree.visible = NO;
    counterFour.visible = NO;
}

#pragma mark - Animation Methods

-(void) animateLives{
    
    id oneIn = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.25 position:ccp(148,winSize.height-17.5)],nil];
    id twoIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.25 position:ccp(173,winSize.height-17.5)],nil];
    id threeIn = [CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCMoveTo actionWithDuration:.25 position:ccp(198,winSize.height-17.5)],nil];
    id fourIn = [CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCMoveTo actionWithDuration:.25 position:ccp(222.5,winSize.height-17.5)],nil];
    
    [lifeOne runAction:oneIn];
    [lifeTwo runAction:twoIn];
    [lifeThree runAction:threeIn];
    [lifeFour runAction:fourIn];
    
}

-(void) animateBars{
    
    //Animate Timer
    id timerIn = [CCSequence actions:[CCDelayTime actionWithDuration:.25],[CCMoveTo actionWithDuration:.1 position:ccp(winSize.width/2, 223)],nil];
    [timerBar runAction:timerIn];
    
    //Animate Top Bar
    [topBar runAction:[CCMoveTo actionWithDuration:.1 position:ccp(winSize.width/2, winSize.height-18)]];
    
    //Animate Score with Bar
    [currentScore runAction:[CCMoveTo actionWithDuration:.25 position:ccp(90, winSize.height-27)]];
}

-(void) animateKeyboardButtons{
    id keyBackIn = [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2,105)];
    id keyMenuIn = [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2, 48)];
    
    [keyboardBackground runAction:keyBackIn];
    [keyboardButtonMenu runAction:keyMenuIn];
}

-(void) animateInitialKeyboard{
    ccTime tmpTime = 0.2;
    
    for(tile *t in keyboardTiles){
        [t runAction:[CCSequence actions:[CCDelayTime actionWithDuration:tmpTime],[CCMoveTo actionWithDuration:.05 position: t.oPos], nil]];
        tmpTime += 0.05;
    }
}

-(void) animatePowerupKeyboard{
    ccTime tmpTime = .2;
    
    for(tile *t in keyboardTiles){
        [t runAction:[CCSequence actions:[CCDelayTime actionWithDuration:tmpTime],[CCMoveTo actionWithDuration:.05 position: t.oPos], nil]];
    }
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.25],[CCCallFunc actionWithTarget:self selector:@selector(arrayCleanup)],nil]];
}

-(void) animateReplaceKeyboard{
    ccTime tmpTime = 0.0;
    
    for(tile *t in replacementTiles){
        [t runAction:[CCSequence actions:[CCDelayTime actionWithDuration:tmpTime],[CCMoveTo actionWithDuration:.05 position: t.oPos], nil]];
        tmpTime += 0.05;
    }
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:tmpTime],[CCCallFunc actionWithTarget:self selector:@selector(arrayCleanup)],nil]];
}

-(void) animateFirstLetter{
    if(currentLength == THREE){
        [tileFirst runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6],[CCMoveTo actionWithDuration:.05 position:pos31], nil]];
    }
    else if(currentLength == FOUR){
        [tileFirst runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6],[CCMoveTo actionWithDuration:.05 position:pos41], nil]];
    }
    else if(currentLength == FIVE){
        [tileFirst runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6],[CCMoveTo actionWithDuration:.05 position:pos51], nil]];
    }
    else if(currentLength == SIX){
        [tileFirst runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6],[CCMoveTo actionWithDuration:.05 position:pos61], nil]];
    }
}

-(void) animateInvalidWord{
    
    for(tile *t in wordTiles){
        [t runAction:[CCSequence actions:
                      [CCMoveTo actionWithDuration:.05 position:ccp(t.position.x+5, t.position.y)],
                      [CCMoveTo actionWithDuration:.05 position:ccp(t.position.x-10, t.position.y)],
                      [CCMoveTo actionWithDuration:.05 position:ccp(t.position.x+10, t.position.y)],
                      [CCMoveTo actionWithDuration:.05 position:ccp(t.position.x-10, t.position.y)],
                      [CCMoveTo actionWithDuration:.05 position:t.wPos],
                      nil]];
    }
}

-(void) animateLifeLost{
    [self disableTouch];
    
    [self flickerBackground];
    
    id lifeDown;
    
    if(lives.count == 4){
        lifeDown =[CCSequence actions:[CCMoveTo actionWithDuration:.3 position:lifeDismiss],
                   [CCDelayTime actionWithDuration:.6],
                   [CCMoveTo actionWithDuration:.2 position:ccp(-400, winSize.height-60)],nil];
        [lifeFour runAction:lifeDown];
    }
    else if (lives.count == 3){
        lifeDown =[CCSequence actions:[CCMoveTo actionWithDuration:.3 position:lifeDismiss],
                   [CCDelayTime actionWithDuration:.6],
                   [CCMoveTo actionWithDuration:.2 position:ccp(-400, winSize.height-60)],nil];
        [lifeThree runAction:lifeDown];
    }
    else if (lives.count == 2){
        lifeDown =[CCSequence actions:[CCMoveTo actionWithDuration:.3 position:lifeDismiss],
                   [CCDelayTime actionWithDuration:.6],
                   [CCMoveTo actionWithDuration:.2 position:ccp(-400, winSize.height-60)],nil];
        [lifeTwo runAction:lifeDown];
    }
    else if (lives.count == 1){
        lifeDown =[CCSequence actions:[CCMoveTo actionWithDuration:.3 position:lifeDismiss],
                   [CCDelayTime actionWithDuration:.6],
                   [CCMoveTo actionWithDuration:.2 position:ccp(-400, winSize.height-60)],nil];
        [lifeOne runAction:lifeDown];
    }
    
    ccTime increment = 0.75;
    for(tile *t in wordTiles){
        [t runAction:[CCSequence actions:[CCDelayTime actionWithDuration:increment],
                      [CCMoveTo actionWithDuration:.2 position:ccp(-400, winSize.height/2 + winSize.height/5)],nil]];
        increment += .05;
    }
    
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.25],
                 [CCCallFunc actionWithTarget:self selector:@selector(loseLife)],nil]];
}

#pragma mark - Pause Methods

-(void) loadPause{
    pauseButton = [CCMenuItemImage itemWithNormalImage:@"4WPauseButtonNormal.png" selectedImage:@"4WPauseButtonSelect.png"
                                                 target:self selector:@selector(pausePressed)];
    
    pauseMenu = [CCMenu menuWithItems:pauseButton, nil];
    pauseMenu.position = ccp(275.5,winSize.height+17.5);
    [pauseMenu alignItemsVertically];
    [self addChild:pauseMenu];
    
    id pauseIn = [CCSequence actions:[CCDelayTime actionWithDuration:.5],
                  [CCMoveTo actionWithDuration:.25 position:ccp(275.5,winSize.height-17.5)],nil];
    [pauseMenu runAction:pauseIn];
} 
                    
-(void) pausePressed{
    if(!allowTouches){
        return;
    }
    if(gamePaused){
        return;
    }
    
    gamePaused = YES;
    [pauseButton setIsEnabled:NO];
    [timerBar stopAllActions];
    [self loadGamePaused];
}

-(void) loadGamePaused{
    gamePausedSprite = [[CCSprite alloc] initWithFile:@"4WPausedScreen.png"];
    gamePausedSprite.position = ccp(winSize.width/2 + 480, winSize.height/2);
    [self addChild:gamePausedSprite];
    
    id pauseScreenIn = [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2, winSize.height/2)];
    
    [gamePausedSprite runAction:pauseScreenIn];
    
    resumeButton = [CCMenuItemImage itemWithNormalImage:@"4WResumeButtonNormal.png" selectedImage:@"4WResumeButtonSelect.png" target:self selector:@selector(pausedResumePressed)];
    menuButton = [CCMenuItemImage itemWithNormalImage:@"4WMenuButtonNormal.png" selectedImage:@"4WMenuButtonSelect.png" target:self selector:@selector(pausedMenuPressed)];

    gamePausedMenu = [CCMenu menuWithItems:resumeButton, menuButton, nil];
    gamePausedMenu.position = ccp(winSize.width/2, 90);
    [gamePausedMenu alignItemsVerticallyWithPadding:15];
    [self addChild:gamePausedMenu];
    
    resumeButton.position = ccp(480,resumeButton.position.y);
    menuButton.position = ccp(480,menuButton.position.y);
    
    id resumeIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(0,resumeButton.position.y)],nil];
    id menuIn = [CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCMoveTo actionWithDuration:.2 position:ccp(0,menuButton.position.y)],nil];
    
    [resumeButton runAction:resumeIn];
    [menuButton runAction:menuIn];
    
    if(scoreOne == -1){
        bestScoreString = @"0";
    }
    else{
        bestScoreString = [NSString stringWithFormat:@"%d",scoreOne];
    }
    
    currentScoreString = [NSString stringWithFormat:@"%d", score];
    
    currentScoreLabel = [[CCLabelTTF alloc]initWithString:currentScoreString fontName:@"Code Pro Demo" fontSize:28];
    currentScoreLabel.color = ccc3(63,97,111);
    currentScoreLabel.position = ccp(winSize.width/2 + 50,winSize.height/2 - 7);
    currentScoreLabel.visible = NO;
    [self addChild:currentScoreLabel];
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCShow action],nil]];
    
    bestScoreLabel = [[CCLabelTTF alloc]initWithString:bestScoreString fontName:@"Code Pro Demo" fontSize:28];
    bestScoreLabel.color = ccc3(63,97,111);
    bestScoreLabel.position = ccp(winSize.width/2 + 50,winSize.height/2 - 62);
    bestScoreLabel.visible = NO;
    [self addChild:bestScoreLabel];
    [bestScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCShow action],nil]];
    
    
}

-(void) loadGameResumed{
    pauseButton.isEnabled = YES;
    
    id resumeOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,resumeButton.position.y)],nil];
    id menuOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(-480,menuButton.position.y)],nil];
    
    [resumeButton runAction:resumeOut];
    [menuButton runAction:menuOut];
    
    id pauseScreenOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                         [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2 - 480, winSize.height/2)], nil];
    [gamePausedSprite runAction:pauseScreenOut];
    
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
}

-(void) pausedMenuPressed{
    gamePaused = NO;
    [self dismissPauseScreenToMenu];
}

-(void) pausedResumePressed{
    gamePaused = NO;
    [self loadGameResumed];
    [self runTimerWithTime:timerValue];
}

-(void) dismissPauseScreenToMenu{
    [self handleNewScore];
    [self hideEverythingForDismiss];
    
    id resumeOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(-480,resumeButton.position.y)],nil];
    id menuOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,menuButton.position.y)],nil];
    
    [resumeButton runAction:resumeOut];
    [menuButton runAction:menuOut];
    
    id pauseScreenOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                         [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2 - 480, winSize.height/2)], nil];
    [gamePausedSprite runAction:pauseScreenOut];
    
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.7],
                     [CCCallFunc actionWithTarget:self selector:@selector(returnToMainMenu)],nil]];
}

#pragma mark - Input Handling Methds

-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if(!allowTouches){
        return;
    }
    
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    if(!gamePaused){
        tile *t = [self getKeyboardTileAtPoint:location];
        if(t != nil){
            [self handleKeyboardTile:t];
        }
        else{
            t = [self getWordTileAtPoint:location];
            if(t != nil){
                [self handdleWordTile:t];
            }
        }
    
        powerup *p = [self getPowerupAtPoint:location];
        if(p != nil){
            if(!allowPowerUps) return;
            [self handlePowerup:p];
        }
    }
}

-(tile*) getKeyboardTileAtPoint:(CGPoint)p{
    CGRect touchRect = CGRectMake(p.x, p.y, 1, 1);
    
    for (tile *t in keyboardTiles) {
        if(CGRectIntersectsRect(touchRect, t.boundingBox)){
            if(![wordTiles containsObject:t]){
                return t;
            }
            
        }
    }
    
    return nil;
}

-(tile*) getWordTileAtPoint:(CGPoint)p{
    CGRect touchRect = CGRectMake(p.x, p.y, 1, 1);
    
    for (tile *t in wordTiles) {
        if(CGRectIntersectsRect(touchRect, t.boundingBox)){
            return t;
        }
    }
    
    return nil;
}

-(powerup*) getPowerupAtPoint:(CGPoint)p{
    CGRect touchRect = CGRectMake(p.x, p.y, 1, 1);
    
    for(powerup *p in powerups){
        if(CGRectIntersectsRect(touchRect, p.boundingBox)){
            return p;
        }
    }
    
    return nil;
}

#pragma mark - Tile Methods

-(tile*) makeTile:(NSString *)letterIn{
    tile *tmpTile;
    NSString *fileName, *tileLetter;
    NSInteger tilePoints;
    CCTexture2D *tmpTex;
    CGRect tmpRect = CGRectMake(0, 0, 45, 45);
    
    if([letterIn isEqualToString:@"a"]){
        fileName = @"4wtA.png";
        tileLetter = @"A";
        tilePoints = 15;
    }
    else if ([letterIn isEqualToString:@"b"]){
        fileName = @"4wtB.png";
        tileLetter = @"B";
        tilePoints = 40;
    }
    else if ([letterIn isEqualToString:@"c"]){
        fileName = @"4wtC.png";
        tileLetter = @"C";
        tilePoints = 40;
    }
    else if ([letterIn isEqualToString:@"d"]){
        fileName = @"4wtD.png";
        tileLetter = @"D";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"e"]){
        fileName = @"4wtE.png";
        tileLetter = @"E";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"f"]){
        fileName = @"4wtF.png";
        tileLetter = @"F";
        tilePoints = 40;
    }
    else if ([letterIn isEqualToString:@"g"]){
        fileName = @"4wtG.png";
        tileLetter = @"G";
        tilePoints = 40;
    }
    else if ([letterIn isEqualToString:@"h"]){
        fileName = @"4wtH.png";
        tileLetter = @"H";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"i"]){
        fileName = @"4wtI.png";
        tileLetter = @"I";
        tilePoints = 30;
    }
    else if ([letterIn isEqualToString:@"j"]){
        fileName = @"4wtJ.png";
        tileLetter = @"J";
        tilePoints = 50;
    }
    else if ([letterIn isEqualToString:@"k"]){
        fileName = @"4wtK.png";
        tileLetter = @"K";
        tilePoints = 50;
    }
    else if ([letterIn isEqualToString:@"l"]){
        fileName = @"4wtL.png";
        tileLetter = @"L";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"m"]){
        fileName = @"4wtM.png";
        tileLetter = @"M";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"n"]){
        fileName = @"4wtN.png";
        tileLetter = @"N";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"o"]){
        fileName = @"4wtO.png";
        tileLetter = @"O";
        tilePoints = 25;
    }
    else if ([letterIn isEqualToString:@"p"]){
        fileName = @"4wtP.png";
        tileLetter = @"P";
        tilePoints = 40;
    }
    else if ([letterIn isEqualToString:@"q"]){
        fileName = @"4wtQ.png";
        tileLetter = @"Q";
        tilePoints = 50;
    }
    else if ([letterIn isEqualToString:@"r"]){
        fileName = @"4wtR.png";
        tileLetter = @"R";
        tilePoints = 25;
    }
    else if ([letterIn isEqualToString:@"s"]){
        fileName = @"4wtS.png";
        tileLetter = @"S";
        tilePoints = 5;
    }
    else if ([letterIn isEqualToString:@"t"]){
        fileName = @"4wtT.png";
        tileLetter = @"T";
        tilePoints = 5;
    }
    else if ([letterIn isEqualToString:@"u"]){
        fileName = @"4wtU.png";
        tileLetter = @"U";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"v"]){
        fileName = @"4wtV.png";
        tileLetter = @"V";
        tilePoints = 45;
    }
    else if ([letterIn isEqualToString:@"w"]){
        fileName = @"4wtW.png";
        tileLetter = @"W";
        tilePoints = 25;
    }
    else if ([letterIn isEqualToString:@"x"]){
        fileName = @"4wtX.png";
        tileLetter = @"X";
        tilePoints = 50;
    }
    else if ([letterIn isEqualToString:@"y"]){
        fileName = @"4wtY.png";
        tileLetter = @"Y";
        tilePoints = 35;
    }
    else if ([letterIn isEqualToString:@"z"]){
        fileName = @"4wtZ.png";
        tileLetter = @"Z";
        tilePoints = 50;
    }
    else{
        fileName = @"";
    }
    
    tmpTex = [[CCTextureCache sharedTextureCache] addImage: fileName];
    
    tmpTile = [tile spriteWithTexture:tmpTex rect:tmpRect];
    tmpTile.letter = tileLetter;
    tmpTile.pointValue = tilePoints;
    
    return tmpTile;
}

-(void) handdleWordTile:(tile *)t{
    if((!wordIsBlank && (t== tileFirst)) || gamePaused || !allowTouches){
        return;
    }
    
    letterCount--;
    [t runAction:[CCMoveTo actionWithDuration:.05 position:t.oPos]];
    [wordTiles removeObject:t];
    [usedTiles removeObject:t];
    [self rearrangeWordTiles];
    [self updatePlayWord];
}

-(void) rearrangeWordTiles{
    int count = 0;
    CGPoint tmpPos;
    
    if(currentLength == THREE){
        for(tile *t in wordTiles){
            if(count == 0) tmpPos = pos31;
            else if(count == 1) tmpPos = pos32;
            else if(count == 2) tmpPos = pos31;
            [t runAction:[CCMoveTo actionWithDuration:.05 position:tmpPos]];
            t.wPos = tmpPos;
            count++;
        }
    }
    else if(currentLength == FOUR){
        for(tile *t in wordTiles){
            if(count == 0) tmpPos = pos41;
            else if(count == 1) tmpPos = pos42;
            else if(count == 2) tmpPos = pos43;
            else if(count == 3) tmpPos = pos44;
            [t runAction:[CCMoveTo actionWithDuration:.05 position:tmpPos]];
            t.wPos = tmpPos;
            count++;
        }
    }
    else if(currentLength == FIVE){
        for(tile *t in wordTiles){
            if(count == 0) tmpPos = pos51;
            else if(count == 1) tmpPos = pos52;
            else if(count == 2) tmpPos = pos53;
            else if(count == 3) tmpPos = pos54;
            else if(count == 4) tmpPos = pos55;
            [t runAction:[CCMoveTo actionWithDuration:.05 position:tmpPos]];
            t.wPos = tmpPos;
            count++;
        }
    }
    else if(currentLength == SIX){
        for(tile *t in wordTiles){
            if(count == 0) tmpPos = pos61;
            else if(count == 1) tmpPos = pos62;
            else if(count == 2) tmpPos = pos63;
            else if(count == 3) tmpPos = pos64;
            else if(count == 4) tmpPos = pos65;
            else if(count == 5) tmpPos = pos66;
            [t runAction:[CCMoveTo actionWithDuration:.05 position:tmpPos]];
            t.wPos = tmpPos;
            count++;
        }
    }
}

-(void) handleKeyboardTile:(tile *)t{
    
    ccTime delayTime = 0;
    
    if(currentLength == THREE){
        
        if([wordTiles count] == 3) return;
        
        if(letterCount == 0){
            letterCount = 1;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos31]];
            t.wPos = pos31;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if(letterCount == 1){
            letterCount = 2;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos32]];
            t.wPos = pos32;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else{
            letterCount = 3;
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos33]];
            t.wPos = pos33;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
            
            [self disableTouch];
            
            if(![self checkWord]){
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:.2],
                                 [CCCallFunc actionWithTarget:self selector:@selector(animateInvalidWord)],
                                 [CCDelayTime actionWithDuration:.5],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
            
            else{
                wCounter++;
                delayTime = 1.2;
                [saveWord setString:playWord];
                [self updateCounter];
                
                if(wCounter == 4){
                    currentLength = FOUR;
                    wCounter = 0;
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(resetCounter)],nil]];
                    delayTime = 1.5;
                    [self newPowerup];
                    [self resetTimer];
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(updateWordBlanks)],nil]];
                }
                
                letterCount = 1;
                
                [self dismissWord];
                [self resetWordWithFirstLetter:t.letter];
                
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:delayTime],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
        }
    }
    
    else if(currentLength == FOUR){
        
        if([wordTiles count] == 4) return;
        
        if(letterCount == 0){
            letterCount = 1;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos41]];
            t.wPos = pos41;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if(letterCount == 1){
            letterCount = 2;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos42]];
            t.wPos = pos42;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if (letterCount == 2){
            letterCount = 3;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos43]];
            t.wPos = pos43;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else{
            letterCount = 4;
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos44]];
            t.wPos = pos44;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
            
            [self disableTouch];
            
            if(![self checkWord]){
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:.2],
                                 [CCCallFunc actionWithTarget:self selector:@selector(animateInvalidWord)],
                                 [CCDelayTime actionWithDuration:.5],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
            
            else{
                wCounter++;
                delayTime = 1.2;
                [saveWord setString:playWord];
                [self updateCounter];
                
                if(wCounter == 4){
                    currentLength = FIVE;
                    wCounter = 0;
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(resetCounter)],nil]];
                    [self updateCounter];
                    delayTime = 1.5;
                    [self newPowerup];
                    [self resetTimer];
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(updateWordBlanks)],nil]];
                }
                
                letterCount = 1;
                
                [self dismissWord];
                [self resetWordWithFirstLetter:t.letter];
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:delayTime],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
        }
    }
    
    else if(currentLength == FIVE){
        
        if([wordTiles count] == 5) return;
        
        if(letterCount == 0){
            letterCount = 1;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos51]];
            t.wPos = pos51;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if(letterCount == 1){
            letterCount = 2;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos52]];
            t.wPos = pos52;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if (letterCount == 2){
            letterCount = 3;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos53]];
            t.wPos = pos53;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if (letterCount == 3){
            letterCount = 4;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos54]];
            t.wPos = pos54;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else{
            letterCount = 5;
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos55]];
            t.wPos = pos55;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
            
            [self disableTouch];
            
            if(![self checkWord]){
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:.2],
                                 [CCCallFunc actionWithTarget:self selector:@selector(animateInvalidWord)],
                                 [CCDelayTime actionWithDuration:.5],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
            
            else{
                wCounter++;
                delayTime = 1.2;
                [saveWord setString:playWord];
                [self updateCounter];
                
                if(wCounter == 4){
                    currentLength = SIX;
                    wCounter = 0;
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(resetCounter)],nil]];
                    [self updateCounter];
                    delayTime = 1.5;
                    [self newPowerup];
                    [self resetTimer];
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(updateWordBlanks)],nil]];
                }
                
                letterCount = 1;
                
                [self dismissWord];
                [self resetWordWithFirstLetter:t.letter];
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:delayTime],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
        }
    }
    
    else if(currentLength == SIX){
        
        if([wordTiles count] == 6) return;
        
        if(letterCount == 0){
            letterCount = 1;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos61]];
            t.wPos = pos61;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if(letterCount == 1){
            letterCount = 2;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos62]];
            t.wPos = pos62;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if (letterCount == 2){
            letterCount = 3;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos63]];
            t.wPos = pos63;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if (letterCount == 3){
            letterCount = 4;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos64]];
            t.wPos = pos64;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else if (letterCount == 4){
            letterCount = 5;
            
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos65]];
            t.wPos = pos65;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
        }
        else{
            letterCount = 6;
            [t runAction:[CCMoveTo actionWithDuration:0.05 position:pos66]];
            t.wPos = pos66;
            [wordTiles addObject:t];
            [usedTiles addObject:t];
            [self addLetter:t.letter];
            
            [self disableTouch];
            
            if(![self checkWord]){
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:.2],
                                 [CCCallFunc actionWithTarget:self selector:@selector(animateInvalidWord)],
                                 [CCDelayTime actionWithDuration:.5],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
            
            else{
                wCounter++;
                delayTime = 1.2;
                [saveWord setString:playWord];
                [self updateCounter];
                
                if(wCounter == 4){
                    currentLength = SIX;
                    wCounter = 0;
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(resetCounter)],nil]];
                    [self updateCounter];
                    delayTime = 1.5;
                    [self newPowerup];
                    [self resetTimer];
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],
                                     [CCCallFunc actionWithTarget:self selector:@selector(updateWordBlanks)],nil]];

                }
                
                letterCount = 1;
                
                [self dismissWord];
                [self resetWordWithFirstLetter:t.letter];
                [self runAction:[CCSequence actions:
                                 [CCDelayTime actionWithDuration:delayTime],
                                 [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],
                                 nil]];
            }
        }
    }
    
}

-(void) dismissFirst{
    [tileFirst runAction:[CCMoveTo actionWithDuration:.05 position:ccp(-winSize.width/2,winSize.height/2 + winSize.height/6)]];
}

-(void) replaceTiles{
    NSInteger i, j;
    NSNumber *tmpIndex;
    CGPoint tmpPos;
    NSNumber *jNum;
    NSString *tLetter;
    
    if([usedLetters count] > 75){
        [usedLetters removeAllObjects];
    }
    
    for(__strong tile *t in usedTiles){
        
        if(t != tileFirst){
        [self removeChild:t cleanup:YES];
        }
        
        for(i=0; i<1; i++){
            j = rand() % 98;
            jNum = [NSNumber numberWithInt:j];
            if(![usedLetters containsObject:jNum]){
                tmpIndex = t.oIndex;
                tmpPos = t.oPos;
                
                if(tOverseer.vowelCounter < 4){
                    j = rand() % [vowelBank count];
                    tLetter = [vowelBank objectAtIndex:j];
                    tOverseer.vowelCounter++;
                }
                else{
                    if(0<=j && j<=26){
                        tOverseer.vowelCounter++;
                    }
                    tLetter = [letterBank objectAtIndex:j];
                    [usedLetters addObject:jNum];
                }
                
                t = [self makeTile:tLetter];
                t.oPos = tmpPos;
                t.oIndex = tmpIndex;
                [keyboardTiles replaceObjectAtIndex:[t.oIndex integerValue] withObject:t];
                t.position = ccp(winSize.width/2, -50);
                [self addChild:t];
                
                [replacementTiles addObject:t];
            }
            else{
                i--;
            }
        }
    }
    
    [self animateReplaceKeyboard];
}

-(void) backspacePressed{
    
    if(gamePaused || !allowTouches){
        return;
    }
    
    if(letterCount == 1){
        if(wordIsBlank == YES){
            letterCount--;
            
            tile *t = [wordTiles objectAtIndex:([wordTiles count]-1)];
            [t runAction:[CCMoveTo actionWithDuration:.05 position:t.oPos]];
            [wordTiles removeLastObject];
            [usedTiles removeLastObject];
            [self removeLastLetter];
        }
    }
    else if(letterCount > 1){
        letterCount--;
        
        tile *t = [wordTiles objectAtIndex:([wordTiles count]-1)];
        [t runAction:[CCMoveTo actionWithDuration:.05 position:t.oPos]];
        [wordTiles removeLastObject];
        [usedTiles removeLastObject];
        [self removeLastLetter];
    }
}

-(void) shufflePressed{
    
    if(gamePaused || !allowTouches){
        return;
    }
    
    NSInteger i, r;
    tile *t1, *t2, *tmp;
    
    for(i=0; i<5; i++){
        [self backspacePressed];
    }
    
    for(i=0; i<20; i++){
        r = rand() % [keyboardTiles count];
        t1 = [keyboardTiles objectAtIndex:i];
        t2 = [keyboardTiles objectAtIndex:r];
        tmp = [[tile alloc]  init];
        
        tmp.oPos = t1.oPos;
        tmp.oIndex = t1.oIndex;
        
        t1.oPos = t2.oPos;
        t1.oIndex = t2.oIndex;
        
        t2.oPos = tmp.oPos;
        t2.oIndex = tmp.oIndex;
        
        [keyboardTiles exchangeObjectAtIndex:i withObjectAtIndex:r];
    }
    
    for(tile *t in keyboardTiles){
        [t runAction: [CCMoveTo actionWithDuration:.15 position:t.oPos]];
    }

}

-(void) updateVowelCounter{
    for(tile *t in wordTiles){
        if([t.letter isEqualToString:@"A"])    tOverseer.vowelCounter--;
        else if([t.letter isEqualToString:@"E"])    tOverseer.vowelCounter--;
        else if([t.letter isEqualToString:@"I"])    tOverseer.vowelCounter--;
        else if([t.letter isEqualToString:@"O"])    tOverseer.vowelCounter--;
        else if([t.letter isEqualToString:@"U"])    tOverseer.vowelCounter--;
    }
}

#pragma mark - Word Handling Methods

-(void) addLetter:(NSString *)nLetter{
    [playWord appendString:nLetter];
}

-(void) updatePlayWord{
    [playWord setString:@""];
    for(tile *t in wordTiles){
        playWord = [[NSString stringWithFormat:@"%@%@",playWord,t.letter] mutableCopy];
    }
    
}

-(void) removeLastLetter{
    NSRange lastChar;
    lastChar.length = 1;
    lastChar.location = (playWord.length-1);
    [playWord replaceCharactersInRange:lastChar withString:@""];
}

-(void) resetWordWithFirstLetter:(NSString *)fLetter{
    NSRange wordRange;
    wordRange.length = playWord.length;
    wordRange.location = 0;
    [playWord replaceCharactersInRange:wordRange withString:@""];
    [playWord appendString:fLetter];
}

-(BOOL) checkWord{
    BOOL wordValid;
     
    if(currentLength == THREE){
        for(NSString *word in wordListThree){
            if ([playWord isEqual:word]){
                wordValid = YES;
                break;
            }
            else{
                wordValid = NO;
            }
        }
    }
    else if(currentLength == FOUR){
        for(NSString *word in wordListFour){
            if ([playWord isEqual:word]){
                wordValid = YES;
                break;
            }
            else{
                wordValid = NO;
            }
        }
    }
    else if(currentLength == FIVE){
        for(NSString *word in wordListFive){
            if ([playWord isEqual:word]){
                wordValid = YES;
                break;
            }
            else{
                wordValid = NO;
            }
        }
    }
    else if(currentLength == SIX){
        for(NSString *word in wordListSix){
            if ([playWord isEqual:word]){
                wordValid = YES;
                break;
            }
            else{
                wordValid = NO;
            }
        }
    }
    else{
        wordValid = NO;
    }
    
    return wordValid;
}

-(void) dismissWord{
    CGPoint tmpPoint;
    
    tileFirst = [wordTiles objectAtIndex:([wordTiles count]-1)];
    
    [self updateVowelCounter];
    
    for(tile *t in wordTiles){
        if(t != tileFirst){
            [t runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCMoveTo actionWithDuration:.05 position: ccp(-160, winSize.height/2 + winSize.height/6)], nil]];
        }
    }
    
    if(currentLength == THREE){
        tmpPoint = pos31;
    }
    else if(currentLength == FOUR){
        tmpPoint = pos41;
    }
    else if(currentLength == FIVE){
        tmpPoint = pos51;
    }
    else if(currentLength == SIX){
        tmpPoint = pos61;
    }
    
    [tileFirst runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCMoveTo actionWithDuration:.05 position: tmpPoint], nil]];
    
    [self updateScore];
    
    [wordTiles removeAllObjects];
    [wordTiles addObject:tileFirst];
    tileFirst.wPos = tmpPoint;
    
    wordIsBlank = NO;
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.75],[CCCallFunc actionWithTarget:self selector:@selector(replaceTiles)],nil]];
}

-(void) resetWord{
    currentLength = THREE;
    letterCount = 1;
    wCounter = 0;
    [self updateCounter];
    multiplier = 1;
    
    if([wordTiles count] != 0){
        tile *tmpFirst = [wordTiles objectAtIndex:0];
        [self removeChild:tmpFirst cleanup:YES];
    }
    
    
    
    for(tile *t in keyboardTiles){
        [self removeChild:t cleanup:YES];
    }
    
    [keyboardTiles removeAllObjects];
    [keyboardLetters removeAllObjects];
    [usedTiles removeAllObjects];
    [wordTiles removeAllObjects];
    [playWord setString:@""];
    
    tOverseer.vowelCounter = 0;
    wordIsBlank = NO;
    
    [self loadKeyboad];
    [self loadFirstLetter];
    [self animateInitialKeyboard];
    [self animateFirstLetter];
    [self resetTimer];
    
    currentTimer = 30;
    
    [self runTimerWithTime:currentTimer];
}

#pragma mark - Word Blank Methods

-(void) updateWordBlanks{
    
    if(currentLength == THREE){
        multiplier = 1;
        [tBlank01 runAction:[CCMoveTo actionWithDuration:.1 position:pos31]];
        [tBlank02 runAction:[CCMoveTo actionWithDuration:.1 position:pos32]];
        [tBlank03 runAction:[CCMoveTo actionWithDuration:.1 position:pos33]];
        
        currentTimer = 30;
        [self runTimerWithTime:currentTimer];
    }
    else if (currentLength == FOUR){
        multiplier = 2;
        [tBlank01 runAction:[CCMoveTo actionWithDuration:.1 position:pos41]];
        [tBlank02 runAction:[CCMoveTo actionWithDuration:.1 position:pos42]];
        [tBlank03 runAction:[CCMoveTo actionWithDuration:.1 position:pos43]];
        [tBlank04 runAction:[CCMoveTo actionWithDuration:.1 position:pos44]];
        
        currentTimer = 40;
        [self runTimerWithTime:currentTimer];
    }
    else if(currentLength == FIVE){
        multiplier = 3;
        [tBlank01 runAction:[CCMoveTo actionWithDuration:.1 position:pos51]];
        [tBlank02 runAction:[CCMoveTo actionWithDuration:.1 position:pos52]];
        [tBlank03 runAction:[CCMoveTo actionWithDuration:.1 position:pos53]];
        [tBlank04 runAction:[CCMoveTo actionWithDuration:.1 position:pos54]];
        [tBlank05 runAction:[CCMoveTo actionWithDuration:.1 position:pos55]];
        
        currentTimer = 50;
        [self runTimerWithTime:currentTimer];
    }
    else if(currentLength == SIX){
        multiplier = 4;
        [tBlank01 runAction:[CCMoveTo actionWithDuration:.1 position:pos61]];
        [tBlank02 runAction:[CCMoveTo actionWithDuration:.1 position:pos62]];
        [tBlank03 runAction:[CCMoveTo actionWithDuration:.1 position:pos63]];
        [tBlank04 runAction:[CCMoveTo actionWithDuration:.1 position:pos64]];
        [tBlank05 runAction:[CCMoveTo actionWithDuration:.1 position:pos65]];
        [tBlank06 runAction:[CCMoveTo actionWithDuration:.1 position:pos66]];
        
        currentTimer = 60;
        [self runTimerWithTime:currentTimer];
    }
    
    [self updateMultipliers];
}

-(void) resetWordBlanks{
    multiplier = 1;
    [tBlank01 runAction:[CCMoveTo actionWithDuration:.1 position:pos31]];
    [tBlank02 runAction:[CCMoveTo actionWithDuration:.1 position:pos32]];
    [tBlank03 runAction:[CCMoveTo actionWithDuration:.1 position:pos33]];
    
    [tBlank04 runAction:[CCMoveTo actionWithDuration:.1 position:initialTilePos]];
    [tBlank05 runAction:[CCMoveTo actionWithDuration:.1 position:initialTilePos]];
    [tBlank06 runAction:[CCMoveTo actionWithDuration:.1 position:initialTilePos]];
    [self updateMultipliers];
}

#pragma mark - Scoring Methods

-(void) updateMultipliers{
    [multOne runAction: [CCMoveTo actionWithDuration:.25 position:multiPosOff]];
    [multTwo runAction: [CCMoveTo actionWithDuration:.25 position:multiPosOff]];
    [multThree runAction: [CCMoveTo actionWithDuration:.25 position:multiPosOff]];
    [multFour runAction: [CCMoveTo actionWithDuration:.25 position:multiPosOff]];
    
    if(multiplier == 1){
        [multOne runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.25],
                        [CCMoveTo actionWithDuration:.25 position:multiPosOn],nil]];
    }
    else if(multiplier == 2){
        [multTwo runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.25],
                            [CCMoveTo actionWithDuration:.25 position:multiPosOn],nil]];
    }
    else if(multiplier == 3){
        [multThree runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.25],
                            [CCMoveTo actionWithDuration:.25 position:multiPosOn],nil]];
    }
    else if(multiplier == 4){
        [multFour runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.25],
                            [CCMoveTo actionWithDuration:.25 position:multiPosOn],nil]];
    }
    
}

-(void) updateScore{
    static NSInteger tmpScore = 0, newScore = 0;
    static int counter = 0;
    
    if(counter == 0){
        for(tile *t in wordTiles){
            tmpScore += t.pointValue;
        }
        tmpScore *= multiplier;
        newScore = score + tmpScore;
        
        if(tmpScore > bestWordScore){
            bestWordScore = tmpScore;
            [bestWord setString:saveWord];
        }
        
    }
    
    if(score < newScore){
        score+=25;
        counter++;
        scoreString = [NSString stringWithFormat:@"%d",score];
        [currentScore setString:scoreString];
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:.0000000001],
                          [CCCallFunc actionWithTarget:self selector:@selector(updateScore)],nil]];
    }
    else{
        score = newScore;
        scoreString = [NSString stringWithFormat:@"%d",score];
        [currentScore setString:scoreString];
        counter = 0;
        tmpScore = 0;
        newScore = 0;
    }
    
}

#pragma mark - Timer Methods

-(void) resetTimer{
    [timerBar stopAllActions];
    keepFlicker = NO;
    gamePaused = YES;
    [timerBar setTexture:timerBlue];
    id timerReset = [CCMoveTo actionWithDuration:.1 position:ccp(winSize.width/2,223)];
    [timerBar runAction:timerReset];
}

-(void) runTimerWithTime: (ccTime)timeLimit{
    timerValue = timeLimit;
    //timerValue = 5;
    
    id runTimer = [CCSequence actions:[CCDelayTime actionWithDuration:.35],[CCMoveTo actionWithDuration:timeLimit position:ccp(-winSize.width/2,223)],nil];
    [timerBar runAction:runTimer];
    gamePaused = NO;
}

-(void) pauseTimer{
    timerPaused = YES;
}

-(void) resumeTimer{
    timerPaused = NO;
}

-(void) setTimerBlue{
    if(keepFlicker){
        [timerBar setTexture:timerBlue];
    }
}

-(void) setTimerRed{
    if(keepFlicker){
        [timerBar setTexture:timerRed];
    }
}

-(void) flickerTimer{
    
    keepFlicker = YES;
    
    //There's got to be a better way...
    //Come back and fix it! Pause bug...
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:.5],
                         [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                         [CCDelayTime actionWithDuration:.5],
                         [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                         [CCDelayTime actionWithDuration:.5],
                         [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                        [CCDelayTime actionWithDuration:.5],
                        [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                        [CCDelayTime actionWithDuration:.5],
                        [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.5],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.5],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.5],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.5],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerBlue)],
                     [CCDelayTime actionWithDuration:.1],
                     [CCCallFunc actionWithTarget:self selector:@selector(setTimerRed)],
                         nil]];

}

-(void) tick:(ccTime)dt{
    if(!gamePaused){
        timerValue--;
    
        if(timerValue == 10){
            [self flickerTimer];
        }
    
        if(timerValue == 0){
            [self animateLifeLost];
        }
    }
}

#pragma mark - Gameplay Elements

-(void) loseLife{
    int lastIndex = [lives count]-1;
    CCSprite *tmpLife = [lives objectAtIndex:lastIndex];
    tmpLife.visible = NO;
    [lives removeObjectAtIndex:lastIndex];
    
    if(lives.count == 0){
        [self gameOver];
        return;
    }
    
    progressCounter = 0;
    
    [self setBackgroundBlue];
    [self resetWord];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(resetCounter)],nil]];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(resetWordBlanks)],
                     [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],nil]];
}

-(void) gameOver{
    gamePaused = YES;
    [pauseButton setIsEnabled:NO];
    [timerBar stopAllActions];
    
    if(scoreOne == -1){
        [self loadGameOverNewBest];
    }
    else if (scoreOne < score){
        [self loadGameOverNewBest];
    }
    else{
        [self loadGameOverNotBest];
    }
}

-(void) loadGameOverNotBest{
    
    gameOverNotBestSprite = [[CCSprite alloc] initWithFile:@"4WGameOverNotBest.png"];
    gameOverNotBestSprite.position = ccp(winSize.width/2 + 480, winSize.height/2);
    [self addChild:gameOverNotBestSprite];
    
    id gameOverIn = [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2, winSize.height/2)];
    
    [gameOverNotBestSprite runAction:gameOverIn];
    
    playAgainButton = [CCMenuItemImage itemWithNormalImage:@"4WPlayAgainButtonNormal.png" selectedImage:@"4WPlayAgainButtonSelect.png" target:self selector:@selector(playAgainNotPressed)];
    menuButton = [CCMenuItemImage itemWithNormalImage:@"4WMenuButtonNormal.png" selectedImage:@"4WMenuButtonSelect.png" target:self selector:@selector(gameOverNotMenuPressed)];
    
    gameOverMenu = [CCMenu menuWithItems: playAgainButton, menuButton, nil];
    [gameOverMenu alignItemsVerticallyWithPadding:10];
    gameOverMenu.position = ccp(winSize.width/2, 80);
    [self addChild:gameOverMenu];
    
    playAgainButton.position = ccp(480,playAgainButton.position.y);
    menuButton.position = ccp(480,menuButton.position.y);
    
    id playAgainIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(0,playAgainButton.position.y)],nil];
    id menuIn = [CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCMoveTo actionWithDuration:.2 position:ccp(0,menuButton.position.y)],nil];

    [playAgainButton runAction:playAgainIn];
    [menuButton runAction:menuIn];
    
    bestScoreString = [NSString stringWithFormat:@"%d",scoreOne];
    currentScoreString = [NSString stringWithFormat:@"%d", score];
    if(bestWordScore != 0){
        bestWordString = [NSString stringWithFormat:@"%@  -  %d",bestWord,bestWordScore];
    }
    else{
        bestWordString = [NSString stringWithFormat:@"No Words!"];
    }
    
    currentScoreLabel = [[CCLabelTTF alloc]initWithString:currentScoreString fontName:@"Code Pro Demo" fontSize:28];
    currentScoreLabel.color = ccc3(63,97,111);
    currentScoreLabel.position = ccp(winSize.width/2 + 50,winSize.height/2 + 69);
    currentScoreLabel.visible = NO;
    [self addChild:currentScoreLabel];
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCShow action],nil]];
    
    bestScoreLabel = [[CCLabelTTF alloc]initWithString:bestScoreString fontName:@"Code Pro Demo" fontSize:28];
    bestScoreLabel.color = ccc3(63,97,111);
    bestScoreLabel.position = ccp(winSize.width/2 + 50,winSize.height/2 + 17);
    bestScoreLabel.visible = NO;
    [self addChild:bestScoreLabel];
    [bestScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCShow action],nil]];
    
    bestWordLabel = [[CCLabelTTF alloc]initWithString:bestWordString fontName:@"Code Pro Demo" fontSize:21];
    bestWordLabel.color = ccc3(63,97,111);
    bestWordLabel.position = ccp(winSize.width/2,winSize.height/2 - 55);
    bestWordLabel.visible = NO;
    [self addChild:bestWordLabel];
    [bestWordLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCShow action],nil]];

}

-(void) loadGameOverNewBest{
    
    gameOverNewBestSprite = [[CCSprite alloc] initWithFile:@"4WGameOverNewBest.png"];
    gameOverNewBestSprite.position = ccp(winSize.width/2 + 480, winSize.height/2);
    [self addChild:gameOverNewBestSprite];
    
    id gameOverIn = [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2, winSize.height/2)];
    
    [gameOverNewBestSprite runAction:gameOverIn];
    
    playAgainButton = [CCMenuItemImage itemWithNormalImage:@"4WPlayAgainButtonNormal.png" selectedImage:@"4WPlayAgainButtonSelect.png" target:self selector:@selector(playAgainNewPressed)];
    menuButton = [CCMenuItemImage itemWithNormalImage:@"4WMenuButtonNormal.png" selectedImage:@"4WMenuButtonSelect.png" target:self selector:@selector(gameOverNewMenuPressed)];
    
    gameOverMenu = [CCMenu menuWithItems: playAgainButton, menuButton, nil];
    [gameOverMenu alignItemsVerticallyWithPadding:10];
    gameOverMenu.position = ccp(winSize.width/2, 80);
    [self addChild:gameOverMenu];
    
    playAgainButton.position = ccp(480,playAgainButton.position.y);
    menuButton.position = ccp(480,menuButton.position.y);
    
    id playAgainIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(0,playAgainButton.position.y)],nil];
    id menuIn = [CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCMoveTo actionWithDuration:.2 position:ccp(0,menuButton.position.y)],nil];
    
    [playAgainButton runAction:playAgainIn];
    [menuButton runAction:menuIn];
    
    currentScoreString = [NSString stringWithFormat:@"%d", score];
    bestWordString = [NSString stringWithFormat:@"%@  -  %d",bestWord,bestWordScore];
    
    currentScoreLabel = [[CCLabelTTF alloc]initWithString:currentScoreString fontName:@"Code Pro Demo" fontSize:36];
    currentScoreLabel.color = ccc3(63,97,111);
    currentScoreLabel.position = ccp(winSize.width/2,winSize.height/2+20);
    currentScoreLabel.visible = NO;
    [self addChild:currentScoreLabel];
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCShow action],nil]];
    
    bestWordLabel = [[CCLabelTTF alloc]initWithString:bestWordString fontName:@"Code Pro Demo" fontSize:21];
    bestWordLabel.color = ccc3(63,97,111);
    bestWordLabel.position = ccp(winSize.width/2,winSize.height/2 - 55);
    bestWordLabel.visible = NO;
    [self addChild:bestWordLabel];
    [bestWordLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCShow action],nil]];
    
    [self handleNewScore];
}

-(void) handleNewScore{
    NSInteger howMany = 0;
    defaults = [NSUserDefaults standardUserDefaults];
    scoreDictionaryTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:4];
 
    if([[NSMutableDictionary dictionaryWithDictionary:
        [defaults dictionaryForKey:scoreDictionaryTag]] count] == 0){
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
    }
    else{
        tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:scoreDictionaryTag]];
    }
    
    if([tmpHighScores objectForKey:@"forwardScoreOne"] == nil){
        [tmpHighScores setObject: [NSNumber numberWithInteger:score] forKey:@"forwardScoreOne"];
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
        
        [[ABGameKitHelper sharedClass] reportScore:score forLeaderboard:@"com.markbellott.4word.forward"];
    }
    else{
        scoreOne = [[tmpHighScores objectForKey:@"forwardScoreOne"] integerValue];
        howMany++;
        
        if([tmpHighScores objectForKey:@"forwardScoreTwo"] != nil){
            scoreTwo = [[tmpHighScores objectForKey:@"forwardScoreTwo"] integerValue];
            howMany++;
        }
        if([tmpHighScores objectForKey:@"forwardScoreThree"] != nil){
            scoreThree = [[tmpHighScores objectForKey:@"forwardScoreThree"] integerValue];
            howMany++;
        }
        if([tmpHighScores objectForKey:@"forwardScoreFour"] != nil){
            scoreFour = [[tmpHighScores objectForKey:@"forwardScoreFour"] integerValue];
            howMany++;
        }
    }
   
    if(howMany == 1){
        if(scoreOne < score){
            scoreTwo = scoreOne;
            scoreOne = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreOne] forKey:@"forwardScoreOne"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreTwo] forKey:@"forwardScoreTwo"];
            
            [[ABGameKitHelper sharedClass] reportScore:score forLeaderboard:@"com.markbellott.4word.forward"];
            
        }
        else{
            [tmpHighScores setObject: [NSNumber numberWithInteger:score] forKey:@"forwardScoreTwo"];
        }
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
    }
    
    else if (howMany == 2){
        if(scoreOne < score){
            scoreThree = scoreTwo;
            scoreTwo = scoreOne;
            scoreOne = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreOne] forKey:@"forwardScoreOne"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreTwo] forKey:@"forwardScoreTwo"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
            
            [[ABGameKitHelper sharedClass] reportScore:score forLeaderboard:@"com.markbellott.4word.forward"];
        }
        else if(scoreTwo < score){
            scoreThree = scoreTwo;
            scoreTwo = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreTwo] forKey:@"forwardScoreTwo"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
        }
        else{
            scoreThree = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
        }
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
    }
    
    else if (howMany == 3){
        if(scoreOne < score){
            scoreFour = scoreThree;
            scoreThree = scoreTwo;
            scoreTwo = scoreOne;
            scoreOne = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreOne] forKey:@"forwardScoreOne"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreTwo] forKey:@"forwardScoreTwo"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
            
            [[ABGameKitHelper sharedClass] reportScore:score forLeaderboard:@"com.markbellott.4word.forward"];
        }
        else if(scoreTwo < score){
            scoreFour = scoreThree;
            scoreThree = scoreTwo;
            scoreTwo = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreTwo] forKey:@"forwardScoreTwo"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
        }
        else if(scoreThree < score){
            scoreFour = scoreThree;
            scoreThree = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
        }
        else{
            scoreFour = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
        }
        
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
    }
    
    else if (howMany == 4){
        if(scoreOne < score){
            scoreFour = scoreThree;
            scoreThree = scoreTwo;
            scoreTwo = scoreOne;
            scoreOne = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreOne] forKey:@"forwardScoreOne"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreTwo] forKey:@"forwardScoreTwo"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
            
            [[ABGameKitHelper sharedClass] reportScore:score forLeaderboard:@"com.markbellott.4word.forward"];
        }
        else if(scoreTwo < score){
            scoreFour = scoreThree;
            scoreThree = scoreTwo;
            scoreTwo = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreTwo] forKey:@"forwardScoreTwo"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
        }
        else if(scoreThree < score){
            scoreFour = scoreThree;
            scoreThree = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreThree] forKey:@"forwardScoreThree"];
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
        }
        else if(scoreFour < score){
            scoreFour = score;
            [tmpHighScores setObject: [NSNumber numberWithInteger:scoreFour] forKey:@"forwardScoreFour"];
        }
        
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
    }
}

-(void) gameOverNotMenuPressed{
    [self hideEverythingForDismiss];
    
    id menuOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.1 position:ccp(-480,menuButton.position.y)],nil];
    id playAgainOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.1 position:ccp(-480,playAgainButton.position.y)],nil];
    
    [menuButton runAction:menuOut];
    [playAgainButton runAction:playAgainOut];
    
    id gameOverOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                         [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2 - 480, winSize.height/2)], nil];
    [gameOverNotBestSprite runAction:gameOverOut];
    
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestWordLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8],
                     [CCCallFunc actionWithTarget:self selector:@selector(returnToMainMenu)],nil]];
}

-(void) gameOverNewMenuPressed{
    [self hideEverythingForDismiss];
    
    id menuOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.1 position:ccp(-480,menuButton.position.y)],nil];
    id playAgainOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.1 position:ccp(-480,playAgainButton.position.y)],nil];
    
    [menuButton runAction:menuOut];
    [playAgainButton runAction:playAgainOut];
    
    id gameOverOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                      [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2 - 480, winSize.height/2)], nil];
    [gameOverNewBestSprite runAction:gameOverOut];
    
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestWordLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8],
                     [CCCallFunc actionWithTarget:self selector:@selector(returnToMainMenu)],nil]];
}

-(void) playAgainNotPressed{
    [self hideEverythingForDismiss];
    
    id menuOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.1 position:ccp(-480,menuButton.position.y)],nil];
    id playAgainOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.1 position:ccp(-480,playAgainButton.position.y)],nil];
    
    [menuButton runAction:menuOut];
    [playAgainButton runAction:playAgainOut];
    
    id gameOverOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                      [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2 - 480, winSize.height/2)], nil];
    [gameOverNotBestSprite runAction:gameOverOut];
    
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestWordLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8],
                     [CCCallFunc actionWithTarget:self selector:@selector(reloadCurrentScene)],nil]];
}

-(void) playAgainNewPressed{
    [self hideEverythingForDismiss];
    
    id menuOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.1 position:ccp(-480,menuButton.position.y)],nil];
    id playAgainOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.1 position:ccp(-480,playAgainButton.position.y)],nil];
    
    [menuButton runAction:menuOut];
    [playAgainButton runAction:playAgainOut];
    
    id gameOverOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                      [CCMoveTo actionWithDuration:.2 position:ccp(winSize.width/2 - 480, winSize.height/2)], nil];
    [gameOverNewBestSprite runAction:gameOverOut];
    
    [currentScoreLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    [bestWordLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCHide action],nil]];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.8],
                     [CCCallFunc actionWithTarget:self selector:@selector(reloadCurrentScene)],nil]];
}

#pragma mark - PowerUp Methods

-(void) powerUpTest{
    pType tmpType;
    
    tmpType = TIMEBOOST;
    powerupOne = [self makePowerupOfType:tmpType];
    powerupOne.position = powerPos01;
    
    tmpType = NEWFIRST;
    powerupTwo = [self makePowerupOfType:tmpType];
    powerupTwo.position = powerPos02;
    
    tmpType = NEWKEYBOARD;
    powerupThree = [self makePowerupOfType:tmpType];
    powerupThree.position = powerPos03;
    
    tmpType = BLANKWORD;
    powerupFour = [self makePowerupOfType:tmpType];
    powerupFour.position = powerPos04;
    
    [powerups addObject:powerupOne];
    [powerups addObject:powerupTwo];
    [powerups addObject:powerupThree];
    [powerups addObject:powerupFour];
    
    [self addChild:powerupOne];
    [self addChild:powerupTwo];
    [self addChild:powerupThree];
    [self addChild:powerupFour];
    
}

-(void) newPowerup{
    
    if([powerups count] == 4) return;
    
    pType newType, tmpType;
    powerup *newPowerup, *tmpPowerup;
    CGPoint tmpPoint;
    NSInteger i, p, n = -1, p0 = 0, p1 = 0, p2 = 0, p3 = 0;
    
    //Check existing type for improved random selection
    if([powerups count] >=2){
        for(i=0; i<[powerups count]; i++){
            tmpPowerup = [powerups objectAtIndex:i];
            tmpType = tmpPowerup.type;
        
            if(tmpType == TIMEBOOST) p0++;
            else if(tmpType == NEWFIRST) p1++;
            else if(tmpType == NEWKEYBOARD) p2++;
            else if(tmpType == BLANKWORD) p3++;
        }
    }
    
    //Strore any "type" that already has two instances
    if(p0 == 2) n=0;
    else if(p1 == 2) n=1;
    else if(p2 == 2) n=2;
    else if(p3 == 2) n=3;
    
    p = n;
    while(p == n){
        p = rand()%4;
    }
    
    if(p == 0) newType = TIMEBOOST;
    else if (p == 1) newType = NEWFIRST;
    else if (p == 2) newType = NEWKEYBOARD;
    else if (p == 3) newType = BLANKWORD;
    else newType = BLANKWORD;
    
    newPowerup = [self makePowerupOfType:newType];
    
    if([powerups count] == 0) tmpPoint = powerPos01;
    else if([powerups count] == 1) tmpPoint = powerPos02;
    else if([powerups count] == 2) tmpPoint = powerPos03;
    else if([powerups count] == 3) tmpPoint = powerPos04;
    
    id powerupIn = [CCMoveTo actionWithDuration:.2 position:tmpPoint];
    
    newPowerup.position = ccp(tmpPoint.x+320, tmpPoint.y);
    
    [self addChild:newPowerup];
    [powerups addObject:newPowerup];
    
    [newPowerup runAction:powerupIn];
    
}

-(powerup*) makePowerupOfType: (pType)typeIn{
    powerup *newPowerup;
    CCTexture2D *tmpTex;
    NSString *fileName;
    CGRect tmpRect = CGRectMake(0, 0, 40, 40);
    
    if(typeIn == TIMEBOOST){
        fileName = @"4WTimeBoostPowerup.png";
    }
    else if(typeIn == NEWFIRST){
        fileName = @"4WNewFirstPowerup.png";
    }
    else if (typeIn == NEWKEYBOARD){
        fileName = @"4WNewKeyboardPowerup.png";
    }
    else if(typeIn == BLANKWORD){
        fileName = @"4WBlankWordPowerup.png";
    }
    else{
        fileName = @"";
    }
    
    tmpTex = [[CCTextureCache sharedTextureCache] addImage: fileName];
    newPowerup = [powerup spriteWithTexture:tmpTex rect:tmpRect];
    newPowerup.type = typeIn;
    
    return newPowerup;
}

-(void) dismissPowerup:(powerup *)p{
    [powerups removeObject:p];
    
    [p runAction:[CCMoveTo actionWithDuration:.1 position:ccp(-120,p.position.y)]];
}

-(void) rearrangePowerups{
    int x = 0;
    CGPoint tmpPos;
    
    for(powerup *p in powerups){
        if(x == 0) tmpPos = powerPos01;
        else if(x == 1) tmpPos = powerPos02;
        else if(x == 2) tmpPos = powerPos03;
        else if(x == 3) tmpPos = powerPos04;
        
        [p runAction:[CCMoveTo actionWithDuration:.1 position:tmpPos]];
        
        x++;
    }
}

-(void) handlePowerup:(powerup*)p{
    [self disablePowerUps];
    
    if(p.type == TIMEBOOST){
        [self timeBoostPowerup];
        [self dismissPowerup:p];
    }
    else if (p.type == NEWFIRST){
        [self newFirstPowerup];
        [self dismissPowerup:p];
    }
    else if(p.type == NEWKEYBOARD){
        [self newKeyboardPowerup];
        [self dismissPowerup:p];
    }
    else if(p.type == BLANKWORD){
        [self blankWordPowerup];
        [self dismissPowerup:p];
    }
    
    [self rearrangePowerups];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCCallFuncN actionWithTarget:self selector:@selector(enablePowerUps)],nil]];
}

-(void) timeBoostPowerup{
    [self resetTimer];
    [self runTimerWithTime:currentTimer];
}

-(void) newFirstPowerup{
    
    NSString *tmpFirst;
    
    for(int i=0; i<5; i++){
        [self backspacePressed];
    }
    
    wordIsBlank = NO;
    
    [self disableTouch];
        
    tmpFirst = tileFirst.letter;
        
    [wordTiles removeAllObjects];
    [self dismissFirst];
    [playWord setString:@""];
    
    [self loadFirstWithPrevious:tmpFirst];
    [self animateFirstLetter];
        
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],
                        [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],nil]];

}

-(void) newKeyboardPowerup{
    
    for(int i=0; i<5; i++){
        [self backspacePressed];
    }
    
    [self disableTouch];
    
    for(tile *t in keyboardTiles){
        [self removeChild:t cleanup:YES];
    }
    
    [keyboardTiles removeAllObjects];
    [keyboardLetters removeAllObjects];

    
    tOverseer.vowelCounter = 0;
    
    [self loadKeyboad];
    [self animatePowerupKeyboard];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],
                     [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)],nil]];
}

-(void) blankWordPowerup{
    for(int i=0; i<5; i++){
        [self backspacePressed];
    }
    
    [self dismissFirst];
    
    [wordTiles removeAllObjects];
    [playWord setString:@""];
    wordIsBlank = YES;
    
    letterCount = 0;
}

-(void) dismissFirstFromBlank{
    [tileFirst runAction:[CCMoveTo actionWithDuration:.05 position:ccp(-winSize.width/2,winSize.height/2 + winSize.height/6)]];
}

-(void) enablePowerUps{
    allowPowerUps = YES;
}

-(void) disablePowerUps{
    allowPowerUps = NO;
}

#pragma mark - Misc Methods

-(void) hideEverythingForDismiss{
    [self setBackgroundBlue];
    
    //Top Bar Stuff
    topBar.visible = NO;
    lifeOne.visible = NO;
    lifeTwo.visible = NO;
    lifeThree.visible = NO;
    lifeFour.visible = NO;
    pauseMenu.visible = NO;
    currentScore.visible = NO;
    multOne.visible = NO;
    multTwo.visible = NO;
    multThree.visible = NO;
    multFour.visible = NO;
    
    //Play Area Stuff
    for(tile *t in wordTiles){
        t.visible = NO;
    }
    for(powerup *p in powerups){
        p.visible = NO;
    }
    pBlank01.visible = NO;
    pBlank02.visible = NO;
    pBlank03.visible = NO;
    pBlank04.visible = NO;
    tBlank01.visible = NO;
    tBlank02.visible = NO;
    tBlank03.visible = NO;
    tBlank04.visible = NO;
    tBlank05.visible = NO;
    tBlank06.visible = NO;
    timerBar.visible = NO;
    counterOne.visible = NO;
    counterTwo.visible = NO;
    counterThree.visible = NO;
    counterFour.visible = NO;
    counterBlank.visible = NO;
    
    //KeyBoard Stuff
    for(tile *t in keyboardTiles){
        t.visible = NO;
    }
    keyboardBackground.visible = NO;
    keyboardButtonMenu.visible = NO;
    
}

-(void) returnToMainMenu{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

-(void) reloadCurrentScene{
    [[CCDirector sharedDirector] replaceScene:[playLayer scene]];
}

-(void) arrayCleanup{
    [usedTiles removeAllObjects];
    [replacementTiles removeAllObjects];
}

-(void) disableTouch{
    allowTouches = NO;
}

-(void) enableTouch{
    allowTouches = YES;
}

@end
