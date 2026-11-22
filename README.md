# macOS Corsair Xeneon Edge Multitouch Enablement

> [!CAUTION] 
> **I have only done limited testing on this. At this time, consider this beta quality!**

> [!CAUTION] 
> **Use at your own risk. Your device may become bricked if you do something wrong or as a result of a bug.**

## Summary
By default macOS does not receive the multitouch digizer HID events from the Corsair Xeneon Edge touchscreen. The touchscreen detects that the OS is not Windows/Linux through the way the USB string descriptors are enumerated.

The touchscreen firmware has been modded (by modifying one RISC-V instruction) to bypass the string descriptor enumeration limitation.

After the firmware mod, macOS by default still does not accept touch even though the HID multitouch reports come through due to the displayUUID property on the HID service not being set. Also, the HID descriptor does not include the "Confidence" bit, so touch on the macOS dock does not work. A utility has been developed for macOS to fix these issues.

## Installation Instructions

> [!NOTE]
> At this time, only one Xeneon Edge connected to macOS is supported.

### On Windows
1. Build from source or download the release zip file and extract.
2. Download the Xeneon Edge firmware update package [from Corsair](https://www.corsair.com/ca/en/s/downloads#more-downloads) and run it to update to the latest firmware (package v1.0.0.14 as of this writing).
> [!NOTE]
> The update package must still be run even if you are on the latest firmware in order to extract the update files.
3. Copy the `CH375DLL64.dll` and `XLIAPApi.dll` from the extracted firmware update package (located at `%TEMP%\XENEON_EDGE`) into the same directory as the extracted release files from this repository.
4. Run `XeneonEdgeTouchFlash.exe <path_to_macos_touch_fw_file.hex>`.
5. The Xeneon Edge should now be updated to enable multitouch on macOS!

### On macOS
1. Build from source or download the release zip file and extract.
2. Copy `xeneonedgehid.app` to `/Library/Application Support/family.hirst.xeneonedgehid` (the directory will need to be created).
3. Copy `family.hirst.xeneonedgehid.plist` to `/Library/LaunchAgents`.
4. Permissions may need to be manually enabled for `/Library/Application Support/family.hirst.xeneonedgehid/xeneonedgehid.app`.
> - On macOS 27.3 Beta 2, Navigate to __Settings > Privacy & Security > System & App Protection Override__ and add the app to the list of apps. You will need to choose "Override System Protections" on the dialog that pops up and click "OK" for all the options.
> - On macOS 27.2, add the app to __Settings > Privacy & Security > Accessibility__
5. Reboot and enjoy!
> [!NOTE]
> Since the utility app is a launch agent, the touch screen may not operate until you login.

## Credits
[Reddit user Sufficient_Divide687](https://www.reddit.com/user/Sufficient_Divide687/)'s info in [this](https://www.reddit.com/r/Corsair/comments/1xsathr/xeneon_edge_with_native_multitouch_on_macos/) post

[@UKTailwind](https://github.com/UKTailwind)'s info in [this](https://github.com/hathach/tinyusb/issues/4346) GitHub issue

[@glasses666](https://github.com/glasses666) [macos27-external-touch](https://github.com/glasses666/macos27-external-touch)

[@MattBrookPro](https://github.com/MattBrookPro) for [this comment](https://github.com/ClassicOldSong/Apollo/pull/1624#issuecomment-6853049696)
