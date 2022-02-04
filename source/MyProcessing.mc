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
using Toybox.Math;
using Toybox.Position as Pos;
using Toybox.Sensor;
using Toybox.System as Sys;

//
// CLASS
//

class MyProcessing {

  //
  // VARIABLES
  //

  // Internal calculation objects
  // ... we must calculate our own vertical speed
  private var iPreviousAltitudeEpoch as Number = -1;
  private var fPreviousAltitude as Float = 0.0f;

  // Public objects
  // ... sensor values (fed by Toybox.Sensor)
  public var iSensorEpoch as Number = -1;
  // ... altimeter values (fed by Toybox.Activity, on Toybox.Sensor events)
  public var fAltitude as Float = NaN;
  public var fTemperature as Float = NaN;
  // ... altimeter calculated values
  public var fVerticalSpeed as Float = NaN;
  // ... position values (fed by Toybox.Position)
  public var bPositionStateful as Boolean = false;
  public var iPositionEpoch as Number = -1;
  public var iPositionElapsed as Number = -1;
  public var iAccuracy as Number = Pos.QUALITY_NOT_AVAILABLE;
  public var fGroundSpeed as Float = NaN;
  public var fHeading as Float = NaN;
  // ... position calculated values
  public var fAirSpeed as Float = NaN;
  // ... post-processing
  public var fFuelFlow as Float = NaN;
  public var bAlertAltitude as Boolean = false;
  public var bAlertTemperature as Boolean = false;
  public var bAlertFuel as Boolean = false;


  //
  // FUNCTIONS: self
  //

  function resetSensorData() as Void {
    //Sys.println("DEBUG: MyProcessing.resetSensorData()");

    // Reset
    // ... we must calculate our own vertical speed
    self.iPreviousAltitudeEpoch = -1;
    self.fPreviousAltitude = 0.0f;
    // ... sensor values
    self.iSensorEpoch = -1;
    // ... altimeter values
    self.fAltitude = NaN;
    self.fTemperature = NaN;
    // ... altimeter calculated values
    self.fVerticalSpeed = NaN;
    // ... filters
    $.oMyFilter.resetFilter(MyFilter.VERTICALSPEED);
  }

  function resetPositionData() as Void {
    //Sys.println("DEBUG: MyProcessing.resetPositionData()");

    // Reset
    // ... position values
    self.bPositionStateful = false;
    self.iPositionEpoch = -1;
    self.iPositionElapsed = -1;
    self.iAccuracy = Pos.QUALITY_NOT_AVAILABLE;
    self.fGroundSpeed = NaN;
    self.fHeading = NaN;
    // ... position calculated values
    self.fAirSpeed = NaN;
    // ... post-processing
    self.fFuelFlow = NaN;
    self.bAlertAltitude = false;
    self.bAlertTemperature = false;
    self.bAlertFuel = false;
    // ... filters
    $.oMyFilter.resetFilter(MyFilter.GROUNDSPEED);
    $.oMyFilter.resetFilter(MyFilter.HEADING_X);
    $.oMyFilter.resetFilter(MyFilter.HEADING_Y);
  }

  function processSensorInfo(_oInfo as Sensor.Info, _iEpoch as Number) as Void {
    //Sys.println("DEBUG: MyProcessing.processSensorInfo()");

    // Process sensor data
    var fValue;

    // ... altitude
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeActual)) {  // ... the closest to the device's raw barometric sensor value
      self.fAltitude = $.oMyAltimeter.fAltitudeActual;
    }
    //else {
    //  Sys.println("WARNING: Internal altimeter has no altitude available");
    //}

    // ... vertical speed
    if(LangUtils.notNaN(self.fAltitude)) {
      if(self.iPreviousAltitudeEpoch >= 0 and self.iSensorEpoch-self.iPreviousAltitudeEpoch != 0) {
        self.fVerticalSpeed = $.oMyFilter.filterValue(MyFilter.VERTICALSPEED, (self.fAltitude-self.fPreviousAltitude) / (self.iSensorEpoch-self.iPreviousAltitudeEpoch), true);
      }
      self.iPreviousAltitudeEpoch = self.iSensorEpoch;
      self.fPreviousAltitude = self.fAltitude;
    }
    //Sys.println(format("DEBUG: (Calculated) vertical speed = $1$", [self.fVerticalSpeed]));

    // ... temperature
    if(LangUtils.notNaN($.oMyAltimeter.fTemperatureActual)) {  // ... computed using sensor (if available) or ISA offset (according to altitude)
      self.fTemperature = $.oMyAltimeter.fTemperatureActual;
    }
    //else {
    //  Sys.println("WARNING: Internal altimeter has no temperature available");
    //}

    // Done
    self.iSensorEpoch = _iEpoch;
  }

  function processPositionInfo(_oInfo as Pos.Info, _iEpoch as Number) as Void {
    //Sys.println("DEBUG: MyProcessing.processPositionInfo()");

    // Process position data
    var fValue;
    var fValue2;
    var bStateful = true;

    // ... accuracy
    if(_oInfo has :accuracy and _oInfo.accuracy != null) {
      self.iAccuracy = _oInfo.accuracy as Number;
      //Sys.println(format("DEBUG: (Position.Info) accuracy = $1$", [self.iAccuracy]));
    }
    else {
      //Sys.println("WARNING: Position data have no accuracy information (:accuracy)");
      self.iAccuracy = Pos.QUALITY_NOT_AVAILABLE;
      return;
    }
    if(self.iAccuracy == Pos.QUALITY_NOT_AVAILABLE or (self.iAccuracy == Pos.QUALITY_LAST_KNOWN and self.iPositionEpoch < 0)) {
      //Sys.println("WARNING: Position accuracy is not good enough to continue or start processing");
      self.iAccuracy = Pos.QUALITY_NOT_AVAILABLE;
      return;
    }
    self.bPositionStateful = false;

    // ... altitude and temperature
    // if(LangUtils.isNaN(self.fAltitude) and _oInfo has :altitude and _oInfo.altitude != null) {  // ... DEBUG (when replaying FIT file in simulator)
    //   self.fAltitude = _oInfo.altitude;
    // }
    if(LangUtils.isNaN(self.fAltitude) or LangUtils.isNaN(self.fTemperature)) {  // ... derived by internal altimeter on sensor events
      bStateful = false;
    }

    // ... ground speed
    if(_oInfo has :speed and _oInfo.speed != null) {
      self.fGroundSpeed = $.oMyFilter.filterValue(MyFilter.GROUNDSPEED, _oInfo.speed as Float, true);
    }
    //else {
    //  Sys.println("WARNING: Position data have no speed information (:speed)");
    //}
    if(LangUtils.isNaN(self.fGroundSpeed)) {
      bStateful = false;
    }
    //Sys.println(format("DEBUG: (Position.Info) ground speed = $1$", [self.fGroundSpeed]));

    // ... heading
    // NOTE: we consider heading meaningful only if ground speed is above 1.0 m/s
    if(self.fGroundSpeed >= 1.0f and _oInfo has :heading and _oInfo.heading != null) {
      fValue = $.oMyFilter.filterValue(MyFilter.HEADING_X, Math.cos(_oInfo.heading as Float).toFloat(), true);
      fValue2 = $.oMyFilter.filterValue(MyFilter.HEADING_Y, Math.sin(_oInfo.heading as Float).toFloat(), true);
      if(LangUtils.notNaN(fValue) and LangUtils.notNaN(fValue2)) {
        fValue = Math.atan2(fValue2, fValue).toFloat();
        if(LangUtils.isNaN(fValue)) {
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
      self.fHeading = NaN;
    }
    //Sys.println(format("DEBUG: (Position.Info) heading = $1$", [self.fHeading]));

    // ... air speed
    if(LangUtils.notNaN(self.fGroundSpeed) and LangUtils.notNaN(self.fHeading)) {
      self.fAirSpeed = self.fGroundSpeed + $.oMySettings.fWindSpeed*Math.cos(self.fHeading-$.oMySettings.fWindDirection).toFloat();
    }
    else {
      //Sys.println("WARNING: No ground speed and/or heading available");
      // NOTE: assume we're static; furthermore, air speed:
      // - is displayed on when on-block
      // - is used only to detect take-off and landing (when the above condition is true)
      self.fAirSpeed = $.oMySettings.fWindSpeed;
    }
    //Sys.println(format("DEBUG: (Calculated) air speed = $1$", [self.fAirSpeed]));

    // Finalize
    if(bStateful) {
      self.bPositionStateful = true;
      if(self.iAccuracy > Pos.QUALITY_LAST_KNOWN) {
        self.iPositionElapsed = self.iPositionEpoch >= 0 ? _iEpoch - self.iPositionEpoch : 0;
        self.iPositionEpoch = _iEpoch;
      }
    }
  }

  function postProcessing() as Void {
    //Sys.println("DEBUG: MyProcessing.postProcessing()");
    if(!self.bPositionStateful) {
      //Sys.println("ERROR: Incomplete data; cannot proceed");
      return;
    }

    // Post process
    var fValue;

    // ... fuel flow/quantity
    if(self.fAirSpeed < $.oMyTowplane.fSpeedTakeoff and self.fAirSpeed < $.oMyTowplane.fSpeedLanding) {
      self.fFuelFlow = $.oMyTowplane.fFuelFlowGround;
    }
    else if($.oMyGlider == null or self.fAirSpeed > $.oMyTowplane.fSpeedMaxTowing) {
      self.fFuelFlow = $.oMyTowplane.fFuelFlowAirborne;
    }
    else {
      self.fFuelFlow = $.oMyTowplane.fFuelFlowTowing;
    }
    fValue = $.oMyTowplane.fFuelQuantity - self.fFuelFlow * self.iPositionElapsed;
    if(fValue < 0.0f) {
      fValue = 0.0f;
    }
    $.oMyTowplane.fFuelQuantity = fValue;
    $.oMyTowplane.updateWeightTotal();
    //Sys.println(format("DEBUG: (Calculated) fuel quantity (flow) = $1$ ($2$)", [$.oMyTowplane.fFuelQuantity, fFuelFlow]));

    // ... alerts
    self.bAlertAltitude = (self.fAltitude > $.oMySettings.fAltimeterAlert);
    self.bAlertTemperature = (self.fTemperature > $.oMySettings.fTemperatureAlert);
    self.bAlertFuel = ($.oMyTowplane.fFuelQuantity < $.oMyTowplane.fFuelAlert);
  }

}
