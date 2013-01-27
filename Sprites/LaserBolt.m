//
//  LaserBolt.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/27/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "LaserBolt.h"
#import "Constants.h"

@implementation LaserBolt


+(CCSprite*) generate:(CGPoint) origin
{
    CCSpriteFrame* laserFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Laser_ggj13.png"];
    
    CCSprite* laser = [CCSprite spriteWithSpriteFrame:laserFrame];
    laser.position = origin;
    laser.tag = LASER_TAG;
    
    
    //Moving Actions
    id actionMove = [CCMoveTo actionWithDuration:1.0 
                                        position:ccp(origin.x, -laser.contentSize.height/2)];
    
    id actionMoveDone = [CCCallFunc actionWithTarget:laser selector:@selector(removeFromParentAndCleanup:)];
    
    [laser runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    return laser;
}


+(CCSprite*) generate:(CGPoint) origin:(CGFloat) offsetVerticallyBy
{
    return [LaserBolt generate:ccp(origin.x, origin.y - offsetVerticallyBy)];
}


#pragma mark Collideable Protocol Methods

-(CollisionLocation)collide:(CCNode *)collidableSprite
{
    return nil;
}

-(BOOL)collideWithRect:(CGRect)rect
{
    return NO;
}

-(BOOL)collideWithSprite:(CCSprite *)sprite
{
    return NO;
}

-(void)drawBoundingBox:(float)lineWidth: (float)pointSize: (ccColor4B)color
{
    
}



@end
