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

using Toybox.Lang;
using Toybox.Math;
using Toybox.Position as Pos;
using Toybox.System as Sys;

//
// CLASS
//

class TSK_Processing {

  //
  // VARIABLES
  //

  // Internal calculation objects
  // ... we must calculate our own vertical speed
  private var iPreviousAltitudeEpoch;
  private var fPreviousAltitude;

  // Public objects
  // ... sensor values (fed by Toybox.Sensor)
  public var iSensorEpoch;
  // ... altimeter values (fed by Toybox.Activity, on Toybox.Sensor events)
  public var fAltitude;
  public var fTemperature;
  // ... altimeter calculated values
  public var fVerticalSpeed;
  // ... position values (fed by Toybox.Position)
  public var bPositionStateful;
  public var iPositionEpoch;
  public var iPositionElapsed;
  public var iAccuracy;
  public var fGroundSpeed;
  public var fHeading;
  // ... position calculated values
  public var fAirSpeed;
  // ... post-processing
  public var fFuelFlow;
  public var bAlertAltitude;
  public var bAlertTemperature;
  public var bAlertFuel;


  //
  // FUNCTIONS: self
  //

  function initialize() {
    // Public objects
    // ... processing values and status
    self.resetSensorData();
    self.resetPositionData();
  }

  function resetSensorData() {
    //Sys.println("DEBUG: TSK_Processing.resetSensorData()");

    // Reset
    // ... we must calculate our own vertical speed
    self.iPreviousAltitudeEpoch = null;
    self.fPreviousAltitude = 0.0f;
    // ... sensor values
    self.iSensorEpoch = null;
    // ... altimeter values
    self.fAltitude = null;
    self.fTemperature = null;
    // ... altimeter calculated values
    self.fVerticalSpeed = null;
    // ... filters
    $.TSK_oFilter.resetFilter(TSK_Filter.VERTICALSPEED);
  }

  function resetPositionData() {
    //Sys.println("DEBUG: TSK_Processing.resetPositionData()");

    // Reset
    // ... position values
    self.bPositionStateful = false;
    self.iPositionEpoch = null;
    self.iPositionElapsed = null;
    self.iAccuracy = Pos.QUALITY_NOT_AVAILABLE;
    self.fGroundSpeed = null;
    self.fHeading = null;
    // ... position calculated values
    self.fAirSpeed = null;
    // ... post-processing
    self.fFuelFlow = null;
    self.bAlertAltitude = false;
    self.bAlertTemperature = false;
    self.bAlertFuel = false;
    // ... filters
    $.TSK_oFilter.resetFilter(TSK_Filter.GROUNDSPEED);
    $.TSK_oFilter.resetFilter(TSK_Filter.HEADING_X);
    $.TSK_oFilter.resetFilter(TSK_Filter.HEADING_Y);
  }

  function processSensorInfo(_oInfo, _iEpoch) {
    //Sys.println("DEBUG: TSK_Processing.processSensorInfo()");

    // Process sensor data
    var fValue;

    // ... altitude
    if($.TSK_oAltimeter.fAltitudeActual != null) {  // ... the closest to the device's raw barometric sensor value
      self.fAltitude = $.TSK_oAltimeter.fAltitudeActual;
    }
    //else {
    //  Sys.println("WARNING: Internal altimeter has no altitude available");
    //}

    // ... vertical speed
    if(self.fAltitude != null) {
      if(self.iPreviousAltitudeEpoch != null and self.iSensorEpoch-self.iPreviousAltitudeEpoch != 0) {
        self.fVerticalSpeed = $.TSK_oFilter.filterValue(TSK_Filter.VERTICALSPEED, (self.fAltitude-self.fPreviousAltitude) / (self.iSensorEpoch-self.iPreviousAltitudeEpoch), true);
      }
      self.iPreviousAltitudeEpoch = self.iSensorEpoch;
      self.fPreviousAltitude = self.fAltitude;
    }
    //Sys.println(Lang.format("DEBUG: (Calculated) vertical speed = $1$", [self.fVerticalSpeed]));

    // ... temperature
    if($.TSK_oAltimeter.fTemperatureActual != null) {  // ... computed using sensor (if available) or ISA offset (according to altitude)
      self.fTemperature = $.TSK_oAltimeter.fTemperatureActual;
    }
    //else {
    //  Sys.println("WARNING: Internal altimeter has no temperature available");
    //}

    // Done
    self.iSensorEpoch = _iEpoch;
  }

  function processPositionInfo(_oInfo, _iEpoch) {
    //Sys.println("DEBUG: TSK_Processing.processPositionInfo()");

    // Process position data
    var fValue;
    var fValue2;
    var bStateful = true;

    // ... accuracy
    if(_oInfo has :accuracy and _oInfo.accuracy != null) {
      self.iAccuracy = _oInfo.accuracy;
      //Sys.println(Lang.format("DEBUG: (Position.Info) accuracy = $1$", [self.iAccuracy]));
    }
    else {
      //Sys.println("WARNING: Position data have no accuracy information (:accuracy)");
      self.iAccuracy = Pos.QUALITY_NOT_AVAILABLE;
      return;
    }
    if(self.iAccuracy == Pos.QUALITY_NOT_AVAILABLE or (self.iAccuracy == Pos.QUALITY_LAST_KNOWN and self.iPositionEpoch == null)) {
      //Sys.println("WARNING: Position accuracy is not good enough to continue or start processing");
      self.iAccuracy = Pos.QUALITY_NOT_AVAILABLE;
      return;
    }
    self.bPositionStateful = false;

    // ... altitude and temperature
    // if(self.fAltitude == null and _oInfo has :altitude and _oInfo.altitude != null) {  // ... DEBUG (when replaying FIT file in simulator)
    //   self.fAltitude = _oInfo.altitude;
    // }
    if(self.fAltitude == null or self.fTemperature == null) {  // ... derived by internal altimeter on sensor events
      bStateful = false;
    }

    // ... ground speed
    if(_oInfo has :speed and _oInfo.speed != null) {
      self.fGroundSpeed = $.TSK_oFilter.filterValue(TSK_Filter.GROUNDSPEED, _oInfo.speed, true);
    }
    //else {
    //  Sys.println("WARNING: Position data have no speed information (:speed)");
    //}
    if(self.fGroundSpeed == null) {
      bStateful = false;
    }
    //Sys.println(Lang.format("DEBUG: (Position.Info) ground speed = $1$", [self.fGroundSpeed]));

    // ... heading
    // NOTE: we consider heading meaningful only if ground speed is above 1.0 m/s
    if(self.fGroundSpeed != null and self.fGroundSpeed >= 1.0f and _oInfo has :heading and _oInfo.heading != null) {
      fValue = $.TSK_oFilter.filterValue(TSK_Filter.HEADING_X, Math.cos(_oInfo.heading), true);
      fValue2 = $.TSK_oFilter.filterValue(TSK_Filter.HEADING_Y, Math.sin(_oInfo.heading), true);
      if(fValue != null and fValue2 != null) {
        fValue = Math.atan2(fValue2, fValue);
        if(fValue == NaN) {
          fValue = self.fHeading;
        }
        else if(fValue < 0.0f) {
          fValue += 6.28318530718f;
        }
      }
      self.fHeading = fValue;
    }
    else {
      //Sys.println("WARNING: Position data have no (meaningful) heading information (:heading)");
      self.fHeading = null;
    }
    //Sys.println(Lang.format("DEBUG: (Position.Info) heading = $1$", [self.fHeading]));

    // ... air speed
    if(self.fGroundSpeed != null and self.fHeading != null) {
      self.fAirSpeed = self.fGroundSpeed + $.TSK_oSettings.fWindSpeed*Math.cos(self.fHeading-$.TSK_oSettings.fWindDirection);
    }
    else {
      //Sys.println("WARNING: No ground speed and/or heading available");
      self.fAirSpeed = self.fGroundSpeed;
    }
    //Sys.println(Lang.format("DEBUG: (Calculated) air speed = $1$", [self.fAirSpeed]));

    // Finalize
    if(bStateful) {
      self.bPositionStateful = true;
      if(self.iAccuracy > Pos.QUALITY_LAST_KNOWN) {
        self.iPositionElapsed = self.iPositionEpoch != null ? _iEpoch - self.iPositionEpoch : 0;
        self.iPositionEpoch = _iEpoch;
      }
    }
  }

  function postProcessing() {
    //Sys.println("DEBUG: TSK_Processing.postProcessing()");
    if(!self.bPositionStateful) {
      //Sys.println("ERROR: Incomplete data; cannot proceed");
      return;
    }

    // Post process
    var fValue;

    // ... fuel flow/quantity
    if(self.fAirSpeed < $.TSK_oTowplane.fSpeedTakeoff and self.fAirSpeed < $.TSK_oTowplane.fSpeedLanding) {
      self.fFuelFlow = $.TSK_oTowplane.fFuelFlowGround;
    }
    else if($.TSK_oGlider == null or self.fAirSpeed > $.TSK_oTowplane.fSpeedMaxTowing) {
      self.fFuelFlow = $.TSK_oTowplane.fFuelFlowAirborne;
    }
    else {
      self.fFuelFlow = $.TSK_oTowplane.fFuelFlowTowing;
    }
    fValue = $.TSK_oTowplane.fFuelQuantity - self.fFuelFlow * self.iPositionElapsed;
    if(fValue < 0.0f) {
      fValue = 0.0f;
    }
    $.TSK_oTowplane.fFuelQuantity = fValue;
    $.TSK_oTowplane.updateWeightTotal();
    //Sys.println(Lang.format("DEBUG: (Calculated) fuel quantity (flow) = $1$ ($2$)", [$.TSK_oTowplane.fFuelQuantity, fFuelFlow]));

    // ... alerts
    self.bAlertAltitude = (self.fAltitude > $.TSK_oSettings.fAltimeterAlert);
    self.bAlertTemperature = (self.fTemperature > $.TSK_oSettings.fTemperatureAlert);
    self.bAlertFuel = ($.TSK_oTowplane.fFuelQuantity < $.TSK_oTowplane.fFuelAlert);
  }

}
