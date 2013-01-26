//
//  Player.m
//  runner
//
//  Created by Ian Coleman on 7/1/12.
//  Copyright 2012 Sweet Carolina Games. All rights reserved.
//

#import "Player.h"
#import "SimpleAudioEngine.h"
#define MAX_HITS 3

@implementation Player

@synthesize velocity, maxDashDistance, stamina, maxStamina,
            maxFallHeight, moveState, spriteSheet, runAction,
            fallAction, fallTermAction, jumpAction, 
            lastCollider, currentCollider, lastCollisionLocation;
@synthesize hits  = _hits;
@synthesize alive = _alive;
@synthesize collisionPaddingX = _collisionPaddingX;
@synthesize collisionPaddingY = _collisionPaddingY;
@synthesize jumpTouchTimeMax = _jumpTouchTimeMax;

static CGFloat jumpStaminaValue;
static CGFloat wallJumpStaminaValue;
static CGFloat dashStaminaValue;
static Player *singletonPlayer;

+(Player*) getPlayer
{
    return singletonPlayer;
}

+(void)initialize {
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"playerAnim.plist"];    
        singletonPlayer = [[Player alloc] initWithSpriteFrameName:@"ninja_run1.png"];
    }
}

-(id)init
{    
    if((self = [super init]))
    {   
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.runAction  = [[PlayerRunAction action] retain];
        self.fallAction = [[PlayerFallAction action] retain];
        self.fallTermAction  = [[PlayerFallTerminalAction actionWithDuration:0] retain];
        self.maxDashDistance = 100;
        self.maxStamina      = 100;
        self.stamina         = self.maxStamina;
        self.velocity = ccp(0.0, 0.0);
        self.position = ccp(winSize.width/4, 100);
        _hits  = 0;
        _alive = YES;
        _collisionPaddingX = 0;
        _collisionPaddingY = 0;

        dashStaminaValue     = self.maxStamina * 0.15f;
        moveState = FALL;
        
        CCTexture2D* spriteTex = [self texture];
        [self setTextureRect:CGRectMake(
                                   self.position.x, 
                                   self.position.y, 
                                   spriteTex.contentSize.width, 
                                   spriteTex.contentSize.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"playerAnim.plist"];    
    }
    
    return self;
}

// todo: rename
-(void)initAnimation
{
    self.spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"playerAnim.png"];
    [self.spriteSheet addChild:self]; // clarification: spriteSheet obj contained in Player obj, but Player sprite is child sprite of spriteSheet 
}

// draw player bounding box & other player-related graphics
-(void)drawPlayer
{ 
    [self drawBoundingBox:1.0f: 16: ccc4(255, 0, 0, 255)];
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
    bbMinX = CGRectGetMinX(boundBox) - _collisionPaddingX;
    bbMinY = CGRectGetMinY(boundBox) - _collisionPaddingY;
    bbHeight = boundBox.size.height + _collisionPaddingY*2;
    bbWidth = boundBox.size.width + _collisionPaddingX*2;
    
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


/**
 * Makes player run to right at self's velocity
 */
-(void)run
{    
    if(self.lastCollider != self.currentCollider)
    {
        [self clearMoveState];
        [self addMoveState:RUN];
        [self resetFallAction];
        
        if(self.runAction != nil)
        {
            // only start running if not already started
            if(!self.runAction.started) 
            {
                [self setVelocity:ccp(0,0)];
                 self.runAction = [PlayerRunAction actionWithVelocity:self.velocity];
                [self runAction:self.runAction];
            }
        }
    }
    // gradually restore player stamina
    self.stamina += 0.25;
    [self normalizeStamina];
}

/**
 * Makes the player take a hit.
 */
-(void) takeHit
{
    if(++_hits > MAX_HITS)
    {
        _alive = NO;
        _hits  = 0;
    }
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"hit.mp3"];
    
    
    // do hit animation
    CCAnimation *hitAnim;
    CCRepeatForever *hitAnimAction;
    
    // setup & run animation
    NSMutableArray *hitAnimFrames = [NSMutableArray array];
    const int frameCount = 1;
    const CGFloat hitAnimDuration = 0.5f;
    
    for(int i = 1; i <= frameCount; ++i) {
        [hitAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"ninja_hit%d.png", i]]];
    }
    hitAnim = [CCAnimation animationWithFrames:hitAnimFrames delay:hitAnimDuration];    
    hitAnimAction = [CCAnimate actionWithDuration:hitAnimDuration animation:hitAnim restoreOriginalFrame:NO];
    [self runAction:hitAnimAction];
    [self flash:ccc3(255, 0, 0) :hitAnimDuration];
    
}


/*
 * Makes player do parabolic jump
 * @param
 * @return pointer to jump action sequence
 */
-(CCAction *)jump
{
    PlayerJumpAction *myJumpAction = nil;
    CCCallFunc *endJumpAction = nil;
    CCSequence *jumpActionSequence = nil;
    
    if(self.stamina >= jumpStaminaValue)
    {
        [self clearMoveState];
        [self addMoveState:JUMP];
        [self resetRunAction];
        [[SimpleAudioEngine sharedEngine]playEffect:@"jump.mp3"];
        
        const float jumpHeight = 45;
        const float jumpDistance = [self velocity].x;
        myJumpAction = [[PlayerJumpAction actionWithDuration:0.5 position:ccp(jumpDistance, jumpHeight) height:jumpHeight jumps:1] retain];
        endJumpAction = [[CCCallFunc actionWithTarget:self selector:@selector(endJump)] retain];
        jumpActionSequence = [[CCSequence actions:myJumpAction, endJumpAction, nil] retain];
        [self setJumpAction:jumpActionSequence];
        [self runAction:jumpActionSequence];
        
        self.stamina -= jumpStaminaValue;
        [self normalizeStamina];
    }
    else 
    {
        [self flash:ccc3(255, 255, 0) :0.25];
    }
    
    return jumpActionSequence;
}

-(CCAction *)wallJump:(CollisionLocation)collLoc

/*
 * Ends jumping state & clears flag that allows player to begin falling
 * when jump is finished
 */
-(void)endJump
{
    [self removeMoveState:JUMP];
    [self resetFallAction];
}

/*
 * Makes player dash in direction of target
 * @param target position for player to dash to
 * @return pointer to dash action executed
 */
-(CCAction *)dash:(CGPoint)target
{    
    return [self dash:self.position :target];
}

-(CCAction *)dash:(CGPoint)start:(CGPoint)end
{
    PlayerDashAction *dashAction = nil;
    CCCallFunc *endDashAction = nil;
    CCSequence *dashActionSequence = nil;
    
    if(self.stamina >= dashStaminaValue)
    {
    
        [self clearMoveState];
        [self addMoveState:DASH];
        [self resetFallAction];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"dash.mp3"];
        CGFloat dashX = 0; // 0 since we don't want to move horizontally
        CGFloat dashY = end.y - start.y;
        const CGPoint dashDelta = ccp(dashX, dashY);
        const ccTime dashTime = 0.25f;
        const CGFloat normVelFactor = 1.0f/dashTime;
        const CGPoint newVel = ccpMult(dashDelta, normVelFactor);
        
        dashAction = [[PlayerDashAction action:dashTime position:dashDelta distance:self.maxDashDistance] retain];
        endDashAction = [[CCCallFunc actionWithTarget:self selector:@selector(endDash)] retain];
        dashActionSequence = [[CCSequence actions:dashAction, endDashAction, nil] retain];
        [self runAction:dashActionSequence];
//        [self setVelocity:ccpMult(newVel, 0.25f)]; // maintain 1/4 of momentum
        [self setVelocity:ccp(0,0)]; // set to zero so falling won't change position either
        
        self.stamina -= dashStaminaValue;
        [self normalizeStamina];
    }
    else 
    {
        [self flash:ccc3(255, 255, 0) :0.25];
    }
    
    return dashActionSequence;
}

// Ends dashing state
-(void)endDash
{
    [self removeMoveState:DASH];
}


-(void)fall
{
    [self clearMoveState];
    [self addMoveState:FALL];
    [self resetRunAction];
    
//    if(self.fallTermAction != nil)
//    {
//        if(!self.fallTermAction.started)
//        {
            [self fallForever];
//            const float force = 50;
//            PlayerFallStepAction *fallStepAction = [PlayerFallStepAction actionWithDuration:0.5 position:ccp(0, -force)];
//            self.fallTermAction = [PlayerFallTerminalAction actionWithAction:fallStepAction rate:1];
//            CCCallFunc *reachTermVelAction = [CCCallFunc actionWithTarget:self selector:@selector(reachTerminalVelocity)];
//            CCSequence *fallActionSequence = [CCSequence actions:self.fallTermAction, reachTermVelAction, nil];
//            [self runAction:fallActionSequence];


//        }
//    }
}

-(void)slide:(CCNode<Collidable> *)collider
{
    // code to make player slide along side of collider
    [self clearMoveState];
    [self addMoveState:SLIDE];
    [self resetRunAction];
    
    if(self.fallAction != nil)
    {
        if(!self.fallAction.started)
        {
            self.fallAction = [PlayerFallAction actionWithDurationAndForce:0.5 :50];
            [self runAction:self.fallAction];
        }
    }
}


#pragma mark Collideable Protocol Methods
/*
 * Returns type of collision with collider
 * @param collider object to test collision againts
 * @return pointer to dash action executed
 */
-(CollisionLocation)collide:(CCNode<Collidable> *)collider
{
    CGFloat playerMinY, playerMaxY, playerMinX, playerMaxX; 
    CGFloat collidableMinY, collidableMaxY, collidableMinX, collidableMaxX;
    BOOL collide;
    const int collisionThresholdX = 10 ; //pixels
    const int collisionThresholdY = 10; //pixels
    
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
        
        if(fabsf(playerMinY - collidableMaxY) <=  collisionThresholdY) 
        {
            return TOP;
        }
        if(fabsf(playerMaxY - collidableMinY) <= collisionThresholdY)
        {
            return BOTTOM;
        }
        if(fabsf(playerMaxX - collidableMinX) <= collisionThresholdX)
        {
            return LEFT;                    
        }
        if(fabsf(playerMinX - collidableMaxX) <= collisionThresholdX)
        {
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
    
    for(MoveState currState = firstState; currState > NONE; currState = va_arg(args, MoveState))
    {
        if(self.moveState & currState)
            return YES;
    }
    va_end(args);

    return NO;
}

-(void)addMoveState:(MoveState)state
{
    self.moveState |= state;
}

-(void)removeMoveState:(MoveState)state
{
    self.moveState &= ~state;
}

-(void)clearMoveState;
{
    [self setMoveState:NONE];
}

// reset runAction so it can be created & run again
-(void)resetRunAction
{
    [[self runAction] setStarted:NO];
}

// reset fallAction so it can be created & run again
-(void)resetFallAction
{
    [[self fallAction] setStarted:NO];
}

-(void)normalizeStamina
{
    if(self.stamina > self.maxStamina)
        self.stamina = self.maxStamina;
    else if(self.stamina < 0)
        self.stamina = 0;
}

-(void)flash:(ccColor3B)color:(ccTime)duration //This code is here because Roger is a poop.
{
    [self setColor:color];
    [NSTimer scheduledTimerWithTimeInterval:duration
                                            target:self
                                            selector:@selector(resetColor)
                                            userInfo:nil
                                            repeats:NO];
}


-(void)resetColor
{
    [self setColor:ccc3(255, 255, 255)];
}

-(void)kill
{
    _alive = NO;
}

@end
