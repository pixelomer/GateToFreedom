#import "GFPage.h"
#import "GFContinueButton.h"
#import "GFNavigationController.h"
#import <Tweak.h>

@implementation GFPage

@dynamic navigationController;

- (instancetype)init {
    if ((self = [super init])) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:34.0 weight:UIFontWeightBold];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;

        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont systemFontOfSize:17.0];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.numberOfLines = 0;

        _continueButton = [GFContinueButton button];
        _continueButton.translatesAutoresizingMaskIntoConstraints = NO;
        _continueButton.layer.masksToBounds = YES;
        _continueButton.layer.cornerRadius = 8.0;
        [_continueButton addTarget:self action:@selector(didPressContinueButton:) forControlEvents:UIControlEventTouchUpInside];

        _skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _skipButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_skipButton setTitle:@"Skip" forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(didPressSkipButton:) forControlEvents:UIControlEventTouchUpInside];

        _headerIconView = [UIImageView new];
        _headerIconView.translatesAutoresizingMaskIntoConstraints = NO;

        _nextButton = [[UIBarButtonItem alloc]
            initWithTitle:@"Next"
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(didPressNextButton:)
        ];
        self.showsContinueButton = NO;
        self.showsSkipButton = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    didHandleButton = NO;
}

- (void)addReadableContentConstraints {
    NSArray *views = @[
        _continueButton,
        _titleLabel,
        _descriptionLabel,
        _skipButton
    ];
    for (UIView *view in views) {
        [view.leftAnchor constraintEqualToAnchor:self.view.readableContentGuide.leftAnchor].active =
        [view.rightAnchor constraintEqualToAnchor:self.view.readableContentGuide.rightAnchor].active = YES;
    }
}

// UIButton at the bottom
- (void)didPressContinueButton:(id)sender {
    [self handleContinueButton];
}

// UIButton under the big continue button at the bottom
- (void)didPressSkipButton:(id)sender {
    [self handleSkipButton];
}

// UIBarButtonItem at the top right
- (void)didPressNextButton:(id)sender {
    [self handleContinueButton];
}

- (void)handleContinueButton {
    if (!didHandleButton && (didHandleButton = YES)) {
        [self.navigationController pushNextPage];
    }
}

- (void)handleSkipButton {
    if (!didHandleButton && (didHandleButton = YES)) {
        [self.navigationController skipToNextSection];
    }
}

- (void)setShowsContinueButton:(BOOL)shouldShow {
    if (shouldShow) {
        self.navigationItem.rightBarButtonItem = nil;
        _continueButton.hidden = NO;
    }
    else {
        _continueButton.hidden = YES;
        self.navigationItem.rightBarButtonItem = _nextButton;
    }
    _showsContinueButton = shouldShow;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    GFAlertController *alert = [GFAlertController
        alertControllerWithTitle:title
        message:message
        preferredStyle:UIAlertControllerStyleAlert
    ];
    [alert addAction:[UIAlertAction
        actionWithTitle:@"OK"
        style:UIAlertActionStyleCancel
        handler:nil
    ]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setShowsSkipButton:(BOOL)shouldShow {
    _skipButton.hidden = !shouldShow;
    _showsSkipButton = shouldShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_descriptionLabel];
    [self.view addSubview:_headerIconView];
    [self.view addSubview:_skipButton];
    [self.view addSubview:_continueButton];
    [self.view addConstraints:[NSLayoutConstraint
        constraintsWithVisualFormat:@"V:[icon(>=0)]-10-[title(>=0)]-10-[desc(>=0)]"
        options:0
        metrics:nil
        views:@{ @"title" : _titleLabel, @"desc" : _descriptionLabel, @"icon" : _headerIconView }
    ]];
    [self.view addConstraints:[NSLayoutConstraint
        constraintsWithVisualFormat:@"V:[continue(==50)]-10-[skip(==17.5)]-15-|"
        options:0
        metrics:nil
        views:@{ @"continue" : _continueButton, @"skip" : _skipButton }
    ]];
    [_headerIconView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [_headerIconView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self addReadableContentConstraints];
}

@end