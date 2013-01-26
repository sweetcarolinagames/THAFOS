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
#import "FallAction.h"
#import "HitAction.h"
#import "ThrowAction.h"
#import "TurretIdleAction.h"
#import "EnemyIdleAction.h"

#define ENEMY_TAG 1
#define BOOK_TAG 2
#define TURRET_TAG 3
#define WALL_TAG 4

typedef enum
{
    MOVESTATE_NONE = 0,
    RUN = (1 << 0),
    FALL = (1 << 1),
    HIT = (1 << 2),
    THROW = (1 << 3),
    IDLE = (1 << 4)
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
