//
//  Character.h
//  ggl
//
//  Created by Ian Coleman on 11/9/12.
//  Copyright 2012 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RunAction.h"
#import "HitAction.h"

#define ENEMY_TAG 1

typedef enum
{
    MOVESTATE_NONE = 0,
    RUN = (1 << 0),
    FALL = (1 << 1),
    HIT = (1 << 2),
    THROW = (1 << 3),
    IDLE = (1 << 4),
    // spaceship
    MOVE_IDLE = (1 << 6), 
    MOVE_LEFT = (1 << 7),
    MOVE_RIGHT = (1 << 8)
}MoveState;

@interface Character : CCSprite { // ABSTRACT
    @protected
    MoveState _moveState;
    BOOL _alive;
}

@property (nonatomic, readwrite) MoveState moveState;
@property (nonatomic, readwrite) BOOL alive;

+(CCSprite*) generate:(CGPoint)origin:(CGFloat)offsetHorizontallyBy;
+(CCSprite*) generate:(CGPoint)origin;
-(BOOL)isInMoveState:(MoveState)state, ...;
-(void)addMoveState:(MoveState)state;
-(void)removeMoveState:(MoveState)state;
-(void)clearMoveState;

@end
