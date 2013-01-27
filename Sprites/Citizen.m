//
//  Grams.m
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import "Citizen.h"


@implementation Citizen

-(id)initWithSpriteFrameName
{
    
    NSString *spriteFile = CITIZEN_MALE ? @"man_silh_ggj13.png" : @"woman_silh_ggj13.png" ;
    return [[Citizen alloc] initWithSpriteFrameName:spriteFile];
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
        
        _velocity = ccp(-25,0);
        _runAction = [[RunAction alloc] initWithDurationAndPosition:1 position:_velocity];
        _hitAction = [[HitAction alloc] initWithDuration:3.0f];
    }
    
    return self;
}

-(void)run
{    
    self.position = ccp(self.position.x + 3.0f, self.position.y);
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
