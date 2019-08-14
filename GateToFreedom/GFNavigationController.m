#import "GFNavigationController.h"
#import "GFPage.h"
#import "GFSection.h"
#import <Tweak.h>

@implementation GFNavigationController

static NSArray<NSString *> *pageClasses;

+ (void)load {
    if (self == GFNavigationController.class) {
        pageClasses = @[
            @"GFWelcomePage",
            @"GFPasswordWelcomePage",
            @"GFRootPasswordPage",
            @"GFMobilePasswordPage",
            @"GFCompletionPage"
        ];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.translucent = YES;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.clearColor};
}

- (instancetype)init {
    NSMutableArray *mPages = [NSMutableArray new];
    for (NSString *pageClass in pageClasses) {
        Class cls = NSClassFromString(pageClass);
        if (!cls) return nil;
        UIViewController *vc = [cls new];
        if (!vc) return nil;
        [mPages addObject:vc];
    }
    if ((self = [super initWithRootViewController:mPages[0]])) {
        pages = mPages.copy;
        return self;
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    showAlertOnDisappear = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (showAlertOnDisappear) {
        UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"Warning"
            message:@"The setup couldn't be completed. It will be restarted after a respring."
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil
        ];
        [alertView show];
    }
}

- (NSInteger)currentIndex {
    return [pages indexOfObjectIdenticalTo:self.visibleViewController];
}

- (BOOL)isOnLastStep {
    return (pages.count-1) == self.currentIndex;
}

- (void)abortSetupWithAlert:(BOOL)showAlert {
    showAlertOnDisappear = showAlert;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeSetup {
    showAlertOnDisappear = NO;
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:kSetupCompleted];
    GFDeleteHelper();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushPageAtIndex:(NSInteger)index {
    if (index < pages.count) {
        [self pushViewController:pages[index] animated:YES];
    }
    else {
        [self completeSetup];
    }
}

- (void)pushNextPage {
    [self pushPageAtIndex:self.currentIndex+1];
}

- (void)skipToNextSection {
    NSInteger nextViewControllerIndex = self.currentIndex;
    while (++nextViewControllerIndex < pages.count) {
        if ([pages[nextViewControllerIndex] isKindOfClass:[GFSection class]]) {
            [self pushPageAtIndex:nextViewControllerIndex];
            return;
        }
    }
    [self completeSetup];
}

- (void)dealloc {
    GFDisableHooks();
}

@end