//
//  tile.h
//  4word
//
//  Created by Mark Bellott on 10/22/12.
//  Copyright 2012 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface tile : CCSprite {
    NSString *letter;
    CGPoint oPos, wPos;
    NSNumber *oIndex;
    NSInteger pointValue;
}

@property(nonatomic, strong) NSString *letter;
@property(nonatomic, readwrite) CGPoint oPos;
@property(nonatomic, readwrite) CGPoint wPos;
@property(nonatomic, strong) NSNumber *oIndex;
@property(nonatomic, readwrite) NSInteger pointValue;

@end
