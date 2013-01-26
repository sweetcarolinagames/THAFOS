//
//  PlayerSprite.h
//  runner
//
//  Created by Ian Coleman on 7/1/12.
//  Copyright 2012 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Collidable.h"
#import "PlayerRunAction.h"
#import "PlayerJumpAction.h"
#import "PlayerJumpEaseAction.h"
#import "PlayerFallAction.h"
#import "PlayerFallTerminalAction.h"
#import "PlayerDashAction.h"

#define GRAV 300 //pixels/s

typedef enum {
    NONE = 0,
    RUN = (1 << 0),
    JUMP = (1 << 1),
    DOUBLE_JUMP = (1 << 2),
    DASH = (1 << 3),
    SLIDE = (1 << 4),
    FALL = (1 << 5)
}MoveState;

@interface Player : CCSprite <Collidable> {
    @private
    int     _hits;
    BOOL    _alive;
    CGPoint velocity;
    CGFloat maxDashDistance;
    CGFloat stamina;
    CGFloat maxStamina;
    CGFloat maxFallHeight;
    MoveState moveState;
    CCSpriteBatchNode *spriteSheet;
    PlayerRunAction   *runAction;
    PlayerFallAction  *fallAction;
    CCSequence *jumpAction;
    PlayerFallTerminalAction *fallTermAction;
    CCNode<Collidable> *lastCollider;
    CCNode<Collidable> *currentCollider;
    CollisionLocation lastCollisionLocation;
    CGFloat _collisionPaddingX;  
    CGFloat _collisionPaddingY;
    CGFloat _jumpTouchTimeMax;
}

@property (nonatomic, readonly) int       hits;
@property (nonatomic, readonly) BOOL      alive;
@property (nonatomic, readwrite) CGPoint   velocity;
@property (nonatomic, readwrite) CGFloat   maxDashDistance;
@property (nonatomic, readwrite) CGFloat   stamina;
@property (nonatomic, readwrite) CGFloat   maxStamina;
@property (nonatomic, readwrite) CGFloat   maxFallHeight;
@property (nonatomic, readwrite) MoveState moveState;
@property (nonatomic, readwrite, retain) CCSpriteBatchNode *spriteSheet;
@property (nonatomic, readwrite, retain) PlayerRunAction   *runAction;
@property (nonatomic, readwrite, retain) PlayerFallAction  *fallAction;
@property (nonatomic, readwrite, retain) CCSequence *jumpAction;
@property (nonatomic, readwrite, retain) PlayerFallTerminalAction *fallTermAction;
@property (nonatomic, readwrite, retain) CCNode<Collidable> *lastCollider;
@property (nonatomic, readwrite, retain) CCNode<Collidable> *currentCollider;
@property (nonatomic, readwrite) CollisionLocation lastCollisionLocation;
@property (nonatomic, readonly) CGFloat collisionPaddingX;  
@property (nonatomic, readonly) CGFloat collisionPaddingY;
@property (nonatomic, readwrite) CGFloat jumpTouchTimeMax;


+(Player*) getPlayer;
-(void)initAnimation;
-(void)drawPlayer;
-(void)run;
-(void)takeHit;
-(CCAction *)jump;
-(CCAction *)wallJump:(CollisionLocation)collLoc;
-(void)endJump;
-(CCAction *)dash:(CGPoint)target;
-(CCAction *)dash:(CGPoint)start:(CGPoint)end;
-(void)endDash;
-(void)fall;
-(void)fallForever;
-(void)reachTerminalVelocity;
-(void)slide:(CCNode<Collidable> *)collider;
-(BOOL)isInMoveState:(MoveState)state, ...;
-(void)addMoveState:(MoveState)state;
-(void)removeMoveState:(MoveState)state;
-(void)clearMoveState;
-(void)resetRunAction;
-(void)resetFallAction;
-(void)normalizeStamina;
-(void)flash:(ccColor3B)color:(ccTime)duration;
-(void)resetColor;
-(void)kill;


@end
