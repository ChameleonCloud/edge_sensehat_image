# CHI@Edge sense-hat tutorials

These notebooks outline how to use both the rasberry pi and waveshare sense hat variants, leveraging the Pi's I2C and gpio interfaces.

## RPi Official Sense Hat

### Required device boot options and device tree overlays
- dtoverlay=rpi-sense

### Required /dev devices to be included in the device profile
- /dev/i2c-0
- /dev/i2c-1
- /dev/gpiomem
- /dev/gpiochip0
- /dev/gpiochip1
- /dev/fb0
- /dev/input/event0
- /dev/input/event1
- /dev/input/event2

### Required dependencies to drive the sensors
- python3
- sense-hat (python)
- RTIMULib (python)
- libstdc++ (shared libraries)


## Waveshare Sense Hat

### Required device boot options and device tree overlays
- dtparam=i2c_arm=on is used to enable the i2c interface on the raspberry pi
- dtoverlay=gpio is used to enable the gpio interface on the raspberry pi

### Required /dev devices to be included in the device profile
- /dev/i2c-0
- /dev/i2c-1
- /dev/gpiomem
- /dev/gpiochip0
- /dev/gpiochip1

### Required dependencies to drive the sensors
- python3
- i2c-tools
- adafruit-blinka 
- rpilgpio
- more (see Dockerfile)
