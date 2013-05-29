#import "GHResource.h"
#import "GHTag.h"
#import "GHCommit.h"
#import "GHRepository.h"
#import "iOctocat.h"
#import "NSURL+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHTag

- (id)initWithRepo:(GHRepository *)repo sha:(NSString *)sha {
	self = [super init];
	if (self) {
		self.repository = repo;
		self.sha = sha;
		self.resourcePath = [NSString stringWithFormat:kTagFormat, self.repository.owner, self.repository.name, self.sha];
	}
	return self;
}

- (NSURL *)htmlURL {
    if (!_htmlURL) {
        self.htmlURL = [NSURL URLWithFormat:@"/%@/%@/tree/%@", self.repository.owner, self.repository.name, self.sha];
    }
    return _htmlURL;
}

#pragma mark Loading

- (void)setValues:(id)dict {
	NSString *sha = [dict safeStringForKeyPath:@"object.sha"];
	self.tag = [dict safeStringForKey:@"tag"];
	self.message = [dict safeStringForKey:@"message"];
	self.taggerName = [dict safeStringForKeyPath:@"tagger.name"];
	self.taggerEmail = [dict safeStringForKeyPath:@"tagger.email"];
	self.taggerDate = [dict safeDateForKeyPath:@"tagger.date"];
	self.commit = [[GHCommit alloc] initWithRepository:self.repository andCommitID:sha];
}

@end