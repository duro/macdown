//
//  MPUtilityTests.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 23/8.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPUtilities.h"

@interface MPUtilityTests : XCTestCase
@end


@implementation MPUtilityTests

- (void)testShouldOpenFileInPreviewOnly
{
    // Full truth table over (opensFilesInPreviewOnly, hasFileURL,
    // hasSavedSplitState). Only true when the pref is on AND opened from a
    // file AND no saved split state.
    XCTAssertTrue(MPShouldOpenFileInPreviewOnly(YES, YES, NO),
                  @"pref on + has file + no saved state should be preview-only");

    XCTAssertFalse(MPShouldOpenFileInPreviewOnly(NO, NO, NO),
                   @"all off");
    XCTAssertFalse(MPShouldOpenFileInPreviewOnly(NO, NO, YES),
                   @"pref off + no file + saved state");
    XCTAssertFalse(MPShouldOpenFileInPreviewOnly(NO, YES, NO),
                   @"pref off + has file + no saved state");
    XCTAssertFalse(MPShouldOpenFileInPreviewOnly(NO, YES, YES),
                   @"pref off + has file + saved state");
    XCTAssertFalse(MPShouldOpenFileInPreviewOnly(YES, NO, NO),
                   @"new untitled doc (no file URL) should not be forced");
    XCTAssertFalse(MPShouldOpenFileInPreviewOnly(YES, NO, YES),
                   @"pref on + no file + saved state");
    XCTAssertFalse(MPShouldOpenFileInPreviewOnly(YES, YES, YES),
                   @"file with remembered split state should not be forced");
}

- (void)testHasSavedSplitStateForAutosaveName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = @"macdown-unit-test-autosave-name";
    NSString *key =
        [NSString stringWithFormat:@"NSSplitView Subview Frames %@", name];

    [defaults removeObjectForKey:key];
    XCTAssertFalse(MPHasSavedSplitStateForAutosaveName(name),
                   @"No saved state should report NO.");

    [defaults setObject:@"0.000000, 0.000000, 200.000000, 300.000000, NO, NO"
                 forKey:key];
    XCTAssertTrue(MPHasSavedSplitStateForAutosaveName(name),
                  @"Saved state should report YES.");

    [defaults removeObjectForKey:key];                  // clean up
    XCTAssertFalse(MPHasSavedSplitStateForAutosaveName(nil),
                   @"nil name should report NO.");
    XCTAssertFalse(MPHasSavedSplitStateForAutosaveName(@""),
                   @"empty name should report NO.");
}

- (void)testGetObjectFromJavaScript
{
    NSString *code = (
        @"var obj = { foo: 'bar', baz: 42 };"
        @"var arr = [0, null, {}];"
    );
    id obj = MPGetObjectFromJavaScript(code, @"obj");
    id objx = @{@"foo": @"bar", @"baz": @42};
    XCTAssertEqualObjects(obj, objx, @"JavaScript object to NSDictionary");

    id arr = MPGetObjectFromJavaScript(code, @"arr");
    id arrx = @[@0, [NSNull null], @{}];
    XCTAssertEqualObjects(arr, arrx, @"JavaScript object to NSDictionary");
}

@end
