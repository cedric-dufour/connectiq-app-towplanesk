// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Towplane Swiss Knife (TowplaneSK)
// Copyright (C) 2019 Cedric Dufour <http://cedric.dufour.name>
//
// Towplane Swiss Knife (TowplaneSK) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Towplane Swiss Knife (TowplaneSK) is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

using Toybox.Application as App;
using Toybox.Attention as Attn;
using Toybox.Lang;
using Toybox.Time;
using Toybox.System as Sys;

//
// CLASS
//

class MyTimer {

  //
  // CONSTANTS
  //

  // States
  public const STATE_STANDBY = 0;
  public const STATE_OFFBLOCK = 1;
  public const STATE_TAKEOFF = 2;
  public const STATE_LANDING = 3;
  public const STATE_ONBLOCK = 4;


  //
  // VARIABLES
  //

  // State
  public var iState;

  // Times and counters
  public var oTimeOffBlock;
  public var oTimeTakeoff;
  public var fAltitudeTakeoff;
  public var oTimeTopOfClimb;
  public var fAltitudeTopOfClimb;
  public var iCountCycles;
  public var oTimeLanding;
  public var fAltitudeLanding;
  public var oTimeOnBlock;
  // ... internals
  private var oTimeTouchGo;


  //
  // FUNCTIONS: self
  //

  function initialize() {
    self.reset();
  }

  function reset() {
    //Sys.println("DEBUG: MyTimer.reset()");

    // Reset
    // ... state
    self.iState = self.STATE_STANDBY;  // DEBUG: self.STATE_ONBLOCK;
    // ... times and counters
    self.oTimeOffBlock = null;  // DEBUG: new Time.Moment(1557316800);
    self.oTimeTakeoff = null;  // DEBUG: new Time.Moment(1557317100);
    self.fAltitudeTakeoff = null;  // DEBUG: 500.0f;
    self.oTimeTopOfClimb = null;  // DEBUG: new Time.Moment(1557318600);
    self.fAltitudeTopOfClimb = null;  // DEBUG: 1000.0f;
    self.iCountCycles = 0;
    self.oTimeLanding = null;  // DEBUG: new Time.Moment(1557320100);
    self.fAltitudeLanding = null;  // DEBUG: 505.0f;
    self.oTimeOnBlock = null;  // DEBUG: new Time.Moment(1557320400);
    // ... internals
    self.oTimeTouchGo = null;
  }

  function onLocationEvent() {
    //Sys.println("DEBUG: MyTimer.onLocationEvent()");
    var oTimeNow = Time.now();

    // State machine
    if(self.iState == self.STATE_STANDBY) {
      if($.oMyProcessing.fGroundSpeed > $.oMyTowplane.fSpeedOffBlock) {
        self.oTimeOffBlock = oTimeNow;
        self.iState = self.STATE_OFFBLOCK;
        if($.oMySettings.bTimerAutoActivity) {
          if($.oMyActivity == null) {
            $.oMyActivity = new MyActivity();
          }
          $.oMyActivity.resume();  // <-> Attn.playTone(Attn.TONE_START)
        }
        else if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_OFFBLOCK) {
      if($.oMyProcessing.fGroundSpeed < $.oMyTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = oTimeNow;
        self.iState = self.STATE_ONBLOCK;
      }
      else if($.oMyProcessing.fAirSpeed > $.oMyTowplane.fSpeedTakeoff) {
        if(self.oTimeTakeoff == null) {  // not a stop-'n-go
          self.oTimeTakeoff = oTimeNow;
          self.fAltitudeTakeoff = $.oMyProcessing.fAltitude;
        }
        self.iState = self.STATE_TAKEOFF;
        if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_TAKEOFF) {
      if($.oMyProcessing.fAirSpeed < $.oMyTowplane.fSpeedLanding) {
        if(oTimeNow.value() - self.oTimeTakeoff.value() < $.oMySettings.iTimerThresholdAirborne) {  // too short a cycle; aborted takeoff ?
          self.oTimeTakeoff = null;
          self.fAltitudeTakeoff = null;
          self.iState = self.STATE_OFFBLOCK;
        }
        else {
          self.oTimeLanding = oTimeNow;
          self.fAltitudeLanding = $.oMyProcessing.fAltitude;
          self.iState = self.STATE_LANDING;
          if(self.oTimeTouchGo == null or oTimeNow.value() - self.oTimeTouchGo.value() > $.oMySettings.iTimerThresholdAirborne) {  // not a bouncing landing
            self.iCountCycles += 1;
            if(Attn has :playTone) {
              Attn.playTone(Attn.TONE_KEY);
            }
          }
        }
      }
      else {  // in flight
        if(self.fAltitudeTopOfClimb == null or self.fAltitudeTopOfClimb < $.oMyProcessing.fAltitude) {
          self.oTimeTopOfClimb = oTimeNow;
          self.fAltitudeTopOfClimb = $.oMyProcessing.fAltitude;
        }
      }
    }
    else if(self.iState == self.STATE_LANDING) {
      if($.oMyProcessing.fAirSpeed > $.oMyTowplane.fSpeedTakeoff) {  // touch-'n-go
        self.oTimeTouchGo = oTimeNow;
        self.oTimeLanding = null;
        self.fAltitudeLanding = null;
        self.iState = self.STATE_TAKEOFF;
        if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
      else if($.oMyProcessing.fGroundSpeed < $.oMyTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = oTimeNow;
        self.iState = self.STATE_ONBLOCK;
        if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_ONBLOCK) {
      if($.oMyProcessing.fGroundSpeed > $.oMyTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = null;
        self.iState = self.STATE_OFFBLOCK;
        if($.oMyActivity != null and $.oMySettings.bTimerAutoActivity) {
          $.oMyActivity.resume();  // <-> Attn.playTone(Attn.TONE_START)
        }
      }
      else if(oTimeNow.value() - self.oTimeOnBlock.value() > $.oMySettings.iTimerThresholdGround) {
        if(self.oTimeTakeoff != null and $.oMySettings.bTimerAutoLog) {
          self.log();
        }
        if($.oMyActivity != null and $.oMySettings.bTimerAutoActivity) {
          $.oMyActivity.pause();  // <-> Attn.playTone(Attn.TONE_STOP)
        }
      }
    }
    //Sys.println(Lang.format("DEBUG: flight state = $1$", [self.iState]));
  }

  function addCycle() {
    //Sys.println("DEBUG: MyTimer.addCycle()");
    if(self.oTimeTakeoff != null) {
      self.iCountCycles += 1;
      if(Attn has :playTone) {
        Attn.playTone(Attn.TONE_KEY);
      }
    }
  }

  function undoCycle() {
    //Sys.println("DEBUG: MyTimer.undoCycle()");
    if(self.iCountCycles > 0) {
      self.iCountCycles -= 1;
      if(Attn has :playTone) {
        Attn.playTone(Attn.TONE_KEY);
      }
    }
  }

  function log() {
    //Sys.println("DEBUG: MyTimer.log()");

    // Check state
    if(self.iState != MyTimer.STATE_ONBLOCK) {
      return;
    }

    // Log entry
    var dictLog = {
      "towplane" => $.oMyTowplane.sCallsign,
      "glider" => $.oMyGlider != null ? $.oMyGlider.sCallsign : null,
      "timeOffBlock" => self.oTimeOffBlock != null ? self.oTimeOffBlock.value() : null,
      "timeTakeoff" => self.oTimeTakeoff != null ? self.oTimeTakeoff.value() : null,
      "countCycles" => self.iCountCycles,
      "timeLanding" => self.oTimeLanding != null ? self.oTimeLanding.value() : null,
      "timeOnBlock" => self.oTimeOnBlock != null ? self.oTimeOnBlock.value() : null
    };
    if($.iMyLogIndex == null) {
      $.iMyLogIndex = 0;
    }
    else {
      $.iMyLogIndex = ($.iMyLogIndex + 1) % $.MY_STORAGE_SLOTS;
    }
    var s = $.iMyLogIndex.format("%02d");
    App.Storage.setValue(Lang.format("storLog$1$", [s]), dictLog);

    // Add activity lap
    if($.oMyActivity != null) {
      $.oMyActivity.setCallsignTowplane($.oMyTowplane.sCallsign);
      $.oMyActivity.setCallsignGlider($.oMyGlider != null ? $.oMyGlider.sCallsign : null);
      $.oMyActivity.setTimeOffBlock(self.oTimeOffBlock);
      $.oMyActivity.setTimeTakeoff(self.oTimeTakeoff);
      $.oMyActivity.setAltitudeTakeoff(self.fAltitudeTakeoff);
      $.oMyActivity.setTimeTopOfClimb(self.oTimeTopOfClimb);
      $.oMyActivity.setAltitudeTopOfClimb(self.fAltitudeTopOfClimb);
      $.oMyActivity.setCountCycles(self.iCountCycles);
      $.oMyActivity.setTimeLanding(self.oTimeLanding);
      $.oMyActivity.setAltitudeLanding(self.fAltitudeLanding);
      $.oMyActivity.setTimeOnBlock(self.oTimeOnBlock);
      if(self.oTimeTakeoff != null and self.oTimeLanding != null) {
        $.oMyActivity.setFlightTime(self.oTimeLanding.subtract(self.oTimeTakeoff));
      }
      else {
        $.oMyActivity.setFlightTime(null);
      }
      if(self.oTimeOffBlock != null and self.oTimeOnBlock != null) {
        $.oMyActivity.setBlockTime(self.oTimeOnBlock.subtract(self.oTimeOffBlock));
      }
      else {
        $.oMyActivity.setBlockTime(null);
      }
      $.oMyActivity.addLap();  // <-> Attn.playTone(Attn.TONE_LAP)
    }
    else if(Attn has :playTone) {
      Attn.playTone(Attn.TONE_LOUD_BEEP);
    }

    // Done
    self.reset();
  }

}
