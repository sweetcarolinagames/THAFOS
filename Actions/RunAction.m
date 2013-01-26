//
//  RunAction.m
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import "RunAction.h"


@implementation RunAction

@synthesize animation = _animation;
@synthesize animAction = _animAction;
@synthesize started = _started;

-(id)initWithDurationAndPosition:(ccTime)d position:(CGPoint)pos
{
    CCMoveBy *runAction = [CCMoveBy actionWithDuration:d position:pos];
    
    if((self = [super initWithAction:runAction]))
    {
        
    }
    
    return self;
}

-(void)startWithTarget:(id)target
{
    [super startWithTarget:target];
    // run the animation
//    [target runAction:_animAction];
}

@end
