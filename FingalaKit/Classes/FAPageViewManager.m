//
//  FAPageViewManager.m
//  FingalaKit
//
//  Created by Farhan Yousuf on 19/08/16.
//  Copyright © 2016 fingala. All rights reserved.
//

#import "FAPageViewManager.h"
#import "NSObject+NSObject_FAExtensions.h"



NSString *const kFAPageViewManagerContentViewStoryBoardName = @"storyboard";
NSString *const kFAPageViewManagerContentViewStoryBoardIdentifier = @"storyboardID";

@interface FAPageViewManager ()

@property (nonatomic, strong) NSArray *pageData;

@end

@implementation FAPageViewManager


- (instancetype)initWithPageData:(NSArray *)pageData datasource:(id <FAPageViewManagerDataSource>)datasource currentPageIndex:(NSInteger)currentPageIndex isDoubleSided:(BOOL)isDoubleSided storyboardInfo:(NSDictionary *)storyboardDictionary {
    if (self = [super init]) {
        _pageData = pageData;
        _datasource = datasource;
        _currentPageIndex = currentPageIndex;
        _isDoubleSided = isDoubleSided;
        _storyboardInfo = storyboardDictionary;
        
        if (_datasource != nil) {
            
            if ([[self datasource] respondsToSelector:@selector(pageViewControllerForFAPageViewManager)]) {
                [[[self datasource] pageViewControllerForFAPageViewManager] setDataSource:self];
                [[[self datasource] pageViewControllerForFAPageViewManager] setDelegate:self];
            }
            
            [self showViewControllerAtIndex:_currentPageIndex direction:UIPageViewControllerNavigationDirectionForward];
        }
        
    }
    return self;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if ([viewController valueForKey:kFAPageViewManagerPageIndex] == nil) {
        NSAssert([viewController valueForKey:kFAPageViewManagerPageIndex] == nil, @"You need to provide a public property with key value as 'pageIndex'");
    }
    
    if (![[viewController valueForKey:kFAPageViewManagerPageIndex] isKindOfClass:[NSNumber class]]) {
        NSAssert(![[viewController valueForKey:kFAPageViewManagerPageIndex] isKindOfClass:[NSNumber class]], @"You need to provide a public property 'pageIndex' as a NSNumber with unsignedIntegerValue");
    }
    
    NSInteger index = [(NSNumber *)[viewController valueForKey:kFAPageViewManagerPageIndex] unsignedIntegerValue];
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == [_pageData count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([viewController valueForKey:kFAPageViewManagerPageIndex] == nil) {
        NSAssert([viewController valueForKey:kFAPageViewManagerPageIndex] == nil, @"You need to provide a public property with key value as 'pageIndex'");
    }
    
    if (![[viewController valueForKey:kFAPageViewManagerPageIndex] isKindOfClass:[NSNumber class]]) {
        NSAssert(![[viewController valueForKey:kFAPageViewManagerPageIndex] isKindOfClass:[NSNumber class]], @"You need to provide a public property 'pageIndex' as an NSNumber with unsignedIntegerValue");
    }
    
    NSInteger index = [(NSNumber *)[viewController valueForKey:kFAPageViewManagerPageIndex] unsignedIntegerValue];
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return _pageData.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    _currentPageIndex = [[pageViewController.viewControllers.firstObject valueForKey:kFAPageViewManagerPageIndex] unsignedIntegerValue];

    return _currentPageIndex;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        return;
    }
    _currentPageIndex = [[[pageViewController.viewControllers lastObject] valueForKey:kFAPageViewManagerPageIndex] unsignedIntegerValue];
    
    if ([self.delegate respondsToSelector:@selector(pageViewManagerDidMoveToPage:)]) {
        [self.delegate pageViewManagerDidMoveToPage:_currentPageIndex];
    }
}

#pragma mark - Page View Controller Helper Methods

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    
    if (([_pageData count] == 0) || (index >= [_pageData count])) {
        return nil;
    }
    
    UIViewController *contentViewController;
    
    if (_storyboardInfo == nil) {
        
        if (_contentViewControllerClassName == nil) {
            NSAssert(_contentViewControllerClassName == nil, @"You need to provide contentViewControllerClassName if storyboard info is not provided.");
        }
        
        contentViewController = [[NSClassFromString(_contentViewControllerClassName) alloc] init];
    }else {
        
        if (_storyboardInfo == nil) {
            NSAssert(_storyboardInfo == nil, @"You need to provide storyboardInfo if contentViewControllerClassName is not provided.");
        }
        
        if (_storyboardInfo[kFAPageViewManagerContentViewStoryBoardName] == nil) {
            NSAssert(_storyboardInfo[kFAPageViewManagerContentViewStoryBoardName] == nil, @"You need to provide storyboard name inside the key kFAPageViewManagerContentViewStoryBoardName");
        }
        
        if (_storyboardInfo[kFAPageViewManagerContentViewStoryBoardIdentifier] == nil) {
            NSAssert(_storyboardInfo[kFAPageViewManagerContentViewStoryBoardIdentifier] == nil, @"You need to provide storyboard identifier of the content view controller inside the key kFAPageViewManagerContentViewStoryBoardIdentifier");
        }
        
        if ([_storyboardInfo[kFAPageViewManagerContentViewStoryBoardIdentifier] isKindOfClass:[NSString class]]) {
            
            contentViewController = [[UIStoryboard storyboardWithName:_storyboardInfo[kFAPageViewManagerContentViewStoryBoardName] bundle:nil] instantiateViewControllerWithIdentifier:_storyboardInfo[kFAPageViewManagerContentViewStoryBoardIdentifier]];
        }else {

            if ([_storyboardInfo[kFAPageViewManagerContentViewStoryBoardIdentifier] count] <= index) {
                
                NSAssert([_storyboardInfo[kFAPageViewManagerContentViewStoryBoardIdentifier] count] <= index, @"You need to provide storyboard identifiers of all the content view controllers inside the key kFAPageViewManagerContentViewStoryBoardIdentifier");

            }
            
            contentViewController = [[UIStoryboard storyboardWithName:_storyboardInfo[kFAPageViewManagerContentViewStoryBoardName] bundle:nil] instantiateViewControllerWithIdentifier:_storyboardInfo[kFAPageViewManagerContentViewStoryBoardIdentifier][index]];
        }
        
    }
    
    if (![[contentViewController allPropertyNames] containsObject:kFAPageViewManagerPageIndex]) {
        NSAssert(![[contentViewController allPropertyNames] containsObject:kFAPageViewManagerPageIndex], @"You need to provide the page index in your content view controller with property name 'pageIndex' with type NSNumber");
    }
    
    [contentViewController setValue:@(index) forKey:kFAPageViewManagerPageIndex];
    
    if (![_pageData[index] isKindOfClass:[NSDictionary class]]) {
        NSAssert(![_pageData[index] isKindOfClass:[NSDictionary class]], @"You need to provide page data for each index as a NSDictionary having keys that matches the key value of the property you want to set for the content view controller");
    }
    
    NSDictionary *pageDictionary = _pageData[index];
    
    for (NSString *key in pageDictionary.allKeys) {
        
        if (![[contentViewController allPropertyNames] containsObject:key]) {
            NSAssert(![[contentViewController allPropertyNames] containsObject:key], @"You need to provide page data for each index as a NSDictionary having keys that matches the key value of the property you want to set for the content view controller");
        }
        
        [contentViewController setValue:pageDictionary[key] forKey:key];
    }
    
    return contentViewController;
}

- (void)showViewControllerAtIndex:(NSInteger)pageIndex direction:(UIPageViewControllerNavigationDirection)direction {
    
    if ([[self datasource] respondsToSelector:@selector(pageViewControllerForFAPageViewManager)]) {
        [[[self datasource] pageViewControllerForFAPageViewManager] setViewControllers:@[[self viewControllerAtIndex:pageIndex]] direction:direction animated:YES completion:nil];
    }
    
}

- (void)moveToPreviousPage {
    
    NSInteger previousPageIndex = _currentPageIndex-1;
    
    if (_currentPageIndex-1 < 0) {
        if (_isDoubleSided) {
            previousPageIndex = _pageData.count-1;
        }else {
            previousPageIndex = _currentPageIndex;
        }
    }
    
    if (previousPageIndex != _currentPageIndex) {
        [self showViewControllerAtIndex:previousPageIndex direction:UIPageViewControllerNavigationDirectionReverse];
    }
    
}

- (void)moveToNextPage {
    
    NSInteger nextPageIndex = _currentPageIndex+1;
    
    if (nextPageIndex > (_pageData.count-1)) {
        if (_isDoubleSided) {
            nextPageIndex = 0;
        }else {
            nextPageIndex = _currentPageIndex;
        }
    }
    if (nextPageIndex != _currentPageIndex) {
        [self showViewControllerAtIndex:nextPageIndex direction:UIPageViewControllerNavigationDirectionForward];
    }
}

- (void)moveToPage:(NSInteger)index {
    if (index>_currentPageIndex) {
        [self showViewControllerAtIndex:index direction:UIPageViewControllerNavigationDirectionForward];
    }else {
        [self showViewControllerAtIndex:index direction:UIPageViewControllerNavigationDirectionReverse];
    }
    
}

@end
