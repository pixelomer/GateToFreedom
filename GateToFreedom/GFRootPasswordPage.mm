#import "GFRootPasswordPage.h"

@implementation GFRootPasswordPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountName = @"root";
    self.accountDescriptionLabel.text = LC(@"ROOT_DESCRIPTION");
}

@end