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
using Toybox.Activity;
using Toybox.ActivityRecording as AR;
using Toybox.Attention as Attn;
using Toybox.FitContributor as FC;
using Toybox.Time;

//
// CLASS
//

class MyActivity {

  //
  // CONSTANTS
  //

  // FIT fields (as per resources/fit.xml)
  // ... record
  public const FITFIELD_BAROMETRICALTITUDE = 0;
  public const FITFIELD_VERTICALSPEED = 1;
  // ... lap
  public const FITFIELD_CALLSIGNTOWPLANE = 10;
  public const FITFIELD_CALLSIGNGLIDER = 11;
  public const FITFIELD_TIMEOFFBLOCK = 12;
  public const FITFIELD_TIMETAKEOFF = 13;
  public const FITFIELD_ALTITUDETAKEOFF = 14;
  public const FITFIELD_TIMETOPOFCLIMB = 15;
  public const FITFIELD_ALTITUDETOPOFCLIMB = 16;
  public const FITFIELD_COUNTCYCLES = 17;
  public const FITFIELD_TIMELANDING = 18;
  public const FITFIELD_ALTITUDELANDING = 19;
  public const FITFIELD_TIMEONBLOCK = 20;
  public const FITFIELD_FLIGHTTIME = 21;
  public const FITFIELD_BLOCKTIME = 22;
  // ... session
  public const FITFIELD_TOTALFLIGHTTIME = 90;
  public const FITFIELD_TOTALBLOCKTIME = 91;

  // Data
  // ... lap
  public const DATA_CALLSIGNTOWPLANE = 0x0001;
  public const DATA_CALLSIGNGLIDER = 0x0002;
  public const DATA_TIMEOFFBLOCK = 0x0004;
  public const DATA_TIMETAKEOFF = 0x0008;
  public const DATA_ALTITUDETAKEOFF = 0x0010;
  public const DATA_TIMETOPOFCLIMB = 0x0020;
  public const DATA_ALTITUDETOPOFCLIMB = 0x0040;
  public const DATA_COUNTCYCLES = 0x0080;
  public const DATA_TIMELANDING = 0x0100;
  public const DATA_ALTITUDELANDING = 0x0200;
  public const DATA_TIMEONBLOCK = 0x0400;
  public const DATA_FLIGHTTIME = 0x0800;
  public const DATA_BLOCKTIME = 0x1000;
  public const DATA_STATEFUL = 0x1D8D;


  //
  // VARIABLES
  //

  // Session (recording)
  private var oSession as AR.Session;
  // ... internals
  private var oDurationFlight as Time.Duration;
  private var oDurationBlock as Time.Duration;

  // FIT fields
  // ... (unit conversion) coefficients
  private var bUnitCoefficient_TimeUTC as Boolean = false;
  private var fUnitCoefficient_Altitude as Float = 1.0f;
  private var fUnitCoefficient_VerticalSpeed as Float = 1.0f;
  private var fUnitCoefficient_HorizontalSpeed as Float = 1.0f;
  // ... record
  private var oFitField_BarometricAltitude as FC.Field;
  private var oFitField_VerticalSpeed as FC.Field;
  // ... lap
  private var oFitField_CallsignTowplane as FC.Field;
  private var oFitField_CallsignGlider as FC.Field;
  private var oFitField_TimeOffBlock as FC.Field;
  private var oFitField_TimeTakeoff as FC.Field;
  private var oFitField_AltitudeTakeoff as FC.Field;
  private var oFitField_TimeTopOfClimb as FC.Field;
  private var oFitField_AltitudeTopOfClimb as FC.Field;
  private var oFitField_CountCycles as FC.Field;
  private var oFitField_TimeLanding as FC.Field;
  private var oFitField_AltitudeLanding as FC.Field;
  private var oFitField_TimeOnBlock as FC.Field;
  private var oFitField_FlightTime as FC.Field;
  private var oFitField_BlockTime as FC.Field;
  // ... session
  private var oFitField_TotalFlightTime as FC.Field;
  private var oFitField_TotalBlockTime as FC.Field;

  // Data
  public var iDataMask as Number = 0;


  //
  // FUNCTIONS: self
  //

  function initialize() {
    //Sys.println("DEBUG: MyActivity.initialize()");

    // Session (recording)
    // SPORT_FLYING = 20 (since API 3.0.10)
    oSession = AR.createSession({
        :name => "TowplaneSK",
        :sport => 20 as AR.Sport2,
        :subSport => AR.SUB_SPORT_GENERIC});
    // ... internals
    oDurationFlight = new Time.Duration(0);
    oDurationBlock = new Time.Duration(0);

    // FIT fields

    // ... (unit conversion) coefficients
    bUnitCoefficient_TimeUTC = $.oMySettings.bUnitTimeUTC;
    fUnitCoefficient_Altitude = $.oMySettings.fUnitElevationCoefficient;
    fUnitCoefficient_VerticalSpeed = $.oMySettings.fUnitVerticalSpeedCoefficient;
    fUnitCoefficient_HorizontalSpeed = $.oMySettings.fUnitHorizontalSpeedCoefficient;

    // ... record
    oFitField_BarometricAltitude =
      oSession.createField("BarometricAltitude",
                           MyActivity.FITFIELD_BAROMETRICALTITUDE,
                           FC.DATA_TYPE_FLOAT,
                           {:mesgType => FC.MESG_TYPE_RECORD, :units => $.oMySettings.sUnitElevation});
    oFitField_VerticalSpeed =
      oSession.createField("VerticalSpeed",
                           MyActivity.FITFIELD_VERTICALSPEED,
                           FC.DATA_TYPE_FLOAT,
                           {:mesgType => FC.MESG_TYPE_RECORD, :units => $.oMySettings.sUnitVerticalSpeed});

    // ... lap
    oFitField_CallsignTowplane =
      oSession.createField("CallsignTowplane",
                           MyActivity.FITFIELD_CALLSIGNTOWPLANE,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9});
    oFitField_CallsignGlider =
      oSession.createField("CallsignGlider",
                           MyActivity.FITFIELD_CALLSIGNGLIDER,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9});
    oFitField_TimeOffBlock =
      oSession.createField("TimeOffBlock",
                           MyActivity.FITFIELD_TIMEOFFBLOCK,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9, :units => $.oMySettings.sUnitTime});
    oFitField_TimeTakeoff =
      oSession.createField("TimeTakeoff",
                           MyActivity.FITFIELD_TIMETAKEOFF,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9, :units => $.oMySettings.sUnitTime});
    oFitField_AltitudeTakeoff =
      oSession.createField("AltitudeTakeoff",
                           MyActivity.FITFIELD_ALTITUDETAKEOFF,
                           FC.DATA_TYPE_FLOAT,
                           {:mesgType => FC.MESG_TYPE_LAP, :units => $.oMySettings.sUnitElevation});
    oFitField_TimeTopOfClimb =
      oSession.createField("TimeTopOfClimb",
                           MyActivity.FITFIELD_TIMETOPOFCLIMB,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9, :units => $.oMySettings.sUnitTime});
    oFitField_AltitudeTopOfClimb =
      oSession.createField("AltitudeTopOfClimb",
                           MyActivity.FITFIELD_ALTITUDETOPOFCLIMB,
                           FC.DATA_TYPE_FLOAT,
                           {:mesgType => FC.MESG_TYPE_LAP, :units => $.oMySettings.sUnitElevation});
    oFitField_CountCycles =
      oSession.createField("CountCycles",
                           MyActivity.FITFIELD_COUNTCYCLES,
                           FC.DATA_TYPE_UINT16,
                           {:mesgType => FC.MESG_TYPE_LAP});
    oFitField_TimeLanding =
      oSession.createField("TimeLanding",
                           MyActivity.FITFIELD_TIMELANDING,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9, :units => $.oMySettings.sUnitTime});
    oFitField_AltitudeLanding =
      oSession.createField("AltitudeLanding",
                           MyActivity.FITFIELD_ALTITUDELANDING,
                           FC.DATA_TYPE_FLOAT,
                           {:mesgType => FC.MESG_TYPE_LAP, :units => $.oMySettings.sUnitElevation});
    oFitField_TimeOnBlock =
      oSession.createField("TimeOnBlock",
                           MyActivity.FITFIELD_TIMEONBLOCK,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9, :units => $.oMySettings.sUnitTime});
    oFitField_FlightTime =
      oSession.createField("FlightTime",
                           MyActivity.FITFIELD_FLIGHTTIME,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9});
    oFitField_BlockTime =
      oSession.createField("BlockTime",
                           MyActivity.FITFIELD_BLOCKTIME,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_LAP, :count => 9});
    self.resetLapFields();

    // ... session
    oFitField_TotalFlightTime =
      oSession.createField("TotalFlightTime",
                           MyActivity.FITFIELD_TOTALFLIGHTTIME,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_SESSION, :count => 9});
    oFitField_TotalBlockTime =
      oSession.createField("TotalBlockTime",
                           MyActivity.FITFIELD_TOTALBLOCKTIME,
                           FC.DATA_TYPE_STRING,
                           {:mesgType => FC.MESG_TYPE_SESSION, :count => 9});
  }


  //
  // FUNCTIONS: self (session)
  //

  function start() as Void {
    //Sys.println("DEBUG: MyActivity.start()");

    self.oSession.start();
    if(Toybox.Attention has :playTone) {
      Attn.playTone(Attn.TONE_START);
    }
  }

  function isRecording() as Boolean {
    //Sys.println("DEBUG: MyActivity.isRecording()");

    return self.oSession.isRecording();
  }

  function addLap() as Void {
    //Sys.println("DEBUG: MyActivity.lap()");

    self.oSession.addLap();
    if(self.oSession.isRecording() and Toybox.Attention has :playTone) {
      Attn.playTone(Attn.TONE_LAP);
    }
    self.resetLapFields();
  }

  function pause() as Void {
    //Sys.println("DEBUG: MyActivity.pause()");

    if(!self.oSession.isRecording()) {
      return;
    }
    self.oSession.stop();
    if(Toybox.Attention has :playTone) {
      Attn.playTone(Attn.TONE_STOP);
    }
  }

  function resume() as Void {
    //Sys.println("DEBUG: MyActivity.resume()");

    if(self.oSession.isRecording()) {
      return;
    }
    self.oSession.start();
    if(Toybox.Attention has :playTone) {
      Attn.playTone(Attn.TONE_START);
    }
  }

  function stop(_bSave as Boolean) as Void {
    //Sys.println(format("DEBUG: MyActivity.stop($1$)", [_bSave]));

    if(self.oSession.isRecording()) {
      self.oSession.stop();
    }
    if(_bSave) {
      self.oFitField_TotalFlightTime.setData(LangUtils.formatElapsedDuration(self.oDurationFlight, true));
      self.oFitField_TotalBlockTime.setData(LangUtils.formatElapsedDuration(self.oDurationBlock, true));
      self.oSession.save();
      if(Toybox.Attention has :playTone) {
        Attn.playTone(Attn.TONE_STOP);
      }
    }
    else {
      self.oSession.discard();
      if(Toybox.Attention has :playTone) {
        Attn.playTone(Attn.TONE_RESET);
      }
    }
  }


  //
  // FUNCTIONS: self (fields)
  //

  // Record

  function setBarometricAltitude(_fValue as Float?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setBarometricAltitude($1$)", [_fValue]));
    if(_fValue != null and LangUtils.notNaN(_fValue)) {
      self.oFitField_BarometricAltitude.setData(_fValue * self.fUnitCoefficient_Altitude);
    }
  }

  function setVerticalSpeed(_fValue as Float?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setVerticalSpeed($1$)", [_fValue]));
    if(_fValue != null and LangUtils.notNaN(_fValue)) {
      self.oFitField_VerticalSpeed.setData(_fValue * self.fUnitCoefficient_VerticalSpeed);
    }
  }

  // Lap

  function resetLapFields() as Void {
    self.iDataMask = 0;
    self.setCallsignTowplane(null);
    self.setCallsignGlider(null);
    self.setTimeOffBlock(null);
    self.setTimeTakeoff(null);
    self.setAltitudeTakeoff(null);
    self.setTimeTopOfClimb(null);
    self.setAltitudeTopOfClimb(null);
    self.setCountCycles(null);
    self.setTimeLanding(null);
    self.setAltitudeLanding(null);
    self.setTimeOnBlock(null);
    self.setFlightTime(null);
    self.setBlockTime(null);
  }

  function setCallsignTowplane(_sValue as String?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setCallsignTowplane($1$)", [_sValue]));
    self.oFitField_CallsignTowplane.setData(_sValue != null ? _sValue.substring(0, 8) as String : "-");
    if(_sValue != null) {
      self.iDataMask |= MyActivity.DATA_CALLSIGNTOWPLANE;
    }
  }

  function setCallsignGlider(_sValue as String?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setCallsignGlider($1$)", [_sValue]));
    self.oFitField_CallsignGlider.setData(_sValue != null ? _sValue.substring(0, 8) as String : "-");
    if(_sValue != null) {
      self.iDataMask |= MyActivity.DATA_CALLSIGNGLIDER;
    }
  }

  function setTimeOffBlock(_oTime as Time.Moment?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setTimeOffBlock($1$)", [_oTime.value()]));
    self.oFitField_TimeOffBlock.setData(LangUtils.formatTime(_oTime, $.oMySettings.bUnitTimeUTC, true));
    if(_oTime != null) {
      self.iDataMask |= MyActivity.DATA_TIMEOFFBLOCK;
    }
  }

  function setTimeTakeoff(_oTime as Time.Moment?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setTimeTakeoff($1$)", [_oTime.value()]));
    self.oFitField_TimeTakeoff.setData(LangUtils.formatTime(_oTime, $.oMySettings.bUnitTimeUTC, true));
    if(_oTime != null) {
      self.iDataMask |= MyActivity.DATA_TIMETAKEOFF;
    }
  }

  function setAltitudeTakeoff(_fValue as Float?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setAltitudeTakeoff($1$)", [_fValue]));
    self.oFitField_AltitudeTakeoff.setData(_fValue != null and LangUtils.notNaN(_fValue) ? _fValue * self.fUnitCoefficient_Altitude : 0.0f);
    if(LangUtils.notNaN(_fValue)) {
      self.iDataMask |= MyActivity.DATA_ALTITUDETAKEOFF;
    }
  }

  function setTimeTopOfClimb(_oTime as Time.Moment?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setTimeTopOfClimb($1$)", [_oTime.value()]));
    self.oFitField_TimeTopOfClimb.setData(LangUtils.formatTime(_oTime, $.oMySettings.bUnitTimeUTC, true));
    if(_oTime != null) {
      self.iDataMask |= MyActivity.DATA_TIMETOPOFCLIMB;
    }
  }

  function setAltitudeTopOfClimb(_fValue as Float?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setAltitudeTopOfClimb($1$)", [_fValue]));
    if(_fValue != null and LangUtils.notNaN(_fValue)) {
      self.oFitField_AltitudeTopOfClimb.setData(_fValue * self.fUnitCoefficient_Altitude);
      self.iDataMask |= MyActivity.DATA_ALTITUDETOPOFCLIMB;
    }
  }

  function setCountCycles(_iValue as Number?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setCountCycles($1$)", [_iValue]));
    self.oFitField_CountCycles.setData(_iValue != null ? _iValue : 0);
    if(_iValue != null) {
      self.iDataMask |= MyActivity.DATA_COUNTCYCLES;
    }
  }

  function setTimeLanding(_oTime as Time.Moment?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setTimeLanding($1$)", [_oTime.value()]));
    self.oFitField_TimeLanding.setData(LangUtils.formatTime(_oTime, $.oMySettings.bUnitTimeUTC, true));
    if(_oTime != null) {
      self.iDataMask |= MyActivity.DATA_TIMELANDING;
    }
  }

  function setAltitudeLanding(_fValue as Float?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setAltitudeLanding($1$)", [_fValue]));
    self.oFitField_AltitudeLanding.setData(_fValue != null and LangUtils.notNaN(_fValue) ? _fValue * self.fUnitCoefficient_Altitude : 0.0f);
    if(LangUtils.notNaN(_fValue)) {
      self.iDataMask |= MyActivity.DATA_ALTITUDELANDING;
    }
  }

  function setTimeOnBlock(_oTime as Time.Moment?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setTimeOnBlock($1$)", [_oTime.value()]));
    self.oFitField_TimeOnBlock.setData(LangUtils.formatTime(_oTime, $.oMySettings.bUnitTimeUTC, true));
    if(_oTime != null) {
      self.iDataMask |= MyActivity.DATA_TIMEONBLOCK;
    }
  }

  function setFlightTime(_oDuration as Time.Duration?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setFlightTime($1$)", [_oDuration.value()]));
    self.oFitField_FlightTime.setData(LangUtils.formatElapsedDuration(_oDuration, true));
    if(_oDuration != null) {
      self.oDurationFlight = self.oDurationFlight.add(_oDuration) as Time.Duration;
      self.iDataMask |= MyActivity.DATA_FLIGHTTIME;
    }
  }

  function setBlockTime(_oDuration as Time.Duration?) as Void {
    //Sys.println(format("DEBUG: MyActivity.setBlockTime($1$)", [_oDuration.value()]));
    self.oFitField_BlockTime.setData(LangUtils.formatElapsedDuration(_oDuration, true));
    if(_oDuration != null) {
      self.oDurationBlock = self.oDurationBlock.add(_oDuration) as Time.Duration;
      self.iDataMask |= MyActivity.DATA_BLOCKTIME;
    }
  }

  function hasLapData(_bStateful as Boolean) as Boolean {
    if(_bStateful) {
      //return self.iDataMask & MyActivity.DATA_STATEFUL ^ MyActivity.DATA_STATEFUL == 0;  // ERROR: Unsupported operation xor (WTF!?!)
      var i = self.iDataMask & MyActivity.DATA_STATEFUL;
      return i & ~MyActivity.DATA_STATEFUL | ~i & MyActivity.DATA_STATEFUL == 0;
    }
    else {
      return self.iDataMask != 0;
    }
  }

}
