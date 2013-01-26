//
//  PlayerRunAction.h
//  runner
//
//  Created by Ian Coleman on 10/13/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "PlayerRunStepAction.h"
//#import "Player.h"

@interface PlayerRunAction : CCRepeatForever {
    @protected 
    BOOL started;
//    CCAnimation *runAnim;
//    CCRepeatForever *runAnimAction;
}

@property (nonatomic, readwrite) BOOL started;
//@property (nonatomic, readwrite, retain) CCAnimation *runAnim;
//@property (nonatomic, readwrite, retain) CCRepeatForever *runAnimAction;


+(id)actionWithVelocity:(CGPoint)vel;
-(id)initWithVelocity:(CGPoint)vel;
-(CCRepeatForever *)animAction;

@end
