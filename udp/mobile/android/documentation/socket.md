# Ti.UDP

## Description

Marshals UDP traffic.

## Properties

### int bufferSize
Specifies how large of a packet that can be received. Defaults to 256.

## Methods

### void start(dictionary args)
Starts the socket. Takes a dictionary with the following values:

* int port: The port on which to listen.

### void sendString(dictionary args)
Sends a string of data over UDP. Takes a dictionary with the following values:

* string host [optional]: The host address to which data will be sent. Broadcasts if no host is specified.
* int port [optional]: The port on which to listen. Uses the port the socket was created with if not specified.
* string data: The string to send.

### void sendBytes(dictionary args)
Sends bytes over UDP. Takes a dictionary with the following values:

* string host [optional]: The host address to which data will be sent. Broadcasts if no host is specified.
* int port [optional]: The port on which to listen. Uses the port the socket was created with if not specified.
* int[] data: The bytes to send.

### void stop()
Stops listening for and sending network traffic.

## Events

### started
Fired when the socket has finished initializing and it is ready to be used.

### data
Fired when data is received. A dictionary is provided with the following values:

* string stringData: A string representation of the data received; may or may not be accurate, depending on the data sent.
* int[] bytesData: A bytes representation of the data received; may or may not be accurate, depending on the data sent.
* string address: The raw address received.

### error
Fired when an error is encountered. A dictionary is provided with the following values:

* string error: The error