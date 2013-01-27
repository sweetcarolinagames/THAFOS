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


+(LaserBolt*) generate:(CGPoint) origin
{
    CCSpriteFrame* laserFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Laser_ggj13.png"];
    
    LaserBolt* laser = [LaserBolt spriteWithSpriteFrame:laserFrame];
    laser.position = origin;
    laser.tag = LASER_TAG;
    
    
    //Moving Actions
    id actionMove = [CCMoveTo actionWithDuration:1.0 
                                        position:ccp(origin.x, -laser.contentSize.height/2)];
    
    id actionMoveDone = [CCCallFunc actionWithTarget:laser selector:@selector(removeFromParentAndCleanup:)];
    
    [laser runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    NSLog(@"Sprite text rect for laser: (%f, %f)", laser.textureRect.size.width, laser.textureRect.size.height);
    NSLog(@"Bounding box for laser: (%f, %f)", laser.boundingBox.size.width, laser.boundingBox.size.height);

    
    return laser;
}


+(CCSprite*) generate:(CGPoint) origin:(CGFloat) offsetVerticallyBy
{
    return [LaserBolt generate:ccp(origin.x, origin.y - offsetVerticallyBy)];
}


#pragma mark Collideable Protocol Methods

-(CollisionLocation)collide:(CCNode *)collidableSprite
{
    CGFloat playerMinY, playerMaxY, playerMinX, playerMaxX; 
    CGFloat collidableMinY, collidableMaxY, collidableMinX, collidableMaxX;
    BOOL collide;
    const int collisionThreshold = 10; //pixels
    
    // do we collide?
    collide = [self collideWithRect:[collidableSprite boundingBox]];
    
    if(collide)
    {
//        NSLog(@"collided!!!");
        // get boundaries for player
        playerMinY = CGRectGetMinY([self boundingBox]);
        playerMaxY = CGRectGetMaxY([self boundingBox]);
        playerMinX = CGRectGetMinX([self boundingBox]);
        playerMaxX = CGRectGetMaxX([self boundingBox]);
        
        // get boundaries for collidable
        collidableMinY = CGRectGetMinY([collidableSprite boundingBox]) + 40;
        collidableMaxY = CGRectGetMaxY([collidableSprite boundingBox]) - 150;
        collidableMinX = CGRectGetMinX([collidableSprite boundingBox]) + 150;
        collidableMaxX = CGRectGetMaxX([collidableSprite boundingBox]) - 150;
        
        if(fabsf(playerMinY - collidableMaxY) < collisionThreshold)
        {
            NSLog(@"COLLIDE_TOP");
            return TOP;
        }
        if(fabsf(playerMaxY - collidableMinY) < collisionThreshold)
        {
            //            NSLog(@"COLLIDE_BOTTOM");
            return BOTTOM;
        }
        if(fabsf(playerMaxX - collidableMinX) < collisionThreshold)
        {
            //            NSLog(@"COLLIDE_LEFT");
            return LEFT;                    
        }
        if(fabsf(playerMinX - collidableMaxX) < collisionThreshold)
        {
            //            NSLog(@"COLLIDE_RIGHT");
            return RIGHT;
        }
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

/*
 * Draw bounding box around player sprite to
 * visualize collision boundary
 * @param lineWidth
 * @param pointSize 
 * @param color
 * @return
 */

-(void)drawBoundingBox:(float)lineWidth: (float)pointSize: (ccColor4B)color
{
    float bbMinX, bbMinY, bbHeight, bbWidth;
    CGRect boundBox;
    
    boundBox = [self boundingBox];
    bbMinX = CGRectGetMinX(boundBox);
    bbMinY = CGRectGetMinY(boundBox);
    bbHeight = boundBox.size.height;
    bbWidth = boundBox.size.width;
    
    //Set line width.
	glLineWidth(lineWidth);
	//Set point size
	glPointSize(pointSize);
	//Enable line smoothing
	glEnable(GL_LINE_SMOOTH);
    // set color
    glColor4ub(color.r, color.g, color.b, color.a);
    // populate array of bounding box vertices
    CGPoint bbVert1 = ccp(bbMinX, bbMinY);
    CGPoint bbVert2 = ccp(bbMinX, bbMinY + bbHeight);
    CGPoint bbVert3 = ccp(bbMinX + bbWidth, bbMinY + bbHeight);
    CGPoint bbVert4 = ccp(bbMinX + bbWidth, bbMinY);
    CGPoint bbVertices[4] = { bbVert1, bbVert2, bbVert3, bbVert4 };
    // draw rectangle for bounding box    
    ccDrawPoly(bbVertices, 4, YES);  
    
}


@end
