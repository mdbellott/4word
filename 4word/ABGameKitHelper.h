//
//  ABGameKitHelper.h
//  4word -- Mark Bellott
//
//  Created by Alexander Blunck on 27.02.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//
//  https://github.com/ablfx/ABGameKitHelper
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface ABGameKitHelper : NSObject <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>

@property (nonatomic) BOOL isAuthenticated;
@property (nonatomic) BOOL isActivated;

+ (id)sharedClass;

-(void) authenticatePlayer;
-(void) showAchievements;
-(void) showLeaderboard:(NSString*)leaderboardID;
-(void) reportScore:(int)score forLeaderboard:(NSString*)leaderboardName;
-(void) reportAchievement:(NSString*)identifier percentComplete:(float)percent;

-(void) resetAchievements;

-(void) showNotification:(NSString*)title message:(NSString*)message identifier:(NSString*)identifier;

@end

