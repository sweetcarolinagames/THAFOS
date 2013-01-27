//
//  GameplaySpriteLayer.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameplaySpriteLayer.h"
#import "LaserBolt.h"
#import "TrueHeart.h"
#import "SimpleAudioEngine.h"

@interface GameplaySpriteLayer (private)

-(void) coolDownLaser:(ccTime) dt;

@end


@implementation GameplaySpriteLayer

@synthesize player = _player;
@synthesize citizen1 = _citizen1;
@synthesize canShoot = _canShoot;
@synthesize battery  = _battery;

- (id)init 
{
    if ((self = [super init])) 
    {
        //add the player
        _player = [Player getPlayer];
        [self addChild:_player];
        
        //add the battery
        _battery = [[Battery alloc] init];
        [self addChild:_battery];
        
        
        //setup input
        self.isKeyboardEnabled = YES;
        [self initKeysPressed];

        
        //enable weaponry
        _canShoot = YES;
        
        
        //begin bgmusic and ufo sounds!        
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.15f];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.9f];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme-dst-arcofdawn.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"20473__dj-chronos__ufo.mp3" loop:YES];
        
        
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
                case NSLeftArrowFunctionKey:
                case 'a':
                {
                    [_player move:MOVE_LEFT: 3.0f];
                }
                    break;
                    
                case NSRightArrowFunctionKey:
                case 'd':
                {
                    [_player move:MOVE_RIGHT :3.0f];
                }
                    break;
                    
                case NSDownArrowFunctionKey:
                case ' ':
                case 's':
                {
                    if ([self canShoot]) 
                    {
                        CCSprite *shot 
                         = [LaserBolt generate:_player.position               
                                              :_player.contentSize.height/2];   
                        
                        //TODO: must add to collideables here
                        [self addChild:shot];
                        
                        //Disable laser and begin cooldown
                        _canShoot = NO;
                        [self performSelector:@selector(coolDownLaser:) 
                                   withObject:nil 
                                   afterDelay:1.0f];
                        
                        //Play sound!
                        [[SimpleAudioEngine sharedEngine] playEffect:@"laser.mp3"];
                        

                        

                    }
                    
                    
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
    
}



-(void) dealloc
{
    [super dealloc];
    
    [_keysPressed release];
    [_battery release];
    
    _keysPressed = nil;
    _battery = nil;
}


#pragma mark Player Auxiliary Methods
-(void)coolDownLaser:(ccTime) dt
{
    _canShoot = YES;
    
    //TODO:  THIS IS ONLY A TEST - PLZ DELETE WHENEVER DONE
    CCSprite *heart = [TrueHeart generate:_player.position];
    
    //TODO: must add to collideables here
    [self addChild:heart];

    
}



#pragma mark Key Delegate Methods
-(void)initKeysPressed
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
        case NSDownArrowFunctionKey:
        case NSRightArrowFunctionKey:
        case NSLeftArrowFunctionKey:
        case 'a':
        case 's':
        case 'd':
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
        case NSDownArrowFunctionKey:
        case NSRightArrowFunctionKey:
        case NSLeftArrowFunctionKey:
        case 'a':
        case 's':
        case 'd':
        case ' ':
            [_keysPressed removeObject:keyReleased];
            break;
            
        default:
            break;
    }
    
    return 1;
}

@end
