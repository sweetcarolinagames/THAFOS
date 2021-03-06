//
//  GameplaySpriteLayer.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameplaySpriteLayer.h"
#import "GameOverScene.h"
#import "LaserBolt.h"
#import "TrueHeart.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "Collidable.h"

@interface GameplaySpriteLayer (private)

-(void) coolDownLaser:(ccTime) dt;
-(void) resetCitizenGenerateFlag:(ccTime) dt;
-(void) addCitizen;
-(void) cleanupOffScreenCitizens;
-(void) initKeysPressed;
-(void) checkCollisions;

@end


@implementation GameplaySpriteLayer

@synthesize player   = _player;
@synthesize citizens = _citizens;
@synthesize laserBolts = _laserBolts;
@synthesize canShoot = _canShoot;
@synthesize canGenerateCitizen = _canGenerateCitizen;
@synthesize battery  = _battery;
@synthesize citizenGenerateDelay = _citizenGenerateDelay;
@synthesize numberOfHeartsCollected = _numberOfHeartsCollected;

- (id)init 
{
    if ((self = [super init])) 
    {
        //add the player
        _player = [[Player alloc] init];
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
        
        //game logic data
        _numberOfHeartsCollected = 0;
        
        
        //begin bgmusic and ufo sounds!        
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.10f];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
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
    
    //check if we still have battery!
    if ([_battery getBatteryLife] < 0.1) {
        //if we're less than 0.1, we are dead.
        GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:[NSString stringWithFormat:@"%d", self.numberOfHeartsCollected]];
		[[CCDirector sharedDirector] replaceScene:gameOverScene];

    }
 
    
    if ([self canGenerateCitizen]) 
    {
        [self addCitizen];
    }    
    
    //check collision
    [self checkCollisions];
    [self cleanupOffScreenCitizens];
    
    //increase difficulty if player is getting good
    if (self.numberOfHeartsCollected < 10) 
    {
        self.citizenGenerateDelay = EASY_DELAY;
    }
    
    else if (self.numberOfHeartsCollected >= 10 && self.numberOfHeartsCollected < 20) 
    {
        self.citizenGenerateDelay = MED_DELAY;
    }
    
    else if(self.numberOfHeartsCollected >= 20 && self.numberOfHeartsCollected < 30)
    {
        self.citizenGenerateDelay = HARD_DELAY;
    }
    
    else
    {
        self.citizenGenerateDelay = INSANE_DELAY;
    }
    
    
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
    [_player release];
    

    _keysPressed = nil;
    _battery = nil;
    _citizens = nil;
    _laserBolts = nil;
    _player = nil;
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
                // citizen fadeout and release sequence
                id citizenFadeOutAction = [CCFadeOut actionWithDuration:0.25f];
                id removeCitizenFromLayerAction = [CCCallBlock actionWithBlock:
                                                   ^{
                                                       // set citizen to be released
                                                        [citizenToRelease addObject:citizen];
                                                       
                                                       // release citizens
                                                       for(Citizen *citizen in citizenToRelease)
                                                       {
                                                           [self.citizens removeObject:citizen];
                                                           [self removeChild:citizen cleanup:YES];
                                                       }
                                                   }];
               [citizen runAction:[CCSequence actions:citizenFadeOutAction, removeCitizenFromLayerAction, nil]];
                
                [laserBoltsToRelease addObject:laserBolt];
                
                if(citizen.goodHeart)
                {
                    // "heart get"
                    CCSprite *heart = [TrueHeart generate:citizen.position];
                    [self addChild:heart];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"phaserUp6.mp3"];
                    _numberOfHeartsCollected++;

                    // add battery life
                    [_battery setBatteryLife:[_battery getBatteryLife] + MAX_BATTERY_LIFE*0.20f];
                }
                else
                {
                    // player hit bad heart
                    [[SimpleAudioEngine sharedEngine] playEffect:@"fakeheartbeat.mp3"];
                    [_battery setBatteryLife:([_battery getBatteryLife] - BAD_HEART_PENALTY*(EASY_DELAY/self.citizenGenerateDelay))];
                }
            }
        }
    }
    
    for(LaserBolt *laserBolt in laserBoltsToRelease)
    {
        [_laserBolts removeObject:laserBolt];
        [self removeChild:laserBolt cleanup:YES];
    }
        
    // garbage collection
    [laserBoltsToRelease release];
    [citizenToRelease release];
    
    laserBoltsToRelease = nil;
    citizenToRelease = nil;
}


#pragma mark Citizen Auto-Gen Methods

-(void) addCitizen
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // random male/female, left/right direction
    Citizen *newCitizen = [[Citizen alloc] init];
    newCitizen.goodHeart = ( rand()%2 ) ? YES : NO;

    newCitizen.position = (newCitizen.dir == CITIZEN_LEFT) ? ccp(winSize.width + newCitizen.contentSize.width, 95) : ccp(0 - newCitizen.contentSize.width, 95);
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
    
    // adjust speed based on difficulty
    CGFloat speed = 0.1f * self.citizenGenerateDelay;
    // make citizen move
    [newCitizen run:newCitizen.dir:speed];
}

-(void) resetCitizenGenerateFlag:(ccTime) dt
{
    _canGenerateCitizen = YES;
}

-(void) cleanupOffScreenCitizens
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSMutableArray *citizensToRelease = [[NSMutableArray alloc] init];
    
    for (Citizen *citizen in _citizens) 
    {
        if (citizen.position.x < -citizen.contentSize.width || citizen.position.x > (winSize.width+citizen.contentSize.width)) 
        {
            // set citizen to be released
            [citizensToRelease addObject:citizen];
        }
    }
    
    // release citizens
    for(Citizen *citizen in citizensToRelease)
    {
        [self.citizens removeObject:citizen];
        [self removeChild:citizen cleanup:YES];
    }
    
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
