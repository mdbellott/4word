//
//  playLayer.h
//  4word
//
//  Created by Mark Bellott on 10/16/12.
//  Copyright 2012 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuLayer.h"
#import "tile.h"
#import "powerup.h"
#import "overseer.h"
#import "ABGameKitHelper.h"

typedef enum{
    THREE,
    FOUR,
    FIVE,
    SIX
} length;

@interface playLayer : CCLayer {
    length currentLength;
    
    CGSize winSize;
    CGRect tileSize, powerupSize;
    
    NSMutableString *saveWord, *bestWord;
    NSInteger bestWordScore;
    
    BOOL timerPaused, wordIsBlank, keepFlicker, gamePaused, allowTouches, allowPowerUps;
    
    ccTime currentTimer;
    
    NSInteger vowelCounter, letterCount, wCounter, score, multiplier, timerValue, progressCounter;
    
    CGPoint kpos01, kpos02, kpos03, kpos04, kpos05, kpos06, kpos07, kpos08, kpos09, kpos10, kpos11, kpos12, kpos13, kpos14, kpos15, kpos16, kpos17, kpos18, kpos19, kpos20;
    CGPoint pos31, pos32, pos33, pos41, pos42, pos43, pos44, pos51, pos52, pos53, pos54, pos55,
    pos61, pos62, pos63, pos64, pos65, pos66;
    CGPoint powerPos01, powerPos02, powerPos03, powerPos04, initialTilePos;
    CGPoint multiPosOff, multiPosOn;
    CGPoint lifeDismiss;
    
    NSString *tmpLetter, *scoreString, *multiplierString;
    NSMutableString *playWord;
    
    CCLabelTTF *currentMultiplier, *currentScore;
    
    CCSprite *pBlank01, *pBlank02, *pBlank03, *pBlank04;
    CCSprite *tBlank01, *tBlank02, *tBlank03, *tBlank04, *tBlank05, *tBlank06;
    CCSprite *backgroundSprite, *keyboardBackground;
    CCSprite *lifeOne, *lifeTwo, *lifeThree, *lifeFour;
    CCSprite *timerBar, *topBar, *scoreBar;
    CCSprite *multOne, *multTwo, *multThree, *multFour;
    CCSprite *gamePausedSprite, *gameOverNotBestSprite, *gameOverNewBestSprite;
    CCSprite *counterBlank, *counterOne, *counterTwo, *counterThree, *counterFour;
    
    CCTexture2D *timerBlue, *timerRed, *backgroundBlue, *backgroundRed;
    
    CCMenuItemImage *backspaceButton, *shuffleButton, *pauseButton, *resumeButton, *menuButton, *playAgainButton;
    CCMenu *keyboardButtonMenu, *pauseMenu, *gamePausedMenu, *gameOverMenu;;
    
    NSArray *wordListThree, *wordListFour, *wordListFive, *wordListSix;
    NSMutableArray *letterBank, *vowelBank, *consonantBank, *firstBank, *tmpArray;
    NSMutableArray *keyboardLetters, *usedLetters, *keyboardTiles, *wordTiles, *usedTiles, *replacementTiles;
    NSMutableArray *lives, *powerups;
    
    tile *tileFirst;
    
    powerup *powerupOne, *powerupTwo, *powerupThree, *powerupFour;
    
    overseer *tOverseer;

    NSUserDefaults *defaults;
    NSMutableDictionary *tmpHighScores;
    NSString *bestScoreString, *currentScoreString, *bestWordString, *scoreTag, *scoreDictionaryTag;
    CCLabelTTF *bestScoreLabel, *currentScoreLabel, *bestWordLabel;
    NSInteger scoreOne, scoreTwo, scoreThree, scoreFour;
    
}

+(CCScene *) scene;

//Init Methods
-(void) setUpDictionaries;
-(void) loadPositions;
-(void) loadImages;
-(void) loadBlanks;
-(void) loadMultipliers;
-(void) loadBars;
-(void) loadLives;
-(void) loadKeyboardButtons;
-(void) loadScoreItems;
-(void) loadLetters;
-(void) loadKeyboad;
-(void) loadFirstLetter;
-(void) loadFirstWithPrevious:(NSString*)f;

//Background Methods
-(void) setBackgroundBlue;
-(void) setBackgroundRed;
-(void) flickerBackground;

//Animate Methods
-(void) animateLives;
-(void) animateBars;
-(void) animateKeyboardButtons;
-(void) animateInitialKeyboard;
-(void) animatePowerupKeyboard;
-(void) animateFirstLetter;
-(void) animateReplaceKeyboard;
-(void) animateInvalidWord;
-(void) animateLifeLost;

//Counter Methods;
-(void) loadCounter;
-(void) updateCounter;
-(void) resetCounter;

//Pause Methods
-(void) loadPause;
-(void) pausePressed;
-(void) loadGamePaused;
-(void) loadGameResumed;
-(void) pausedMenuPressed;
-(void) pausedResumePressed;
-(void) dismissPauseScreenToMenu;

//Word Handling Methods
-(void) addLetter: (NSString*)nLetter;
-(void) removeLastLetter;
-(void) resetWordWithFirstLetter: (NSString*)fLetter;
-(BOOL) checkWord;
-(void) resetWord;

//Word Blank Methods
-(void) updateWordBlanks;
-(void) resetWordBlanks;

//Tile Methods
-(tile*) makeTile:(NSString *)letterIn;
-(void) handleKeyboardTile: (tile*)t;
-(void) dismissWord;
-(void) replaceTiles;
-(void) backspacePressed;
-(void) shufflePressed;
-(void) updateVowelCounter;

//Input Handling Methods
-(void) registerWithTouchDispatcher;
-(BOOL) ccTouchBegan: (UITouch *)touch withEvent: (UIEvent *)event;
-(void) ccTouchEnded: (UITouch *)touch withEvent: (UIEvent *)event;
-(tile*) getKeyboardTileAtPoint: (CGPoint) p;

//Scoring Methods
-(void) updateMultipliers;
-(void) updateScore;

//Timer Methods
-(void) resetTimer;
-(void) runTimerWithTime: (ccTime)timeLimit;
-(void) tick: (ccTime)dt;
-(void) pauseTimer;
-(void) resumeTimer;

//Gamplay Elements
-(void) loseLife;
-(void) gameOver;
-(void) loadGameOverNotBest;
-(void) loadGameOverNewBest;
-(void) handleNewScore;
-(void) gameOverNotMenuPressed;
-(void) gameOverNewMenuPressed;
-(void) playAgainNotPressed;
-(void) playAgainNewPressed;

//PowerUp Methods
-(void) powerUpTest;
-(void) newPowerup;
-(powerup*) makePowerupOfType: (pType)typeIn;
-(void) dismissPowerup: (powerup*)p;
-(void) rearrangePowerups;
-(void) handlePowerup:(powerup*)p;
-(void) timeBoostPowerup;
-(void) newFirstPowerup;
-(void) newKeyboardPowerup;
-(void) blankWordPowerup;
-(void) dismissFirstFromBlank;
-(void) enablePowerUps;
-(void) disablePowerUps;

//Misc Methods
-(void) hideEverythingForDismiss;
-(void) returnToMainMenu;
-(void) reloadCurrentScene;
-(void) arrayCleanup;
-(void) disableTouch;
-(void) enableTouch;


@end
