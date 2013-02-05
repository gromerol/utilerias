/**
 * Ti.Box2d Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Box2D/Box2D.h>
#import <vector>
#import <algorithm>
#import "TiProxy.h"

struct TiContact {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    bool operator==(const TiContact& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
};

class TiContactListener : public b2ContactListener {

public:
    std::vector<TiContact>_contacts;
    
    TiContactListener(TiProxy *proxy);
    ~TiContactListener();
    
	virtual void BeginContact(b2Contact* contact);
	virtual void EndContact(b2Contact* contact);
	virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);    
	virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);

private:
    TiProxy *proxy;
	NSDictionary* CreateEvent(TiContact *myContact,NSString *phase);
};
