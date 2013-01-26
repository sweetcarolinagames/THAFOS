//
//  Collidable.h
//
//  Created by Ian Coleman on 9/22/12.
//  Copyright (c) 2012 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum 
{
    NO_COLLISION = 0,
    TOP,
    RIGHT,
    BOTTOM,
    LEFT
} CollisionLocation;

@protocol Collidable

@optional

@required
-(CollisionLocation)collide:(CCNode *)collidableSprite;
-(BOOL)collideWithRect:(CGRect)rect;
-(BOOL)collideWithSprite:(CCSprite *)sprite;
-(void)drawBoundingBox:(float)lineWidth: (float)pointSize: (ccColor4B)color;
@end
