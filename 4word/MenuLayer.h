//
//  MenuLayer.h
//  4word
//
//  Created by Mark Bellott on 10/13/12.
//  Copyright 2012 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "playLayer.h"
#import "freePlayLayer.h"
#import "ABGameKitHelper.h"

@interface MenuLayer : CCLayer {
    CGSize winSize;
    
    NSUserDefaults *defaults;
    NSMutableDictionary *tmpHighScores;
    NSString *highScoresTag,
    *fScoreOneString, *fScoreTwoString,
    *fScoreThreeString, *fScoreFourString;
    CCLabelTTF *fScoreOne, *fScoreTwo, *fScoreThree, *fScoreFour;
    
    NSInteger howPage, tmpScoreValue;
    
    CCMenu *currentMenu, *gcButtonMenu;
    CCMenuItem *gcButton;
    
    CCSprite *backgroundSprite, *titleSprite, *blackSprite, *tmpPageSprite;
    CCSprite *howSpriteOne, *howSpriteTwo, *howSpriteThree, *howSpriteFour, *howSpriteFive;
    
    CGPoint pageOff, pageOn, pageOut;
}

+(CCScene *) scene;

-(void) loadPositions;
-(void) loadBackground;
-(void) loadTitle;

//Main Menu
-(CCMenu*) loadMain;
-(void) playPressed;
-(void) scoresPressed;
-(void) optionsPressed;
-(void) aboutPressed;
-(void) dismissMainWithSelectedIndex:(NSUInteger)index;

//Socres Page
-(CCMenu*) loadScores;
-(void) setUpScoreLabels;
-(void) scoresBackPressed;
-(void) gcButtonPressed;
-(void) dismissScores;

//Options Page
-(CCMenu*) loadOptions;
-(void) resetScoresPressed;
-(void) optionsBackPressed;
-(void) dismissOptions;

//About Page
-(CCMenu*) loadAbout;
-(void) aboutBackPressed;
-(void) dismissAbout;

//Mode Menu
-(CCMenu*) loadMode;
-(void) forwardPressed;
-(void) relaxPressed;
-(void) howToPressed;
-(void) modeBackPressed;
-(void) dismissModeWithSelectedIndex:(NSUInteger)index;

//How To PLay
-(CCMenu*) loadHowTo;
-(void) howNextPressed;
-(void) howBackPressed;
-(void) dismissHowTo;

//Dismiss
-(void) dismissTitle;
-(void) loadForwardScene;
-(void) loadRelaxScene;

@end