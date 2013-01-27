//
//  GameplayBackgroundLayer.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameplayBackgroundLayer.h"


@implementation GameplayBackgroundLayer

-(id) init
{
    if ((self = [super init])) 
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        //Init the background.
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        //_backgroundImage = [CCSprite spriteWithFile:@"Field.pvr.ccz"];
        _backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        _backgroundImage.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_backgroundImage z:0];
    }
    
    return self;
}

-(void) dealloc
{
    [_backgroundImage release];
    _backgroundImage = nil;
}

@end
