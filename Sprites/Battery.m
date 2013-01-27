//
//  Battery.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "Battery.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "math.h"

@interface Battery (private)

-(NSString*) getChargeLevelIconName: (CGFloat) chargeLevel;

@end


@implementation Battery
@synthesize batteryDecay;
@synthesize doFirstBatteryLifeWarning = _doFirstBatteryLifeWarning;
@synthesize doSecondBatteryLifeWarning = _doSecondBatteryLifeWarning;

-(id) init
{
    if ((self = [super init])) 
    {
        [self setBatteryLife:100.0];
        _batteryDecay = 0.1;
        self.doFirstBatteryLifeWarning  = YES;
        self.doSecondBatteryLifeWarning = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.position  = ccp(winSize.width*11/12, winSize.height*15/17);
        
        
        [self schedule:@selector(decay:) interval:0.1]; //sec.
    }
    
    return self;
}


-(void) decay:(ccTime) dt
{
    [self setBatteryLife:[self getBatteryLife] - _batteryDecay];
    
    if([self getBatteryLife] < 66.6 && [self doFirstBatteryLifeWarning])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"zap1.mp3"];
        self.doFirstBatteryLifeWarning = NO;
    }
    
    if ([self getBatteryLife] < 33.3 && [self doSecondBatteryLifeWarning]) 
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"zapTwoTone2.mp3"];
        self.doSecondBatteryLifeWarning = NO;
    }
}


-(CGFloat) getBatteryLife
{
    return _batteryLife;
}


-(void) setBatteryLife:(CGFloat)batteryLife
{
    if (batteryLife != _batteryLife) 
    {
        //we need to check if we're going to update the battery charge icon going up or down
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                    spriteFrameByName:
                                        [self getChargeLevelIconName:batteryLife]];
        [self setDisplayFrame:frame];
    }
    
    _batteryLife = batteryLife;
    
    if(_batteryLife > 100.0) 
        _batteryLife = 100.0;
    
    if(_batteryLife < 0.0)
        _batteryLife = 0.0;
}


-(NSString*) getChargeLevelIconName:(CGFloat)chargeLevel
{
    int iconIndex =  (BATTERY_STAGES - ceil(chargeLevel/BATTERY_STAGE_DELTA));
//    NSString *log = [NSString stringWithFormat:@"%f charge gives %d index", chargeLevel, iconIndex];
//    NSLog(log);
    return [NSString stringWithFormat:@"battery%d.png", iconIndex];
}

@end
