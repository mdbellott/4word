//
//  powerup.h
//  4word
//
//  Created by Mark Bellott on 12/29/12.
//  Copyright 2012 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    TIMEBOOST,
    NEWFIRST,
    NEWKEYBOARD,
    BLANKWORD,
    RESET,
} pType;

@interface powerup : CCSprite {
    pType type;
}

@property(nonatomic,readwrite) pType type;

@end
