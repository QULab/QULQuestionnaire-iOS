//
//  NSMutableArray+Shuffle.m
//  QULQuestionnaire
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)shuffle {
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger remaining = count - i;
        NSUInteger exchangeIndex = i + arc4random_uniform((uint32_t) remaining);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
