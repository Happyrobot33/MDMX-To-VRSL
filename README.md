# WARNING! This is NOT a full DMX SYSTEM! This is a SHIM that converts from the MDMX Format to the VRSL format, thats all it does. It only provides bit accuracy and CRC checking
VCC Link: https://www.matthewherber.com/MDMX-To-VRSL/

Binary conversion code from the official (unfinished) MDMX repository https://github.com/micksam7/VRC-MDMX

## Getting started

All you need to do to use this in a world is add the prefab from the package into your scene, and assign the render texture input of your video player to it. You also need to use the VRSL control panel to switch to 9 universe mode. I also recommend enabling fine channel support and using the max movement range as this will take the most advantage of the binary grid

If you are using MIDIDMX, then ensure you switch its mode from normal VRSL mode to 9 Universe mode. Do NOT switch it to MDMX, as thats only for the ACTUAL MDMX system.

<img width="966" height="543" alt="image" src="https://github.com/user-attachments/assets/2cec7e98-6ada-4d63-890f-eaef4b717349" />

### Non-standard video resolutions

If you are running non standard 1080p video resolutions, or your OBS output is 720p etc instead of 1080p, you will need to change a setting on the manager. There is a field labelled `BaseVideoResolution`. This is the *expected* resolution that the render texture should be interpreted at. If your canvas is 1080p in OBS, but it comes into the world as 720p, then this field should still be set to 1920x1080. This also allows you to use 1440p canvases, and more exotic canvases such as 4000x1080. HNode supports resolutions other than 1080p using the config file.

This also allows support of multi streaming different resolutions. If you stream at 1080p and have a fallback at 720p, you can set the base resolution to 1080p, and if the 1080p stream fails and it falls back to 720p, it will still be interpreted as 1080p by the system.

### Known issues

If your video player has a built in VRSL integration, such as VideoTXL does, make sure to disable it. in some cases it will work fine, but the video player and this system will be fighting for control over the texture which can lead to weird behaviour

VRSL has a issue where its logic doesnt sample the upper section of some universes properly. This is NOT a issue with this project, it is a issue with VRSL, but you might run into this if you start using alot of channels. Be warned
