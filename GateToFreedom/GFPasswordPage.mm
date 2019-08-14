#import "GFPasswordPage.h"
#import <Tweak.h>

@implementation GFPasswordPage

static UIImage *lockImage;
static UIColor *separatorColor;
static NSString *initialDescription;

+ (void)load {
    if (self == [GFPasswordPage class]) {
        unsigned char lockImageContents[] = {
            0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
            0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00, 0x00, 0x48,
            0x08, 0x04, 0x00, 0x00, 0x00, 0xff, 0xe4, 0x7b, 0xcc, 0x00, 0x00, 0x01,
            0xa3, 0x49, 0x44, 0x41, 0x54, 0x78, 0x01, 0xed, 0xd8, 0x01, 0x47, 0x43,
            0x51, 0x18, 0x87, 0xf1, 0xa7, 0x60, 0x45, 0x2a, 0x42, 0x1a, 0x20, 0x90,
            0x05, 0x40, 0x5b, 0x2b, 0xd2, 0x07, 0x09, 0x16, 0xc8, 0x02, 0x15, 0x00,
            0x05, 0x4a, 0x00, 0x54, 0x02, 0xd5, 0x07, 0x29, 0xa1, 0xaa, 0x12, 0x20,
            0x49, 0x28, 0x43, 0x6d, 0xa3, 0x00, 0x1b, 0x83, 0xed, 0x0d, 0xe0, 0x75,
            0x1d, 0xbb, 0xed, 0xda, 0xbb, 0xc3, 0x76, 0x7e, 0x7f, 0x80, 0xc3, 0x79,
            0x60, 0xbb, 0x1c, 0x06, 0x4d, 0xb0, 0xc8, 0x09, 0xcf, 0x94, 0x68, 0x50,
            0xa7, 0xc4, 0x33, 0xc7, 0xe4, 0xf1, 0x64, 0x84, 0x4d, 0x3e, 0x11, 0xc7,
            0x3e, 0xd9, 0x24, 0x45, 0x8f, 0xad, 0x51, 0x45, 0xda, 0xac, 0xca, 0x1a,
            0x3d, 0xb4, 0x8b, 0x10, 0xbf, 0x3d, 0x7a, 0xe4, 0x14, 0xf9, 0xe7, 0x4e,
            0xc1, 0xde, 0x01, 0xd2, 0xc1, 0xf6, 0x31, 0x56, 0x40, 0x22, 0xbb, 0x61,
            0x87, 0x05, 0x26, 0x99, 0x64, 0x81, 0x6d, 0x6e, 0x91, 0xc8, 0x0a, 0x18,
            0x1a, 0xe1, 0x17, 0x51, 0x7b, 0x27, 0x47, 0x54, 0x8e, 0x77, 0x44, 0xed,
            0x87, 0x51, 0xcc, 0x6c, 0x21, 0x6a, 0x2f, 0x4c, 0xe1, 0x32, 0xc5, 0x0b,
            0xa2, 0xb6, 0x85, 0x99, 0x8a, 0xba, 0xe6, 0x8b, 0x69, 0xc0, 0x6d, 0x9a,
            0x2f, 0x75, 0xb2, 0x82, 0x91, 0x2c, 0xa2, 0xb6, 0x42, 0x3b, 0xab, 0x88,
            0x5a, 0x16, 0x13, 0x87, 0xea, 0x8a, 0x2b, 0xe2, 0x5c, 0xaa, 0xd3, 0x87,
            0x98, 0xb8, 0x56, 0x57, 0x6c, 0x10, 0x67, 0x43, 0x9d, 0xbe, 0xc6, 0x84,
            0xfe, 0xf5, 0xcc, 0x13, 0x27, 0x83, 0xfe, 0x35, 0x9a, 0xa8, 0xab, 0x2b,
            0x26, 0x88, 0x33, 0xa1, 0x4e, 0xd7, 0x30, 0x21, 0x6a, 0xdd, 0x39, 0x1f,
            0x82, 0x42, 0x50, 0x08, 0x4a, 0x51, 0xe4, 0x03, 0xe9, 0xe2, 0x3e, 0x28,
            0x92, 0x22, 0xa1, 0x19, 0xde, 0x10, 0x83, 0xbd, 0x91, 0x26, 0x81, 0x21,
            0xee, 0x10, 0xa3, 0x3d, 0x30, 0x44, 0xc7, 0x0a, 0x88, 0xe1, 0xd6, 0xe9,
            0xd8, 0xa3, 0x69, 0xd0, 0x53, 0xf2, 0x2f, 0x97, 0xcd, 0x6a, 0x74, 0x4c,
            0x8c, 0x17, 0x82, 0x42, 0x50, 0x08, 0x0a, 0x41, 0x7d, 0x1b, 0xd4, 0xe0,
            0x88, 0x59, 0x00, 0x66, 0x39, 0xa2, 0xe1, 0x3b, 0xa8, 0x4c, 0x06, 0x2d,
            0xc3, 0xb7, 0xcf, 0xa0, 0x26, 0xcb, 0x44, 0xe5, 0x69, 0xfa, 0x0b, 0x3a,
            0xc7, 0xe5, 0xcc, 0x5f, 0xd0, 0x22, 0x2e, 0x39, 0x7f, 0x41, 0xe3, 0xb8,
            0x8c, 0xfb, 0x0b, 0x1a, 0xc3, 0x65, 0xcc, 0x5f, 0x50, 0x0e, 0x97, 0xac,
            0xbf, 0xa0, 0x0b, 0x5c, 0xce, 0xfd, 0x05, 0xb5, 0xc8, 0x13, 0xb5, 0x44,
            0xcb, 0xef, 0x1f, 0xe3, 0x1c, 0xda, 0x1c, 0xe5, 0xf0, 0xe9, 0x08, 0x5f,
            0xfb, 0x10, 0x14, 0x82, 0x42, 0xd0, 0xa0, 0x06, 0xd5, 0x3c, 0x3c, 0xc7,
            0xf8, 0x7c, 0xb0, 0xea, 0x83, 0x27, 0xbd, 0x61, 0xee, 0xcd, 0x72, 0xee,
            0x19, 0x26, 0x81, 0x34, 0xaf, 0x26, 0x39, 0xaf, 0xa4, 0x49, 0xfe, 0x70,
            0x4e, 0xa9, 0xab, 0x31, 0x25, 0x8a, 0xa4, 0xf0, 0x28, 0x08, 0x82, 0x3f,
            0xdd, 0x2b, 0x71, 0xac, 0xa3, 0xed, 0x20, 0x8b, 0x00, 0x00, 0x00, 0x00,
            0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82
        };
        lockImage = [UIImage imageWithData:[NSData dataWithBytes:lockImageContents length:sizeof(lockImageContents)]];
        separatorColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.925 alpha:1.0];
        initialDescription = LC(@"TYPE_YOUR_NEW_PASSWORD");
    }
}

- (void)resetDescription {
    self.descriptionLabel.text = initialDescription;
    self.descriptionLabel.textColor = [UIColor blackColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetDescription];
}

- (instancetype)init {
    if ((self = [super init])) {
        [self resetDescription];

        _accountDescriptionLabel = [UILabel new];
        _accountDescriptionLabel.font = [UIFont systemFontOfSize:12.0];
        _accountDescriptionLabel.textColor = [UIColor lightGrayColor];
        _accountDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _accountDescriptionLabel.textAlignment = NSTextAlignmentCenter;
        _accountDescriptionLabel.numberOfLines = 0;

        _lockImageView = [UIImageView new];
        _lockImageView.image = lockImage;
        _lockImageView.contentMode = UIViewContentModeScaleAspectFit;
        _lockImageView.alpha = 0.7;
        _lockImageView.translatesAutoresizingMaskIntoConstraints = NO;

        _newPasswordField = [UITextField new];
        _newPasswordField.placeholder = LC(@"NEW_PASSWORD");

        _verifyPasswordField = [UITextField new];
        _verifyPasswordField.placeholder = LC(@"RETYPE_PASSWORD");
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _newPasswordField) {
        [_verifyPasswordField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)setWarning:(NSString *)message {
    self.descriptionLabel.textColor = [UIColor redColor];
    self.descriptionLabel.text = message;
}

- (void)handleContinueButton {
    NSString *error;
    if (![_newPasswordField.text isEqualToString:_verifyPasswordField.text]) {
        self.warning = LC(@"PASSWORDS_DONT_MATCH_MESSAGE");
    }
    else if (!_newPasswordField.text.length) {
        self.warning = LC(@"EMPTY_PASSWORD_MESSAGE");
    }
    else if (!(error = GFChangeAccountPassword(_accountName, _newPasswordField.text))) {
        [super handleContinueButton];
    }
    else {
        self.warning = error;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // This code makes simple things complex.
    // TODO: Make this code cleaner

    NSArray<UITextField *> *fields = @[
        _newPasswordField,
        _verifyPasswordField
    ];
    for (UITextField *field in fields) {
        field.delegate = self;
        [field setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        field.secureTextEntry = YES;
        field.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:field];
        [field.heightAnchor constraintEqualToConstant:45.0].active = YES;
        [field.rightAnchor constraintEqualToAnchor:self.view.readableContentGuide.rightAnchor].active = YES;
    }
    for (NSInteger i=0; i<fields.count; i++) {
        UITextField *textField = fields[i];
        for (NSInteger j=0; j<fields.count; j++) {
            if (j==i) continue;
            [textField.widthAnchor constraintEqualToAnchor:fields[j].widthAnchor].active = YES;
        }
    }

    NSArray<UIView *> *separators = @[
        [UIView new],
        [UIView new],
        [UIView new]
    ];
    for (UIView *separator in separators) {
        separator.backgroundColor = separatorColor;
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:separator];
        [separator.leftAnchor constraintEqualToAnchor:self.view.readableContentGuide.leftAnchor].active = YES;
        [separator.rightAnchor constraintEqualToAnchor:self.view.readableContentGuide.rightAnchor].active = YES;
        [separator.heightAnchor constraintEqualToConstant:1.0].active = YES;
    }

    NSMutableArray<UILabel *> *labels = @[
        (id)[NSString stringWithFormat:@"%@  ", LC(@"PASSWORD")],
        (id)[NSString stringWithFormat:@"%@  ", LC(@"VERIFY")]
    ].mutableCopy;
    for (NSInteger i=0; i<labels.count; i++) {
        NSString *text = (id)labels[i];
        UILabel *label = [UILabel new];
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        label.font = [UIFont systemFontOfSize:_newPasswordField.font.pointSize weight:UIFontWeightSemibold];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = text;
        labels[i] = label;
        [self.view addSubview:label];
        [label.rightAnchor constraintEqualToAnchor:fields[i].leftAnchor].active = YES;
        [label.heightAnchor constraintEqualToAnchor:fields[i].heightAnchor].active = YES;
        [label.leftAnchor constraintEqualToAnchor:self.view.readableContentGuide.leftAnchor].active = YES;
        [label.topAnchor constraintEqualToAnchor:fields[i].topAnchor].active = YES;
    }
    
    [self.view addConstraints:[NSLayoutConstraint
        constraintsWithVisualFormat:@"V:[desc]-15-[s1]-(2.5)-[password]-(2.5)-[s2]-(2.5)-[verify]-(2.5)-[s3]"
        options:0
        metrics:nil
        views:@{ @"desc" : self.descriptionLabel, @"s1" : separators[0], @"s2" : separators[1], @"s3" : separators[2], @"verify" : _verifyPasswordField, @"password" : _newPasswordField }
    ]];

    // Overcomplicated code ends here.

    [self.view addSubview:_lockImageView];
    [_lockImageView.topAnchor constraintEqualToAnchor:separators[2].bottomAnchor constant:20.0].active =
    [_lockImageView.widthAnchor constraintEqualToConstant:24.0].active =
    [_lockImageView.heightAnchor constraintEqualToAnchor:_lockImageView.widthAnchor].active =
    [_lockImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;

    [self.view addSubview:_accountDescriptionLabel];
    [_accountDescriptionLabel.topAnchor constraintEqualToAnchor:_lockImageView.bottomAnchor constant:5.0].active =
    [_accountDescriptionLabel.leftAnchor constraintEqualToAnchor:self.view.readableContentGuide.leftAnchor].active =
    [_accountDescriptionLabel.rightAnchor constraintEqualToAnchor:self.view.readableContentGuide.rightAnchor].active =
    [_accountDescriptionLabel.heightAnchor constraintGreaterThanOrEqualToConstant:0.0].active = YES;
}

- (void)setAccountName:(NSString *)accountName {
    self.titleLabel.text = [NSString stringWithFormat:LC(@"PASSWORD_TITLE_FORMAT"), accountName.lowercaseString.capitalizedString];
    _accountName = accountName;
}

@end