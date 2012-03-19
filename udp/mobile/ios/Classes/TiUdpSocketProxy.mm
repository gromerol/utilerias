/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUdpSocketProxy.h"
#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/fcntl.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>

@interface TiUdpSocketProxy (Private)

-(void)_send:(NSData*)data withDict:(NSDictionary*)args;
-(void)_stopWithError:(NSError*)error;
-(BOOL)_setupSocketConnectedToAddress:(NSData*)address port:(NSUInteger)port error:(NSError**)errorPtr;
-(void)_stopHostResolution;
-(void)_stopWithStreamError:(CFStreamError)streamError;
static void HostResolveCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError* error, void* info);

@end

@implementation TiUdpSocketProxy

#pragma mark Initialization and Deinitialization

-(id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

-(void)dealloc
{
    [self stop:nil];
    [super dealloc];
}

#pragma mark Public API

-(void)start:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    int newPort = [TiUtils intValue:[args objectForKey:@"port"]];
    
    BOOL success;
    NSError* error;
    
    success = [self _setupSocketConnectedToAddress:nil port:newPort error:&error];
    
    if (success)
    {
        isServer = true;
        _port = newPort;
        NSLog(@"[INFO] Socket Started!");
        [self fireEvent:@"started" withObject:nil];
    }
    else
    {
        [self _stopWithError:error];
    }
}

-(void)sendString:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    [self _send:[[TiUtils stringValue:[args objectForKey:@"data"]] dataUsingEncoding:NSUTF8StringEncoding] withDict:args];
}

-(void)sendBytes:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSArray* rawData = (NSArray*)[args objectForKey:@"data"];
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:[rawData count]];
    for (NSNumber* number in rawData)
    {
        char byte = [number charValue];
        [data appendBytes:&byte length:1];
    }
    
    [self _send:data withDict:args];
    
    [data release];
}

-(void)stop:(id)args
{   
    _hostName = nil;
    _hostAddress = nil;
    _port = 0;
    [self _stopHostResolution];
    if (self->_cfSocket != NULL)
    {
        CFSocketInvalidate(self->_cfSocket);
        CFRelease(self->_cfSocket);
        self->_cfSocket = NULL;
    }
    
    NSLog(@"[INFO] Stopped!");
}


#pragma mark Private Utility Methods


// Returns a dotted decimal string for the specified address (a (struct sockaddr) 
// within the address NSData).
static NSString* GetAddressForAddress(NSData* data)
{
    
    int status;
    const struct sockaddr_storage* ss = (const struct sockaddr_storage*)[data bytes];
    char hostname[NI_MAXHOST];
    char portname[NI_MAXSERV];
    
    status = getnameinfo((sockaddr*)ss,
                         ss->ss_family == AF_INET6 ? sizeof(sockaddr_in6) : sizeof(sockaddr_in),
                         hostname, sizeof(hostname)/sizeof(hostname[0]),
                         portname, sizeof(portname)/sizeof(portname[0]),
                         NI_NUMERICHOST | NI_NUMERICSERV);
    
    if (status != 0)
    {
        NSLog (@"[ERROR] Failed to retrieve host name! Received exit status: %d", status);
        return nil;
    }
    else
    {
        return [NSString stringWithFormat:@"%s:%s", hostname, portname];
    }
    
    return nil;
}

// Returns a human readable string for the given data.
static NSString* GetStringFromData(NSData* data)
{
    NSMutableString* result;
    NSUInteger dataLength;
    NSUInteger dataIndex;
    const uint8_t* dataBytes;
    
    assert(data != nil);
    
    dataLength = [data length];
    dataBytes = (uint8_t*)[data bytes];
    
    result = [NSMutableString stringWithCapacity:dataLength];
    assert(result != nil);
    
    for (dataIndex = 0; dataIndex < dataLength; dataIndex++)
    {
        uint8_t ch;
        
        ch = dataBytes[dataIndex];
        if (ch == 10)
        {
            [result appendString:@"\n"];
        }
        else if (ch == 13)
        {
            [result appendString:@"\r"];
        }
        else if (ch == '"')
        {
            [result appendString:@"\\\""];
        }
        else if (ch == '\\')
        {
            [result appendString:@"\\\\"];
        }
        else if ((ch >= ' ') && (ch < 127))
        {
            [result appendFormat:@"%c", (int)ch];
        }
        else
        {
            [result appendFormat:@"\\x%02x", (unsigned int)ch];
        }
    }
    
    return result;
}

static NSArray* GetBytesFromData(NSData* data)
{
    NSMutableArray* result;
    NSUInteger dataLength;
    NSUInteger dataIndex;
    const uint8_t* dataBytes;
    
    assert(data != nil);
    
    dataLength = [data length];
    dataBytes = (uint8_t*)[data bytes];
    
    result = [NSMutableArray arrayWithCapacity:dataLength];
    assert(result != nil);
    
    for (dataIndex = 0; dataIndex < dataLength; dataIndex++)
    {
        [result addObject:[NSNumber numberWithUnsignedInt:dataBytes[dataIndex]]];
    }
    
    return result;
}


-(void)_send:(NSData*)data withDict:(NSDictionary*)args
{
    int err;
    ssize_t bytesWritten;
    struct sockaddr* addrPtr;
    socklen_t addrLen;
    
    int sock = CFSocketGetNative(self->_cfSocket);
    assert(sock >= 0);
    
    id host = [args objectForKey:@"host"];
    int port = [TiUtils intValue:[args objectForKey:@"port"] def:_port];
    
    if (host == nil)
    {
        struct sockaddr_in destinationAddress;
        socklen_t sockaddr_destaddr_len = sizeof(destinationAddress);
        memset(&destinationAddress, 0, sockaddr_destaddr_len);
        destinationAddress.sin_len = (__uint8_t) sockaddr_destaddr_len;
        destinationAddress.sin_family = AF_INET;
        destinationAddress.sin_port = htons(port);
        destinationAddress.sin_addr.s_addr = htonl(INADDR_ANY);
        
        addrPtr = (sockaddr*)&destinationAddress;
        addrLen = sockaddr_destaddr_len;
        
        bytesWritten = sendto(sock, [data bytes], [data length], 0, addrPtr, addrLen);
    }
    else
    {
        struct sockaddr_in destinationAddress;
        socklen_t sockaddr_destaddr_len = sizeof(destinationAddress);
        memset(&destinationAddress, 0, sockaddr_destaddr_len);
        destinationAddress.sin_len = (__uint8_t) sockaddr_destaddr_len;
        destinationAddress.sin_family = AF_INET;
        destinationAddress.sin_port = htons(port);
        destinationAddress.sin_addr.s_addr = inet_addr([host cStringUsingEncoding:NSUTF8StringEncoding]);
        
        addrPtr = (sockaddr*)&destinationAddress;
        addrLen = sockaddr_destaddr_len;
        
        bytesWritten = sendto(sock, [data bytes], [data length], 0, addrPtr, addrLen);
    }
    
    if (bytesWritten < 0)
    {
        err = errno;
    }
    else if (bytesWritten == 0)
    {
        err = EPIPE;                    
    }
    else
    {
        // We ignore any short writes, which shouldn't happen for UDP anyway.
        assert((NSUInteger)bytesWritten == [data length]);
        err = 0;
    }
    
    if (err == 0)
    {
        NSLog(@"[INFO] Data Sent!");
    }
    else
    {
        [self fireEvent:@"error" withObject:[NSDictionary dictionaryWithObjectsAndKeys:[[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil] localizedDescription],@"error",nil]];
    }
}

// Stops the object, reporting the supplied error to the delegate.
-(void)_stopWithError:(NSError*)error
{
    [self stop:nil];
    NSLog(@"[ERROR] Error Hit! %@", error);
    [self fireEvent:@"error" withObject:[NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], @"error", nil]];
}

// Stops the object, reporting the supplied error to the delegate.
-(void)_stopWithStreamError:(CFStreamError)streamError
{
    NSDictionary* userInfo;
    NSError* error;
    
    if (streamError.domain == kCFStreamErrorDomainNetDB)
    {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInteger:streamError.error], kCFGetAddrInfoFailureKey,
                    nil];
    }
    else
    {
        userInfo = nil;
    }
    error = [NSError errorWithDomain:(NSString*)kCFErrorDomainCFNetwork code:kCFHostErrorUnknown userInfo:userInfo];
    assert(error != nil);
    
    [self _stopWithError:error];
}

// Called by the CFSocket read callback to actually read and process data 
// from the socket.
-(void)_readData
{
    int err;
    int sock;
    struct sockaddr_storage addr;
    socklen_t addrLen;
    uint8_t buffer[65536];
    ssize_t bytesRead;
    
    sock = CFSocketGetNative(self->_cfSocket);
    assert(sock >= 0);
    
    addrLen = sizeof(addr);
    bytesRead = recvfrom(sock, buffer, sizeof(buffer), 0, (struct sockaddr*)&addr, &addrLen);
    if (bytesRead < 0)
    {
        err = errno;
    }
    else if (bytesRead == 0)
    {
        err = EPIPE;
    }
    else
    {
        NSData* dataObj;
        NSData* addrObj;
        
        err = 0;
        
        dataObj = [NSData dataWithBytes:buffer length:bytesRead];
        assert(dataObj != nil);
        addrObj = [NSData dataWithBytes:&addr  length:addrLen];
        assert(addrObj != nil);
        
        NSString* stringData = GetStringFromData(dataObj);
        NSArray* bytesData = GetBytesFromData(dataObj);
        NSString* addr = GetAddressForAddress(addrObj);
        
        [self fireEvent:@"data" withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                            stringData,@"stringData",
                                            bytesData,@"bytesData",
                                            addr,@"address",
                                            nil]];
    }
    
    // If we got an error, tell the delegate.
    
    if (err != 0)
    {
        [self fireEvent:@"error" withObject:[NSDictionary dictionaryWithObjectsAndKeys:[[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil] localizedDescription],@"error", nil]];
    }
}

// This C routine is called by CFSocket when there's data waiting on our 
// UDP socket.  It just redirects the call to Objective-C code.
static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void* data, void* info)
{
    TiUdpSocketProxy* obj = (TiUdpSocketProxy*)info;
    [obj _readData];
}

// Called by our CFHost resolution callback (HostResolveCallback) when host 
// resolution is complete.  We find the best IP address and create a socket 
// connected to that.
-(void)_hostResolutionDone
{
    NSError* error;
    Boolean resolved;
    NSArray* resolvedAddresses;
    
    error = nil;
    
    // Walk through the resolved addresses looking for one that we can work with.
    
    resolvedAddresses = (NSArray*)CFHostGetAddressing(self->_cfHost, &resolved);
    if (resolved && (resolvedAddresses != nil))
    {
        for (NSData* address in resolvedAddresses)
        {
            const struct sockaddr* addrPtr;
            NSUInteger addrLen;
            
            addrPtr = (const struct sockaddr*)[address bytes];
            addrLen = [address length];
            assert(addrLen >= sizeof(struct sockaddr));
            
            // Try to create a connected CFSocket for this address.  If that fails, 
            // we move along to the next address.  If it succeeds, we're done.
            
            if (addrPtr->sa_family == AF_INET && [self _setupSocketConnectedToAddress:address port:_port error:&error])
            {
                CFDataRef hostAddress = CFSocketCopyPeerAddress(self->_cfSocket);
                assert(hostAddress != NULL);
                
                _hostAddress = (NSData*)hostAddress;
                
                CFRelease(hostAddress);
                
                break;
            }
        }
    }
    
    // If we didn't get an address and didn't get an error, synthesise a host not found error.
    if ((_hostAddress == nil) && (error == nil))
    {
        error = [NSError errorWithDomain:(NSString*)kCFErrorDomainCFNetwork code:kCFHostErrorHostNotFound userInfo:nil];
    }
    
    if (error == nil)
    {
        // We're done resolving, so shut that down.
        NSLog(@"[INFO] Client Started!");
        [self fireEvent:@"started" withObject:nil];
        [self _stopHostResolution];
    }
    else
    {
        [self _stopWithError:error];
    }
}

// This C routine is called by CFHost when the host resolution is complete. 
// It just redirects the call to the appropriate Objective-C method.
static void HostResolveCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void* info)
{
    TiUdpSocketProxy* obj = (TiUdpSocketProxy*)info;
    
    if ((error != NULL) && (error->domain != 0))
    {
        [obj _stopWithStreamError:*error];
    }
    else
    {
        [obj _hostResolutionDone];
    }
}

// Sets up the CFSocket in either client or server mode.  In client mode, 
// address contains the address that the socket should be connected to. 
// The address contains zero port number, so the port parameter is used instead. 
// In server mode, address is nil and the socket is bound to the wildcard 
// address on the specified port.
-(BOOL)_setupSocketConnectedToAddress:(NSData*)address port:(NSUInteger)port error:(NSError**)errorPtr
{
    int err;
    int junk;
    int sock;
    const CFSocketContext context = {0, self, NULL, NULL, NULL};
    CFRunLoopSourceRef rls;
    
    // Create the UDP socket itself.
    
    err = 0;
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0)
    {
        err = errno;
    }
    
    // Bind or connect the socket, depending on whether we're in server or client mode.
    
    if (err == 0)
    {
        struct sockaddr_in addr;
        
        memset(&addr, 0, sizeof(addr));
        if (address == nil)
        {
            // Server mode.  Set up the address based on the socket family of the socket 
            // that we created, with the wildcard address and the caller-supplied port number.
            addr.sin_len         = sizeof(addr);
            addr.sin_family      = AF_INET;
            addr.sin_port        = htons(port);
            addr.sin_addr.s_addr = INADDR_ANY;
            err = bind(sock, (const struct sockaddr*)&addr, sizeof(addr));
        }
        else
        {
            // Client mode.  Set up the address on the caller-supplied address and port 
            // number.
            if ([address length] > sizeof(addr))
            {
                assert(NO); // very weird
                [address getBytes:&addr length:sizeof(addr)];
            }
            else
            {
                [address getBytes:&addr length:[address length]];
            }
            assert(addr.sin_family == AF_INET);
            addr.sin_port = htons(port);
            err = connect(sock, (const struct sockaddr*)&addr, sizeof(addr));
        }
        if (err < 0)
        {
            err = errno;
        }
    }
    
    // From now on we want the socket in non-blocking mode to prevent any unexpected 
    // blocking of the main thread.  None of the above should block for any meaningful 
    // amount of time.
    
    if (err == 0)
    {
        int flags;
        
        flags = fcntl(sock, F_GETFL);
        err = fcntl(sock, F_SETFL, flags | O_NONBLOCK);
        if (err < 0)
        {
            err = errno;
        }
    }
    
    // Wrap the socket in a CFSocket that's scheduled on the runloop.
    
    if (err == 0)
    {
        self->_cfSocket = CFSocketCreateWithNative(NULL, sock, kCFSocketReadCallBack, SocketReadCallback, &context);
        
        // The socket will now take care of cleaning up our file descriptor.
        
        assert(CFSocketGetSocketFlags(self->_cfSocket)&kCFSocketCloseOnInvalidate);
        sock = -1;
        
        rls = CFSocketCreateRunLoopSource(NULL, self->_cfSocket, 0);
        assert(rls != NULL);
        
        CFRunLoopAddSource(CFRunLoopGetMain(), rls, kCFRunLoopCommonModes);
        
        CFRelease(rls);
    }
    
    // Handle any errors.
    
    if (sock != -1)
    {
        junk = close(sock);
        assert(junk == 0);
    }
    assert((err == 0) == (self->_cfSocket != NULL));
    if ((self->_cfSocket == NULL) && (errorPtr != NULL))
    {
        *errorPtr = [NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil];
    }
    
    return (err == 0);
}

// Called to stop the CFHost part of the object, if it's still running.
-(void)_stopHostResolution
{
    if (self->_cfHost != NULL)
    {
        CFHostSetClient(self->_cfHost, NULL, NULL);
        CFHostCancelInfoResolution(self->_cfHost, kCFHostAddresses);
        CFHostUnscheduleFromRunLoop(self->_cfHost, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(self->_cfHost);
        self->_cfHost = NULL;
    }
}

@end