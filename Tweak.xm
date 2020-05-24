#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

#define kOverlayViewTag 21372137

// iOS 13
@interface SBFLockScreenDateViewController: UIViewController
-(void)_updateView;
@end

// iOS 12
@interface SBLockScreenDateViewController: UIViewController
-(void)_updateView;
@end

HBPreferences *preferences;
BOOL isEnabledAllTheTime = false;
BOOL werePrefsUpdated = false;

static void prefsDidUpdate() {
    werePrefsUpdated = true;
}

static void updatePopeView(UIView *v) {
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];

    BOOL isAlreadyThere = false;

    for (UIView *view in v.superview.superview.superview.subviews) {
        if (view.tag == kOverlayViewTag) {
            if (werePrefsUpdated) {
                [view removeFromSuperview]; // preferences were updated, we need to recreate our view
            } else {
                isAlreadyThere = true;
            }
        }
    }
    werePrefsUpdated = false;
    
    if (isEnabledAllTheTime || [[NSString stringWithFormat: @"%@", newDateString] isEqualToString: @"21:37"]) {

        if (!isAlreadyThere) {

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

// iOS 13
%hook SBFLockScreenDateViewController
-(void)_updateView {
    %orig;
    updatePopeView([self view]);
}
%end

// iOS 12
%hook SBLockScreenDateViewController
-(void)_updateView {
    %orig;
    updatePopeView([self view]);
}
%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"net.p0358.popetime"];
    [preferences registerDefaults:@{
        @"EnabledAllTheTime": @NO
        //@"AnotherSetting": @1.f
    }];

    [preferences registerBool:&isEnabledAllTheTime default:NO forKey:@"EnabledAllTheTime"];

    [preferences registerPreferenceChangeBlock:^{
        prefsDidUpdate();
    }];

    NSLog(@"Am I enabled all the time? %i", [preferences boolForKey:@"EnabledAllTheTime"]);
    //NSLog(@"Can I do thing? %i", doThing);
}
