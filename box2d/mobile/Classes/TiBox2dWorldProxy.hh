/**
 *  Copyright 2011 Jeff Haynie
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */


#import "TiProxy.h"
#import "TiViewProxy.h"
#import <Box2D/Box2D.h>
#import "TiContactListener.h"

#define PTM_RATIO 16


@interface TiBox2dWorldProxy : TiProxy {

	b2Vec2 gravity;
	b2World *world;
	NSTimer *timer;
	TiViewProxy *surface;
	TiContactListener *contactListener;
	NSLock *lock;
	BOOL _destroyed;
    NSMutableArray *bodies;
}

-(id)initWithViewProxy:(TiViewProxy*)view pageContext:(id<TiEvaluator>)pageContext;
-(b2World*)world;

@end
