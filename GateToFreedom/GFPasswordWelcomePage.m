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
    self.titleLabel.text = @"Keep Your Device Secure";
    self.descriptionLabel.text = @"Normally, every iOS device uses the same passwords for system accounts. People can remotely connect to your device with these passwords, so the setup will help you change them.";
    self.showsSkipButton = YES;
    [self.skipButton setTitle:@"Change Later" forState:UIControlStateNormal];
}

- (void)handleSkipButton {
    GFAlertController *alert = [GFAlertController
        alertControllerWithTitle:@"Are you sure?"
        message:@"Skipping this step will leave your device insecure. Anyone who is on the same network as you will be able to access your phone using SSH."
        preferredStyle:UIAlertControllerStyleAlert
    ];
    [alert addAction:[UIAlertAction
        actionWithTitle:@"Skip"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction *action){
            dispatch_async(dispatch_get_main_queue(), ^{
                [super handleSkipButton];
            });
        }
    ]];
    [alert addAction:[UIAlertAction
        actionWithTitle:@"Cancel"
        style:UIAlertActionStyleCancel
        handler:nil
    ]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end