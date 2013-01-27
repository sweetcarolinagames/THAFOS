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
#import "Constants.h"
#import "Collidable.h"

@interface GameplaySpriteLayer (private)

-(void) coolDownLaser:(ccTime) dt;
-(void)resetCitizenGenerateFlag:(ccTime) dt;
-(void)addCitizen;
-(void)initKeysPressed;
-(void)checkCollisions;



@end


@implementation GameplaySpriteLayer

@synthesize player = _player;
@synthesize citizens = _citizens;
@synthesize laserBolts = _laserBolts;
@synthesize canShoot = _canShoot;
@synthesize canGenerateCitizen = _canGenerateCitizen;
@synthesize battery  = _battery;
@synthesize citizenGenerateDelay = _citizenGenerateDelay;

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

        // init collider arrays
        _citizens = [[NSMutableArray alloc] init];
        _laserBolts = [[NSMutableArray alloc] init];
        
        //setup input
        self.isKeyboardEnabled = YES;
        [self initKeysPressed];

        // difficulty settings
        self.citizenGenerateDelay = EASY_DELAY;
        
        //enable weaponry
        _canShoot = YES;
        _canGenerateCitizen = YES;
        
        
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
    
    //DEBUG:
    NSLog(@"Number of active projectiles: %lu", [_laserBolts count]);
    NSLog(@"Number of active citizens: %lu", [_citizens count]);
    NSLog(@"Number of active children: %lu", [[self children] count]);
    
    if ([self canGenerateCitizen]) 
    {
        [self addCitizen];
    }    
    
    //CHECK COLLLLIIISSSSSIONS!!!
    [self checkCollisions];
    
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
                        LaserBolt *shot = [LaserBolt generate:_player.position :_player.contentSize.height/2];   
                        [self addChild:shot];
                        [_laserBolts addObject:shot];
                        
                        // shot penalty
                        [_battery setBatteryLife:[_battery getBatteryLife] - LASER_BATTERY_PENALTY];
                        
                        // disable laser and begin cooldown
                        _canShoot = NO;
                        [self performSelector:@selector(coolDownLaser:) 
                                   withObject:nil 
                                   afterDelay:1.0f];
                        
                        // play sound!
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
    [_citizens release];
    [_laserBolts release];
    
    _keysPressed = nil;
    _battery = nil;
    _citizens = nil;
    _laserBolts = nil;
}


#pragma mark Player Auxiliary Methods
-(void)coolDownLaser:(ccTime) dt
{
    _canShoot = YES;
}

-(void)checkCollisions
{
    NSMutableArray *laserBoltsToRelease = [[NSMutableArray alloc] init];
    NSMutableArray *citizenToRelease = [[NSMutableArray alloc] init];
    
    // iterate
    for (LaserBolt *laserBolt in self.laserBolts) 
    {
        for (Citizen *citizen  in self.citizens) 
        {
            if([laserBolt collide:citizen] > NO_COLLISION)
            {
                id citizenFadeOutAction = [citizen runAction:[CCFadeOut actionWithDuration:0.25f]];
                id removeCitizenFromLayerAction = [CCCallBlock actionWithBlock:^
                                                   {
                                                       // set citizen to be released
                                                       [citizenToRelease addObject:citizen];
                                                   }];
               [citizen runAction:[CCSequence actions:citizenFadeOutAction, removeCitizenFromLayerAction, nil]];
                
                [laserBoltsToRelease addObject:laserBolt];
//                [citizenToRelease addObject:citizen];

                
                if(citizen.goodHeart)
                {
                    // "heart get"
                    CCSprite *heart = [TrueHeart generate:citizen.position];
                    [self addChild:heart];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"phaserUp6.mp3"];
                    // add battery life
                    [_battery setBatteryLife:[_battery getBatteryLife] + MAX_BATTERY_LIFE*0.20f];
                }
                else
                {
                    // player hit bad heart
                    [[SimpleAudioEngine sharedEngine] playEffect:@"fakeheartbeat.mp3"];
                    [_battery setBatteryLife:([_battery getBatteryLife] - BAD_HEART_PENALTY)];
                }
            }
        }
    }
    
    for(LaserBolt *laserBolt in laserBoltsToRelease)
    {
        [_laserBolts removeObject:laserBolt];
        [self removeChild:laserBolt cleanup:YES];
    }
    
    for(Citizen *citizen in citizenToRelease)
    {
        [_citizens removeObject:citizen];
        [self removeChild:citizen cleanup:YES];
    }
    
    // garbage collection
    [laserBoltsToRelease release];
    [citizenToRelease release];
    
    laserBoltsToRelease = nil;
    citizenToRelease = nil;
}


#pragma mark Citizen Auto-Gen Methods

-(void)addCitizen
{
    // random male/female, left/right direction
    Citizen *newCitizen = [[Citizen alloc] init];
    newCitizen.position = ccp(rand()%600 + 50, 95);
    newCitizen.goodHeart = ( rand()%2 ) ? YES : NO;
    [newCitizen run];
    // add to sprite layer
    [self addChild:newCitizen];
    // add to list of colliders
    [_citizens addObject:newCitizen];
    
    //Play sound!
    if(newCitizen.goodHeart)
        [[SimpleAudioEngine sharedEngine] playEffect:@"heartbeat.mp3"];
    
    _canGenerateCitizen = NO;
    [self performSelector:@selector(resetCitizenGenerateFlag:) 
               withObject:nil 
               afterDelay:self.citizenGenerateDelay];
}

-(void)resetCitizenGenerateFlag:(ccTime) dt
{
    _canGenerateCitizen = YES;
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
