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
#import "TiBox2dWorldProxy.hh"

#import <Box2D/Box2D.h>

@interface TiBox2dBodyProxy : TiProxy 
{	
@public
	b2Body *body;
    NSLock *lock;
	TiViewProxy *viewproxy;

}

-(id)initWithBody:(b2Body*)body viewproxy:(TiViewProxy*)vp pageContext:(id<TiEvaluator>)context;
-(TiViewProxy*)viewproxy;
-(b2Body*)body;

@end
