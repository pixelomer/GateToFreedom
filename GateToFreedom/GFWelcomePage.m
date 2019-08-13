#import "GFWelcomePage.h"

@implementation GFWelcomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = @"Jailbreak Completed";
    self.descriptionLabel.text = @"Your iPhone was jailbroken successfully. You'll need to complete a few more steps to make your device more secure.";
}

@end