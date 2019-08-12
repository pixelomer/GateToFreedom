#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GateToFreedom/GFNavigationController.h"

@interface SpringBoard : NSObject
- (BOOL)isLocked;
- (UIGestureRecognizer *)screenshotGestureRecognizer;
@end

static GFNavigationController * __unsafe_unretained setupController;
static SpringBoard * __weak springboard;
static NSPointerArray * __strong classes;
static NSPointerArray * __strong messages;
static NSPointerArray * __strong originals;

%group Tweak
%hook SBHomeHardwareButton

- (void)singlePressDown:(id)arg1 { if (springboard.isLocked) %orig; }
- (void)singlePressUp:(id)arg1   { if (springboard.isLocked) %orig; }
- (void)doublePressDown:(id)arg1 { if (springboard.isLocked) %orig; }
- (void)doublePressUp:(id)arg1   { if (springboard.isLocked) %orig; }
- (void)triplePressDown:(id)arg1 { if (springboard.isLocked) %orig; }
- (void)triplePressUp:(id)arg1   { if (springboard.isLocked) %orig; }

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

	// This check is used to disable the tweak by lowering the device volume to 0. It only works in debug builds.
	#if DEBUG
	if (AVAudioSession.sharedInstance.outputVolume)
	#endif

	// This definition is used to track the hooks using arrays. The collected information is then used in GFDisableHooks() to disable the hooks.
	#define MSHookMessageEx(cls, sel, hook, orig) {Class _cls=cls;SEL _sel=sel;IMP*_orig =orig;MSHookMessageEx(_cls,_sel,hook,_orig);if(*_orig){[classes addPointer:(__bridge void*)_cls];[messages addPointer:_sel];[originals addPointer:*_orig];}}

	// "Logos" turns this tiny init() into a huge block of code. That code uses MSHookMessageEx to hook methods. As a result, parts of the code is replaced with the definition from the previous line.
	%init(Tweak);

	// Undefine the MSHookMessageEx definition to prevent GFDisableHooks() from causing problems.
	#undef MSHookMessageEx
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