# User Playtest Acceptance - Upgrade Integration

## Current tested surface

The user tested the current foreground Demo and explicitly reported `测试通过` for:

- First upgrade presents three genuinely selectable cards;
- Selecting 1/2/3 updates the displayed build identity;
- Second and third upgrades show the current-build enhancement card;
- Current-build enhancement changes behavior;
- Card image, text, and empty card area are clickable.

## Evidence boundary

This is user-observed acceptance of the upgrade/build interaction surface. It does not by itself prove export readiness, cross-hardware performance, audio taste, or the entire 5–10 minute Demo is accepted.

## Related implementation checkpoints

- `eb7074e`: responsive card centering and capture foreground gate
- `8b9caee`: upgrade integration state ownership and HUD/confirmation alignment
- `749589f`: full card clickability
- `a58fdae`: unavailable card visibility retirement
- `32952f1`: single current-build enhancement card centering
- `c915c32`: real first build choice
- `2f7b7e9`, `cb3953b`: unified build rank and Pulse correction

## Status

`user_accepted / upgrade-integration-surface`
