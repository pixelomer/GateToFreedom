#import <UIKit/UIKit.h>

@interface GFNavigationController : UINavigationController {
    NSArray<__kindof UIViewController *> *pages;
    BOOL showAlertOnDisappear;
}
- (instancetype)init;
- (void)pushNextPage;
- (BOOL)isOnLastStep;
- (void)completeSetup;
- (void)skipToNextSection;
- (void)abortSetupWithAlert:(BOOL)showAlert;
@end