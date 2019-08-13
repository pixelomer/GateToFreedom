#import <UIKit/UIKit.h>

@interface GFNavigationController : UINavigationController {
    NSArray<__kindof UIViewController *> *pages;
    BOOL showAlertOnDisappear;
}
- (instancetype)init;
- (void)pushNextPage;
- (void)completeSetup;
- (void)skipToNextSection;
- (void)abortSetupWithAlert:(BOOL)showAlert;
@end