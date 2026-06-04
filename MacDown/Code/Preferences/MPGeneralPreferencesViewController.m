//
//  MPGeneralPreferencesViewController.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 01/7.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPGeneralPreferencesViewController.h"
#import "MPPreferences.h"
#import "MPUtilities.h"


@interface MPGeneralPreferencesViewController ()
@property (weak) IBOutlet NSButton *autoRenderingToggle;
@property (weak) IBOutlet NSButton *useCurrentSizeButton;
@property (weak) IBOutlet NSTextField *preferredSizeLabel;
@end


@implementation MPGeneralPreferencesViewController

- (void)viewWillAppear
{
    [super viewWillAppear];
    [self refreshPreferredSizeControls];
}


#pragma mark - MASPreferencesViewController

- (NSString *)viewIdentifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"PreferencesGeneral"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Preference pane title.");
}


#pragma mark - IBAction

- (IBAction)updateWordCounterVisibility:(id)sender
{
    if (sender == self.autoRenderingToggle)
    {
        if (self.autoRenderingToggle.state != NSOnState)
            self.preferences.editorShowWordCount = NO;
    }
}

- (IBAction)useCurrentWindowSizeAsDefault:(id)sender
{
    NSWindow *docWindow = [self frontmostDocumentWindow];
    if (!docWindow)
        return;

    NSSize content =
        [docWindow contentRectForFrameRect:docWindow.frame].size;
    NSSize screen = docWindow.screen.visibleFrame.size;
    NSSize clamped = MPClampPreferredWindowSize(content, screen);

    self.preferences.preferredWindowWidth = clamped.width;
    self.preferences.preferredWindowHeight = clamped.height;
    [self.preferences synchronize];

    [self refreshPreferredSizeControls];
}

// The frontmost on-screen window backed by a document (skips the Preferences
// panel and other non-document windows). orderedWindows is front-to-back.
- (NSWindow *)frontmostDocumentWindow
{
    for (NSWindow *window in [NSApp orderedWindows])
    {
        if (window.isVisible && window.windowController.document)
            return window;
    }
    return nil;
}

- (void)refreshPreferredSizeControls
{
    CGFloat w = self.preferences.preferredWindowWidth;
    CGFloat h = self.preferences.preferredWindowHeight;
    if (w > 0 && h > 0)
    {
        self.preferredSizeLabel.stringValue =
            [NSString stringWithFormat:@"%.0f × %.0f", w, h];
    }
    else
    {
        self.preferredSizeLabel.stringValue =
            NSLocalizedString(@"Not set",
                              @"Preferred window size not yet captured.");
    }
    self.useCurrentSizeButton.enabled =
        ([self frontmostDocumentWindow] != nil);
}

@end
