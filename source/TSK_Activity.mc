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

using Toybox.Activity;
using Toybox.ActivityRecording as AR;
using Toybox.Attention as Attn;
using Toybox.FitContributor as FC;
using Toybox.Time;

//
// CLASS
//

class TSK_Activity {

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


  //
  // VARIABLES
  //

  // Session (recording)
  private var oSession;
  // ... internals
  private var oDurationFlight;
  private var oDurationBlock;

  // FIT fields
  // ... (unit conversion) coefficients
  private var bUnitCoefficient_TimeUTC = false;
  private var fUnitCoefficient_Altitude = 1.0f;
  private var fUnitCoefficient_VerticalSpeed = 1.0f;
  private var fUnitCoefficient_HorizontalSpeed = 1.0f;
  // ... record
  private var oFitField_BarometricAltitude = null;
  private var oFitField_VerticalSpeed = null;
  // ... lap
  private var oFitField_CallsignTowplane = null;
  private var oFitField_CallsignGlider = null;
  private var oFitField_TimeOffBlock = null;
  private var oFitField_TimeTakeoff = null;
  private var oFitField_AltitudeTakeoff = null;
  private var oFitField_TimeTopOfClimb = null;
  private var oFitField_AltitudeTopOfClimb = null;
  private var oFitField_CountCycles = null;
  private var oFitField_TimeLanding = null;
  private var oFitField_AltitudeLanding = null;
  private var oFitField_TimeOnBlock = null;
  private var oFitField_FlightTime = null;
  private var oFitField_BlockTime = null;
  // ... session
  private var oFitField_TotalFlightTime = null;
  private var oFitField_TotalBlockTime = null;


  //
  // FUNCTIONS: self
  //

  function initialize() {
    //Sys.println("DEBUG: TSK_Activity.initialize()");

    // Session (recording)
    // NOTE: "Flying" activity number is 20 (cf. https://www.thisisant.com/resources/fit -> Profiles.xlsx)
    self.oSession = AR.createSession({ :name=>"TowplaneSK", :sport=>20, :subSport=>AR.SUB_SPORT_GENERIC });
    // ... internals
    self.oDurationFlight = new Time.Duration(0);
    self.oDurationBlock = new Time.Duration(0);

    // FIT fields

    // ... (unit conversion) coefficients
    self.bUnitCoefficient_TimeUTC = $.TSK_oSettings.bUnitTimeUTC;
    self.fUnitCoefficient_Altitude = $.TSK_oSettings.fUnitElevationCoefficient;
    self.fUnitCoefficient_VerticalSpeed = $.TSK_oSettings.fUnitVerticalSpeedCoefficient;
    self.fUnitCoefficient_HorizontalSpeed = $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;

    // ... record
    self.oFitField_BarometricAltitude = self.oSession.createField("BarometricAltitude", TSK_Activity.FITFIELD_BAROMETRICALTITUDE, FC.DATA_TYPE_FLOAT, { :mesgType=>FC.MESG_TYPE_RECORD, :units=>$.TSK_oSettings.sUnitElevation });
    self.oFitField_VerticalSpeed = self.oSession.createField("VerticalSpeed", TSK_Activity.FITFIELD_VERTICALSPEED, FC.DATA_TYPE_FLOAT, { :mesgType=>FC.MESG_TYPE_RECORD, :units=>$.TSK_oSettings.sUnitVerticalSpeed });

    // ... lap
    self.oFitField_CallsignTowplane = self.oSession.createField("CallsignTowplane", TSK_Activity.FITFIELD_CALLSIGNTOWPLANE, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9 });
    self.oFitField_CallsignGlider = self.oSession.createField("CallsignGlider", TSK_Activity.FITFIELD_CALLSIGNGLIDER, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9 });
    self.oFitField_TimeOffBlock = self.oSession.createField("TimeOffBlock", TSK_Activity.FITFIELD_TIMEOFFBLOCK, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9, :units=>$.TSK_oSettings.sUnitTime });
    self.oFitField_TimeTakeoff = self.oSession.createField("TimeTakeoff", TSK_Activity.FITFIELD_TIMETAKEOFF, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9, :units=>$.TSK_oSettings.sUnitTime });
    self.oFitField_AltitudeTakeoff = self.oSession.createField("AltitudeTakeoff", TSK_Activity.FITFIELD_ALTITUDETAKEOFF, FC.DATA_TYPE_FLOAT, { :mesgType=>FC.MESG_TYPE_LAP, :units=>$.TSK_oSettings.sUnitElevation });
    self.oFitField_TimeTopOfClimb = self.oSession.createField("TimeTopOfClimb", TSK_Activity.FITFIELD_TIMETOPOFCLIMB, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9, :units=>$.TSK_oSettings.sUnitTime });
    self.oFitField_AltitudeTopOfClimb = self.oSession.createField("AltitudeTopOfClimb", TSK_Activity.FITFIELD_ALTITUDETOPOFCLIMB, FC.DATA_TYPE_FLOAT, { :mesgType=>FC.MESG_TYPE_LAP, :units=>$.TSK_oSettings.sUnitElevation });
    self.oFitField_CountCycles = self.oSession.createField("CountCycles", TSK_Activity.FITFIELD_COUNTCYCLES, FC.DATA_TYPE_UINT16, { :mesgType=>FC.MESG_TYPE_LAP });
    self.oFitField_TimeLanding = self.oSession.createField("TimeLanding", TSK_Activity.FITFIELD_TIMELANDING, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9, :units=>$.TSK_oSettings.sUnitTime });
    self.oFitField_AltitudeLanding = self.oSession.createField("AltitudeLanding", TSK_Activity.FITFIELD_ALTITUDELANDING, FC.DATA_TYPE_FLOAT, { :mesgType=>FC.MESG_TYPE_LAP, :units=>$.TSK_oSettings.sUnitElevation });
    self.oFitField_TimeOnBlock = self.oSession.createField("TimeOnBlock", TSK_Activity.FITFIELD_TIMEONBLOCK, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9, :units=>$.TSK_oSettings.sUnitTime });
    self.oFitField_FlightTime = self.oSession.createField("FlightTime", TSK_Activity.FITFIELD_FLIGHTTIME, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9 });
    self.oFitField_BlockTime = self.oSession.createField("BlockTime", TSK_Activity.FITFIELD_BLOCKTIME, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_LAP, :count=>9 });
    self.resetLapFields();

    // ... session
    self.oFitField_TotalFlightTime = self.oSession.createField("TotalFlightTime", TSK_Activity.FITFIELD_TOTALFLIGHTTIME, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_SESSION, :count=>9 });
    self.oFitField_TotalBlockTime = self.oSession.createField("TotalBlockTime", TSK_Activity.FITFIELD_TOTALBLOCKTIME, FC.DATA_TYPE_STRING, { :mesgType=>FC.MESG_TYPE_SESSION, :count=>9 });
  }


  //
  // FUNCTIONS: self (session)
  //

  function start() {
    //Sys.println("DEBUG: TSK_Activity.start()");

    self.oSession.start();
    if(Attn has :playTone) {
      Attn.playTone(Attn.TONE_START);
    }
  }

  function isRecording() {
    //Sys.println("DEBUG: TSK_Activity.isRecording()");

    return self.oSession.isRecording();
  }

  function addLap() {
    //Sys.println("DEBUG: TSK_Activity.lap()");

    self.oSession.addLap();
    if(Attn has :playTone) {
      Attn.playTone(Attn.TONE_LAP);
    }
    self.resetLapFields();
  }

  function pause() {
    //Sys.println("DEBUG: TSK_Activity.pause()");

    if(!self.oSession.isRecording()) {
      return;
    }
    self.oSession.stop();
    if(Attn has :playTone) {
      Attn.playTone(Attn.TONE_STOP);
    }
  }

  function resume() {
    //Sys.println("DEBUG: TSK_Activity.resume()");

    if(self.oSession.isRecording()) {
      return;
    }
    self.oSession.start();
    if(Attn has :playTone) {
      Attn.playTone(Attn.TONE_START);
    }
  }

  function stop(_bSave) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.stop($1$)", [_bSave]));

    if(self.oSession.isRecording()) {
      self.oSession.stop();
    }
    if(_bSave) {
      self.oFitField_TotalFlightTime.setData(LangUtils.formatElapsedDuration(self.oDurationFlight, true));
      self.oFitField_TotalBlockTime.setData(LangUtils.formatElapsedDuration(self.oDurationBlock, true));
      self.oSession.save();
      if(Attn has :playTone) {
        Attn.playTone(Attn.TONE_STOP);
      }
    }
    else {
      self.oSession.discard();
      if(Attn has :playTone) {
        Attn.playTone(Attn.TONE_RESET);
      }
    }
  }


  //
  // FUNCTIONS: self (fields)
  //

  // Record

  function setBarometricAltitude(_fValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setBarometricAltitude($1$)", [_fValue]));
    if(_fValue != null) {
      self.oFitField_BarometricAltitude.setData(_fValue * self.fUnitCoefficient_Altitude);
    }
  }

  function setVerticalSpeed(_fValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setVerticalSpeed($1$)", [_fValue]));
    if(_fValue != null) {
      self.oFitField_VerticalSpeed.setData(_fValue * self.fUnitCoefficient_VerticalSpeed);
    }
  }

  // Lap

  function resetLapFields() {
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

  function setCallsignTowplane(_sValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setCallsignTowplane($1$)", [_sValue]));
    self.oFitField_CallsignTowplane.setData(_sValue != null ? _sValue.substring(0, 8) : "-");
  }

  function setCallsignGlider(_sValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setCallsignGlider($1$)", [_sValue]));
    self.oFitField_CallsignGlider.setData(_sValue != null ? _sValue.substring(0, 8) : "-");
  }

  function setTimeOffBlock(_oTime) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setTimeOffBlock($1$)", [_oTime.value()]));
    self.oFitField_TimeOffBlock.setData(LangUtils.formatTime(_oTime, $.TSK_oSettings.bUnitTimeUTC, true));
  }

  function setTimeTakeoff(_oTime) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setTimeTakeoff($1$)", [_oTime.value()]));
    self.oFitField_TimeTakeoff.setData(LangUtils.formatTime(_oTime, $.TSK_oSettings.bUnitTimeUTC, true));
  }

  function setAltitudeTakeoff(_fValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setAltitudeTakeoff($1$)", [_fValue]));
    self.oFitField_AltitudeTakeoff.setData(_fValue != null ? _fValue * self.fUnitCoefficient_Altitude : 0.0f);
  }

  function setTimeTopOfClimb(_oTime) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setTimeTopOfClimb($1$)", [_oTime.value()]));
    self.oFitField_TimeTopOfClimb.setData(LangUtils.formatTime(_oTime, $.TSK_oSettings.bUnitTimeUTC, true));
  }

  function setAltitudeTopOfClimb(_fValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setAltitudeTopOfClimb($1$)", [_fValue]));
    if(_fValue != null) {
      self.oFitField_AltitudeTopOfClimb.setData(_fValue * self.fUnitCoefficient_Altitude);
    }
  }

  function setCountCycles(_iValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setCountCycles($1$)", [_iValue]));
    self.oFitField_CountCycles.setData(_iValue != null ? _iValue : 0);
  }

  function setTimeLanding(_oTime) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setTimeLanding($1$)", [_oTime.value()]));
    self.oFitField_TimeLanding.setData(LangUtils.formatTime(_oTime, $.TSK_oSettings.bUnitTimeUTC, true));
  }

  function setAltitudeLanding(_fValue) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setAltitudeLanding($1$)", [_fValue]));
    self.oFitField_AltitudeLanding.setData(_fValue != null ? _fValue * self.fUnitCoefficient_Altitude : 0.0f);
  }

  function setTimeOnBlock(_oTime) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setTimeOnBlock($1$)", [_oTime.value()]));
    self.oFitField_TimeOnBlock.setData(LangUtils.formatTime(_oTime, $.TSK_oSettings.bUnitTimeUTC, true));
  }

  function setFlightTime(_oDuration) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setFlightTime($1$)", [_oDuration.value()]));
    self.oFitField_FlightTime.setData(LangUtils.formatElapsedDuration(_oDuration, true));
    if(_oDuration != null) {
      self.oDurationFlight = self.oDurationFlight.add(_oDuration);
    }
  }

  function setBlockTime(_oDuration) {
    //Sys.println(Lang.format("DEBUG: TSK_Activity.setBlockTime($1$)", [_oDuration.value()]));
    self.oFitField_BlockTime.setData(LangUtils.formatElapsedDuration(_oDuration, true));
    if(_oDuration != null) {
      self.oDurationBlock = self.oDurationBlock.add(_oDuration);
    }
  }

}
