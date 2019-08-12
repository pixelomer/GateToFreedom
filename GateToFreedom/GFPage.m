#import "GFPage.h"
#import "GFContinueButton.h"
#import "GFNavigationController.h"

@implementation GFPage

@dynamic navigationController;

- (instancetype)init {
    if ((self = [super init])) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:34.0 weight:UIFontWeightBold];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;

        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont systemFontOfSize:17.0];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.numberOfLines = 0;

        _nextButton = [[UIBarButtonItem alloc]
            initWithTitle:@"Next"
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(didPressNextButton:)
        ];
        self.showsContinueButton = NO;
    }
    return self;
}

- (void)addReadableContentConstraintsForView:(UIView *)view {
    [view.leftAnchor constraintEqualToAnchor:self.view.readableContentGuide.leftAnchor].active =
    [view.rightAnchor constraintEqualToAnchor:self.view.readableContentGuide.rightAnchor].active = YES;
}

- (void)addReadableContentConstraints {
    NSArray *views = @[
        _continueButton ?: NSNull.null,
        _titleLabel,
        _descriptionLabel
    ];
    for (UIView *view in views) {
        if ([view isKindOfClass:[UIView class]]) {
            [self addReadableContentConstraintsForView:view];
        }
    }
}

- (void)addContinueButtonConstraints {
    if (_continueButton) {
        [self.view addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"V:[continue(==50)]-44-|"
            options:0
            metrics:nil
            views:@{ @"continue" : _continueButton }
        ]];
    }
}

// UIButton at the bottom
- (void)didPressContinueButton:(id)sender {
    [self handleContinueButton];
}

// UIBarButtonItem at the top right
- (void)didPressNextButton:(id)sender {
    [self handleContinueButton];
}

- (void)handleContinueButton {
    [self.navigationController pushNextPage];
}

- (void)setShowsContinueButton:(BOOL)shouldShow {
    if (shouldShow) {
        if (!_continueButton) {
            _continueButton = [GFContinueButton button];
            _continueButton.translatesAutoresizingMaskIntoConstraints = NO;
            _continueButton.layer.masksToBounds = YES;
            _continueButton.layer.cornerRadius = 8.0;
            [_continueButton addTarget:self action:@selector(didPressContinueButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.navigationItem.rightBarButtonItem = nil;
        [self.view addSubview:_continueButton];
        if (self.isViewLoaded) {
            [self addContinueButtonConstraints];
            [self addReadableContentConstraintsForView:_continueButton];
        }
    }
    else {
        [_continueButton removeFromSuperview];
        self.navigationItem.rightBarButtonItem = _nextButton;
    }
    _showsContinueButton = shouldShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_descriptionLabel];
    [self.view addConstraints:[NSLayoutConstraint
        constraintsWithVisualFormat:@"V:[title(>=0)]-10-[desc(>=0)]"
        options:0
        metrics:nil
        views:@{ @"title" : _titleLabel, @"desc" : _descriptionLabel }
    ]];
    if (@available(iOS 11.0, *))
    [_titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self addReadableContentConstraints];
    [self addContinueButtonConstraints];
}

@end