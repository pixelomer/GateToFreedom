#import "GFPasswordWelcomePage.h"
#import <Tweak.h>

@implementation GFPasswordWelcomePage

static UIImage *headerIcon;

- (instancetype)init {
    if (!headerIcon) {
        NSBundle *setupBundle = [NSBundle bundleWithPath:@"/Applications/Setup.app"];
        headerIcon = [UIImage imageNamed:@"cloud_config" inBundle:setupBundle compatibleWithTraitCollection:nil];
    }
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerIconView.image = headerIcon;
    self.titleLabel.text = LC(@"PASSWORDS_WELCOME_TITLE");
    self.descriptionLabel.text = LC(@"PASSWORDS_WELCOME_DESCRIPTION");
    self.showsSkipButton = YES;
    [self.skipButton setTitle:LC(@"PASSWORDS_WELCOME_SKIP") forState:UIControlStateNormal];
}

- (void)handleSkipButton {
    GFAlertController *alert = [GFAlertController
        alertControllerWithTitle:LC(@"ARE_YOU_SURE")
        message:LC(@"PASSWORDS_SKIP_ALERT_MESSAGE")
        preferredStyle:UIAlertControllerStyleAlert
    ];
    [alert addAction:[UIAlertAction
        actionWithTitle:LC(@"SKIP")
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction *action){
            dispatch_async(dispatch_get_main_queue(), ^{
                [super handleSkipButton];
            });
        }
    ]];
    [alert addAction:[UIAlertAction
        actionWithTitle:LC(@"CANCEL")
        style:UIAlertActionStyleCancel
        handler:nil
    ]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end