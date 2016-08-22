//
//  FAPageViewManager.h
//  FingalaKit
//
//  Created by Farhan Yousuf on 19/08/16.
//  Copyright © 2016 fingala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const kFAPageViewManagerPageIndex = @"pageIndex";

extern NSString *const kFAPageViewManagerContentViewStoryBoardName;
extern NSString *const kFAPageViewManagerContentViewStoryBoardIdentifier;

NS_ASSUME_NONNULL_BEGIN

@protocol FAPageViewManagerDataSource <NSObject>

- (UIPageViewController *)pageViewControllerForFAPageViewManager;

@end
/** The object of this class will serve as the page view datasource and delegate
 *  if initialized using the constructor 'initWithPageData:'.
 *  The content view controller can be configured to be fetched from a storyboard by providing the storyboardInfo.
 *  Provides methods to return content view controller at each index.
 *  This object relies heavily on key value coding, so the page data should have a dictionary at each index whose key matches with the property to be set for content view controller.
 */



@interface FAPageViewManager : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) id <FAPageViewManagerDataSource> datasource;

@property (nonatomic, assign, readonly) NSInteger currentPageIndex; /**< An integer value that keeps track of the current index of the page that is now presented. Defaults to 0. */

@property (nonatomic, assign) BOOL isDoubleSided; /**< A bool value which when set will allow the first page to be shown when the page reaches the last page and calls the method 'moveToNextPage'. Likewise when 'moveToPreviousPage' is to be called when on the first page, the last page will be shown. Defaults to NO. */

@property (nonatomic, strong, nullable) NSDictionary *storyboardInfo; /**< A dictionary which can be used to specify the name of the storyBoard from which the content view controller need to be instantiated and the storyboard identifier of the content view controller using the keys kFAPageViewManagerContentViewStoryBoardName and kFAPageViewManagerContentViewStoryBoardIdentifier respectively. This property is mandatory if contentViewControllerClassName is not set. */

@property (nonatomic, strong, nullable) NSString *contentViewControllerClassName; /**< A string which can be used to specify the name of the content view controller which will be used to be instantiate the content view controller This property is mandatory if no storyboard info is provided. */

/* Initializer used to initiate page view controller with a datasource.
 * @param an NSArray of pageData used to send  properties for the content view controller. This object relies heavily on key value coding, so the page data should have a dictionary at each index whose key matches with the property to be set for content view controller. for eg: if there is a property called '@property NSString *imageName' as public property in content view controller to pass the image name. page data should look like this: @[ @{@"imageName":@"theNameOfTheImage"} ]
 * @return an instance of FAPageViewManager
 */
- (instancetype)initWithPageData:(NSArray *)pageData datasource:(id <FAPageViewManagerDataSource>)datasource currentPageIndex:(NSInteger)currentPageIndex isDoubleSided:(BOOL)isDoubleSided storyboardInfo:(NSDictionary *)storyboardDictionary;

/* This method returns a content view controller at the specified index.
 * @param an NSInteger value of the index
 * @return an instance of content view controller
 */
- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

- (void)moveToPreviousPage;

- (void)moveToNextPage;

@end

NS_ASSUME_NONNULL_END