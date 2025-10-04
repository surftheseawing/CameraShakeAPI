# Camera Shake API 

Figura library that enables players to shake their own camera and the camera of other players who also have this script in their avatar.

**Table of Contents**

- [Features](#️features)
- [Functions](#functions)
    - [Require](#require)
    - [Update](#update)
    - [Set Default Position](#setDefaultPos)
    - [Get Duration](#getDuration)
    - [Get Maximum Duration](#getMaxDuration)
    - [Get Intensity](#getIntensity)

## Features

- Calls `renderer:setOffsetCameraPivot()` every frame in `events.render` with a random value adjusted by the given intensity that diminishes over the given duration.
- Host stores information about current camera shake to `avatar` metadata.
- Clients read information about current camera shake from `avatar` metadata.

## Functions

### Require

Import the Camera Shake API for use in a script.

**Example:**

```lua
local cameraShake = require('CameraShake')
```

### `update()`

Updates the current camera shake.

**Parameters:**

Name | Type | Description
---  | ---  | ---
duration | `number` | How long the shake should last in ticks
intensity | `number` | How far the camera should be displaced in blocks (16 pixels)

**Example:**

Shake the camera for 20 ticks (1 second) with an intensity of 1 pixel.

```lua
cameraShake.update(20, 1/16)
```

### `setDefaultPos()`

Sets the default position of the camera when not shaking.

**Parameters:**

Name | Type | Description
---  | ---  | ---
cameraVec | `Vector3` | Position

**Example:**

Set the default position of the camera two pixels higher than normal.

```lua
cameraShake.setDefaultPos(vec(0, 2/16, 0))
```

### `getDuration()`

Gets the duration of the current camera shake. This value decreases over time from the maximum duration set with `update()`.

**Returns:**

Type | Description
---  | ---
`number` | Duration in ticks

**Example:**

```lua
cameraShake.getDuration()
```

### `getMaxDuration()`

Gets the maximum duration of the current camera shake.

**Returns:**

Type | Description
---  | ---
`number` | Duration in ticks

**Example:**

```lua
cameraShake.getMaxDuration()
```

### `getIntensity()`

Gets the intensity of the current camera shake.

**Returns:**

Type | Description
---  | ---
`number` | Intensity in blocks (16 pixels)

**Example:**

```lua
cameraShake.getIntensity()
```
