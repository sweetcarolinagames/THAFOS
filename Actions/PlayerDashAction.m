//
//  PlayerDashAction.m
//  runner
//
//  Created by Ian Coleman on 10/6/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import "PlayerDashAction.h"


@implementation PlayerDashAction
    
@synthesize distance;

+(id)action:(ccTime)duration position:(CGPoint)deltaPosition distance:(float)dist
{    
    // get hypotenuse of deltaPosition triangle
    float totalDistance = sqrt(powf(deltaPosition.x, 2) + powf(deltaPosition.y, 2));
    // get ratio of dist to touch distance
    float distanceRatio = dist/totalDistance;
    CGPoint croppedPosition = ccpMult(deltaPosition, distanceRatio);
    
    return [[self alloc] init:duration position:croppedPosition distance:dist];
}

-(id)init:(ccTime)duration position:(CGPoint)deltaPosition distance:(float)dist
{
    CCMoveBy *dashAction = [CCMoveBy actionWithDuration:duration position:deltaPosition];
    
    if((self = [super initWithAction:dashAction rate:2]))
    {
        self.distance = dist;
    }
    
    return self;
}

-(void)startWithTarget:(id)target
{
    NSLog(@"START_DASH");
    [super startWithTarget:target];
}

@end
