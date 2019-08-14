#import "GFRootPasswordPage.h"

@implementation GFRootPasswordPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountName = @"root";
    self.accountDescriptionLabel.text = @"\"root\" is a system account that has access to every file on your iOS device. By default, this account has the same password on every iOS device, which makes it really easy for people with bad intentions to break into your device and do whatever they want. That is why it is recommended to change your root password after jailbreaking.";
}

@end