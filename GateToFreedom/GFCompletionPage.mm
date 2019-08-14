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
    welcomeLabel.text = [NSString stringWithFormat:LC(@"WELCOME_TO_DEVICE"), [UIDevice.currentDevice.model componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].firstObject];
    [self.view addSubview:welcomeLabel];
    [welcomeLabel.leftAnchor constraintEqualToAnchor:self.view.readableContentGuide.leftAnchor].active =
    [welcomeLabel.rightAnchor constraintEqualToAnchor:self.view.readableContentGuide.rightAnchor].active =
    [welcomeLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;

    // Get started button
    object_setClass(self.continueButton, [UIButton class]);
    [self.continueButton setTitleColor:self.continueButton.tintColor forState:UIControlStateNormal];
    self.continueButton.backgroundColor = [UIColor clearColor];
    [self.continueButton setTitle:LC(@"GET_STARTED") forState:UIControlStateNormal];
    self.continueButton.titleLabel.font = [UIFont systemFontOfSize:25.0];

    // A message to people who are going to steal this tweak
    char message[84];
    message[0] = 0x54; message[1] = 0x68; message[2] = 0x69; message[3] = 0x73; message[4] = 0x20; message[5] = 0x74; message[6] = 0x77; message[7] = 0x65; message[8] = 0x61; message[9] = 0x6b; message[10] = 0x20; message[11] = 0x77; message[12] = 0x61; message[13] = 0x73; message[14] = 0x20; message[15] = 0x6d; message[16] = 0x61; message[17] = 0x64; message[18] = 0x65; message[19] = 0x20; message[20] = 0x62; message[21] = 0x79; message[22] = 0x20; message[23] = 0x40; message[24] = 0x70; message[25] = 0x69; message[26] = 0x78; message[27] = 0x65; message[28] = 0x6c; message[29] = 0x6f; message[30] = 0x6d; message[31] = 0x65; message[32] = 0x72; message[33] = 0x20; message[34] = 0x66; message[35] = 0x6f; message[36] = 0x72; message[37] = 0x20; message[38] = 0x74; message[39] = 0x68; message[40] = 0x65; message[41] = 0x20; message[42] = 0x75; message[43] = 0x6e; message[44] = 0x63; message[45] = 0x30; message[46] = 0x76; message[47] = 0x65; message[48] = 0x72; message[49] = 0x20; message[50] = 0x6a; message[51] = 0x61; message[52] = 0x69; message[53] = 0x6c; message[54] = 0x62; message[55] = 0x72; message[56] = 0x65; message[57] = 0x61; message[58] = 0x6b; message[59] = 0x2e; message[60] = 0x20; message[61] = 0x50; message[62] = 0x6c; message[63] = 0x65; message[64] = 0x61; message[65] = 0x73; message[66] = 0x65; message[67] = 0x20; message[68] = 0x64; message[69] = 0x6f; message[70] = 0x6e; message[71] = 0x27; message[72] = 0x74; message[73] = 0x20; message[74] = 0x73; message[75] = 0x74; message[76] = 0x65; message[77] = 0x61; message[78] = 0x6c; message[79] = 0x20; message[80] = 0x69; message[81] = 0x74; message[82] = 0x2e; message[83] = 0x00;
    [self.skipButton setTitle:@(message) forState:UIControlStateNormal];
    self.skipButton.hidden = YES;
}

@end