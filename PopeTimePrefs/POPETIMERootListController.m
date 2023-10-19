#include "POPETIMERootListController.h"
#include <rootless.h>

@implementation POPETIMERootListController

- (instancetype)init {
    self = [super init];

    if (self) {
        //POPETIMEAppearanceSettings *appearanceSettings = [[POPETIMEAppearanceSettings alloc] init];
        //self.hb_appearanceSettings = appearanceSettings;
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        //appearanceSettings.tintColor = [UIColor colorWithRed:0.64 green:0.67 blue:1.00 alpha:1];
        appearanceSettings.tintColor = [UIColor colorWithRed:0.98 green:0.75 blue:0.53 alpha:1];
        //appearanceSettings.statusBarTintColor = [UIColor whiteColor]; // deprecated
        appearanceSettings.statusBarStyle = UIStatusBarStyleLightContent;
        appearanceSettings.navigationBarTitleColor = [UIColor whiteColor];
        appearanceSettings.navigationBarTintColor = [UIColor whiteColor];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        //appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:0.64 green:0.67 blue:1.00 alpha:1];
        appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:0.98 green:0.75 blue:0.53 alpha:1];
        //appearanceSettings.translucentNavigationBar = YES;
        //appearanceSettings.largeTitleStyle = 2;
        self.hb_appearanceSettings = appearanceSettings;

        /*self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"ReSpring" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(respring)];
        self.respringButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = self.respringButton;*/

        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"PopeTime";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/PreferenceBundles/PopeTimePrefs.bundle/icon@2x.png")];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
    }

    return self;
}

-(NSArray *)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /*self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    //self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PopeTimePrefs.bundle/Banner.png"];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;*/

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];

    NSArray *animationFrames = [NSArray arrayWithObjects:
        [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope0.png")],
        [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope1.png")],
        [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope2.png")],
        [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope3.png")],
        [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope4.png")],
        [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope5.png")],
        [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/Application Support/PopeTime/pope6.png")],
    nil];
    
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.headerImageView.animationImages = animationFrames;
    self.headerImageView.animationDuration = 0.35;
    [self.headerImageView startAnimating];

    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //CGRect frame = self.table.bounds;
    //frame.origin.y = -frame.size.height;

    //self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.64 green:0.67 blue:1.00 alpha:1.0];
    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.98 green:0.75 blue:0.53 alpha:1.0];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //self.navigationController.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //[self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //[self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /*CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }
    
    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);*/
}

/*-(void)respring {
	UIAlertController *respring = [UIAlertController alertControllerWithTitle:@"TweakName"
													 message:@"Do you really want to ReSpring?"
													 preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			[self respringUtil];
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[respring addAction:confirmAction];
	[respring addAction:cancelAction];
	[self presentViewController:respring animated:YES completion:nil];

}

-(void)respringUtil {
	NSTask *t = [[NSTask alloc] init];
    [t setLaunchPath:@"/usr/bin/killall"];
    [t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [t launch];
}*/

@end
