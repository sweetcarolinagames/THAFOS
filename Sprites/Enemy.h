//
//  Enemy.h
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Character.h"
#import "Collidable.h"

typedef enum {
    NO_OBJ = 0,
    BOOK = (1 << 0),
    WALL = (1 << 1)
}CollisionObj;

@interface Enemy : Character<Collidable> {
    @protected
    RunAction       *_runAction;
    CCRepeatForever *_runAnimAction;
    HitAction       *_hitAction;
    CCAnimate       *_hitAnimAction;
    CGPoint         _velocity;
    BOOL            _converted;
    int             _moneyAmount;
}

@property (nonatomic, readwrite, retain) RunAction *runAction;
@property (nonatomic, readwrite, retain) CCRepeatForever *runAnimAction;
@property (nonatomic, readwrite, retain) HitAction *hitAction;
@property (nonatomic, readwrite, retain) CCAnimate *hitAnimAction;
@property (nonatomic, readwrite) CGPoint velocity;
@property (nonatomic, readwrite) BOOL converted;
@property (nonatomic, readwrite) int  moneyAmount;

-(void)run;
-(void)hit:(CollisionObj)obj;
-(void)hitEnd;
-(CCAnimation *)getRunAnimation;
-(CCAnimation *)getHitAnimation;

@end
