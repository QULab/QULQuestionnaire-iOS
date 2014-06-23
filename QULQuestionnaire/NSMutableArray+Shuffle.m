//
//  NSMutableArray+Shuffle.m
//  QULQuestionnaire
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)shuffle {
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remaining = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remaining);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
