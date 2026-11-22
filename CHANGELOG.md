# Changelog

All notable changes to this fork of ROCKNIXDS. Newest first.

ROCKNIXDS has two release lines. Versions ending in `-plus` are for the **RG DS Plus**. The others are for the
**RG DS**. Fork releases add a fourth number to the upstream release they build on (1.6.3 and 1.6.4-plus).
Each release's full notes are in [`docs/releases/`](docs/releases/) and on the
[releases page](https://github.com/agiacalone/ROCKNIXDS/releases).

A **beta** is a pre-release. It is offered only on the Beta update channel until someone has run it on that
handheld.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Please report problems at
<https://github.com/agiacalone/ROCKNIXDS/issues>.

## 1.6.4.8-plus (RG DS Plus) · 2026-11-22

### Fixed
- **SuperDrastic comes back after ROCKNIX 20261101's update.** That update's first start resets every standalone
  emulator's settings folder, DraStic's included, which removed SuperDrastic. DS games then ran on stock DraStic.
  Now ROCKNIXDS notices at start-up, installs the same version again once Wi-Fi is up, and says so in the menu.
  Saves are not touched. DraStic options you changed yourself need setting again.
- The Beta update channel follows each release, so it never offers an older build. On the RG DS Plus it had stayed at
  1.6.4.1-plus since October; it was moved to 1.6.4.7-plus on 2026-11-16, and each release now moves it.

## 1.6.4.7-plus (RG DS Plus) · 2026-11-16

### Added
- **GBA DS in the Store**, by kyannon (GPL-3.0). It plays Game Boy Advance games on one screen and shows the game's
  own map, race display or unit details on the other. Its saves, save states and settings stay when it is updated
  or removed.
- This changelog.

### Fixed
- SuperDrastic 0.5.0-beta.1-rocknixds.13, with five fixes from upstream SuperDrastic:
  - A button or direction released while the in-game menu is open is now released in the game too. Before, the game
    kept it held after the menu closed.
  - If a save on quit does not finish (a full card, or the 5-second limit), the previous resume state stays.
    Before, it was deleted first.
  - A build with stronger security checks no longer stops at start-up.
  - The NNDDSS shaders scale correctly, and the Retro tiles shader no longer shows a washed-out half.

### Changed
- The terms of use (`LEGAL.md`) are version 2. They name this fork, drop the performance-log section, and send
  questions to this fork's issues. The licences are unchanged: MIT, and GPL-3.0 for Bank & Trade.

## 1.6.3.4 (RG DS, beta) · 2026-11-16

### Added
- GBA DS in the Store, as in 1.6.4.7-plus.
- This changelog.

### Fixed
- SuperDrastic 0.5.0-beta.1-rocknixds.13, the same package and fixes as 1.6.4.7-plus.

### Changed
- The terms of use (`LEGAL.md`) are back, as version 2. The installer's link to them works again.

## 1.6.4.6-plus (RG DS Plus) · 2026-11-16

### Fixed
- **DS games count as played again** (upstream #50, #62, #88). A DS game that was quit normally was recorded as a
  failed launch, so play count, time played and last played never changed.
- **A Store update cut short no longer loses an app's saves.** A power cut during an update could leave the only
  copy of an app's saves in a folder that the next install deleted.

## 1.6.3.3 (RG DS, beta) · 2026-11-16

### Fixed
- DS games count as played again, and a Store update cut short no longer loses an app's saves, as in 1.6.4.6-plus.

## 1.6.4.5-plus (RG DS Plus) · 2026-11-01

### Added
- *Nintendo DS > Shader* lists 19 more shaders from libretro, DraStic and Anbernic NNDDSS. Before, only the in-game
  menu offered them.

## 1.6.3.2 (RG DS, beta) · 2026-11-01

Brings the RG DS up to 1.6.4.4-plus.

### Added
- SuperDrastic 0.5.0-beta.1-rocknixds.12 (was rocknixds.9-test.6), with 21 more shaders, save and load pop-ups,
  and *Quit without saving*.
- 60 Hz panels by default (upstream #86). `--no-60hz` keeps 59.8 Hz.

### Fixed
- The audio crackle in heavy 3D scenes.
- No long white screen after a long sleep (BananaLinux #64).
- Games launched over the network start in about 6 seconds, not at the next full minute.
- The menu gets the pad back after a DS game (upstream #89).

### Changed
- The Store, Bank & Trade and Döda Kvarter come from this fork.

### Removed
- The optional performance-log upload to upstream, with its question and its menu option.

## 1.6.4.4-plus (RG DS Plus) · 2026-11-01

### Added
- SuperDrastic 0.5.0-beta.1-rocknixds.12: *Quit without saving* on the quit question.
- Experimental options, off unless switched on: low latency (`DSFLIP_LOWLAT=1`), a sleeping sound wait
  (`DSFLIP_AUDIO_WAIT=1`) and a gentler CPU governor rule (`DSFLIP_CPUGOV_SPIKE=1`).

### Fixed
- Games launched over the network (the Store, scripts) start in about 6 seconds, not at the next full minute.
- A quit sent while the in-game menu is open closes the menu and quits.

## 1.6.4.3-plus (RG DS Plus) · 2026-11-01

### Added
- SuperDrastic 0.5.0-beta.1-rocknixds.11, with fixes from the BananaOS line of SuperDrastic.
- 21 more shaders in the in-game menu. All 29 compile on ROCKNIX's Mali driver.
- "Saved to slot n" and "Loaded slot n" pop-ups for DraStic's save and load state buttons.
- An opt-in sound rate for display-locked pacing (`DSFLIP_AUDIO_LOCK_PER`).

### Changed
- ds-grid-2x is 13% cheaper on the GPU, with the same picture.

### Fixed
- No long white screen after a sleep of about 36 minutes or more (BananaLinux #64).
- A charger shows as charging in the in-game menu (BananaLinux #35).

## 1.6.4.2-plus (RG DS Plus) · 2026-11-01

The first release after upstream stopped on 2026-10-22. This fork now maintains ROCKNIXDS on base ROCKNIX.

### Added
- 60 Hz panels by default (upstream #86). The panels go from 60.17 to 60.0027 Hz, DraStic's frame rate, after one
  reboot. `--no-60hz` turns it off.

### Fixed
- The menu answers the pad after a DS game (upstream #89).

### Changed
- The Store, Döda Kvarter and Bank & Trade come from this fork. eReaderDS still comes from its author.
- The README says what this fork is.

## 1.6.4.1-plus (RG DS Plus) and 1.6.3.1 (RG DS) · 2026-10-19

Upstream's last releases (1.6.4-plus and 1.6.3) with fixes that were open as pull requests upstream.

### Added
- Any theme with a dual-screen layout uses both screens and shows in the theme menu (upstream #84, #85).
- More about the game on the library's top screen (upstream #72).
- A charging battery and coloured status icons (upstream #73).
- Touch controls on the bottom panel during the screensaver (upstream #75).

### Changed
- The screensaver runs on the top panel with the bottom backlight off, and long names stay on one line
  (upstream #69).

### Fixed
- The slideshow wakes only when its clock changes (upstream #71).

## Before the fork

Releases up to 1.6.4-plus and 1.6.3 were made by JorreFog. See
[JorreFog/ROCKNIXDS releases](https://github.com/JorreFog/ROCKNIXDS/releases).
