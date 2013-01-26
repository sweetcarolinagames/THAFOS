//
//  GameplayScene.h
//  ggj13
//
//  The GameplayScene contains all gameplay related CCLayers
//  and is responsible for management of game logic.
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameplayBackgroundLayer.h"

#import "cocos2d.h"

@interface GameplayScene : CCScene {
    
    @private
    GameplayBackgroundLayer* _bgLayer;
    
}

+(GameplayScene*) scene;

@property (nonatomic, readonly) GameplayBackgroundLayer *bgLayer;

@end