#import <UIKit/UIKit.h>

@interface GFNavigationController : UINavigationController {
    NSArray<__kindof UIViewController *> *pages;
    BOOL setupCompleted;
}
- (instancetype)init;
- (void)pushNextPage;
@end