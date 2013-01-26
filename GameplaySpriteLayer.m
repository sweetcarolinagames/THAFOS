//
//  GameplaySpriteLayer.m
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import "GameplaySpriteLayer.h"

@implementation GameplaySpriteLayer

-(id) init
{
    if ((self = [super init])) {
        
        self.isKeyboardEnabled = YES;
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime) dt
{
    //handle keyboard input
    if ([_keysPressed count] != 0) {
        NSEnumerator *enumerator = [_keysPressed objectEnumerator];
        NSNumber *keyHit;
        
        //process all keys of interest that are held down
        while (keyHit = [enumerator nextObject]) {
            switch ([keyHit unsignedIntValue]) {
                case NSLeftArrowFunctionKey:
                case 'a':
                    NSLog(@"Moving Left!");
                    break;
                    
                case NSRightArrowFunctionKey:
                case 'd':
                    NSLog(@"Moving Right!");
                    break;
                    
                case NSDownArrowFunctionKey:
                case ' ':
                case 's':
                    NSLog(@"Shooting Down!");
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
-(BOOL) ccKeyDown:(NSEvent *)event
{
    NSNumber *keyHit 
        = [NSNumber numberWithUnsignedInt:[[event characters] characterAtIndex:0]];

    switch ([keyHit unsignedIntValue]) {
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
    if (!_keysPressed) {
        _keysPressed = [[NSMutableSet alloc] init];
    }
    
    NSNumber *keyReleased 
        = [NSNumber numberWithUnsignedInt:[[event characters] characterAtIndex:0]];
    
    switch ([keyReleased unsignedIntValue]) {
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
