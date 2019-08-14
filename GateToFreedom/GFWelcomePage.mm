#import "GFWelcomePage.h"

@implementation GFWelcomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = LC(@"WELCOME_TITLE");
    self.descriptionLabel.text = LC(@"WELCOME_DESCRIPTION");
}

@end