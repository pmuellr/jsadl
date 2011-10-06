
#-------------------------------------------------------------------------------
@jsasdl Accelerometer

Captures device motion in the x, y, and z direction.

#-------------------------------------------------------------------------------
@jsadl Accelerometer.getCurrentAcceleration

Get the current acceleration along the x, y, and z axis.

@jsadl-parameters
* success called when acceleration value is available
* error   called when an error occurs

Description
-----------
The accelerometer is a motion sensor that detects the change (delta) in
movement relative to the current device orientation. The accelerometer can
detect 3D movement along the x, y, and z axis.

The acceleration is returned using the `accelerometerSuccess` callback function.

Supported Platforms
-------------------

* Android
* BlackBerry WebWorks (OS 5.0 and higher)
* iPhone

Quick Example
-------------

    function onSuccess(acceleration) {
        alert('Acceleration X: ' + acceleration.x + '\n' +
              'Acceleration Y: ' + acceleration.y + '\n' +
              'Acceleration Z: ' + acceleration.z + '\n' +
              'Timestamp: '      + acceleration.timestamp + '\n');
    };

    function onError() {
        alert('onError!');
    };

    navigator.accelerometer.getCurrentAcceleration(onSuccess, onError);

iPhone Quirks
-------------

* iPhone doesn't have the concept of getting the current acceleration at any
given point.
* You must watch the acceleration and capture the data at given time intervals.
* Thus, this function will give you the last value
reported from a `watchAccelerometer` call.

#-------------------------------------------------------------------------------
@jsadl Accelerometer.watchAcceleration

At a regular interval, get the acceleration along the x, y, and z axis.

@jsadl-parms
* success called when acceleration value is available
* error   called when an error occurs
* options options

Description
-----------

The accelerometer is a motion sensor that detects the change (delta) in
movement relative to the current position. The accelerometer can detect
3D movement along the x, y, and z axis.

This function gets the device's current
acceleration at a regular interval. Each time the @jsadl:Acceleration is
retrieved, the @jsadl:parm:accelerometerSuccess callback function is executed.
Specify the interval in milliseconds via the frequency parameter in the
@jsadl:parm:acceleratorOptions object.

The returned watch ID references references the accelerometer watch
interval. The watch ID can be used with @jsadl:Accelerometer.clearWatch to stop
watching the accelerometer.

Supported Platforms
-------------------

* Android
* BlackBerry WebWorks (OS 5.0 and higher)
* iPhone
* Quick Example

    function onSuccess(acceleration) {
        alert('Acceleration X: ' + acceleration.x + '\n' +
              'Acceleration Y: ' + acceleration.y + '\n' +
              'Acceleration Z: ' + acceleration.z + '\n' +
              'Timestamp: '      + acceleration.timestamp + '\n');
    };

    function onError() {
        alert('onError!');
    };

    var options = { frequency: 3000 };  // Update every 3 seconds

    var watchID = navigator.accelerometer.watchAcceleration(onSuccess, onError, options);

iPhone Quirks
-------------

* At the interval requested, PhoneGap will call the success callback
function and pass the accelerometer results.
* However, in requests to the device PhoneGap restricts the interval to
minimum of every 40ms and a maximum of every 1000ms.
* For example, if you request an interval of 3 seconds (3000ms),
PhoneGap will request an interval of 1 second from the device but invoke
the success callback at the requested interval of 3 seconds.

#-------------------------------------------------------------------------------
@jsadl Accelerometer.clearWatch

Stop watching the Acceleration referenced by the watch ID parameter.

@jsadl-parms
* watchID The ID returned by @jsadl:Accelerometer.watchAcceleration.

Supported Platforms
-------------------

* Android
* BlackBerry WebWorks (OS 5.0 and higher)
* iPhone

Quick Example
-------------

    var watchID = navigator.accelerometer.watchAcceleration(onSuccess, onError, options);

    // ... later on ...

    navigator.accelerometer.clearWatch(watchID);

#-------------------------------------------------------------------------------
@jsadl Acceleration

Contains Accelerometer data captured at a specific point in time.

@jsadl-properties
* x         Amount of motion on the x-axis. Range [0, 1]
* y         Amount of motion on the y-axis. Range [0, 1]
* z         Amount of motion on the z-axis. Range [0, 1]
* timestamp Creation timestamp in milliseconds.

Description
-----------

This object is created and populated by PhoneGap, and returned by an `Accelerometer` method.

Supported Platforms
-------------------

* Android
* BlackBerry WebWorks (OS 5.0 and higher)
* iPhone
* Windows Phone 7 ( Mango )

Quick Example
-------------

    function onSuccess(acceleration) {
        alert('Acceleration X: ' + acceleration.x + '\n' +
              'Acceleration Y: ' + acceleration.y + '\n' +
              'Acceleration Z: ' + acceleration.z + '\n' +
              'Timestamp: '      + acceleration.timestamp + '\n');
    };

    function onError() {
        alert('onError!');
    };

    navigator.accelerometer.getCurrentAcceleration(onSuccess, onError);


#-------------------------------------------------------------------------------
@jsadl AccelerometerValue

onSuccess callback function that provides the `Acceleration` information.

@jsdl-parms
* acceleration  The acceleration at a single moment in time. (Acceleration)

Example
-------

    function onSuccess(acceleration) {
        alert('Acceleration X: ' + acceleration.x + '\n' +
              'Acceleration Y: ' + acceleration.y + '\n' +
              'Acceleration Z: ' + acceleration.z + '\n' +
              'Timestamp: '      + acceleration.timestamp + '\n');
    };


#-------------------------------------------------------------------------------
@jsadl AccelerometerError

onError callback function for acceleration functions.

#-------------------------------------------------------------------------------
@jsadl AccelerometerOptions

An optional parameter to customize the retrieval of the accelerometer.

@jsadl-properties
* frequency  How often to retrieve the Acceleration in milliseconds. (Default: 10000)