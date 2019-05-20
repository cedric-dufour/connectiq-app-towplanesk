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

class TSK_Towplane {

  //
  // VARIABLES
  //

  // Parameters
  public var sCallsign;
  // ... weight
  public var fWeightEmpty;
  public var fWeightPayload;
  public var fWeightTotal;
  public var fWeightMaxTakeoff;
  public var fWeightMaxTowing;
  public var fWeightMaxTowed;
  // ... fuel
  public var fFuelQuantity;
  public var fFuelDensity;
  public var fFuelFlowGround;
  public var fFuelFlowAirborne;
  public var fFuelFlowTowing;
  public var fFuelAlert;
  // ... speed
  public var fSpeedOffBlock;
  public var fSpeedTakeoff;
  public var fSpeedLanding;
  public var fSpeedMaxTowing;


  //
  // FUNCTIONS: self
  //

  function initialize(_dictTowplane) {
    self.import(_dictTowplane);
  }

  function import(_dictTowplane) {
    if(!(_dictTowplane instanceof Lang.Dictionary)) {
      _dictTowplane = {};
    }
    // Parameters
    self.setCallsign(_dictTowplane.get("callsign"));
    // ... weight
    self.setWeightEmpty(_dictTowplane.get("weightEmpty"));
    self.setWeightPayload(_dictTowplane.get("weightPayload"));
    self.setWeightMaxTakeoff(_dictTowplane.get("weightMaxTakeoff"));
    self.setWeightMaxTowing(_dictTowplane.get("weightMaxTowing"));
    self.setWeightMaxTowed(_dictTowplane.get("weightMaxTowed"));
    // ... fuel
    self.setFuelQuantity(_dictTowplane.get("fuelQuantity"));
    self.setFuelDensity(_dictTowplane.get("fuelDensity"));
    self.setFuelFlowGround(_dictTowplane.get("fuelFlowGround"));
    self.setFuelFlowAirborne(_dictTowplane.get("fuelFlowAirborne"));
    self.setFuelFlowTowing(_dictTowplane.get("fuelFlowTowing"));
    self.setFuelAlert(_dictTowplane.get("fuelAlert"));
    // ... speed
    self.setSpeedOffBlock(_dictTowplane.get("speedOffBlock"));
    self.setSpeedTakeoff(_dictTowplane.get("speedTakeoff"));
    self.setSpeedLanding(_dictTowplane.get("speedLanding"));
    self.setSpeedMaxTowing(_dictTowplane.get("speedMaxTowing"));
  }

  function export() {
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

  function setCallsign(_sCallsign) {
    if(_sCallsign == null) {
      _sCallsign = "P18";  // short for PA18, 180ch
    }
    self.sCallsign = _sCallsign;
  }

  function setWeightEmpty(_fWeightEmpty) {  // [kg]
    if(_fWeightEmpty == null) {
      _fWeightEmpty = 525.0f;
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

  function setWeightMaxTakeoff(_fWeightMaxTakeoff) {  // [kg]
    if(_fWeightMaxTakeoff == null) {
      _fWeightMaxTakeoff = 793.79f;  // 1750 lbs
    }
    else if(_fWeightMaxTakeoff > 9999.0f) {
      _fWeightMaxTakeoff = 9999.0f;
    }
    else if(_fWeightMaxTakeoff < 0.0f) {
      _fWeightMaxTakeoff = 0.0f;
    }
    self.fWeightMaxTakeoff = _fWeightMaxTakeoff;
  }

  function setWeightMaxTowing(_fWeightMaxTowing) {  // [kg]
    if(_fWeightMaxTowing == null) {
      _fWeightMaxTowing = 720.0f;
    }
    else if(_fWeightMaxTowing > 9999.0f) {
      _fWeightMaxTowing = 9999.0f;
    }
    else if(_fWeightMaxTowing < 0.0f) {
      _fWeightMaxTowing = 0.0f;
    }
    self.fWeightMaxTowing = _fWeightMaxTowing;
  }

  function setWeightMaxTowed(_fWeightMaxTowed) {  // [kg]
    if(_fWeightMaxTowed == null) {
      _fWeightMaxTowed = 650.0f;
    }
    else if(_fWeightMaxTowed > 9999.0f) {
      _fWeightMaxTowed = 9999.0f;
    }
    else if(_fWeightMaxTowed < 0.0f) {
      _fWeightMaxTowed = 0.0f;
    }
    self.fWeightMaxTowed = _fWeightMaxTowed;
  }

  function setFuelQuantity(_fFuelQuantity) {  // [m3]
    if(_fFuelQuantity == null) {
      _fFuelQuantity = 0.135f;
    }
    else if(_fFuelQuantity > 1.0f) {
      _fFuelQuantity = 1.0f;
    }
    else if(_fFuelQuantity < 0.0f) {
      _fFuelQuantity = 0.0f;
    }
    self.fFuelQuantity = _fFuelQuantity;
    self.updateWeightTotal();
  }

  function setFuelDensity(_fFuelDensity) {  // [kg/m3]
    if(_fFuelDensity == null) {
      _fFuelDensity = 721.0f;
    }
    else if(_fFuelDensity > 1000.0f) {
      _fFuelDensity = 1000.0f;
    }
    else if(_fFuelDensity < 0.0f) {
      _fFuelDensity = 0.0f;
    }
    self.fFuelDensity = _fFuelDensity;
    self.updateWeightTotal();
  }

  function setFuelFlowGround(_fFuelFlowGround) {  // [m3/s]
    if(_fFuelFlowGround == null) {
      _fFuelFlowGround = 0.000001389f;  // 5.0 [l/h]
    }
    else if(_fFuelFlowGround > 0.001f) {
      _fFuelFlowGround = 0.001f;
    }
    else if(_fFuelFlowGround < 0.0f) {
      _fFuelFlowGround = 0.0f;
    }
    self.fFuelFlowGround = _fFuelFlowGround;
  }

  function setFuelFlowAirborne(_fFuelFlowAirborne) {  // [m3/s]
    if(_fFuelFlowAirborne == null) {
      _fFuelFlowAirborne = 0.000009722f;  // 35.0 [l/h]
    }
    else if(_fFuelFlowAirborne > 0.001f) {
      _fFuelFlowAirborne = 0.001f;
    }
    else if(_fFuelFlowAirborne < 0.0f) {
      _fFuelFlowAirborne = 0.0f;
    }
    self.fFuelFlowAirborne = _fFuelFlowAirborne;
  }

  function setFuelFlowTowing(_fFuelFlowTowing) {  // [m3/s]
    if(_fFuelFlowTowing == null) {
      _fFuelFlowTowing = 0.000011111f;  // 40.0 [l/h]
    }
    else if(_fFuelFlowTowing > 0.001f) {
      _fFuelFlowTowing = 0.001f;
    }
    else if(_fFuelFlowTowing < 0.0f) {
      _fFuelFlowTowing = 0.0f;
    }
    self.fFuelFlowTowing = _fFuelFlowTowing;
  }

  function setFuelAlert(_fFuelAlert) {  // [m3]
    if(_fFuelAlert == null) {
      _fFuelAlert = 0.055f;
    }
    else if(_fFuelAlert > 0.999f) {
      _fFuelAlert = 0.999f;
    }
    else if(_fFuelAlert < 0.0f) {
      _fFuelAlert = 0.0f;
    }
    self.fFuelAlert = _fFuelAlert;
  }

  function setSpeedOffBlock(_fSpeedOffBlock) {  // [m/s]
    if(_fSpeedOffBlock == null) {
      _fSpeedOffBlock = 1.39f;  // 5 km/h
    }
    else if(_fSpeedOffBlock > 99.0f) {
      _fSpeedOffBlock = 99.0f;
    }
    else if(_fSpeedOffBlock < 0.0f) {
      _fSpeedOffBlock = 0.0f;
    }
    self.fSpeedOffBlock = _fSpeedOffBlock;
  }

  function setSpeedTakeoff(_fSpeedTakeoff) {  // [m/s]
    if(_fSpeedTakeoff == null) {
      _fSpeedTakeoff = 20.92f;  // 47 mph
    }
    else if(_fSpeedTakeoff > 99.0f) {
      _fSpeedTakeoff = 99.0f;
    }
    else if(_fSpeedTakeoff < 0.0f) {
      _fSpeedTakeoff = 0.0f;
    }
    self.fSpeedTakeoff = _fSpeedTakeoff;
  }

  function setSpeedLanding(_fSpeedLanding) {  // [m/s]
    if(_fSpeedLanding == null) {
      _fSpeedLanding = 19.14f;  // 43 mph
    }
    else if(_fSpeedLanding > 99.0f) {
      _fSpeedLanding = 99.0f;
    }
    else if(_fSpeedLanding < 0.0f) {
      _fSpeedLanding = 0.0f;
    }
    self.fSpeedLanding = _fSpeedLanding;
  }

  function setSpeedMaxTowing(_fSpeedMaxTowing) {  // [m/s]
    if(_fSpeedMaxTowing == null) {
      _fSpeedMaxTowing = 41.67f;  // 150 km/h
    }
    else if(_fSpeedMaxTowing > 99.0f) {
      _fSpeedMaxTowing = 99.0f;
    }
    else if(_fSpeedMaxTowing < 0.0f) {
      _fSpeedMaxTowing = 0.0f;
    }
    self.fSpeedMaxTowing = _fSpeedMaxTowing;
  }

  function updateWeightTotal() {
    var fValue = 0.0f;
    if(self.fWeightEmpty != null) {
      fValue += self.fWeightEmpty;
    }
    if(self.fWeightPayload != null) {
      fValue += self.fWeightPayload;
    }
    if(self.fFuelQuantity != null and self.fFuelDensity != null) {
      fValue += self.fFuelQuantity * self.fFuelDensity;
    }
    self.fWeightTotal = fValue;
  }

}
