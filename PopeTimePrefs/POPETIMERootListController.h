#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>

#if __has_include (<CepheiPrefs/CepheiPrefs-Swift.h>)
#import <CepheiPrefs/CepheiPrefs-Swift.h>
#import <CepheiPrefs/PSListController+HBTintAdditions.h>
#else
#import <CepheiPrefs/HBAppearanceSettings.h>
#endif

#import <Cephei/HBPreferences.h>

@interface POPETIMERootListController : HBRootListController {
    UITableView * _table;
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;

@end
