#import "GFContinueButton.h"

@implementation GFContinueButton

+ (instancetype)button {
    GFContinueButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.tintColor = button.tintColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 8.0;
    button.highlighted = NO;
    [button setTitle:@"Continue" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    CGFloat r,g,b;
    [tintColor getRed:&r green:&g blue:&b alpha:nil];
    highlightedColor = [UIColor colorWithRed:r green:g blue:b alpha:0.5];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? highlightedColor : self.tintColor;
}

@end