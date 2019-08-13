#import <UIKit/UIKit.h>

@class GFNavigationController;

@interface GFPage : UIViewController {
    UIBarButtonItem *_nextButton;
    BOOL didHandleButton;
}
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *continueButton;
@property (nonatomic, strong, readonly) UIButton *skipButton;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UIImageView *headerIconView;
@property (nonatomic, assign) BOOL showsContinueButton;
@property (nonatomic, assign) BOOL showsSkipButton;
@property (nonatomic, readonly, strong) GFNavigationController *navigationController;
- (void)viewDidLoad;
- (void)handleContinueButton;
- (void)handleSkipButton;
@end