#import "GFMobilePasswordPage.h"

@implementation GFMobilePasswordPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountName = @"mobile";
    self.accountDescriptionLabel.text = @"\"mobile\" is another system account on iOS devices. Although this account doesn't have as many privileges as the root account, it can still access a lot of your personal information. It is recommended for everyone to change the password for this account since the default password for this account is the same as the default password for the root account.";
}

@end