//
//  MPUtilities.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 8/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMPStylesDirectoryName;
extern NSString * const kMPStyleFileExtension;
extern NSString * const kMPThemesDirectoryName;
extern NSString * const kMPThemeFileExtension;
extern NSString * const kMPPlugInsDirectoryName;
extern NSString * const kMPPlugInFileExtension;

NSString *MPDataDirectory(NSString *relativePath);
NSString *MPPathToDataFile(NSString *name, NSString *dirPath);

NSArray *MPListEntriesForDirectory(
    NSString *dirName, NSString *(^processor)(NSString *absolutePath)
);

// Block factory for MPListEntriesForDirectory
NSString *(^MPFileNameHasExtensionProcessor(NSString *ext))(NSString *path);

BOOL MPCharacterIsWhitespace(unichar character);
BOOL MPCharacterIsNewline(unichar character);
BOOL MPStringIsNewline(NSString *str);
BOOL MPShouldOpenFileInPreviewOnly(BOOL opensFilesInPreviewOnly,
                                   BOOL hasFileURL,
                                   BOOL hasSavedSplitState);
BOOL MPHasSavedSplitStateForAutosaveName(NSString *autosaveName);

extern const CGFloat kMPMinPreferredWindowWidth;
extern const CGFloat kMPMinPreferredWindowHeight;

// Returns whether a document window with no remembered frame should be opened
// at the user's preferred content size. True only when the feature is enabled,
// the window has no remembered frame, and the preferred size is non-zero.
BOOL MPShouldApplyPreferredWindowSize(BOOL enabled, BOOL hasRememberedFrame,
                                      NSSize preferred);

// Clamps a content size to a floor (kMPMinPreferredWindowWidth/Height) and a
// ceiling (screenVisibleSize). A zero screenVisibleSize applies only the floor.
NSSize MPClampPreferredWindowSize(NSSize size, NSSize screenVisibleSize);

NSString *MPStylePathForName(NSString *name);
NSString *MPThemePathForName(NSString *name);
NSURL *MPHighlightingThemeURLForName(NSString *name);
NSString *MPReadFileOfPath(NSString *path);

NSDictionary *MPGetDataMap(NSString *name);

id MPGetObjectFromJavaScript(NSString *code, NSString *variableName);


static void (^MPDocumentOpenCompletionEmpty)(
        NSDocument *doc, BOOL wasOpen, NSError *error) = ^(
        NSDocument *doc, BOOL wasOpen, NSError *error) {

};
