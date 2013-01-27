//
//  Grams.m
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import "Citizen.h"


@implementation Citizen
@synthesize dir = _dir;
@synthesize gender = _gender;

+(Citizen*)initWithSpriteFrameName:(CitizenGender)g:(CitizenDirection)d;
{

    NSString *spriteFile = (g == CITIZEN_MALE ? @"man_silh_ggj13.png" : @"woman_silh_ggj13.png");
    Citizen* citizen = (Citizen*) [[Citizen alloc] initWithSpriteFrameName:spriteFile];
    citizen.gender = g;
    citizen.dir = d;
    return citizen;
}


-(id)init
{
    if((self = [super init]))
    {
        CCTexture2D* spriteTex = [self texture];
        [self setTextureRect:CGRectMake(
                                        self.position.x, 
                                        self.position.y, 
                                        spriteTex.contentSize.width, 
                                        spriteTex.contentSize.height)];
    
        
        self.position = ccp(500, 95);
        _velocity = ccp(-25,0);
        _runAction = [[RunAction alloc] initWithDurationAndPosition:1 position:_velocity];
        _hitAction = [[HitAction alloc] initWithDuration:3.0f];
    }

    return self;
}

-(void)run
{   
    int dirMod = (_dir == CITIZEN_RIGHT ? 1 : -1);
    
    switch(_gender)
    {
        case CITIZEN_MALE:
            (_dir == CITIZEN_RIGHT) ? [self setScaleX:-1.0f] : nil;
            break;
        case CITIZEN_FEMALE:
            (_dir == CITIZEN_LEFT) ? [self setScaleX:-1.0f] : nil;
            break;
        default:
            break;
    }
    
    CCJumpBy *jumpAction = [[CCJumpBy alloc] initWithDuration:0.5 position:ccp(dirMod*20,0) height:30 jumps:1];
    CCRepeatForever *jumpForeverAction = [[CCRepeatForever alloc] initWithAction:jumpAction];
    [self runAction:jumpForeverAction];
}

-(void)hit:(CollisionObj)obj
{    

}

-(CCAnimation *)getRunAnimation
{
    NSMutableArray *animFrames = [NSMutableArray array];
    const int frameCount = 4;
    NSString *filePath, *prefix, *mod, *postfix;
    
    filePath = @"";
    prefix = @"grams_";
    mod = (_converted ? @"convinced_" : @"");
    postfix = @"run%d.png";
    filePath = [filePath stringByAppendingString:prefix];
    filePath = [filePath stringByAppendingString:mod];
    filePath = [filePath stringByAppendingString:postfix];
    
    
    for(int i = 1; i <= frameCount; ++i) {
        [animFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:filePath, i]]];
    }
    CCAnimation *anim = [CCAnimation animationWithFrames:animFrames delay:0.15f]; 
    
    return anim;
}

-(CCAnimation *)getHitAnimation
{
    NSMutableArray *animFrames = [NSMutableArray array];
    const int frameCount = 6;
    
    for(int i = 1; i <= frameCount; ++i) {
        [animFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"grams_hit%d.png", i]]];
    }
    CCAnimation *anim = [CCAnimation animationWithFrames:animFrames delay:0.15f]; 
    
    return anim;
}

@end
