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
@synthesize goodHeart = _goodHeart;

+(Citizen*)initWithSpriteFrameName:(CitizenGender)g:(CitizenDirection)d;
{
    return [[Citizen alloc] init];
}


-(id)init
{
    if((self = [super init]))
    {
        //random male or female to generate
        _gender = rand()%2;
        NSString *spriteFile = (_gender == CITIZEN_MALE ? @"man_silh_ggj13.png" : @"woman_silh_ggj13.png");

        //we need to check if we're going to update the battery charge icon going up or down
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:
                                spriteFile];
        [self setDisplayFrame:frame];
        
        //pick a random direction to face
        self.dir = rand()%2; 
        
        
        NSLog(@"Sprite text rect for citizen: (%f, %f)", self.textureRect.size.width, self.textureRect.size.height);
        NSLog(@"Bounding box for citizen: (%f, %f)", self.boundingBox.size.width, self.boundingBox.size.height);
//        self.position = ccp(500, 95);
//        _velocity = ccp(-25,0);
//        _runAction = [[RunAction alloc] initWithDurationAndPosition:1 position:_velocity];
//        _hitAction = [[HitAction alloc] initWithDuration:3.0f];
        _goodHeart = NO;
    }

    return self;
}

-(void)run:(CitizenDirection)d
{   
    self.dir = d;
    int dirMod = (_dir == CITIZEN_RIGHT ? 1 : -1);
    
    switch(_gender)
    {
        case CITIZEN_MALE:
            (self.dir == CITIZEN_RIGHT) ? [self setScaleX:-1.0f] : nil;
            break;
        case CITIZEN_FEMALE:
            (self.dir == CITIZEN_LEFT) ? [self setScaleX:-1.0f] : nil;
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
