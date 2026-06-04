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
