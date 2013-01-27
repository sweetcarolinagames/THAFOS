//
//  GameOverScene.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/27/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameOverScene.h"
#import "GameplayScene.h"
#import "SimpleAudioEngine.h"

@implementation GameOverLayer
@synthesize label = _label;

-(id) init
{
	if( (self=[super initWithColor:ccc4(0,0,0,0)] )) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];

        //game over background
        _backgroundImage = [CCSprite spriteWithFile:@"gameover.png"];
        _backgroundImage.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_backgroundImage z:0];

        //game over score label
		self.label = [CCLabelTTF labelWithString:@"Test" fontName:@"Helvetica" fontSize:42];
		_label.color = ccc3(255,255,255);
		_label.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:_label];
        

		
		[self runAction:[CCSequence actions:
						 [CCDelayTime actionWithDuration:7],
						 [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
						 nil]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"die.wav"]; //explosion
		
	}	
	return self;
}

- (void)gameOverDone {
    
	[[CCDirector sharedDirector] replaceScene:[GameplayScene scene]];
    
}

- (void)dealloc {
	[_label release];
	_label = nil;
	[super dealloc];
}

@end


@implementation GameOverScene
@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [GameOverLayer node];
		[self addChild:_layer];
	}
	return self;
}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}

@end