//
//  RunAction.h
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CharacterAction.h"

@interface RunAction : CCRepeatForever {
    @private
    CCAnimation *_animation;
    CCRepeatForever *_animAction;
    BOOL _started;
}

@property (nonatomic, readwrite, retain) CCAnimation *animation;
@property (nonatomic, readwrite, retain) CCRepeatForever *animAction;
@property (nonatomic, readwrite) BOOL started;

-(id)initWithDurationAndPosition:(ccTime)d position:(CGPoint)pos;

@end
