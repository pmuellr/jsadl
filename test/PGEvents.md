#-------------------------------------------------------------------------------
@jsasdl-module PGEvents

#-------------------------------------------------------------------------------
Many objects in Node emit events: a `net.Server` emits an event each time
a peer connects to it, a `fs.readStream` emits an event when the file is
opened. All objects which emit events are instances of
`events.EventEmitter`. You can access this module by doing:
`require("events");`

Typically, event names are represented by a camel-cased string, however,
there aren't any strict restrictions on that, as any string will be
accepted.

Functions can then be attached to objects, to be executed when an event
is emitted. These functions are called *listeners*.

#-------------------------------------------------------------------------------
@jsasdl EventEmitter

To access the EventEmitter class, `require('events').EventEmitter`.

When an `EventEmitter` instance experiences an error, the typical action
is to emit an `'error'` event. Error events are treated as a special case
in node. If there is no listener for it, then the default action is to
print a stack trace and exit the program.

All EventEmitters emit the event `'newListener'` when new listeners are
added.

#-------------------------------------------------------------------------------
@jsadl addListener

Adds a listener to the end of the listeners array for the specified event.

    server.on('connection', function (stream) {
      console.log('someone connected!');
    });

#-------------------------------------------------------------------------------
@jsadl on

Shorter named version of @jasdl:EventEmitter.addListener

#-------------------------------------------------------------------------------
@jsadl once

Adds a **one time** listener for the event.
The listener is invoked only the first time the event is fired, after
which it is removed.

    server.once('connection', function (stream) {
      console.log('Ah, we have our first user!');
    });

#-------------------------------------------------------------------------------
@jsadl removeListener

Remove a listener from the listener array for the specified event.
**Caution**: changes array indices in the listener array behind the listener.

    var callback = function(stream) {
      console.log('someone connected!');
    };
    server.on('connection', callback);
    // ...
    server.removeListener('connection', callback);

#-------------------------------------------------------------------------------
@jsadl removeAllListeners

Removes all listeners from the listener array for the specified event.

#-------------------------------------------------------------------------------
@jsadl setMaxListeners

By default EventEmitters will print a warning if more than 10 listeners are added to it.
This is a useful default which helps finding memory leaks.
Obviously not all Emitters should be limited to 10. This function allows
that to be increased. Set to zero for unlimited.

#-------------------------------------------------------------------------------
@jsadl listeners

Returns an array of listeners for the specified event.
This array can be manipulated, e.g. to remove listeners.

    server.on('connection', function (stream) {
      console.log('someone connected!');
    });
    console.log(util.inspect(server.listeners('connection')); // [ [Function] ]

#-------------------------------------------------------------------------------
@jsadl emit

Execute each of the listeners in order with the supplied arguments.

#-------------------------------------------------------------------------------
@jsadl -newListener

This event is emitted any time someone adds a new listener.
