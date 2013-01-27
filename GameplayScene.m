//
//  GameplayScene.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameplayScene.h"
#import "GameplayBackgroundLayer.h"
#import "Constants.h"

@interface GameplayScene (private)

@end



@implementation GameplayScene
@synthesize bgLayer = _bgLayer;
@synthesize spriteLayer = _spriteLayer;

+(GameplayScene*) scene
{
    GameplayScene* scene = [GameplayScene node];
    return scene;
}

-(id) init
{
    if((self = [super init])) 
    {
        // cache sprites
        [self loadSpriteSheets];
        
        // Background Layer
        _bgLayer   = [GameplayBackgroundLayer node]; //auto-release object
        [self addChild:_bgLayer z:BACKGROUND_LAYER_LEVEL];        
        
        // Sprite Layer
        _spriteLayer = [GameplaySpriteLayer node]; //auto-release object
        [self addChild:_spriteLayer z:SPRITE_LAYER_LEVEL];
                
        //Schedule the game loop
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime) dt
{
    //do game loop stuff
}

-(void) dealloc
{
    [super dealloc];
}

-(void) loadSpriteSheets
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
    CCSpriteBatchNode *spritesheet = [CCSpriteBatchNode batchNodeWithFile:@"sprites.png"];
    [self addChild:spritesheet];
}


@end
