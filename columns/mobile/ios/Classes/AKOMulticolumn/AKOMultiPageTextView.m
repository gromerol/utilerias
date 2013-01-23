//
//  AKOMultiPageTextView.m
//  CoreTextWrapper
//
//  Created by Adrian on 4/28/10.
//  Copyright 2010 akosma software. All rights reserved.
//

#import "AKOMultiPageTextView.h"
#import "AKOMultiColumnTextView.h"


@interface AKOMultiColumnTextView ()
- (void)setPage:(NSInteger)page;
@end

@interface AKOMultiPageTextView ()


@property (nonatomic, retain) NSMutableArray *pages;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic) BOOL pageControlUsed;

- (void)setup;
@end


@implementation AKOMultiPageTextView

@synthesize delegate;
@synthesize pages = _pages;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize dataSource = _dataSource;
@synthesize scrollEnabled = _scrollEnabled;

@synthesize lineBreakMode = _lineBreakMode;
@synthesize textAlignment = _textAlignment;
@synthesize firstLineHeadIndent = _firstLineHeadIndent;
@synthesize spacing = _spacing;
@synthesize topSpacing = _topSpacing;
@synthesize lineSpacing = _lineSpacing;
@synthesize columnInset = _columnInset;


@synthesize currentPageIndex;
@synthesize lastPageIndex;

@dynamic text;
@dynamic font;
@dynamic columnCount;
@dynamic color;



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	if(self.scrollView == nil || self.pageControl == nil)
	{
		[self setup];
	}
    CGRect scrollViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 20.0);
    [self.scrollView setFrame:scrollViewFrame];

    CGRect pageControlFrame = CGRectMake(0.0, self.frame.size.height - 20.0, self.frame.size.width, 20.0);
    [self.pageControl setFrame:pageControlFrame];

}

- (void)setup
{
    _lineBreakMode = kCTLineBreakByWordWrapping;
    _textAlignment = kCTLeftTextAlignment;
    _firstLineHeadIndent = 0.0;
    _spacing = 5.0;
    _topSpacing = 0.0;
    _lineSpacing = 1.0;
    _columnCount = 2;
    _columnInset = CGPointMake(10.0, 10.0);
    _scrollEnabled = YES;
    
    self.pages = [NSMutableArray arrayWithCapacity:5];
    
    CGRect scrollViewFrame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height - 20.0);
    self.scrollView = [[[UIScrollView alloc] initWithFrame:scrollViewFrame] autorelease];
    self.scrollView.scrollEnabled = self.scrollEnabled;
    self.scrollView.bounces = YES;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
    
    CGRect pageControlFrame = CGRectMake(0.0, self.frame.size.height - 20.0, self.frame.size.width, 20.0);
    self.pageControl = [[[UIPageControl alloc] initWithFrame:pageControlFrame] autorelease];
    self.pageControl.numberOfPages = 2;
    self.pageControl.backgroundColor = [UIColor blackColor];
    self.pageControl.currentPage = 0;
    self.pageControl.hidden = NO;
    
    [self.pageControl addTarget:self
                         action:@selector(changePage:) 
               forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

- (void)dealloc 
{
    self.pageControl = nil;
    self.scrollView = nil;
    self.pages = nil;
    self.dataSource = nil;
  
    
    [_text release];
    _text = nil;
    [_font release];
    _font = nil;
    [_color release];
    _color = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods


- (void)scrollViewDidScroll:(UIScrollView *)sender 
{

    if (self.pageControlUsed) 
    {
        return;
    }
	
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
	
	id pageAsId = [NSNumber numberWithInt:self.pageControl.currentPage];

	if ([delegate respondsToSelector:@selector(columnsViewIsStillScrolling:)])
		[delegate columnsViewIsStillScrolling:pageAsId];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    self.pageControlUsed = NO;
	id page = [NSNumber numberWithInt:self.pageControl.currentPage];
	if ([delegate respondsToSelector:@selector(columnsViewDidStartScrolling:)])
		[delegate columnsViewDidStartScrolling:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    self.pageControlUsed = NO;
	
	id page = [NSNumber numberWithInt:self.pageControl.currentPage];
	
	if ([delegate respondsToSelector:@selector(columnsViewDidFinishScrolling:)])
		[delegate columnsViewDidFinishScrolling:page];

}

#pragma mark -
#pragma mark events methods

- (void)changePage:(id)sender 
{
    int page = self.pageControl.currentPage;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlUsed = YES;
}

-(void)scrollToPage:(int)pageNumber animated:(BOOL)animated
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * pageNumber;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:animated];
    self.pageControlUsed = YES;
    self.pageControl.currentPage = pageNumber;
}

#pragma mark -
#pragma mark Properties

- (NSString *)text
{
    return _text;
}

- (void)setText:(NSString *)newText
{
    if (![self.text isEqualToString:newText])
    {
        [_text release];
        _text = [newText copy];
        [self setNeedsDisplay];
    }
}

- (UIFont *)font
{
    return _font;
}

- (void)setFont:(UIFont *)newFont
{
    if (newFont != self.font)
    {
        [_font release];
        _font = [newFont retain];
        [self setNeedsDisplay];
    }
}

- (NSInteger)columnCount
{
    return _columnCount;
}

- (void)setColumnCount:(NSInteger)newColumnCount
{
    if (newColumnCount != self.columnCount)
    {
        _columnCount = newColumnCount;
        [self setNeedsDisplay];
    }
}

- (UIColor *)color
{
    return _color;
}

- (void)setColor:(UIColor *)newColor
{
    if (newColor != self.color)
    {
        [_color release];
        _color = [newColor retain];
        [self setNeedsDisplay];
    }
}


- (void)setDataSource:(id<AKOMultiColumnTextViewDataSource>)dataSource
{
    if (![_dataSource isEqual:dataSource])
    {
        _dataSource = dataSource;
         if (dataSource != nil)
         {
             [self setNeedsDisplay];
         }
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.scrollView.scrollEnabled = scrollEnabled;
}

- (NSInteger)getCurrentPageIndex
{
    return self.pageControl.currentPage;
}

- (NSInteger)getLastPageIndex
{
    return [_pages count]-1;
}

#pragma mark -
#pragma mark Drawing code

- (void)drawRect:(CGRect)rect 
{
    [self.pages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pages removeAllObjects];

    CGRect pageControlFrame = CGRectMake(0.0, self.frame.size.height - 20.0, self.frame.size.width, 20.0);
    self.pageControl.frame = pageControlFrame;

    NSInteger currentPosition = 0;
    NSInteger iteration = 0;
    BOOL moreTextAvailable = YES;
    do 
    {
        CGRect currentFrame = CGRectOffset(self.scrollView.frame, self.scrollView.frame.size.width * iteration, 0.0);
        AKOMultiColumnTextView *view = [[[AKOMultiColumnTextView alloc] initWithFrame:currentFrame] autorelease];
        [view setPage:iteration];
        
        view.columnCount = self.columnCount;
        view.startIndex = currentPosition;
        view.text = self.text;
        view.font = self.font;
        view.color = self.color;
        view.backgroundColor = self.backgroundColor;
        
        // set the properties
        view.lineBreakMode = _lineBreakMode;
        view.textAlignment = _textAlignment;
        view.firstLineHeadIndent = _firstLineHeadIndent;
        view.spacing = _spacing;
        view.topSpacing = _topSpacing;
        view.lineSpacing = _lineSpacing;
        view.columnInset = _columnInset;

        view.dataSource = self.dataSource;
        
        [self.pages addObject:view];
        [self.scrollView addSubview:view];

        currentPosition = view.finalIndex;
        iteration += 1;
        
        self.scrollView.contentSize = CGSizeMake(currentFrame.size.width * iteration, currentFrame.size.height);
        moreTextAvailable = view.moreTextAvailable;
    } 
    while (moreTextAvailable);
    self.pageControl.numberOfPages = iteration;
    self.pageControl.currentPage = 0;
    
}

@end
