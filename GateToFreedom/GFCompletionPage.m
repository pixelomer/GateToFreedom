#import "GFCompletionPage.h"
#import <objc/runtime.h>

@implementation GFCompletionPage

- (void)viewDidLoad {
    [super viewDidLoad];

    // Welcome label
    UILabel *welcomeLabel = [UILabel new];
    welcomeLabel.font = self.titleLabel.font;
    welcomeLabel.numberOfLines = 1;
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    welcomeLabel.adjustsFontSizeToFitWidth = YES;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = [NSString stringWithFormat:@"Welcome to %@", [UIDevice.currentDevice.model componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].firstObject];
    [self.view addSubview:welcomeLabel];
    [welcomeLabel.leftAnchor constraintEqualToAnchor:self.view.readableContentGuide.leftAnchor].active =
    [welcomeLabel.rightAnchor constraintEqualToAnchor:self.view.readableContentGuide.rightAnchor].active =
    [welcomeLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;

    // Get started button
    object_setClass(self.continueButton, [UIButton class]);
    [self.continueButton setTitleColor:self.continueButton.tintColor forState:UIControlStateNormal];
    self.continueButton.backgroundColor = [UIColor clearColor];
    [self.continueButton setTitle:@"Get Started" forState:UIControlStateNormal];
    self.continueButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
}

@end