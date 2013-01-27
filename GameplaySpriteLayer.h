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
#import "Sprites/Battery.h"

@interface GameplaySpriteLayer : CCLayer 
{
    @private
    Battery *_batteryMeter;
    Player  *_player;
    NSMutableArray *_citizens;
    NSMutableSet *_keysPressed;
    
    BOOL _canShoot;
}

@property (nonatomic,readwrite,assign) Battery *battery;
@property (nonatomic,readwrite,retain) Player  *player;
@property (nonatomic,readwrite,retain) NSMutableArray *citizens;
@property (nonatomic,readonly) BOOL canShoot;

-(void)initKeysPressed;
-(void)addCitizen;

@end
