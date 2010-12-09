//
//  FingerMouseAppDelegate.h
//  FingerMouse
//
//  Created by bia on 12/9/10.
//  Copyright 2010 bianca cheng costanzo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FingerMouseAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *pointerOverlay;
}

@property (assign) IBOutlet NSWindow *window;

@end
