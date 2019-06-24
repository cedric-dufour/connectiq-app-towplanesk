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
using Toybox.Time.Gregorian;
using Toybox.System as Sys;

//
// CLASS
//

class TSK_Timer {

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
    //Sys.println("DEBUG: TSK_Timer.reset()");

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
    //Sys.println("DEBUG: TSK_Timer.onLocationEvent()");
    var oTimeNow = Time.now();

    // State machine
    if(self.iState == self.STATE_STANDBY) {
      if($.TSK_oProcessing.fGroundSpeed > $.TSK_oTowplane.fSpeedOffBlock) {
        self.oTimeOffBlock = oTimeNow;
        self.iState = self.STATE_OFFBLOCK;
        if($.TSK_oSettings.bTimerAutoActivity) {
          if($.TSK_oActivity == null) {
            $.TSK_oActivity = new TSK_Activity();
          }
          $.TSK_oActivity.resume();  // <-> Attn.playTone(Attn.TONE_START)
        }
        else if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_OFFBLOCK) {
      if($.TSK_oProcessing.fGroundSpeed < $.TSK_oTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = oTimeNow;
        self.iState = self.STATE_ONBLOCK;
      }
      else if($.TSK_oProcessing.fAirSpeed > $.TSK_oTowplane.fSpeedTakeoff) {
        if(self.oTimeTakeoff == null) {  // not a stop-'n-go
          self.oTimeTakeoff = oTimeNow;
          self.fAltitudeTakeoff = $.TSK_oProcessing.fAltitude;
        }
        self.iState = self.STATE_TAKEOFF;
        if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_TAKEOFF) {
      if($.TSK_oProcessing.fAirSpeed < $.TSK_oTowplane.fSpeedLanding) {
        if(oTimeNow.value() - self.oTimeTakeoff.value() < $.TSK_oSettings.iTimerThresholdAirborne) {  // too short a cycle; aborted takeoff ?
          self.oTimeTakeoff = null;
          self.fAltitudeTakeoff = null;
          self.iState = self.STATE_OFFBLOCK;
        }
        else {
          self.oTimeLanding = oTimeNow;
          self.fAltitudeLanding = $.TSK_oProcessing.fAltitude;
          self.iState = self.STATE_LANDING;
          if(self.oTimeTouchGo == null or oTimeNow.value() - self.oTimeTouchGo.value() > $.TSK_oSettings.iTimerThresholdAirborne) {  // not a bouncing landing
            self.iCountCycles += 1;
            if(Attn has :playTone) {
              Attn.playTone(Attn.TONE_KEY);
            }
          }
        }
      }
      else {  // in flight
        if(self.fAltitudeTopOfClimb == null or self.fAltitudeTopOfClimb < $.TSK_oProcessing.fAltitude) {
          self.oTimeTopOfClimb = oTimeNow;
          self.fAltitudeTopOfClimb = $.TSK_oProcessing.fAltitude;
        }
      }
    }
    else if(self.iState == self.STATE_LANDING) {
      if($.TSK_oProcessing.fAirSpeed > $.TSK_oTowplane.fSpeedTakeoff) {  // touch-'n-go
        self.oTimeTouchGo = oTimeNow;
        self.oTimeLanding = null;
        self.fAltitudeLanding = null;
        self.iState = self.STATE_TAKEOFF;
        if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
      else if($.TSK_oProcessing.fGroundSpeed < $.TSK_oTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = oTimeNow;
        self.iState = self.STATE_ONBLOCK;
        if(Attn has :playTone) {
          Attn.playTone(Attn.TONE_KEY);
        }
      }
    }
    else if(self.iState == self.STATE_ONBLOCK) {
      if($.TSK_oProcessing.fGroundSpeed > $.TSK_oTowplane.fSpeedOffBlock) {
        self.oTimeOnBlock = null;
        self.iState = self.STATE_OFFBLOCK;
        if($.TSK_oActivity != null and $.TSK_oSettings.bTimerAutoActivity) {
          $.TSK_oActivity.resume();  // <-> Attn.playTone(Attn.TONE_START)
        }
      }
      else if(oTimeNow.value() - self.oTimeOnBlock.value() > $.TSK_oSettings.iTimerThresholdGround) {
        if(self.oTimeTakeoff != null and $.TSK_oSettings.bTimerAutoLog) {
          self.log();
        }
        if($.TSK_oActivity != null and $.TSK_oSettings.bTimerAutoActivity) {
          $.TSK_oActivity.pause();  // <-> Attn.playTone(Attn.TONE_STOP)
        }
      }
    }
    //Sys.println(Lang.format("DEBUG: flight state = $1$", [self.iState]));
  }

  function addCycle() {
    //Sys.println("DEBUG: TSK_Timer.addCycle()");
    if(self.oTimeTakeoff != null) {
      self.iCountCycles += 1;
      if(Attn has :playTone) {
        Attn.playTone(Attn.TONE_KEY);
      }
    }
  }

  function undoCycle() {
    //Sys.println("DEBUG: TSK_Timer.undoCycle()");
    if(self.iCountCycles > 0) {
      self.iCountCycles -= 1;
      if(Attn has :playTone) {
        Attn.playTone(Attn.TONE_KEY);
      }
    }
  }

  function log() {
    //Sys.println("DEBUG: TSK_Timer.log()");

    // Check state
    if(self.iState != TSK_Timer.STATE_ONBLOCK) {
      return;
    }

    // Log entry
    var dictLog = {
      "towplane" => $.TSK_oTowplane.sCallsign,
      "glider" => $.TSK_oGlider != null ? $.TSK_oGlider.sCallsign : null,
      "timeOffBlock" => self.oTimeOffBlock != null ? self.oTimeOffBlock.value() : null,
      "timeTakeoff" => self.oTimeTakeoff != null ? self.oTimeTakeoff.value() : null,
      "countCycles" => self.iCountCycles,
      "timeLanding" => self.oTimeLanding != null ? self.oTimeLanding.value() : null,
      "timeOnBlock" => self.oTimeOnBlock != null ? self.oTimeOnBlock.value() : null
    };
    if($.TSK_iLogIndex == null) {
      $.TSK_iLogIndex = 0;
    }
    else {
      $.TSK_iLogIndex = ($.TSK_iLogIndex + 1) % $.TSK_STORAGE_SLOTS;
    }
    var s = $.TSK_iLogIndex.format("%02d");
    App.Storage.setValue(Lang.format("storLog$1$", [s]), dictLog);

    // Add activity lap
    if($.TSK_oActivity != null) {
      $.TSK_oActivity.setCallsignTowplane($.TSK_oTowplane.sCallsign);
      $.TSK_oActivity.setCallsignGlider($.TSK_oGlider != null ? $.TSK_oGlider.sCallsign : null);
      $.TSK_oActivity.setTimeOffBlock(self.oTimeOffBlock);
      $.TSK_oActivity.setTimeTakeoff(self.oTimeTakeoff);
      $.TSK_oActivity.setAltitudeTakeoff(self.fAltitudeTakeoff);
      $.TSK_oActivity.setTimeTopOfClimb(self.oTimeTopOfClimb);
      $.TSK_oActivity.setAltitudeTopOfClimb(self.fAltitudeTopOfClimb);
      $.TSK_oActivity.setCountCycles(self.iCountCycles);
      $.TSK_oActivity.setTimeLanding(self.oTimeLanding);
      $.TSK_oActivity.setAltitudeLanding(self.fAltitudeLanding);
      $.TSK_oActivity.setTimeOnBlock(self.oTimeOnBlock);
      if(self.oTimeTakeoff != null and self.oTimeLanding != null) {
        $.TSK_oActivity.setFlightTime(self.oTimeLanding.subtract(self.oTimeTakeoff));
      }
      else {
        $.TSK_oActivity.setFlightTime(null);
      }
      if(self.oTimeOffBlock != null and self.oTimeOnBlock != null) {
        $.TSK_oActivity.setBlockTime(self.oTimeOnBlock.subtract(self.oTimeOffBlock));
      }
      else {
        $.TSK_oActivity.setBlockTime(null);
      }
      $.TSK_oActivity.addLap();  // <-> Attn.playTone(Attn.TONE_LAP)
    }
    else if(Attn has :playTone) {
      Attn.playTone(Attn.TONE_LOUD_BEEP);
    }

    // Done
    self.reset();
  }

  static function formatTime(_oTime) {
    var oTimeInfo = $.TSK_oSettings.bUnitTimeUTC ? Gregorian.utcInfo(_oTime, Time.FORMAT_SHORT) : Gregorian.info(_oTime, Time.FORMAT_SHORT);
    return Lang.format("$1$:$2$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d")]);
  }

  static function formatElapsedTime(_oTimeFrom, _oTimeTo) {  // minute-precision
    var oTimeInfo_from = Gregorian.utcInfo(_oTimeFrom, Time.FORMAT_SHORT);
    var oTimeInfo_to = Gregorian.utcInfo(_oTimeTo, Time.FORMAT_SHORT);
    var oTimeInfo_elapsed = Gregorian.utcInfo(new Time.Moment((3600*oTimeInfo_to.hour+60*oTimeInfo_to.min) - (3600*oTimeInfo_from.hour+60*oTimeInfo_from.min)), Time.FORMAT_SHORT);
    return Lang.format("$1$:$2$", [oTimeInfo_elapsed.hour.format("%01d"), oTimeInfo_elapsed.min.format("%02d")]);
  }

}
