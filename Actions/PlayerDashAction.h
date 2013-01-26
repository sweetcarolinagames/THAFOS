//
//  PlayerDashAction.h
//  runner
//
//  Created by Ian Coleman on 10/6/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayerDashAction : CCEaseOut {
    float distance;
}

@property (nonatomic, readwrite) float distance;

+(id)action:(ccTime)duration position:(CGPoint)deltaPosition distance:(float)dist;
-(id)init:(ccTime)duration position:(CGPoint)deltaPosition distance:(float)dist;

@end
