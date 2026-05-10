# WARNING! This is NOT a full DMX SYSTEM! This is a SHIM that converts from the MDMX Format to the VRSL format, thats all it does. It only provides bit accuracy and CRC checking

Binary conversion code from the official (unfinished) MDMX repository https://github.com/micksam7/VRC-MDMX

## Getting started

All you need to do to use this in a world is add the prefab from the package into your scene, and assign the render texture input of your video player to it. You also need to use the VRSL control panel to switch to 9 universe mode. I also recommend enabling fine channel support and using the max movement range as this will take the most advantage of the binary grid
<img width="966" height="543" alt="image" src="https://github.com/user-attachments/assets/2cec7e98-6ada-4d63-890f-eaef4b717349" />

### Known issues

VRSL has a issue where its logic doesnt sample the upper section of some universes properly. This is NOT a issue with this project, it is a issue with VRSL, but you might run into this if you start using alot of channels. Be warned
