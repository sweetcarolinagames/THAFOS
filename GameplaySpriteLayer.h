//
//  GameplaySpriteLayer.h
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Sprites/Player.h"
#import "Sprites/Citizen.h"

@interface GameplaySpriteLayer : CCLayer 
{
    @private
    Player *_player;
    Citizen *_citizen1;
    NSMutableSet *_keysPressed;
}

@property (nonatomic,readwrite,retain) Player *player;
@property (nonatomic,readwrite,retain) Citizen *citizen1;

-(void)initKeysPressed;

@end
