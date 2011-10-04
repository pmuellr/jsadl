
@jsasdl Accelerometer

Captures device motion in the x, y, and z direction.

@jsadl Accelerometer.getCurrentAcceleration

Get the current acceleration along the x, y, and z axis.

Description 
-----------
The accelerometer is a motion sensor that detects the change (delta) in 
movement relative to the current device orientation. The accelerometer can 
detect 3D movement along the x, y, and z axis.

The acceleration is returned using the accelerometerSuccess callback function.

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
* Thus, the getCurrentAcceleration function will give you the last value 
reported from a phoneGap watchAccelerometer call.

