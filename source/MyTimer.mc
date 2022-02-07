// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Towplane Swiss Knife (TowplaneSK)
// Copyright (C) 2019-2022 Cedric Dufour <http://cedric.dufour.name>
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

import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Attention as Attn;
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
  public var iState as Number = 0;  // STATE_STANDBY

  // Times and counters
  public var oTimeOffBlock as Time.Moment?;
  public var oTimeTakeoff as Time.Moment?;
  public var fAltitudeTakeoff as Float = NaN;
  public var oTimeTopOfClimb as Time.Moment?;
  public var fAltitudeTopOfClimb as Float = NaN;
  public var iCountCycles as Number = 0;
  public var oTimeLanding as Time.Moment?;
  public var fAltitudeLanding as Float = NaN;
  public var oTimeOnBlock as Time.Moment?;
  // ... internals
  private var oTimeTouchGo as Time.Moment?;


  //
  // FUNCTIONS: self
  //

  function reset() as Void {
    //Sys.println("DEBUG: MyTimer.reset()");

    // Reset
    // ... state
    self.iState = self.STATE_STANDBY;  // DEBUG: self.STATE_ONBLOCK;
    // ... times and counters
    self.oTimeOffBlock = null;  // DEBUG: new Time.Moment(1557316800);
    self.oTimeTakeoff = null;  // DEBUG: new Time.Moment(1557317100);
    self.fAltitudeTakeoff = NaN;  // DEBUG: 500.0f;
    self.oTimeTopOfClimb = null;  // DEBUG: new Time.Moment(1557318600);
    self.fAltitudeTopOfClimb = NaN;  // DEBUG: 1000.0f;
    self.iCountCycles = 0;
    self.oTimeLanding = null;  // DEBUG: new Time.Moment(1557320100);
    self.fAltitudeLanding = NaN;  // DEBUG: 505.0f;
    self.oTimeOnBlock = null;  // DEBUG: new Time.Moment(1557320400);
    // ... internals
    self.oTimeTouchGo = null;
  }

  function onLocationEvent() as Void {
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
          ($.oMyActivity as MyActivity).resume();  // <-> Attn.playTone(Attn.TONE_START)
        }
        else if(Toybox.Attention has :playTone) {
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
        self.iCountCycles += 1;
        if(self.oTimeTakeoff == null) {  // not a stop-'n-go
          self.oTimeTakeoff = oTimeNow;
          self.fAltitudeTakeoff = $.oMyProcessing.fAltitude;
        }
        self.oTimeLanding = null;
        self.fAltitudeLanding = NaN;
        self.iState = self.STATE_TAKEOFF;
        if(Toybox.Attention has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_TAKEOFF) {
      if($.oMyProcessing.fAirSpeed < $.oMyTowplane.fSpeedLanding) {
        if((oTimeNow as Time.Moment).value() - (self.oTimeTakeoff as Time.Moment).value() < $.oMySettings.iTimerThresholdAirborne) {  // too short a cycle; aborted takeoff ?
          self.iCountCycles -= 1;
          self.oTimeTakeoff = null;
          self.fAltitudeTakeoff = NaN;
          self.iState = self.STATE_OFFBLOCK;
        }
        else {
          if(self.oTimeTouchGo != null and (oTimeNow as Time.Moment).value() - (self.oTimeTouchGo as Time.Moment).value() < $.oMySettings.iTimerThresholdAirborne) {  // too short a cycle; bouncing landing ?
            self.iCountCycles -= 1;
          }
          self.oTimeLanding = oTimeNow;
          self.fAltitudeLanding = $.oMyProcessing.fAltitude;
          self.iState = self.STATE_LANDING;
          if(Toybox.Attention has :playTone) {
            Attn.playTone(Attn.TONE_KEY);
          }
        }
      }
      else {  // in flight
        if(!(self.fAltitudeTopOfClimb >= $.oMyProcessing.fAltitude)) {  // comparing to NaN is always false
          self.oTimeTopOfClimb = oTimeNow;
          self.fAltitudeTopOfClimb = $.oMyProcessing.fAltitude;
        }
      }
    }
    else if(self.iState == self.STATE_LANDING) {
      if($.oMyProcessing.fAirSpeed > $.oMyTowplane.fSpeedTakeoff) {  // touch-'n-go
        self.iCountCycles += 1;
        self.oTimeTouchGo = oTimeNow;
        self.oTimeLanding = null;
        self.fAltitudeLanding = NaN;
        self.iState = self.STATE_TAKEOFF;
        if(Toybox.Attention has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
      else if($.oMyProcessing.fGroundSpeed < $.oMyTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = oTimeNow;
        self.iState = self.STATE_ONBLOCK;
        if(Toybox.Attention has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_ONBLOCK) {
      if($.oMyProcessing.fGroundSpeed > $.oMyTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = null;
        self.iState = self.STATE_OFFBLOCK;
        if($.oMyActivity != null and $.oMySettings.bTimerAutoActivity) {
          ($.oMyActivity as MyActivity).resume();  // <-> Attn.playTone(Attn.TONE_START)
        }
      }
      else if((oTimeNow as Time.Moment).value() - (self.oTimeOnBlock as Time.Moment).value() > $.oMySettings.iTimerThresholdGround) {
        if(self.oTimeTakeoff != null and $.oMySettings.bTimerAutoLog) {
          self.log();
        }
        if($.oMyActivity != null and $.oMySettings.bTimerAutoActivity) {
          ($.oMyActivity as MyActivity).pause();  // <-> Attn.playTone(Attn.TONE_STOP)
        }
      }
    }
    //Sys.println(format("DEBUG: flight state = $1$", [self.iState]));
  }

  function addCycle() as Void {
    //Sys.println("DEBUG: MyTimer.addCycle()");
    if(self.oTimeTakeoff != null) {
      self.iCountCycles += 1;
      if(Toybox.Attention has :playTone) {
        Attn.playTone(Attn.TONE_KEY);
      }
    }
  }

  function undoCycle() as Void {
    //Sys.println("DEBUG: MyTimer.undoCycle()");
    if(self.iCountCycles > 0) {
      self.iCountCycles -= 1;
      if(Toybox.Attention has :playTone) {
        Attn.playTone(Attn.TONE_KEY);
      }
    }
  }

  function log() as Void {
    //Sys.println("DEBUG: MyTimer.log()");

    // Check state
    if(self.iState != MyTimer.STATE_ONBLOCK) {
      return;
    }

    // Log entry
    var dictLog = {
      "towplane" => $.oMyTowplane.sCallsign,
      "glider" => $.oMyGlider != null ? ($.oMyGlider as MyGlider).sCallsign : null,
      "timeOffBlock" => self.oTimeOffBlock != null ? (self.oTimeOffBlock as Time.Moment).value() : null,
      "timeTakeoff" => self.oTimeTakeoff != null ? (self.oTimeTakeoff as Time.Moment).value() : null,
      "countCycles" => self.iCountCycles,
      "timeLanding" => self.oTimeLanding != null ? (self.oTimeLanding as Time.Moment).value() : null,
      "timeOnBlock" => self.oTimeOnBlock != null ? (self.oTimeOnBlock as Time.Moment).value() : null
    };
    $.iMyLogIndex = ($.iMyLogIndex + 1) % $.MY_STORAGE_SLOTS;
    var s = $.iMyLogIndex.format("%02d");
    App.Storage.setValue(format("storLog$1$", [s]), dictLog as App.PropertyValueType);
    App.Storage.setValue("storLogIndex", $.iMyLogIndex as App.PropertyValueType);

    // Add activity lap
    if($.oMyActivity != null) {
      var oMyActivity = $.oMyActivity as MyActivity;
      oMyActivity.setCallsignTowplane($.oMyTowplane.sCallsign);
      oMyActivity.setCallsignGlider($.oMyGlider != null ? ($.oMyGlider as MyGlider).sCallsign : null);
      oMyActivity.setTimeOffBlock(self.oTimeOffBlock);
      oMyActivity.setTimeTakeoff(self.oTimeTakeoff);
      oMyActivity.setAltitudeTakeoff(self.fAltitudeTakeoff);
      oMyActivity.setTimeTopOfClimb(self.oTimeTopOfClimb);
      oMyActivity.setAltitudeTopOfClimb(self.fAltitudeTopOfClimb);
      oMyActivity.setCountCycles(self.iCountCycles);
      oMyActivity.setTimeLanding(self.oTimeLanding);
      oMyActivity.setAltitudeLanding(self.fAltitudeLanding);
      oMyActivity.setTimeOnBlock(self.oTimeOnBlock);
      if(self.oTimeTakeoff != null and self.oTimeLanding != null) {
        oMyActivity.setFlightTime((self.oTimeLanding as Time.Moment).subtract(self.oTimeTakeoff as Time.Moment) as Time.Duration);
      }
      else {
        oMyActivity.setFlightTime(null);
      }
      if(self.oTimeOffBlock != null and self.oTimeOnBlock != null) {
        oMyActivity.setBlockTime((self.oTimeOnBlock as Time.Moment).subtract(self.oTimeOffBlock as Time.Moment) as Time.Duration);
      }
      else {
        oMyActivity.setBlockTime(null);
      }
      oMyActivity.addLap();  // <-> Attn.playTone(Attn.TONE_LAP)
    }
    else if(Toybox.Attention has :playTone) {
      Attn.playTone(Attn.TONE_LOUD_BEEP);
    }

    // Done
    self.reset();
  }

}
