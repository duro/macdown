//
//  MPPreferencesTests.m
//  MPPreferencesTests
//
//  Created by Tzu-ping Chung  on 6/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPPreferences.h"

@interface MPPreferencesTests : XCTestCase
@property MPPreferences *preferences;
@property NSDictionary *oldFontInfo;
@end


@implementation MPPreferencesTests

- (void)setUp
{
    [super setUp];
    self.preferences = [MPPreferences sharedInstance];
    self.oldFontInfo = [self.preferences.editorBaseFontInfo copy];

}

- (void)tearDown
{
    self.preferences.editorBaseFontInfo = self.oldFontInfo;
    [self.preferences synchronize];
    [super tearDown];
}

- (void)testFont
{
    NSFont *font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
    self.preferences.editorBaseFont = font;

    XCTAssertTrue([self.preferences synchronize],
                  @"Failed to synchronize user defaults.");

    NSFont *result = [self.preferences.editorBaseFont copy];
    XCTAssertEqualObjects(font, result,
                          @"Preferences not preserving font info correctly.");
}

- (void)testOpensFilesInPreviewOnlyPersists
{
    BOOL old = self.preferences.opensFilesInPreviewOnly;

    self.preferences.opensFilesInPreviewOnly = YES;
    XCTAssertTrue([self.preferences synchronize],
                  @"Failed to synchronize user defaults.");
    XCTAssertTrue([MPPreferences sharedInstance].opensFilesInPreviewOnly,
                  @"opensFilesInPreviewOnly did not persist as YES.");

    self.preferences.opensFilesInPreviewOnly = NO;
    XCTAssertTrue([self.preferences synchronize],
                  @"Failed to synchronize user defaults.");
    XCTAssertFalse([MPPreferences sharedInstance].opensFilesInPreviewOnly,
                   @"opensFilesInPreviewOnly did not persist as NO.");

    self.preferences.opensFilesInPreviewOnly = old;     // restore prior value
    [self.preferences synchronize];
}

@end
