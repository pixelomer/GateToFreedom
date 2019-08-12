#import <UIKit/UIKit.h>

@class GFNavigationController;

@interface GFPage : UIViewController {
    UIButton *_continueButton;
    UIBarButtonItem *_nextButton;
}
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, assign) BOOL showsContinueButton;
@property (nonatomic, readonly, strong) GFNavigationController *navigationController;
- (void)viewDidLoad;
- (void)handleContinueButton;
@end