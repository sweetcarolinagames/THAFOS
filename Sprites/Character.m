//
//  Character.m
//  ggl
//
//  Created by Ian Coleman on 11/9/12.
//  Copyright 2012 Sweet Carolina Games. All rights reserved.
//

#import "Character.h"


@implementation Character

@synthesize moveState = _moveState;
@synthesize alive = _alive;

+(CCSprite *) generate:(CGPoint)origin{return nil;}
+(CCSprite *) generate:(CGPoint)origin:(CGFloat)offsetHorizontallyBy{return nil;}

#pragma mark MoveState methods
/*
 * Logical OR method that returns true if player is in 
 * ANY state in argument list
 * @param firstState start of variable length list of params
 * @param ... represents rest of list of MoveState's after firstState
 * @return BOOL YES if player is in ANY of param states; NO if in none
 */
-(BOOL)isInMoveState:(MoveState)firstState, ...
{
    va_list args;
    va_start(args, firstState);
    
    for(MoveState currState = firstState; currState > MOVESTATE_NONE; currState = va_arg(args, MoveState))
    {
        if(_moveState & currState)
            return YES;
    }
    va_end(args);
    
    return NO;
}

-(void)addMoveState:(MoveState)state
{
    _moveState |= state;
}

-(void)removeMoveState:(MoveState)state
{
    _moveState &= ~state;
}

-(void)clearMoveState;
{
    [self setMoveState:MOVESTATE_NONE];
}

@end
