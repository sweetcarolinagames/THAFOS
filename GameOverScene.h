//
//  GameOverScene.h
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/27/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//The one GameOverLayer to be included in this scene.
@interface GameOverLayer : CCLayer 
{
    @private
    CCSprite *_backgroundImage;
	CCLabelTTF *_label;
}

@property (nonatomic, retain) CCLabelTTF *label;

@end



@interface GameOverScene : CCScene {
	GameOverLayer *_layer;
}

@property (nonatomic, retain) GameOverLayer *layer;

@end
