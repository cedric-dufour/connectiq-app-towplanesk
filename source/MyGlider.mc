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

import Toybox.Lang;
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
  public var sCallsign as String = "A21";  // short for ASK21
  // ... weight
  public var fWeightEmpty as Float = 360.0f;
  public var fWeightPayload as Float = 80.0f;
  public var fWeightBallast as Float = 0.0f;
  public var fWeightTotal as Float = 440.0f;
  public var fWeightMaxTakeoff as Float = 600.0f;
  // ... speed
  public var fSpeedTowing as Float = 31.94f;  // 115km/h


  //
  // FUNCTIONS: self
  //

  function load(_dictGlider as Dictionary?) as Void {
    if(_dictGlider == null) {
      _dictGlider = {};
    }
    // Parameters
    self.setCallsign(_dictGlider.get("callsign") as String);
    // ... weight
    self.setWeightEmpty(_dictGlider.get("weightEmpty") as Float);
    self.setWeightPayload(_dictGlider.get("weightPayload") as Float);
    self.setWeightBallast(_dictGlider.get("weightBallast") as Float);
    self.setWeightMaxTakeoff(_dictGlider.get("weightMaxTakeoff") as Float);
    // ... speed
    self.setSpeedTowing(_dictGlider.get("speedTowing") as Float);
  }

  function export() as Dictionary {
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

  function setCallsign(_sValue as String?) as Void {
    if(_sValue == null) {
      _sValue = "A21";  // short for ASK21
    }
    self.sCallsign = _sValue;
  }

  function setWeightEmpty(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 360.0f;
    }
    else if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWeightEmpty = _fValue;
    self.updateWeightTotal();
  }

  function setWeightPayload(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 80.0f;
    }
    else if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWeightPayload = _fValue;
    self.updateWeightTotal();
  }

  function setWeightBallast(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 0.0f;
    }
    else if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWeightBallast = _fValue;
    self.updateWeightTotal();
  }

  function setWeightMaxTakeoff(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 600.0f;
    }
    else if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWeightMaxTakeoff = _fValue;
  }

  function setSpeedTowing(_fValue as Float?) as Void {  // [m/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 31.94f;  // 115 km/h
    }
    else if(_fValue > 99.0f) {
      _fValue = 99.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fSpeedTowing = _fValue;
  }

  function updateWeightTotal() as Void {
    self.fWeightTotal =
      self.fWeightEmpty
      + self.fWeightPayload
      + self.fWeightBallast;
  }

}
