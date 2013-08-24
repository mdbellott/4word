//
//  MenuLayer.m
//  4word
//
//  Created by Mark Bellott on 10/13/12.
//  Copyright 2012 Mark Bellott. All rights reserved.
//

#import "MenuLayer.h"


@implementation MenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	MenuLayer *layer = [MenuLayer node];
	
	[scene addChild: layer];

	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        [self loadPositions];
        [self loadBackground];
        [self loadTitle];
        [self syncHighScores];
        
        howPage = 0;
        
        currentMenu = [self loadMain];
        
    }
    return self;
}


#pragma mark - Init Methods

-(void) loadPositions{
    pageOn = ccp(winSize.width/2, winSize.height/2+63);
    pageOff = ccp(winSize.width/2 + 400, winSize.height/2+63);
    pageOut = ccp(winSize.width/2 - 400, winSize.height/2+63);
}

-(void) loadBackground{
    backgroundSprite = [[CCSprite alloc] initWithFile:@"4WBackground2.png"];
    backgroundSprite.position = ccp(160, winSize.height/2);
    [self addChild:backgroundSprite];
}

-(void) loadTitle{
    
    titleSprite = [[CCSprite alloc] initWithFile:@"4WTitle.png"];
    titleSprite.position = ccp(-320,(winSize.height/2 + winSize.height/3.5));
    [self addChild:titleSprite];
    
    id titleIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(160, titleSprite.position.y)],nil];
    
    [titleSprite runAction:titleIn];
}

//Note: This was put in to fix highscores lost dues GameCenter being unavailable
-(void) syncHighScores{
    NSInteger highScore;
    
    highScoresTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:4];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:highScoresTag]];
    
    if([tmpHighScores objectForKey:@"forwardScoreOne"] != nil){
        highScore = [[tmpHighScores objectForKey:@"forwardScoreOne"] integerValue];
    }
    else{
        return;
    }
    
    [[ABGameKitHelper sharedClass] reportScore:highScore forLeaderboard:@"com.markbellott.4word.forward"];
}

#pragma mark - Main Methods

-(CCMenu*) loadMain{
    
    CCMenuItemImage *play = [CCMenuItemImage itemWithNormalImage:@"4WPlayButtonNormal.png" selectedImage:@"4WPlayButtonSelect.png" target:self selector:@selector(playPressed)];
    CCMenuItemImage *scores = [CCMenuItemImage itemWithNormalImage:@"4WScoresButtonNormal.png" selectedImage:@"4WScoresButtonSelect.png" target:self selector:@selector(scoresPressed)];
    CCMenuItemImage *options = [CCMenuItemImage itemWithNormalImage:@"4WOptionsButtonNormal.png" selectedImage:@"4WOptionsButtonSelect.png" target:self selector:@selector(optionsPressed)];
    CCMenuItemImage *about = [CCMenuItemImage itemWithNormalImage:@"4WAboutButtonNormal.png" selectedImage:@"4WAboutButtonSelect.png" target:self selector:@selector(aboutPressed)];
    
    CCMenu *main = [CCMenu menuWithItems:play, scores, options, about, nil];
    [main alignItemsVerticallyWithPadding:0];
    main.position = ccp(160,winSize.height/3);
    [self addChild:main];
    
    play.position = ccp(480,play.position.y);
    scores.position = ccp(480,scores.position.y);
    options.position = ccp(480,options.position.y);
    about.position = ccp(480,about.position.y);
    
    id playIn = [CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCMoveTo actionWithDuration:.2 position:ccp(0,play.position.y)],nil];
    id scoresIn = [CCSequence actions:[CCDelayTime actionWithDuration:.6],[CCMoveTo actionWithDuration:.2 position:ccp(0,scores.position.y)],nil];
    id optionsIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCMoveTo actionWithDuration:.2 position:ccp(0,options.position.y)],nil];
    id aboutIn = [CCSequence actions:[CCDelayTime actionWithDuration:.8],[CCMoveTo actionWithDuration:.2 position:ccp(0,about.position.y)],nil];
    
    [play runAction:playIn];
    [scores runAction:scoresIn];
    [options runAction:optionsIn];
    [about runAction:aboutIn];
    
    return main;
}

-(void) playPressed{
    NSUInteger index = 0;
    [self dismissMainWithSelectedIndex:index];
    
    if([defaults boolForKey:@"FirstHowToDone"] == NO){
            [defaults setBool:YES forKey:@"FirstHowToDone"];
            [defaults synchronize];
    
        currentMenu = [self loadHowTo];
    }
    
    else{
        currentMenu = [self loadMode];
    }
}

-(void) scoresPressed{
    NSUInteger index = 1;
    [self dismissMainWithSelectedIndex:index];
    currentMenu = [self loadScores];
}

-(void) optionsPressed{
    NSUInteger index = 2;
    [self dismissMainWithSelectedIndex:index];
    currentMenu = [self loadOptions];
};

-(void) aboutPressed{
    NSUInteger index = 3;
    [self dismissMainWithSelectedIndex:index];
    currentMenu = [self loadAbout];
}

-(void) dismissMainWithSelectedIndex:(NSUInteger)index{
    CCMenuItem *first = [[CCMenuItem alloc] init];
    CCMenuItem *second = [[CCMenuItem alloc] init];
    CCMenuItem *third = [[CCMenuItem alloc] init];
    CCMenuItem *fourth = [[CCMenuItem alloc] init];
    
    if(index == 0){
        first = [[currentMenu children]objectAtIndex:0];
        second = [[currentMenu children]objectAtIndex:1];
        third = [[currentMenu children]objectAtIndex:2];
        fourth = [[currentMenu children]objectAtIndex:3];
    }
    else if(index == 1){
        first = [[currentMenu children]objectAtIndex:1];
        second = [[currentMenu children]objectAtIndex:2];
        third = [[currentMenu children]objectAtIndex:3];
        fourth = [[currentMenu children]objectAtIndex:0];
    }
    else if(index == 2){
        first = [[currentMenu children]objectAtIndex:2];
        second = [[currentMenu children]objectAtIndex:1];
        third = [[currentMenu children]objectAtIndex:0];
        fourth = [[currentMenu children]objectAtIndex:3];
    }
    else if (index == 3){
        first = [[currentMenu children]objectAtIndex:3];
        second = [[currentMenu children]objectAtIndex:2];
        third = [[currentMenu children]objectAtIndex:1];
        fourth = [[currentMenu children]objectAtIndex:0];
    }
    
    [first setIsEnabled:NO];
    [second setIsEnabled:NO];
    [third setIsEnabled:NO];
    [fourth setIsEnabled:NO];
    
    id firstOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,first.position.y)],nil];
    id secondOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(-480,second.position.y)],nil];
    id thirdOut = [CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCMoveTo actionWithDuration:.2 position:ccp(-480,third.position.y)],nil];
    id fourthOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCMoveTo actionWithDuration:.2 position:ccp(-480,fourth.position.y)],nil];
    
    [first runAction:firstOut];
    [second runAction:secondOut];
    [third runAction:thirdOut];
    [fourth runAction:fourthOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];

}

#pragma mark - Score Methods

-(CCMenu*) loadScores{

    CCSprite *settingsSprite = [[CCSprite alloc] initWithFile:@"4WScoresPage.png"];
    settingsSprite.position = pageOff;
    [self addChild:settingsSprite];
    tmpPageSprite = settingsSprite;
    
    id settingsIn = [CCSequence actions: [CCDelayTime actionWithDuration:.5], [CCMoveTo actionWithDuration:.2 position:pageOn],nil];
    [settingsSprite runAction:settingsIn];
    
    CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"4WBackButtonNormal.png" selectedImage:@"4WBackButtonSelect.png" target:self selector:@selector(scoresBackPressed)];
    
    CCMenu *scores = [CCMenu menuWithItems:back, nil];
    [scores alignItemsVerticallyWithPadding:0];
    scores.position = ccp(winSize.width/2, 95);
    [self addChild:scores];

    back.position = ccp(480,back.position.y);
    id backIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCMoveTo actionWithDuration:.2 position:ccp(0,back.position.y)],nil];
    [back runAction:backIn];
    
    [self setUpScoreLabels];
    
    gcButton = [CCMenuItemImage itemWithNormalImage:@"4WGameCenterNormal.png" selectedImage:@"4WGameCenterSelect.png" target:self selector:@selector(gcButtonPressed)];
    
    gcButtonMenu = [CCMenu menuWithItems:gcButton, nil];
    [gcButtonMenu alignItemsVerticallyWithPadding:0];
    gcButtonMenu.position = ccp(winSize.width/2, winSize.height/2 - 50);
    [self addChild:gcButtonMenu];
    
    gcButton.position = ccp(480,gcButton.position.y);
    id gcIn = [CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCMoveTo actionWithDuration:.2 position:ccp(0,gcButton.position.y)],nil];
    [gcButton runAction:gcIn];
    
    return scores;
}

-(void) setUpScoreLabels{
    highScoresTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:4];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:highScoresTag]];
    
    //Forward Score One
    if([tmpHighScores objectForKey:@"forwardScoreOne"] == nil){
        fScoreOneString = [NSString stringWithFormat:@"0"];
    }
    else{
        tmpScoreValue = [[tmpHighScores objectForKey:@"forwardScoreOne"] integerValue];
        fScoreOneString = [NSString stringWithFormat:@"%d",tmpScoreValue];
    }
    
    fScoreOne = [[CCLabelTTF alloc]initWithString:fScoreOneString fontName:@"Code Pro Demo" fontSize:18];
    fScoreOne.color = ccc3(63,97,111);
    fScoreOne.position = ccp(winSize.width/2 + 5,winSize.height/2 + 92);
    fScoreOne.visible = NO;
    [self addChild:fScoreOne];
    [fScoreOne runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
    
    //Forward Score Two
    if([tmpHighScores objectForKey:@"forwardScoreTwo"] == nil){
       fScoreTwoString = [NSString stringWithFormat:@"0"];
    }
    else{
        tmpScoreValue = [[tmpHighScores objectForKey:@"forwardScoreTwo"] integerValue];
        fScoreTwoString = [NSString stringWithFormat:@"%d",tmpScoreValue];
    }
    
    fScoreTwo = [[CCLabelTTF alloc]initWithString:fScoreTwoString fontName:@"Code Pro Demo" fontSize:18];
    fScoreTwo.color = ccc3(63,97,111);
    fScoreTwo.position = ccp(winSize.width/2 + 5,winSize.height/2 + 63);
    fScoreTwo.visible = NO;
    [self addChild:fScoreTwo];
    [fScoreTwo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
    
    //Forward Score Three
    if([tmpHighScores objectForKey:@"forwardScoreThree"] == nil){
       fScoreThreeString = [NSString stringWithFormat:@"0"];
    }
    else{
        tmpScoreValue = [[tmpHighScores objectForKey:@"forwardScoreThree"] integerValue];
        fScoreThreeString = [NSString stringWithFormat:@"%d",tmpScoreValue];
    }
    
    fScoreThree = [[CCLabelTTF alloc]initWithString:fScoreThreeString fontName:@"Code Pro Demo" fontSize:18];
    fScoreThree.color = ccc3(63,97,111);
    fScoreThree.position = ccp(winSize.width/2 + 5,winSize.height/2 + 32);
    fScoreThree.visible = NO;
    [self addChild:fScoreThree];
    [fScoreThree runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
    
    //Forward Score Four
    if([tmpHighScores objectForKey:@"forwardScoreFour"] == nil){
       fScoreFourString = [NSString stringWithFormat:@"0"];
    }
    else{
        tmpScoreValue = [[tmpHighScores objectForKey:@"forwardScoreFour"] integerValue];
        fScoreFourString = [NSString stringWithFormat:@"%d",tmpScoreValue];
    }
    
    fScoreFour = [[CCLabelTTF alloc]initWithString:fScoreFourString fontName:@"Code Pro Demo" fontSize:18];
    fScoreFour.color = ccc3(63,97,111);
    fScoreFour.position = ccp(winSize.width/2 + 5,winSize.height/2 + 3);
    fScoreFour.visible = NO;
    [self addChild:fScoreFour];
    [fScoreFour runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
}

-(void) scoresBackPressed{
    [self dismissScores];
    currentMenu = [self loadMain];
}

-(void) gcButtonPressed{
    [[ABGameKitHelper sharedClass] showLeaderboard:@"com.markbellott.4word.forward"];
}

-(void) dismissScores{
    
    [fScoreOne runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCHide action],nil]];
    [fScoreTwo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCHide action],nil]];
    [fScoreThree runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCHide action],nil]];
    [fScoreFour runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCHide action],nil]];
    
    id tmpPageOut = [CCSequence actions: [CCDelayTime actionWithDuration:.3], [CCMoveTo actionWithDuration:.2 position:pageOut],nil];
    [tmpPageSprite runAction:tmpPageOut];
    
    id gcOut = [CCSequence actions: [CCDelayTime actionWithDuration:.3], [CCMoveTo actionWithDuration:.2 position:ccp(-480, gcButton.position.y)],nil];
    [gcButton runAction:gcOut];
    
    CCMenuItem *first = [[CCMenuItem alloc] init];
    first = [[currentMenu children]objectAtIndex:0];
    [first setIsEnabled:NO];
    id firstOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,first.position.y)],nil];
    [first runAction:firstOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];

}

#pragma mark - Options Methods

-(CCMenu*) loadOptions{
    
    CCSprite *optionsSprite = [[CCSprite alloc] initWithFile:@"4WOptionsPage.png"];
    optionsSprite.position = pageOff;
    [self addChild:optionsSprite];
    tmpPageSprite = optionsSprite;
    
    id optionsIn = [CCSequence actions: [CCDelayTime actionWithDuration:.5], [CCMoveTo actionWithDuration:.2 position:pageOn],nil];
    [optionsSprite runAction:optionsIn];
    
    CCMenuItemImage *reset = [CCMenuItemImage itemWithNormalImage:@"4WResetButtonNormal.png" selectedImage:@"4WResetButtonSelect.png" target:self selector:@selector(resetScoresPressed)];
    
    CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"4WBackButtonNormal.png" selectedImage:@"4WBackButtonSelect.png" target:self selector:@selector(optionsBackPressed)];
    
    CCMenu *options = [CCMenu menuWithItems: reset, back, nil];
    [options alignItemsVerticallyWithPadding:100];
    options.position = ccp(winSize.width/2, 150);
    [self addChild:options];
    
    reset.position = ccp(480,reset.position.y);
    id resetIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCMoveTo actionWithDuration:.2 position:ccp(0,reset.position.y)],nil];
    [reset runAction:resetIn];
    
    back.position = ccp(480,back.position.y);
    id backIn = [CCSequence actions:[CCDelayTime actionWithDuration:.8],[CCMoveTo actionWithDuration:.2 position:ccp(0,back.position.y)],nil];
    [back runAction:backIn];
    
    return options;
    
}

-(void) resetScoresPressed{
    NSInteger zero = 0;
    
    defaults = [NSUserDefaults standardUserDefaults];
    highScoresTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:4];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:highScoresTag]];
    
    [tmpHighScores setObject: [NSNumber numberWithInteger:zero] forKey:@"forwardScoreOne"];
    [tmpHighScores setObject: [NSNumber numberWithInteger:zero] forKey:@"forwardScoreTwo"];
    [tmpHighScores setObject: [NSNumber numberWithInteger:zero] forKey:@"forwardScoreThree"];
    [tmpHighScores setObject: [NSNumber numberWithInteger:zero] forKey:@"forwardScoreFour"];
    
    [defaults setObject:tmpHighScores forKey:highScoresTag];
    [defaults synchronize];
    
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Scores Reset!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [resetAlert show];
}

-(void) optionsBackPressed{
    [self dismissOptions];
    currentMenu = [self loadMain];
}

-(void) dismissOptions{
    id tmpPageOut = [CCSequence actions: [CCDelayTime actionWithDuration:.4], [CCMoveTo actionWithDuration:.2 position:pageOut],nil];
    
    [tmpPageSprite runAction:tmpPageOut];
    
    CCMenuItem *first = [[CCMenuItem alloc] init];
    CCMenuItem *second = [[CCMenuItem alloc] init];
    first = [[currentMenu children]objectAtIndex:0];
    second = [[currentMenu children]objectAtIndex:1];
    [first setIsEnabled:NO];
    [second setIsEnabled:NO];
    
    id firstOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(-480,first.position.y)],nil];
    id secondOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,second.position.y)],nil];
    
    [first runAction:firstOut];
    [second runAction:secondOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    
    [self runAction:delayRelease];
}

#pragma mark - About Methods

-(CCMenu*) loadAbout{
    CCSprite *aboutSprite = [[CCSprite alloc] initWithFile:@"4WAboutPage.png"];
    aboutSprite.position = pageOff;
    [self addChild:aboutSprite];
    tmpPageSprite = aboutSprite;
    
    id aboutIn = [CCSequence actions: [CCDelayTime actionWithDuration:.5], [CCMoveTo actionWithDuration:.2 position:pageOn],nil];
    [aboutSprite runAction:aboutIn];
    
    CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"4WBackButtonNormal.png" selectedImage:@"4WBackButtonSelect.png" target:self selector:@selector(scoresBackPressed)];
    
    CCMenu *about = [CCMenu menuWithItems:back, nil];
    [about alignItemsVerticallyWithPadding:0];
    about.position = ccp(winSize.width/2, 95);
    [self addChild:about];
    
    back.position = ccp(480,back.position.y);
    id backIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCMoveTo actionWithDuration:.2 position:ccp(0,back.position.y)],nil];
    [back runAction:backIn];
    
    return about;
}

-(void) aboutBackPressed{
    [self dismissScores];
    currentMenu = [self loadMain];
}

-(void) dismissAbout{
    
    id tmpPageOut = [CCSequence actions: [CCDelayTime actionWithDuration:.3], [CCMoveTo actionWithDuration:.2 position:pageOut],nil];
    [tmpPageSprite runAction:tmpPageOut];
    
    CCMenuItem *first = [[CCMenuItem alloc] init];
    first = [[currentMenu children]objectAtIndex:0];
    
    [first setIsEnabled:NO];
    
    id firstOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,first.position.y)],nil];
    [first runAction:firstOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
    
}

#pragma mark - Mode Methods

-(CCMenu*) loadMode{
    CCMenuItemImage *forward = [CCMenuItemImage itemWithNormalImage:@"4WForwardButtonNormal.png" selectedImage:@"4WForwardButtonSelect.png" target:self selector:@selector(forwardPressed)];
    CCMenuItemImage *relax = [CCMenuItemImage itemWithNormalImage:@"4WRelaxButtonNormal.png" selectedImage:@"4WRelaxButtonSelect.png" target:self selector:@selector(relaxPressed)];
    CCMenuItemImage *howTo = [CCMenuItemImage itemWithNormalImage:@"4WHowButtonNormal.png" selectedImage:@"4WHowButtonSelect.png" target:self selector:@selector(howToPressed)];
    CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"4WBackButtonNormal.png" selectedImage:@"4WBackButtonSelect.png" target:self selector:@selector(modeBackPressed)];
    
    CCMenu *mode = [CCMenu menuWithItems:forward, relax, howTo, back, nil];
    [mode alignItemsVerticallyWithPadding:0];
    mode.position = ccp(160,winSize.height/3);
    [self addChild:mode];
    
    forward.position = ccp(480,forward.position.y);
    relax.position = ccp(480,relax.position.y);
    howTo.position = ccp(480,howTo.position.y);
    back.position = ccp(480,back.position.y);
    
    id forwardIn = [CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCMoveTo actionWithDuration:.2 position:ccp(0,forward.position.y)],nil];
    id relaxIn = [CCSequence actions:[CCDelayTime actionWithDuration:.6],[CCMoveTo actionWithDuration:.2 position:ccp(0,relax.position.y)],nil];
    id howToIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCMoveTo actionWithDuration:.2 position:ccp(0,howTo.position.y)],nil];
    id backIn = [CCSequence actions:[CCDelayTime actionWithDuration:.8],[CCMoveTo actionWithDuration:.2 position:ccp(0,back.position.y)],nil];
    
    [forward runAction:forwardIn];
    [relax runAction:relaxIn];
    [howTo runAction:howToIn];
    [back runAction:backIn];
    
    return mode;
}

-(void) forwardPressed{
    NSUInteger index = 0;
    [self dismissModeWithSelectedIndex:index];
    [self dismissTitle];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFuncN actionWithTarget:self selector:@selector(loadForwardScene)], nil]];
}

-(void) relaxPressed{
    NSUInteger index = 1;
    [self dismissModeWithSelectedIndex:index];
    [self dismissTitle];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFuncN actionWithTarget:self selector:@selector(loadRelaxScene)], nil]];
}

-(void) howToPressed{
    NSUInteger index = 2;
    [self dismissModeWithSelectedIndex:index];
    currentMenu = [self loadHowTo];
}

-(void) modeBackPressed{
    NSUInteger index = 3;
    [self dismissModeWithSelectedIndex:index];
    currentMenu = [self loadMain];
}

-(void) dismissModeWithSelectedIndex:(NSUInteger)index{
    CCMenuItem *first = [[CCMenuItem alloc] init];
    CCMenuItem *second = [[CCMenuItem alloc] init];
    CCMenuItem *third = [[CCMenuItem alloc] init];
    CCMenuItem *fourth = [[CCMenuItem alloc] init];
    
    if(index == 0){
        first = [[currentMenu children]objectAtIndex:0];
        second = [[currentMenu children]objectAtIndex:1];
        third = [[currentMenu children]objectAtIndex:2];
        fourth = [[currentMenu children]objectAtIndex:3];
    }
    else if(index == 1){
        first = [[currentMenu children]objectAtIndex:1];
        second = [[currentMenu children]objectAtIndex:2];
        third = [[currentMenu children]objectAtIndex:3];
        fourth = [[currentMenu children]objectAtIndex:0];
    }
    else if(index == 2){
        first = [[currentMenu children]objectAtIndex:2];
        second = [[currentMenu children]objectAtIndex:1];
        third = [[currentMenu children]objectAtIndex:0];
        fourth = [[currentMenu children]objectAtIndex:3];
    }
    else if (index == 3){
        first = [[currentMenu children]objectAtIndex:3];
        second = [[currentMenu children]objectAtIndex:2];
        third = [[currentMenu children]objectAtIndex:1];
        fourth = [[currentMenu children]objectAtIndex:0];
    }
    
    [first setIsEnabled:NO];
    [second setIsEnabled:NO];
    [third setIsEnabled:NO];
    [fourth setIsEnabled:NO];
    
    id firstOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,first.position.y)],nil];
    id secondOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(-480,second.position.y)],nil];
    id thirdOut = [CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCMoveTo actionWithDuration:.2 position:ccp(-480,third.position.y)],nil];
    id fourthOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCMoveTo actionWithDuration:.2 position:ccp(-480,fourth.position.y)],nil];
    
    [first runAction:firstOut];
    [second runAction:secondOut];
    [third runAction:thirdOut];
    [fourth runAction:fourthOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
}

#pragma mark - How To Methods

-(CCMenu*) loadHowTo{
    
    [titleSprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCHide action],nil]];
    
    if(howPage == 0){
        howSpriteOne = [[CCSprite alloc] initWithFile:@"4WHowToPageOne.png"];
        howSpriteTwo = [[CCSprite alloc] initWithFile:@"4WHowToPageTwo.png"];
        howSpriteThree = [[CCSprite alloc] initWithFile:@"4WHowToPageThree.png"];
        howSpriteFour = [[CCSprite alloc] initWithFile:@"4WHowToPageFour.png"];
        howSpriteFive = [[CCSprite alloc] initWithFile:@"4WHowToPageFive.png"];
        
        [self addChild:howSpriteOne];
        [self addChild:howSpriteTwo];
        [self addChild:howSpriteThree];
        [self addChild:howSpriteFour];
        [self addChild:howSpriteFive];
    }
    
    howPage = 1;
    
    howSpriteOne.position = pageOff;
    howSpriteTwo.position = pageOff;
    howSpriteThree.position = pageOff;
    howSpriteFour.position = pageOff;
    howSpriteFive.position = pageOff;
    
    id howIn = [CCSequence actions: [CCDelayTime actionWithDuration:.5], [CCMoveTo actionWithDuration:.2 position:pageOn],nil];
    [howSpriteOne runAction:howIn];
    
    CCMenuItemImage *next = [CCMenuItemImage itemWithNormalImage:@"4WNextButtonNormal.png" selectedImage:@"4WNextButtonSelect.png" target:self selector:@selector(howNextPressed)];
    CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"4WBackButtonNormal.png" selectedImage:@"4WBackButtonSelect.png" target:self selector:@selector(howBackPressed)];
    
    CCMenu *howTo = [CCMenu menuWithItems:next, back, nil];
    [howTo alignItemsVerticallyWithPadding:0];
    howTo.position = ccp(winSize.width/2, 77);
    [self addChild:howTo];
    
    next.position = ccp(480,next.position.y);
    back.position = ccp(480,back.position.y);
    
    id nextIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCMoveTo actionWithDuration:.2 position:ccp(0,next.position.y)],nil];
    id backIn = [CCSequence actions:[CCDelayTime actionWithDuration:.8],[CCMoveTo actionWithDuration:.2 position:ccp(0,back.position.y)],nil];
    
    [next runAction:nextIn];
    [back runAction:backIn];
    
    return howTo;

}

-(void) howNextPressed{
    id tmpPageOut = [CCMoveTo actionWithDuration:.2 position:pageOut];
    id tmpPageOn = [CCMoveTo actionWithDuration:.2 position:pageOn];
    
    if(howPage == 5){
        [self dismissHowTo];
        currentMenu = [self loadMode];
    }
    else{
        if(howPage == 1){
            [howSpriteOne runAction:tmpPageOut];
            [howSpriteTwo runAction:tmpPageOn];
        }
        else if(howPage == 2){
            [howSpriteTwo runAction:tmpPageOut];
            [howSpriteThree runAction:tmpPageOn];
        }
        else if(howPage == 3){
            [howSpriteThree runAction:tmpPageOut];
            [howSpriteFour runAction:tmpPageOn];
        }
        else if(howPage == 4){
            [howSpriteFour runAction:tmpPageOut];
            [howSpriteFive runAction:tmpPageOn];
        }
        howPage++;
    }
}

-(void) howBackPressed{
    id tmpPageOn = [CCMoveTo actionWithDuration:.2 position:pageOn];
    id tmpPageOff = [CCMoveTo actionWithDuration:.2 position:pageOff];
    
    if(howPage == 1){
        [self dismissHowTo];
        currentMenu = [self loadMode];
    }
    else{
        if(howPage == 2){
            [howSpriteOne runAction:tmpPageOn];
            [howSpriteTwo runAction:tmpPageOff];
        }
        else if(howPage == 3){
            [howSpriteTwo runAction:tmpPageOn];
            [howSpriteThree runAction:tmpPageOff];
        }
        else if(howPage == 4){
            [howSpriteThree runAction:tmpPageOn];
            [howSpriteFour runAction:tmpPageOff];
        }
        else if(howPage == 5){
            [howSpriteFour runAction:tmpPageOn];
            [howSpriteFive runAction:tmpPageOff];
        }
        howPage--;
    }
}

-(void) dismissHowTo{
    titleSprite.visible = YES;
    
    id tmpPageOut = [CCSequence actions: [CCDelayTime actionWithDuration:.3], [CCMoveTo actionWithDuration:.2 position:pageOut],nil];
    
    if(howPage == 1){
        [howSpriteOne runAction:tmpPageOut];
    }
    else if(howPage == 5){
        [howSpriteFive runAction:tmpPageOut];
    }
    
    CCMenuItem *first = [[CCMenuItem alloc] init];
    CCMenuItem *second = [[CCMenuItem alloc] init];
    
    if(howPage == 1){
        first = [[currentMenu children]objectAtIndex:0];
        second = [[currentMenu children]objectAtIndex:1];
    }
    else{
        first = [[currentMenu children]objectAtIndex:1];
        second = [[currentMenu children]objectAtIndex:0];
    }
    
    [first setIsEnabled:NO];
    [second setIsEnabled:NO];
    
    id firstOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:.2 position:ccp(-480,first.position.y)],nil];
    id secondOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:.2 position:ccp(-480,second.position.y)],nil];
    
    [first runAction:firstOut];
    [second runAction:secondOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    
    [self runAction:delayRelease];
}

#pragma mark - Dismiss Methods

-(void) dismissTitle{
    
    id titleOut = [CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCMoveTo actionWithDuration:.2 position:ccp(480, titleSprite.position.y)],nil];
    
    [titleSprite runAction:titleOut];
}

-(void) loadForwardScene{
    CCLayer *layer = [playLayer node];
    CCScene *scene = [CCScene node];
    [scene addChild:layer z:0 tag:100];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void) loadRelaxScene{
    [[CCDirector sharedDirector] replaceScene:[freePlayLayer scene]];
}


@end
