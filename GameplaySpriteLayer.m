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
@synthesize citizen1 = _citizen1;

- (id)init 
{
    if ((self = [super init])) 
    {
        _player = [Player getPlayer];
        [self addChild:_player];
        
//        _citizen1 = [Citizen 
        
        self.isKeyboardEnabled = YES;
        [self initKeysPressed];
        
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
                    [_player move:MOVE_LEFT: 3.0f];
                    break;
                    
                case NSRightArrowFunctionKey:
                case 'd':
                    [_player move:MOVE_RIGHT :3.0f];
                    break;
                    
                case NSDownArrowFunctionKey:
                case ' ':
                case 's':
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
    
    _keysPressed = nil;
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
//    if (!_keysPressed) 
//    {
//        _keysPressed = [[NSMutableSet alloc] init];
//    }
    
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
