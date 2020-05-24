#import <UIKit/UIKit.h>

#define kOverlayViewTag 21372137

@interface SBFLockScreenDateViewController: UIViewController
-(void)_updateView;
//+(void)updatePopeView;
@end

%hook SBFLockScreenDateViewController

/*%new
+(void)updatePopeView {

}*/

-(void)_updateView {
    %orig;
    //[SBFLockScreenDateViewController updatePopeView];
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    UIView *v = [self view];

    BOOL isAlreadyThere = false;

    for (UIView *view in v.superview.superview.superview.subviews) {
        if(view.tag == kOverlayViewTag) {
            isAlreadyThere = true;
        }
    }
    
    if ([[NSString stringWithFormat: @"%@", newDateString] isEqualToString: @"21:37"]) {

        if (!isAlreadyThere) {

            //UIImageView *snoopImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/snoop.png"]];
            UIImageView *snoopImageView = [[UIImageView alloc] init];

            NSArray *animationFrames = [NSArray arrayWithObjects:
                [UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/pope0.png"],
                [UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/pope1.png"],
                [UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/pope2.png"],
                [UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/pope3.png"],
                [UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/pope4.png"],
                [UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/pope5.png"],
                [UIImage imageWithContentsOfFile:@"/Library/Application Support/PopeTime/pope6.png"],
            nil];
            
            snoopImageView.frame = v.superview.bounds;
            snoopImageView.tag = kOverlayViewTag;
            //snoopImageView.contentMode = UIViewContentModeScaleAspectFill;
            snoopImageView.contentMode = UIViewContentModeBottom;

            snoopImageView.animationImages = animationFrames;
            snoopImageView.animationDuration = 0.35;
            [snoopImageView startAnimating];

            if (![snoopImageView isDescendantOfView: v.superview.superview.superview]) {
                [v.superview.superview.superview insertSubview: snoopImageView atIndex: 0];
            }

        }

    } else if (isAlreadyThere) {
        for (UIView *view in v.superview.superview.superview.subviews) {
            if (view.tag == kOverlayViewTag) {
                [view removeFromSuperview];
            }
        }
    }
}

%end
