//
//  HitAction.m
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import "HitAction.h"


@implementation HitAction

@synthesize animation = _animation;
@synthesize animAction = _animAction;
@synthesize started = _started;

-(void)startWithTarget:(id)target
{
    [super startWithTarget:target];
    // run the animation
    [target runAction:_animAction];
}

@end
