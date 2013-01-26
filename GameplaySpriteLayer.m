//
//  GameplaySpriteLayer.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameplaySpriteLayer.h"


@implementation GameplaySpriteLayer

@synthesize player = _player;

- (id)init {
    self = [super init];
    if (self) {
        _player = [Player getPlayer];
        [self addChild:_player];
    }
    return self;
}

-(void) update:(ccTime) dt
{
    NSLog(@"updating");
    [_player run];
}

@end
