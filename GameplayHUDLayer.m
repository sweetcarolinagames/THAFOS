//
//  GameplayHUDLayer.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameplayHUDLayer.h"
#import "Battery.h"


@implementation GameplayHUDLayer

-(id) init
{
    if ((self = [super init])) 
    {
        _batteryMeter = [[Battery alloc] init];
        [self addChild:_batteryMeter];
    }
    
    return self;
}


-(void) dealloc
{
    [super dealloc];
    
    [_batteryMeter release];
    
    _batteryMeter = nil;    
}

@end
