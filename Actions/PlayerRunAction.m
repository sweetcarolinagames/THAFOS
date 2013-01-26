//
//  PlayerRunAction.m
//  runner
//
//  Created by Ian Coleman on 10/13/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import "PlayerRunAction.h"
#import "Player.h"


@implementation PlayerRunAction

@synthesize started;

+(id)actionWithVelocity:(CGPoint)vel
{
    return [[self alloc] initWithVelocity:vel];
}

-(id)initWithVelocity:(CGPoint)vel
{
    PlayerRunStepAction *runStepAction = [PlayerRunStepAction actionWithDuration:1 position:vel];
//    CCMoveBy *runStepAction = [CCMoveBy actionWithDuration:1 position:ccp(0,0)];
    if((self = [super initWithAction:runStepAction]))
    {
        // init stuff
    }
    
    return self;
}

-(CCRepeatForever *)animAction
{
    CCAnimation *runAnim;
    CCRepeatForever *runAnimAction;
    
    // setup & run animation
    NSMutableArray *runAnimFrames = [NSMutableArray array];
    const int frameCount = 6;
    
    for(int i = 1; i <= frameCount; ++i) {
        [runAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"ninja_run%d.png", i]]];
    }
    runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.15f];    
    runAnimAction = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]];
    
    return runAnimAction;
}

-(void)startWithTarget:(id)target
{
    [super startWithTarget:target];
    NSLog(@"START_RUN");
    self.started = YES;
    CCRepeatForever *runAnimAction; 
    runAnimAction = [self animAction];
    [target runAction:runAnimAction];
}

@end
