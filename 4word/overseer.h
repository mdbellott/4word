//
//  overseer.h
//  4word
//
//  Created by Mark Bellott on 12/20/12.
//  Copyright 2012 Mark Bellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface overseer : CCNode {
    
    NSInteger vowelCounter;
    
}

@property(nonatomic, readwrite) NSInteger vowelCounter;

@end
