#import "GFPage.h"

@interface GFPasswordPage : GFPage<UITextFieldDelegate> {
    UIImageView *_lockImageView;
    UITextField *_newPasswordField;
    UITextField *_verifyPasswordField;
}
@property (nonatomic, readonly, strong) UILabel *accountDescriptionLabel;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, assign) BOOL showAccountDescription;
@end