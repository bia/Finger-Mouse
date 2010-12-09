//
//  FingerMouseAppDelegate.m
//  FingerMouse
//
//  Created by bia on 12/9/10.
//  Copyright 2010 bianca cheng costanzo. All rights reserved.
//

#import "FingerMouseAppDelegate.h"

@implementation FingerMouseAppDelegate

@synthesize window;

- (void)_updateWindowPosition
{
	NSPoint p = [NSEvent mouseLocation];
	[pointerOverlay setFrameOrigin:NSMakePoint(p.x - 25, p.y - 25)];
}

- (void)mouseDown
{
	[pointerOverlay setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"Active"]]];
}

- (void)mouseUp
{
	[pointerOverlay setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"Hover"]]];
}

- (void)mouseMoved
{
	[self _updateWindowPosition];
}

- (void)mouseDragged
{
	[self _updateWindowPosition];
}

CGEventRef tapCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *info)
{
	FingerMouseAppDelegate *delegate = (FingerMouseAppDelegate *)info;
	switch(type)
	{
		case kCGEventLeftMouseDown:
			[delegate mouseDown];
			break;
		case kCGEventLeftMouseUp:
			[delegate mouseUp];
			break;
		case kCGEventLeftMouseDragged:
			[delegate mouseDragged];
			break;
		case kCGEventMouseMoved:
			[delegate mouseMoved];
			break;
	}
	return event;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	pointerOverlay = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 50, 50) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[pointerOverlay setAlphaValue:0.8];
	[pointerOverlay setOpaque:NO];
	[pointerOverlay setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"Hover"]]];
	[pointerOverlay setLevel:NSFloatingWindowLevel];
	[pointerOverlay setIgnoresMouseEvents:YES];
	[self _updateWindowPosition];
	[pointerOverlay orderFront:nil];
	
	CGEventMask mask =	CGEventMaskBit(kCGEventLeftMouseDown) | 
	CGEventMaskBit(kCGEventLeftMouseUp) | 
	CGEventMaskBit(kCGEventLeftMouseDragged) | 
	CGEventMaskBit(kCGEventMouseMoved);
	
	CFMachPortRef tap = CGEventTapCreate(kCGAnnotatedSessionEventTap,
										 kCGTailAppendEventTap,
										 kCGEventTapOptionListenOnly,
										 mask,
										 tapCallBack,
										 self);
	
	CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(NULL, tap, 0);
	CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, kCFRunLoopCommonModes);
	
	CFRelease(runLoopSource);
	CFRelease(tap);
}

@end
