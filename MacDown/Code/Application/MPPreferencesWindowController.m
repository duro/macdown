//
//  MPPreferencesWindowController.m
//  MacDown
//

#import "MPPreferencesWindowController.h"


@implementation MPPreferencesWindowController
{
    BOOL _fittingInProgress;    // guards -fitWindowToSelectedPane re-entry
}

- (void)windowDidLoad
{
    // Set the modern toolbar style before super selects the first pane, so the
    // geometry super computes already accounts for it. MASPreferences predates
    // -[NSWindow toolbarStyle] (macOS 11+); without Expanded the label-only
    // panes collapse into a » overflow on the modern SDK.
    if (@available(macOS 11.0, *))
        self.window.toolbarStyle = NSWindowToolbarStyleExpanded;

    // Observe BEFORE calling super: super's -windowDidLoad selects the first
    // pane, which posts this notification synchronously. Registering first
    // means we size the initial pane too, not only later tab switches.
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(selectedPaneDidChange:)
               name:kMASPreferencesWindowControllerDidChangeViewNotification
             object:self];

    [super windowDidLoad];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)selectedPaneDidChange:(NSNotification *)notification
{
    [self fitWindowToSelectedPane];
}

- (void)fitWindowToSelectedPane
{
    if (_fittingInProgress)
        return;

    NSView *view = self.selectedViewController.view;
    if (!view)
        return;

    // Force a layout pass so controls report their modern-SDK heights, then ask
    // Auto Layout for the height the pane actually needs.
    [view layoutSubtreeIfNeeded];
    CGFloat needed = view.fittingSize.height;

    NSRect contentRect =
        [self.window contentRectForFrameRect:self.window.frame];
    if (needed <= NSHeight(contentRect) + 0.5)
        return;             // already tall enough — leave it alone

    // MASPreferences caps contentMaxSize at the baked height for panes it
    // treats as non-resizable; lift the cap so the window can grow.
    NSSize maxSize = self.window.contentMaxSize;
    if (maxSize.height < needed)
    {
        maxSize.height = needed;
        self.window.contentMaxSize = maxSize;
    }

    // Grow downward: keep the existing top-left corner fixed. The
    // _fittingInProgress flag brackets -setFrame:display: (which drives a
    // display cycle while we are inside a pane-change notification) so a
    // re-entrant call cannot recurse here.
    NSRect targetContent = NSMakeRect(0.0, 0.0, NSWidth(contentRect), needed);
    NSRect targetFrame = [self.window frameRectForContentRect:targetContent];
    NSRect oldFrame = self.window.frame;
    targetFrame = NSOffsetRect(targetFrame,
                               NSMinX(oldFrame),
                               NSMaxY(oldFrame) - NSMaxY(targetFrame));
    _fittingInProgress = YES;
    [self.window setFrame:targetFrame display:YES animate:NO];
    _fittingInProgress = NO;
}

@end
