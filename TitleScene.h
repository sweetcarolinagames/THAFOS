//
//  TitleScene.h
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/27/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//The one TitleLayer to be included in this scene.
@interface TitleLayer : CCLayerColor
{
    @private
    CCSprite *_backgroundImage;
    NSMutableSet *_keysPressed;
}


@end





@interface TitleScene : CCScene {
    
    TitleLayer *_layer;
    
}

@property (nonatomic, retain) TitleLayer *layer;

@end
