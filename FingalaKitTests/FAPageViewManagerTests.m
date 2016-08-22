//
//  FAPageViewManagerTests.m
//  FingalaKit
//
//  Created by Farhan Yousuf on 19/08/16.
//  Copyright © 2016 fingala. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FingalaKit/FAPageViewManager.h>

@interface FAPageViewManagerTests : XCTestCase

@end

@implementation FAPageViewManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/** This is a test for instance method in class FAPageViewManager with
 *  Method Signature. -initWithPageData:
 *  Used XCTAssertNotNil to check if the method returned a FAPageViewManager object.
 */
- (void)testInitWithPageData {
    
    FAPageViewManager *manager = [[FAPageViewManager alloc] initWithPageData:@[] datasource:nil currentPageIndex:0 isDoubleSided:NO];
    
    XCTAssertNotNil(manager, "a valid instance of manager should be returned from the method");
}

/** This is a test for performance of instance method in class FAPageViewManager with
 *  Method Signature. -initWithPageData:
 */
- (void)testPerformanceInitWithPageData {

    [self measureBlock:^{

        FAPageViewManager *manager = [[FAPageViewManager alloc] initWithPageData:@[] datasource:nil currentPageIndex:0 isDoubleSided:NO];

        NSLog(@"%@",manager);
    }];
}

@end
