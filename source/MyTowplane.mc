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

class MyTowplane {

  //
  // VARIABLES
  //

  // Parameters
  public var sCallsign as String = "P18";  // short for PA18
  // ... weight
  public var fWeightEmpty as Float = 525.0f;
  public var fWeightPayload as Float = 80.0f;
  public var fWeightTotal as Float = 702.335f;
  public var fWeightMaxTakeoff as Float = 793.79f;  // 1750 lbs
  public var fWeightMaxTowing as Float = 720.0f;
  public var fWeightMaxTowed as Float = 650.0f;
  // ... fuel
  public var fFuelQuantity as Float = 0.135f;
  public var fFuelDensity as Float = 721.0f;
  public var fFuelFlowGround as Float = 0.000001389f;  // 5.0 [l/h]
  public var fFuelFlowAirborne as Float = 0.000009722f;  // 35.0 [l/h]
  public var fFuelFlowTowing as Float = 0.000011111f;  // 40.0 [l/h]
  public var fFuelAlert as Float = 0.055f;
  // ... speed
  public var fSpeedOffBlock as Float = 1.39f;  // 5 km/h
  public var fSpeedTakeoff as Float = 20.92f;  // 47 mph
  public var fSpeedLanding as Float = 19.14f;  // 43 mph
  public var fSpeedMaxTowing as Float = 41.67f;  // 150 km/h


  //
  // FUNCTIONS: self
  //

  function load(_dictTowplane as Dictionary?) as Void {
    if(_dictTowplane == null) {
      _dictTowplane = {};
    }
    // Parameters
    self.setCallsign(_dictTowplane.get("callsign") as String);
    // ... weight
    self.setWeightEmpty(_dictTowplane.get("weightEmpty") as Float);
    self.setWeightPayload(_dictTowplane.get("weightPayload") as Float);
    self.setWeightMaxTakeoff(_dictTowplane.get("weightMaxTakeoff") as Float);
    self.setWeightMaxTowing(_dictTowplane.get("weightMaxTowing") as Float);
    self.setWeightMaxTowed(_dictTowplane.get("weightMaxTowed") as Float);
    // ... fuel
    self.setFuelQuantity(_dictTowplane.get("fuelQuantity") as Float);
    self.setFuelDensity(_dictTowplane.get("fuelDensity") as Float);
    self.setFuelFlowGround(_dictTowplane.get("fuelFlowGround") as Float);
    self.setFuelFlowAirborne(_dictTowplane.get("fuelFlowAirborne") as Float);
    self.setFuelFlowTowing(_dictTowplane.get("fuelFlowTowing") as Float);
    self.setFuelAlert(_dictTowplane.get("fuelAlert") as Float);
    // ... speed
    self.setSpeedOffBlock(_dictTowplane.get("speedOffBlock") as Float);
    self.setSpeedTakeoff(_dictTowplane.get("speedTakeoff") as Float);
    self.setSpeedLanding(_dictTowplane.get("speedLanding") as Float);
    self.setSpeedMaxTowing(_dictTowplane.get("speedMaxTowing") as Float);
  }

  function export() as Dictionary {
    var dictTowplane = {
      "callsign" => self.sCallsign,
      "weightEmpty" => self.fWeightEmpty,
      "weightPayload" => self.fWeightPayload,
      "weightMaxTakeoff" => self.fWeightMaxTakeoff,
      "weightMaxTowing" => self.fWeightMaxTowing,
      "weightMaxTowed" => self.fWeightMaxTowed,
      "fuelQuantity" => self.fFuelQuantity,
      "fuelDensity" => self.fFuelDensity,
      "fuelFlowGround" => self.fFuelFlowGround,
      "fuelFlowAirborne" => self.fFuelFlowAirborne,
      "fuelFlowTowing" => self.fFuelFlowTowing,
      "fuelAlert" => self.fFuelAlert,
      "speedOffBlock" => self.fSpeedOffBlock,
      "speedTakeoff" => self.fSpeedTakeoff,
      "speedLanding" => self.fSpeedLanding,
      "speedMaxTowing" => self.fSpeedMaxTowing
    };
    return dictTowplane;
  }

  function setCallsign(_sValue as String?) as Void {
    if(_sValue == null) {
      _sValue = "P18";  // short for PA18
    }
    self.sCallsign = _sValue;
  }

  function setWeightEmpty(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 525.0f;
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

  function setWeightMaxTakeoff(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 793.79f;  // 1750 lbs
    }
    else if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWeightMaxTakeoff = _fValue;
  }

  function setWeightMaxTowing(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 720.0f;
    }
    else if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWeightMaxTowing = _fValue;
  }

  function setWeightMaxTowed(_fValue as Float?) as Void {  // [kg]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 650.0f;
    }
    else if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWeightMaxTowed = _fValue;
  }

  function setFuelQuantity(_fValue as Float?) as Void {  // [m3]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 0.135f;
    }
    else if(_fValue > 1.0f) {
      _fValue = 1.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fFuelQuantity = _fValue;
    self.updateWeightTotal();
  }

  function setFuelDensity(_fValue as Float?) as Void {  // [kg/m3]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 721.0f;
    }
    else if(_fValue > 1000.0f) {
      _fValue = 1000.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fFuelDensity = _fValue;
    self.updateWeightTotal();
  }

  function setFuelFlowGround(_fValue as Float?) as Void {  // [m3/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 0.000001389f;  // 5.0 [l/h]
    }
    else if(_fValue > 0.001f) {
      _fValue = 0.001f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fFuelFlowGround = _fValue;
  }

  function setFuelFlowAirborne(_fValue as Float?) as Void {  // [m3/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 0.000009722f;  // 35.0 [l/h]
    }
    else if(_fValue > 0.001f) {
      _fValue = 0.001f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fFuelFlowAirborne = _fValue;
  }

  function setFuelFlowTowing(_fValue as Float?) as Void {  // [m3/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 0.000011111f;  // 40.0 [l/h]
    }
    else if(_fValue > 0.001f) {
      _fValue = 0.001f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fFuelFlowTowing = _fValue;
  }

  function setFuelAlert(_fValue as Float?) as Void {  // [m3]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 0.055f;
    }
    else if(_fValue > 0.999f) {
      _fValue = 0.999f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fFuelAlert = _fValue;
  }

  function setSpeedOffBlock(_fValue as Float?) as Void {  // [m/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 1.39f;  // 5 km/h
    }
    else if(_fValue > 99.0f) {
      _fValue = 99.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fSpeedOffBlock = _fValue;
  }

  function setSpeedTakeoff(_fValue as Float?) as Void {  // [m/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 20.92f;  // 47 mph
    }
    else if(_fValue > 99.0f) {
      _fValue = 99.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fSpeedTakeoff = _fValue;
  }

  function setSpeedLanding(_fValue as Float?) as Void {  // [m/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 19.14f;  // 43 mph
    }
    else if(_fValue > 99.0f) {
      _fValue = 99.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fSpeedLanding = _fValue;
  }

  function setSpeedMaxTowing(_fValue as Float?) as Void {  // [m/s]
    if(_fValue == null or LangUtils.isNaN(_fValue)) {
      _fValue = 41.67f;  // 150 km/h
    }
    else if(_fValue > 99.0f) {
      _fValue = 99.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fSpeedMaxTowing = _fValue;
  }

  function updateWeightTotal() as Void {
    self.fWeightTotal =
      self.fWeightEmpty
      + self.fWeightPayload
      + self.fFuelQuantity * self.fFuelDensity;
  }

}
