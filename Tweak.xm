#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <substrate.h>
#import <Private/NSTask.h>
#import "Tweak.h"
#import "GateToFreedom/GFNavigationController.h"

@interface SpringBoard : NSObject
- (BOOL)isLocked;
- (UIGestureRecognizer *)screenshotGestureRecognizer;
@end

@interface SBIdleTimerProxy : NSObject
- (void)reset;
- (id)sourceTimer;
@end

@implementation GFAlertController
- (BOOL)shouldAutorotate {
	return NO;
}
@end

static GFNavigationController * __weak setupController;
static SpringBoard * __weak springboard;
static NSPointerArray * __strong classes;
static NSPointerArray * __strong messages;
static NSPointerArray * __strong originals;
static NSTimer * __strong preventAutolockTimer;
static NSBundle * __strong GFBundle;
static BOOL iPad;
static BOOL didPresentSetupController;

static void GFHookMessageEx(Class cls, SEL message, IMP hook, IMP *origPt) {
	MSHookMessageEx(cls, message, hook, origPt);
	if (origPt && *origPt) {
		[classes addPointer:(__bridge void *)cls];
		[messages addPointer:message];
		[originals addPointer:(void *)*origPt];
	}
}

static NSString *GFGetHelperPath(void) {
	return [GFGetBundle() pathForResource:@"setuphelper" ofType:nil];
}

NSString *GFChangeAccountPassword(NSString *accountName, NSString *newPassword) {
	NSString *helperPath = GFGetHelperPath();
	NSLog(@"Helper: %@", helperPath);
	if (!helperPath) return LC(@"CANNOT_ACCESS_HELPER");
	// This API is both private and deprecated. However, it works, so we are using it.
	NSTask *task = [NSTask
		launchedTaskWithLaunchPath:helperPath
		arguments:@[ @"-c", accountName, newPassword ]
	];
	[task waitUntilExit];
	return task.terminationStatus ? [GFGetBundle() localizedStringForKey:[NSString stringWithFormat:@"HELPER_ERROR_%i", task.terminationStatus] value:LC(@"UNKNOWN_ERROR") table:nil] : nil;
}

void GFDeleteHelper(void) {
	NSString *helperPath = GFGetHelperPath();
	if (!helperPath) return;
	[NSTask
		launchedTaskWithLaunchPath:helperPath
		arguments:@[ @"-d" ]
	];
}

NSBundle *GFGetBundle(void) {
	return (GFBundle ?: (GFBundle = [NSBundle bundleWithPath:@"/Library/Application Support/GateToFreedom"]));
}

void GFDisableHooks(void) {
	for (NSUInteger i=0; i<classes.count; i++) {
		SEL selector = (SEL)[messages pointerAtIndex:i];
		IMP originalImplementation = (IMP)[originals pointerAtIndex:i];
		Class cls = (__bridge Class)[classes pointerAtIndex:i];
		if (!selector || !originalImplementation || !cls) continue;
		MSHookMessageEx(cls, selector, originalImplementation, NULL);
	}
	[preventAutolockTimer invalidate];
	preventAutolockTimer = nil;
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

- (void)longPress:(id)arg1 {
	if (springboard.isLocked) %orig;
	else if (!iPad && !setupController.isOnLastStep) {
		GFAlertController *alert = [GFAlertController
			alertControllerWithTitle:nil
			message:nil
			preferredStyle:UIAlertControllerStyleActionSheet
		];
		[alert addAction:[UIAlertAction
			actionWithTitle:LC(@"Start Over")
			style:UIAlertActionStyleDefault
			handler:^(UIAlertAction *action){
				dispatch_async(dispatch_get_main_queue(), ^{
					[setupController popToRootViewControllerAnimated:YES];
				});
			}
		]];
		[alert addAction:[UIAlertAction
			actionWithTitle:LC(@"Cancel")
			style:UIAlertActionStyleCancel
			handler:nil
		]];
		[setupController presentViewController:alert animated:YES completion:nil];
	}
}

%end

%hook SBLockHardwareButton

- (void)singlePress:(id)arg1 {
	if (springboard.isLocked) %orig;
	else {
		GFAlertController *alert = [GFAlertController
			alertControllerWithTitle:LC(@"ABORT_SETUP")
			message:LC(@"ABORT_SETUP_MESSAGE")
			preferredStyle:(iPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet)
		];
		[alert addAction:[UIAlertAction
			actionWithTitle:LC(@"ABORT")
			style:UIAlertActionStyleDestructive
			handler:^(UIAlertAction *action){
				dispatch_async(dispatch_get_main_queue(), ^{
					[setupController abortSetupWithAlert:NO];
				});
			}
		]];
		[alert addAction:[UIAlertAction
			actionWithTitle:LC(@"Cancel")
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
	if (!didPresentSetupController) {
		didPresentSetupController = YES;
		id vc = [GFNavigationController new];
		[(id)self presentViewController:vc animated:NO completion:nil];
		setupController = vc;
		// Normal ways to disable the idle timer didn't work so here's my solution
		preventAutolockTimer = [NSTimer
			scheduledTimerWithTimeInterval:10.0
			repeats:YES
			block:^(NSTimer *timer){
				if (!springboard.isLocked) {
					SBIdleTimerProxy *currentTimer = MSHookIvar<id>(springboard, "_idleTimer");
					if (currentTimer) {
						while (currentTimer.class == %c(SBIdleTimerProxy)) {
							currentTimer = currentTimer.sourceTimer;
						}
						[currentTimer reset];
					}
				}
			}
		];
	}
}

%end

%hook SpringBoard

+ (id)alloc {
	id orig = %orig;
	springboard = orig;
	return orig;
}

- (void)takeScreenshot {}
- (void)takeScreenshotAndEdit:(BOOL)shouldEdit {}

%end
%end

%ctor {
	#if DEBUG
	[NSUserDefaults.standardUserDefaults setBool:NO forKey:kSetupCompleted];
	#endif

	if (!GFGetBundle()) {
		[NSException raise:NSInternalInconsistencyException format:@"Setup failed to open the setup bundle."];
	}
	if ([NSUserDefaults.standardUserDefaults boolForKey:kSetupCompleted] || ![NSFileManager.defaultManager fileExistsAtPath:GFGetHelperPath()]) {
		GFDeleteHelper();
		return;
	}
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

