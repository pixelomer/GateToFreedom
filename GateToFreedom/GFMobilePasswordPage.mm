#import "GFMobilePasswordPage.h"

@implementation GFMobilePasswordPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountName = @"mobile";
    self.accountDescriptionLabel.text = LC(@"MOBILE_DESCRIPTION");
}

@end