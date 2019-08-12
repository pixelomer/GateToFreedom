#import "GFNavigationController.h"
#import "GFPage.h"
#import <Tweak.h>

@implementation GFNavigationController

static NSArray<NSString *> *pageClasses;

+ (void)load {
    if (self == GFNavigationController.class) {
        pageClasses = @[
            @"GFWelcomePage",
            @"GFRootPasswordPage"
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

- (void)pushNextPage {
    if (self.viewControllers.count < pages.count) {   
        [self pushViewController:pages[self.viewControllers.count] animated:YES];
    }
    else {
        setupCompleted = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"View did disappear");
    if (!setupCompleted) {
        UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"Warning"
            message:@"The setup wasn't completed. It will be restarted after a respring."
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil
        ];
        [alertView show];
    }
}

- (void)dealloc {
    GFDisableHooks();
}

@end