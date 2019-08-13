#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <substrate.h>
#import "Tweak.h"
#import "GateToFreedom/GFNavigationController.h"

@interface SpringBoard : NSObject
- (BOOL)isLocked;
- (UIGestureRecognizer *)screenshotGestureRecognizer;
@end

@implementation GFAlertController
- (BOOL)shouldAutorotate {
	return NO;
}
@end

static GFNavigationController * __unsafe_unretained setupController;
static SpringBoard * __weak springboard;
static NSPointerArray * __strong classes;
static NSPointerArray * __strong messages;
static NSPointerArray * __strong originals;
static BOOL iPad;

static void GFHookMessageEx(Class cls, SEL message, IMP hook, IMP *origPt) {
	MSHookMessageEx(cls, message, hook, origPt);
	if (origPt && *origPt) {
		[classes addPointer:(__bridge void *)cls];
		[messages addPointer:message];
		[originals addPointer:*origPt];
	}
}

void GFDisableHooks(void) {
	for (NSUInteger i=0; i<classes.count; i++) {
		SEL selector = (SEL)[messages pointerAtIndex:i];
		IMP originalImplementation = (IMP)[originals pointerAtIndex:i];
		Class cls = (__bridge Class)[classes pointerAtIndex:i];
		if (!selector || !originalImplementation || !cls) continue;
		MSHookMessageEx(cls, selector, originalImplementation, NULL);
	}
	classes = nil;
	messages = nil;
	originals = nil;
}

%group Tweak
%hook SBHomeHardwareButton

- (void)singlePressDown:(id)arg1 { if (springboard.isLocked) %orig; }
- (void)singlePressUp:(id)arg1   { if (springboard.isLocked) %orig; }
- (void)doublePressDown:(id)arg1 { if (springboard.isLocked) %orig; }
- (void)doublePressUp:(id)arg1   { if (springboard.isLocked) %orig; }
- (void)triplePressDown:(id)arg1 { if (springboard.isLocked) %orig; }
- (void)triplePressUp:(id)arg1   { if (springboard.isLocked) %orig; }

%end

%hook SBLockHardwareButton

- (void)singlePress:(id)arg1 {
	if (springboard.isLocked) %orig;
	else {
		GFAlertController *alert = [GFAlertController
			alertControllerWithTitle:@"Abort Setup"
			message:@"Are you sure you want to abort the setup? The setup will be restarted after a respring."
			preferredStyle:(iPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet)
		];
		[alert addAction:[UIAlertAction
			actionWithTitle:@"Abort"
			style:UIAlertActionStyleDestructive
			handler:^(UIAlertAction *action){
				dispatch_async(dispatch_get_main_queue(), ^{
					[setupController abortSetupWithAlert:NO];
				});
			}
		]];
		[alert addAction:[UIAlertAction
			actionWithTitle:@"Cancel"
			style:UIAlertActionStyleCancel
			handler:nil
		]];
		[setupController presentViewController:alert animated:YES completion:nil];
	}
}

%end

%hook SBHomeScreenViewController

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	if (!setupController) {
		id vc = [GFNavigationController new];
		[(id)self presentViewController:vc animated:NO completion:nil];
		setupController = vc;
	}
}

%end

%hook SpringBoard

+ (id)alloc {
	id orig = %orig;
	springboard = orig;
	return orig;
}

%end
%end

%ctor {
	NSPointerFunctionsOptions options = (NSPointerFunctionsOpaqueMemory | NSPointerFunctionsOpaquePersonality);
	classes = [[NSPointerArray alloc] initWithOptions:options];
	messages = [[NSPointerArray alloc] initWithOptions:options];
	originals = [[NSPointerArray alloc] initWithOptions:options];
	iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

	// This check is used to disable the tweak by lowering the device volume to 0. It only works in debug builds.
	#if DEBUG
	if (AVAudioSession.sharedInstance.outputVolume)
	#endif

	// This definition is used to track the hooks using arrays. The collected information is then used in GFDisableHooks() to disable the hooks.
	#define MSHookMessageEx(args...) GFHookMessageEx(args) 

	// logos.pl turns this tiny init() into a huge block of code. That code uses MSHookMessageEx to hook methods. As a result, parts of the code is replaced with the definition from the previous line.
	%init(Tweak);

	// Undefine the MSHookMessageEx definition, just in case logos.pl adds something extra at the end of the file.
	#undef MSHookMessageEx
}

