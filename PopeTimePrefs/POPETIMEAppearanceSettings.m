#import "POPETIMERootListController.h"

@implementation POPETIMEAppearanceSettings

-(UIColor *)tintColor {
    //return [UIColor colorWithRed:0.64 green:0.67 blue:1.00 alpha:1.0];
    return [UIColor colorWithRed:0.98 green:0.75 blue:0.53 alpha:1.0];
}

-(UIColor *)statusBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)tableViewCellSeparatorColor {
    return [UIColor colorWithWhite:0 alpha:0];
}

-(UIColor *)navigationBarBackgroundColor {
    //return [UIColor colorWithRed:0.64 green:0.67 blue:1.00 alpha:1.0];
    return [UIColor colorWithRed:0.98 green:0.75 blue:0.53 alpha:1.0];
}

-(BOOL)translucentNavigationBar {
    //return NO;
    return YES;
}

/*- (NSUInteger)largeTitleStyle {
    return 2;
}*/

@end