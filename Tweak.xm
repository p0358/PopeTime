#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#include <rootless.h>

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
static NSInteger audioStartAt;
static BOOL didInitSoundAlready = false;
static BOOL werePrefsUpdated = false;

static void prefsDidUpdate() {
    werePrefsUpdated = true;
}

static inline BOOL is2137() {
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];

    return [[NSString stringWithFormat: @"%@", newDateString] isEqualToString: @"21:37"];
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

            UIImageView *popeImageView = [[UIImageView alloc] init];

            NSArray *animationFrames = [NSArray arrayWithObjects:
                [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope0.png")],
                [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope1.png")],
                [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope2.png")],
                [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope3.png")],
                [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope4.png")],
                [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope5.png")],
                [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope6.png")],
            nil];
            
            popeImageView.frame = v.superview.bounds;
            popeImageView.tag = kOverlayViewTag;
            switch (displayMode) {
                case 1: popeImageView.contentMode = UIViewContentModeScaleAspectFit; break;
                case 2: popeImageView.contentMode = UIViewContentModeScaleAspectFill; break;
                case 0:
                default: popeImageView.contentMode = UIViewContentModeBottom; break;
            }

            popeImageView.animationImages = animationFrames;
            popeImageView.animationDuration = 0.35;
            [popeImageView startAnimating];

            if (![popeImageView isDescendantOfView: v.superview.superview.superview]) {
                [v.superview.superview.superview insertSubview: popeImageView atIndex: 0];
            }

        }

        if (isAudioEnabled) {

            // init sound if needed
            if (!didInitSoundAlready) {
                player = [[objc_getClass("AVAudioPlayer") alloc] initWithContentsOfURL:[NSURL fileURLWithPath:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/inba.mp3") isDirectory:NO] error:nil];
                didInitSoundAlready = true;
            }

            if (![player isPlaying]) {
                if (audioStartAt > 0) switch (audioStartAt) {
                    case 1: player.currentTime = 22; break;
                    case 2: player.currentTime = 44; break;
                }
                [player play];
            }
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

    [preferences registerBool:&isEnabledAllTheTime default:NO forKey:@"ShowAllTheTime"];
    [preferences registerInteger:&displayMode default:0 forKey:@"DisplayMode"];
    [preferences registerBool:&isAudioEnabled default:NO forKey:@"AudioEnabled"];
    [preferences registerInteger:&audioStartAt default:0 forKey:@"AudioStartAt"];

    [preferences registerPreferenceChangeBlock:^{
        prefsDidUpdate();
    }];
}
