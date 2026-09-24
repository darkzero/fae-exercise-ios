# fae-exercise-ios

Assignment for Bragi Field Engineer Candidates.

*Copyright (C) Bragi GmbH. All rights reserved.*

## Overview

This repository contains three components:

- `smartcasekit` contains a Swift package named `SmartCaseKit`. It finds, connects to, and controls a Bragi Smart Case using CoreBluetooth.
- `app` is a macOS SwiftUI application. It uses `smartcasekit` to show a list of nearby smart cases. A user can select a smart case from the list. `app` then connects to the smart case and shows its four buttons. A user can click a button to assign it the next icon and background color from a fixed list.
- `smartcase` is an iOS application. It acts as a Bluetooth LE peripheral, imitating an earbuds charging case with a touchscreen with four buttons. `smartcase` implements the protocol in [`sbsc-protocol.md`](sbsc-protocol.md).

`Assignment.xcworkspace` is at the root of the repository. It contains the Xcode projects for `app` and `smartcase`, and `smartcasekit` as an app dependency.

## Building And Running

Open `Assignment.xcworkspace` in Xcode.

Follow these steps to build the macOS app:

1. Select the `App` scheme.
2. Select a macOS run destination.
3. Open the Product menu.
4. Click Build.

Follow these steps to build the `smartcase` app:

1. Select the `SmartCase` scheme.
2. Select an iOS device run destination.
3. Open the Product menu.
4. Click Build.

To build and test `SmartCaseKit` without `app` or `smartcase`, run these commands in the `smartcasekit` folder:

```sh
swift build
swift test
```

Running this assignment needs two devices. Use a Mac for `App`. Use an iPhone for `SmartCase`.

1. Run `SmartCase` on an iPhone. `SmartCase` starts to advertise itself over Bluetooth.
2. Run `App` on the Mac. `App` scans for nearby smart cases.
3. Select the simulated smart case in the sidebar. `App` connects to it. `App` lists its four buttons.
4. Click a button. `App` assigns it the next icon and background color. The change appears on the simulated case within a second.
5. Tap a button on the simulated case. The matching button in `App` shows an orange border for half a second.
6. Click Disconnect in the `App` to close the connection. `App` returns to the device list.

## Assignment

QA has found bugs when testing `app` and `smartcase`.

Your assignment is to analyze them, find the root cause and propose fixes.

The bug reports are:

1. When changing button icon and background from `app`, the background color on `smartcase` seems to be slightly wrong. For example when `app` shows a dark red background, device shows dark olive.

2. `App` is connected to a `smartcase`. When terminating `smartcase` on the iPhone, `app` doesn't seem to notice it. `App` never reverts to disconnected state. Some delay noticing it would be acceptable, but nothing happened in the app, even after 30 seconds.

3. Start `smartcase` on iPhone, then connect to it from `app` on the Mac. The `app` doesn't show the same icons as `smartcase`. When changing icons from the `app`, everything is looking good, however when restarting the `app`, the icons are wrong again.

4. When `app` starts the first time, the Bluetooth permission popup says "Allow Bluetooth access to find and control nearby smart watches". This is wrong, the popup should say "Allow Bluetooth access to find and control nearby smart cases".

5. Clicking on a `smartcase` button is visible in the `app`, but holding down the button and releasing later is not visible. Feels like a bug, but maybe this is by design?

Yes, I think it is by design.

This behavior is consistent with the current protocol and implementation.
The protocol only defines ButtonTap (0x00), and the iOS app sends this event through onTapGesture. Long-press and release events are neither defined in the protocol nor implemented.

I think No code change is required for the current specification.
Supporting these interactions would require a protocol extension and corresponding changes to the iOS app and Mac-side event handling.

6. A new customer was complaining that the properties of the *SmartCaseButton* class in `smartcasekit` are not documented at all, so they don't know how to use them from their app.

### How To Deliver The Solutions

- Create a public Git repository on GitHub, GitLab or a similar service, with this code as baseline
  - The repository should be accessible by Bragi from Europe
- For every bugfix, create a new branch in this repository
- Deliver the fixes independently in their branches
- Tell Bragi the location of the public Git repository and the names of the bugfix branches
