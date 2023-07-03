# Building and flashing custom Model100 firmware

## Setup

_Extracted/tweaked from `.github/workflows/build.yml`_

1. Clone Model100-Firmware
2. Check out this branch

3. In `Model100-Firmware`:
```
$ make setup
$ ./tools/collect-build-info
$ mkdir -p .kaleidoscope-temp
```

## Building

```
$ make Keyboardio/Model100 VERBOSE=1 KALEIDOSCOPE_TEMP_PATH=`realpath .kaleidoscope-temp`
```

Output will be in `./output/Keyboardio/Model100/default.bin`.

## Flashing

Ref.: <https://community.keyboard.io/t/model-100-current-default-firmware-might-be-buggy/5333>

1. Unplug, hold PROG, plug back in
2. `dfu-util -l` and confirm the keyboard is listed
3. `dfu-util --device 0x3496:0005 -R -D ./output/Keyboardio/Model100/default.bin`

## Modifying

1. Clone the `Kaleidoscope` repo.
1. edit `.gitmodules` and change the `lib/Kaleidoscope` path to point to your clone
1. `git submodule sync`
1. `git submodule update --init --recursive`
1. `cd lib/Kaleidoscope`
1. Edit `./examples/Devices/Keyboardio/Model100/Model100.ino`
1. Repeat the build and flash steps.
