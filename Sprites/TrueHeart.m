//
//  TrueHeart.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/27/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "TrueHeart.h"


@implementation TrueHeart

+(CCSprite*) generate:(CGPoint) origin
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSpriteFrame* heartFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"RedHeart_ggj13.png"];
    CCSprite* heart = [CCSprite spriteWithSpriteFrame:heartFrame];
    heart.position = origin;

    
    
    //Moving Actions
    id actionMove = [CCMoveTo actionWithDuration:5.0 
                                        position:ccp(origin.x, winSize.height + heart.contentSize.height/2)];
    
    id actionMoveDone = [CCCallFunc actionWithTarget:heart selector:@selector(removeFromParentAndCleanup:)];
    
    [heart runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    
    //Fade Out Actions
    id actionFade = [CCFadeOut actionWithDuration:3.0];
    [heart runAction:[CCSequence actions:actionFade, nil]];
    
    
    return heart;
}

@end
