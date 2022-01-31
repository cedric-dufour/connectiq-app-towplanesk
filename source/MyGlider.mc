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
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// CLASS
//

class MyGlider {

  //
  // VARIABLES
  //

  // Parameters
  public var sCallsign;
  // ... weight
  public var fWeightEmpty;
  public var fWeightPayload;
  public var fWeightBallast;
  public var fWeightTotal;
  public var fWeightMaxTakeoff;
  // ... speed
  public var fSpeedTowing;


  //
  // FUNCTIONS: self
  //

  function initialize(_dictGlider) {
    self.import(_dictGlider);
  }

  function import(_dictGlider) {
    if(!(_dictGlider instanceof Lang.Dictionary)) {
      _dictGlider = {};
    }
    // Parameters
    self.setCallsign(_dictGlider.get("callsign"));
    // ... weight
    self.setWeightEmpty(_dictGlider.get("weightEmpty"));
    self.setWeightPayload(_dictGlider.get("weightPayload"));
    self.setWeightBallast(_dictGlider.get("weightBallast"));
    self.setWeightMaxTakeoff(_dictGlider.get("weightMaxTakeoff"));
    // ... speed
    self.setSpeedTowing(_dictGlider.get("speedTowing"));
  }

  function export() {
    var dictGlider = {
      "callsign" => self.sCallsign,
      "weightEmpty" => self.fWeightEmpty,
      "weightPayload" => self.fWeightPayload,
      "weightBallast" => self.fWeightBallast,
      "weightMaxTakeoff" => self.fWeightMaxTakeoff,
      "speedTowing" => self.fSpeedTowing
    };
    return dictGlider;
  }

  function setCallsign(_sCallsign) {
    if(_sCallsign == null) {
      _sCallsign = "A21";  // short for ASK21
    }
    self.sCallsign = _sCallsign;
  }

  function setWeightEmpty(_fWeightEmpty) {  // [kg]
    if(_fWeightEmpty == null) {
      _fWeightEmpty = 360.0f;
    }
    else if(_fWeightEmpty > 9999.0f) {
      _fWeightEmpty = 9999.0f;
    }
    else if(_fWeightEmpty < 0.0f) {
      _fWeightEmpty = 0.0f;
    }
    self.fWeightEmpty = _fWeightEmpty;
    self.updateWeightTotal();
  }

  function setWeightPayload(_fWeightPayload) {  // [kg]
    if(_fWeightPayload == null) {
      _fWeightPayload = 80.0f;
    }
    else if(_fWeightPayload > 9999.0f) {
      _fWeightPayload = 9999.0f;
    }
    else if(_fWeightPayload < 0.0f) {
      _fWeightPayload = 0.0f;
    }
    self.fWeightPayload = _fWeightPayload;
    self.updateWeightTotal();
  }

  function setWeightBallast(_fWeightBallast) {  // [kg]
    if(_fWeightBallast == null) {
      _fWeightBallast = 0.0f;
    }
    else if(_fWeightBallast > 9999.0f) {
      _fWeightBallast = 9999.0f;
    }
    else if(_fWeightBallast < 0.0f) {
      _fWeightBallast = 0.0f;
    }
    self.fWeightBallast = _fWeightBallast;
    self.updateWeightTotal();
  }

  function setWeightMaxTakeoff(_fWeightMaxTakeoff) {  // [kg]
    if(_fWeightMaxTakeoff == null) {
      _fWeightMaxTakeoff = 600.0f;
    }
    else if(_fWeightMaxTakeoff > 9999.0f) {
      _fWeightMaxTakeoff = 9999.0f;
    }
    else if(_fWeightMaxTakeoff < 0.0f) {
      _fWeightMaxTakeoff = 0.0f;
    }
    self.fWeightMaxTakeoff = _fWeightMaxTakeoff;
  }

  function setSpeedTowing(_fSpeedTowing) {  // [m/s]
    if(_fSpeedTowing == null) {
      _fSpeedTowing = 31.94f;  // 115 km/h
    }
    else if(_fSpeedTowing > 99.0f) {
      _fSpeedTowing = 99.0f;
    }
    else if(_fSpeedTowing < 0.0f) {
      _fSpeedTowing = 0.0f;
    }
    self.fSpeedTowing = _fSpeedTowing;
  }

  function updateWeightTotal() {
    var fValue = 0.0f;
    if(self.fWeightEmpty != null) {
      fValue += self.fWeightEmpty;
    }
    if(self.fWeightPayload != null) {
      fValue += self.fWeightPayload;
    }
    if(self.fWeightBallast != null) {
      fValue += self.fWeightBallast;
    }
    self.fWeightTotal = fValue;
  }

}
