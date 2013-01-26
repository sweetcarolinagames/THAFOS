//
//  Enemy.m
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import "Enemy.h"


@implementation Enemy

@synthesize runAction = _runAction;
@synthesize runAnimAction = _runAnimAction;
@synthesize hitAction = _hitAction;
@synthesize hitAnimAction = _hitAnimAction;
@synthesize velocity = _velocity;
@synthesize converted = _converted;
@synthesize moneyAmount = _moneyAmount;

+(CCSprite *)generate:(CGPoint)origin
{
//    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *sprite = [[[self class] alloc] initWithSpriteFrameName];
    sprite.position = origin;
//    [sprite fall:ccp(origin.x, winSize.height + sprite.contentSize.height/2)];
    [sprite run];
    
    return sprite;
}

+(CCSprite *)generate:(CGPoint)origin :(CGFloat)offsetHorizontallyBy
{
    return [Enemy generate:ccp(origin.x+offsetHorizontallyBy, origin.y)];
}

-(void)run{}
-(void)hit:(CollisionObj)obj{}

-(void)hitEnd
{
    [self removeFromParentAndCleanup:YES];
}

-(CCAnimation *)getRunAnimation{return nil;}
-(CCAnimation *)getHitAnimation{return nil;}

#pragma mark Collideable Protocol Methods
/*
 * Returns type of collision with collider
 * @param collider object to test collision againts
 * @return pointer to dash action executed
 */
-(CollisionLocation)collide:(Character *)collider
{
    CGFloat playerMinY, playerMaxY, playerMinX, playerMaxX; 
    CGFloat collidableMinY, collidableMaxY, collidableMinX, collidableMaxX;
    BOOL collide;
//    const int collisionThresholdX = 10; //pixels
//    const int collisionThresholdY = 10; //pixels
    
    // do we collide?
    collide = [self collideWithRect:[collider boundingBox]];
    
    if(collide)
    {
        // get boundaries for player
        playerMinY = CGRectGetMinY([self boundingBox]);
        playerMaxY = CGRectGetMaxY([self boundingBox]);
        playerMinX = CGRectGetMinX([self boundingBox]);
        playerMaxX = CGRectGetMaxX([self boundingBox]);
        
        // get boundaries for collidable
        collidableMinY = CGRectGetMinY([collider boundingBox]);
        collidableMaxY = CGRectGetMaxY([collider boundingBox]);
        collidableMinX = CGRectGetMinX([collider boundingBox]);
        collidableMaxX = CGRectGetMaxX([collider boundingBox]);

        //todo: fix, 
        // for now, all collisions are equal
        return TOP;
        
//        if(fabsf(playerMinY - collidableMaxY) <=  collisionThresholdY) 
//        {
//            return TOP;
//        }
//        if(fabsf(playerMaxY - collidableMinY) <= collisionThresholdY)
//        {
//            return BOTTOM;
//        }
//        if(fabsf(playerMaxX - collidableMinX) <= collisionThresholdX)
//        {
//            return LEFT;                    
//        }
//        if(fabsf(playerMinX - collidableMaxX) <= collisionThresholdX)
//        {
//            return RIGHT;
//        }
    }
    
    return NO_COLLISION;
}

-(BOOL)collideWithRect:(CGRect)rect
{   
    return CGRectIntersectsRect(self.boundingBox, rect);
}

-(BOOL)collideWithSprite:(CCSprite *)sprite
{
    return [self collideWithRect:[sprite boundingBox]];
}

-(void)drawBoundingBox:(float)lineWidth: (float)pointSize: (ccColor4B)color
{
    // NOTHING
}
@end
