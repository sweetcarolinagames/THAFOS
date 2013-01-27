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
    NSMutableArray *_laserBolts;
    NSMutableSet *_keysPressed;
    CGFloat _citizenGenerateDelay;
    
    BOOL _canShoot;
    BOOL _canGenerateCitizen;
}

@property (nonatomic,readwrite,assign) Battery *battery;
@property (nonatomic,readwrite,retain) Player  *player;
@property (nonatomic,readwrite,retain) NSMutableArray *citizens;
@property (nonatomic,readwrite,retain) NSMutableArray *laserBolts;
@property (nonatomic,readonly) BOOL canShoot;
@property (nonatomic,readonly) BOOL canGenerateCitizen;
@property (nonatomic,readwrite) CGFloat citizenGenerateDelay;

@end
