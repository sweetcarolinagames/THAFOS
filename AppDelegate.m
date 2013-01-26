//
//  AppDelegate.m
//  ggj13
//
//  Created by Ian Coleman on 1/25/13.
//  Copyright Sweet Carolina Games 2013. All rights reserved.
//

#import "AppDelegate.h"
#import "GameplayScene.h"

@implementation ggj13AppDelegate
@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
    //*********************
    // see http://www.cocos2d-iphone.org/forum/topic/12457 for reference
    // on window-sizing code
    //*********************
    NSRect f = glView_.frame;
    
    NSRect mainDisplayRect = [[NSScreen mainScreen] frame];
    CGFloat display_width = mainDisplayRect.size.width;
    CGFloat display_height = mainDisplayRect.size.height;
    
    double ar = mainDisplayRect.size.width / mainDisplayRect.size.height;
    
    CGFloat min_width = 768; //default window width on app start
    CGFloat min_height = roundf(min_width / ar); // calculated window height on app start
    
    CGFloat work_width = 1200; //default working resolution witdh
    CGFloat work_height = roundf(work_width / ar); //calculated working resolution height
    
    [window_ setFrame:NSMakeRect(0, 0, min_width, min_height) display:YES];
    [glView_ setFrame:CGRectMake(f.origin.x, f.origin.y, work_width, work_height)];
    [director setDisplayFPS:NO];
    [director setOpenGLView:glView_];
    [director setResizeMode:kCCDirectorResize_AutoScale];
    [glView_ setFrame:CGRectMake(0, 0, min_width, min_height)];
    [window_ setContentAspectRatio:NSMakeSize(display_width, display_height)];
    
    NSScreen * screen = window_.screen;
    NSRect r = screen.frame;
    [window_ setFrameTopLeftPoint:NSMakePoint(r.size.width/2 - window_.frame.size.width/2, r.size.height/2 + window_.frame.size.height/2)];
    //*********************
    
	// Enable "moving" mouse event. Default no.
	[window_ setAcceptsMouseMovedEvents:NO];
	
	
	[director runWithScene:[GameplayScene scene]];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
	return YES;
}

- (void)dealloc
{
	[[CCDirector sharedDirector] end];
	[window_ release];
	[super dealloc];
}

#pragma mark AppDelegate - IBActions

- (IBAction)toggleFullScreen: (id)sender
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setFullScreen: ! [director isFullScreen] ];
}

@end
