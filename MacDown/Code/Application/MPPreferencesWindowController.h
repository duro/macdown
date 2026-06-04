//
//  MPPreferencesWindowController.h
//  MacDown
//
//  Sizes the Preferences window to each pane's true Auto Layout height.
//

#import <MASPreferences/MASPreferencesWindowController.h>

/**
 * A MASPreferences window controller that resizes the window to the selected
 * pane's real Auto Layout fitting height after the pane appears.
 *
 * MASPreferences sizes the window from each pane view's baked nib bounds, which
 * ibtool computed from design-time control metrics. The modern SDK draws
 * controls taller at runtime, so some panes end up clipped. This subclass
 * grows the window (never shrinks it) to fit the live fitting size.
 */
@interface MPPreferencesWindowController : MASPreferencesWindowController

@end
