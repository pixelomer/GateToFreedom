#import "GFSection.h"

@implementation GFSection

- (instancetype)init {
    if ((self = [super init])) {
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showsContinueButton = YES;
}

@end