//
//  GameplaySpriteLayer.h
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface GameplaySpriteLayer : CCLayer 
{
    @private
    Player *_player;
    NSMutableSet *_keysPressed;
}

@property (nonatomic,readwrite,retain) Player *player;

@end
