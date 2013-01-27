//
//  TitleScene.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/27/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "TitleScene.h"
#import "SimpleAudioEngine.h"
#import "GameplayScene.h"


#pragma mark TitleLayer Implementation

@interface TitleLayer (private)
-(void) initKeysPressed;
@end


@implementation TitleLayer

-(id) init
{    
    if( (self=[super initWithColor:ccc4(0,0,0,0)])) 
    {	
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //title background
        _backgroundImage = [CCSprite spriteWithFile:@"title.png"];
        _backgroundImage.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_backgroundImage z:0];
        
        //setup input
        self.isKeyboardEnabled = YES;
        [self initKeysPressed];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"dst-2ndballad.mp3"];
        
        //setup gameloop
        [self scheduleUpdate];
	}	
	return self;

}

-(void) update:(ccTime) dt
{
    //handle keyboard input
    if ([_keysPressed count] != 0) 
    {
        NSEnumerator *enumerator = [_keysPressed objectEnumerator];
        NSNumber *keyHit;
        
        //process all keys of interest that are held down
        while ((keyHit = [enumerator nextObject])) 
        {
            switch ([keyHit unsignedIntValue]) 
            {
                case ' ':
                {
                    [[CCDirector sharedDirector] replaceScene:[GameplayScene scene]];
                }
                    break;
                default:
                    break;
            }
        }
    }

}

- (void)dealloc {
	[_backgroundImage release];
    [_keysPressed release];
    
    _keysPressed = nil;
	_backgroundImage = nil;
}


#pragma mark Key Delegate Methods
-(void) initKeysPressed
{
    if (!_keysPressed) 
    {
        _keysPressed = [[NSMutableSet alloc] init];
    }
}

-(BOOL) ccKeyDown:(NSEvent *)event
{
    NSNumber *keyHit 
    = [NSNumber numberWithUnsignedInt:[[event characters] characterAtIndex:0]];
    
    switch ([keyHit unsignedIntValue]) 
    {
        //these are the only keys I care about
        case ' ':
            [_keysPressed addObject:keyHit];
            break;
            
        default:
            break;
    }
    
    return 1;
}


-(BOOL) ccKeyUp:(NSEvent *)event
{    
    NSNumber *keyReleased 
    = [NSNumber numberWithUnsignedInt:[[event characters] characterAtIndex:0]];
    
    switch ([keyReleased unsignedIntValue]) 
    {
        case ' ':
            [_keysPressed removeObject:keyReleased];
            break;
            
        default:
            break;
    }
    
    return 1;
}


@end





#pragma mark TitleScene Implementation

@implementation TitleScene

@synthesize layer = _layer;

- (id)init {
    
	if ((self = [super init])) {
		self.layer = [TitleLayer node];
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
