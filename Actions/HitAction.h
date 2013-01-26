//
//  HitAction.h
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HitAction : CCActionInterval {
    @private
    CCAnimation *_animation;
    CCAnimate *_animAction;
    BOOL _started;
}

@property (nonatomic, readwrite, retain) CCAnimation *animation;
@property (nonatomic, readwrite, retain) CCAnimate *animAction;
@property (nonatomic, readwrite) BOOL started;

@end
