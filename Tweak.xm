#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <AVFoundation/AVFoundation.h>

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
AVAudioPlayer *player;
static BOOL isEnabledAllTheTime;
static NSInteger displayMode;
static BOOL isAudioEnabled;
static BOOL werePrefsUpdated = false;

static void prefsDidUpdate() {
    werePrefsUpdated = true;
}

static BOOL is2137() {
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];

    return [[NSString stringWithFormat: @"%@", newDateString] isEqualToString: @"21:37"];
}

static BOOL didInitSoundAlready = false;
static void initSoundIfNeeded() {
    if (didInitSoundAlready) return;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"/Library/Application Support/PopeTime/inba.mp3" isDirectory:NO] error:nil];
    [player prepareToPlay];
    didInitSoundAlready = true;
}

static void updatePopeView(UIView *v) {

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
    
    if (isEnabledAllTheTime || is2137()) {

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
            switch (displayMode) {
                case 1: snoopImageView.contentMode = UIViewContentModeScaleAspectFit; break;
                case 2: snoopImageView.contentMode = UIViewContentModeScaleAspectFill; break;
                case 0:
                default: snoopImageView.contentMode = UIViewContentModeBottom; break;
            }

            snoopImageView.animationImages = animationFrames;
            snoopImageView.animationDuration = 0.35;
            [snoopImageView startAnimating];

            if (![snoopImageView isDescendantOfView: v.superview.superview.superview]) {
                [v.superview.superview.superview insertSubview: snoopImageView atIndex: 0];
            }

        }

        if (isAudioEnabled) {
            initSoundIfNeeded();
            if (![player isPlaying])
                [player play];
        }

    } else if (isAlreadyThere) {
        for (UIView *view in v.superview.superview.superview.subviews) {
            if (view.tag == kOverlayViewTag) {
                [view removeFromSuperview];
            }
        }
    }

    if (!isAudioEnabled && didInitSoundAlready && [player isPlaying])
        [player stop];
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
    /*[preferences registerDefaults:@{
        @"ShowAllTheTime": @NO
        //@"AnotherSetting": @1.f
    }];*/

    [preferences registerBool:&isEnabledAllTheTime default:NO forKey:@"ShowAllTheTime"];
    [preferences registerInteger:&displayMode default:0 forKey:@"DisplayMode"];
    [preferences registerBool:&isAudioEnabled default:NO forKey:@"AudioEnabled"];

    [preferences registerPreferenceChangeBlock:^{
        prefsDidUpdate();
    }];

    //NSLog(@"Am I enabled all the time? %i", [preferences boolForKey:@"ShowAllTheTime"]);
    //NSLog(@"Can I do thing? %i", doThing);

    player = [[AVAudioPlayer alloc] init];
}
