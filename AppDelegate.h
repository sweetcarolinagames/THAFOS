//
//  AppDelegate.h
//  ggj13
//
//  Created by Ian Coleman on 1/25/13.
//  Copyright Sweet Carolina Games 2013. All rights reserved.
//

#import "cocos2d.h"

@interface ggj13AppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	MacGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet MacGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
