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

class MySettings {

  //
  // VARIABLES
  //

  // Settings
  // ... altimeter
  public var fAltimeterCalibrationQNH;
  public var fAltimeterCorrectionAbsolute;
  public var fAltimeterCorrectionRelative;
  public var fAltimeterAlert;
  // ... temperature
  public var fTemperatureISAOffset;
  public var bTemperatureAuto;
  public var fTemperatureAlert;
  // ... wind
  public var fWindSpeed;
  public var fWindDirection;
  // ... timer
  public var bTimerAutoLog;
  public var bTimerAutoActivity;
  public var iTimerThresholdGround;
  public var iTimerThresholdAirborne;
  // ... notifications
  public var bNotificationsAltimeter;
  public var bNotificationsTemperature;
  public var bNotificationsFuel;
  // ... general
  public var iGeneralBackgroundColor;
  // ... units
  public var iUnitDistance;
  public var iUnitElevation;
  public var iUnitWeight;
  public var iUnitFuel;
  public var iUnitPressure;
  public var iUnitTemperature;
  public var bUnitTimeUTC;

  // Units
  // ... symbols
  public var sUnitDistance;
  public var sUnitHorizontalSpeed;
  public var sUnitElevation;
  public var sUnitVerticalSpeed;
  public var sUnitWeight;
  public var sUnitFuel;
  public var sUnitPressure;
  public var sUnitTemperature;
  public var sUnitTime;
  // ... conversion coefficients
  public var fUnitDistanceCoefficient;
  public var fUnitHorizontalSpeedCoefficient;
  public var fUnitElevationCoefficient;
  public var fUnitVerticalSpeedCoefficient;
  public var fUnitWeightCoefficient;
  public var fUnitFuelCoefficient;
  public var fUnitPressureCoefficient;
  public var fUnitTemperatureCoefficient;
  public var fUnitTemperatureOffset;


  //
  // FUNCTIONS: self
  //

  function load() {
    // Settings
    // ... altimeter
    self.setAltimeterCalibrationQNH(App.Properties.getValue("userAltimeterCalibrationQNH"));
    self.setAltimeterCorrectionAbsolute(App.Properties.getValue("userAltimeterCorrectionAbsolute"));
    self.setAltimeterCorrectionRelative(App.Properties.getValue("userAltimeterCorrectionRelative"));
    self.setAltimeterAlert(App.Properties.getValue("userAltimeterAlert"));
    // ... temperature
    self.setTemperatureISAOffset(App.Properties.getValue("userTemperatureISAOffset"));
    self.setTemperatureAuto(App.Properties.getValue("userTemperatureAuto"));
    self.setTemperatureAlert(App.Properties.getValue("userTemperatureAlert"));
    // ... wind
    self.setWindSpeed(App.Properties.getValue("userWindSpeed"));
    self.setWindDirection(App.Properties.getValue("userWindDirection"));
    // ... timer
    self.setTimerAutoLog(App.Properties.getValue("userTimerAutoLog"));
    self.setTimerAutoActivity(App.Properties.getValue("userTimerAutoActivity"));
    self.setTimerThresholdGround(App.Properties.getValue("userTimerThresholdGround"));
    self.setTimerThresholdAirborne(App.Properties.getValue("userTimerThresholdAirborne"));
    // ... notifications
    self.setNotificationsAltimeter(App.Properties.getValue("userNotificationsAltimeter"));
    self.setNotificationsTemperature(App.Properties.getValue("userNotificationsTemperature"));
    self.setNotificationsFuel(App.Properties.getValue("userNotificationsFuel"));
    // ... general
    self.setGeneralBackgroundColor(App.Properties.getValue("userGeneralBackgroundColor"));
    // ... units
    self.setUnitDistance(App.Properties.getValue("userUnitDistance"));
    self.setUnitElevation(App.Properties.getValue("userUnitElevation"));
    self.setUnitWeight(App.Properties.getValue("userUnitWeight"));
    self.setUnitFuel(App.Properties.getValue("userUnitFuel"));
    self.setUnitPressure(App.Properties.getValue("userUnitPressure"));
    self.setUnitTemperature(App.Properties.getValue("userUnitTemperature"));
    self.setUnitTimeUTC(App.Properties.getValue("userUnitTimeUTC"));
  }

  function setAltimeterCalibrationQNH(_fAltimeterCalibrationQNH) {  // [Pa]
    // REF: https://en.wikipedia.org/wiki/Atmospheric_pressure#Records
    if(_fAltimeterCalibrationQNH == null) {
      _fAltimeterCalibrationQNH = 101325.0f;
    }
    else if(_fAltimeterCalibrationQNH > 110000.0f) {
      _fAltimeterCalibrationQNH = 110000.0f;
    }
    else if(_fAltimeterCalibrationQNH < 85000.0f) {
      _fAltimeterCalibrationQNH = 85000.0f;
    }
    self.fAltimeterCalibrationQNH = _fAltimeterCalibrationQNH;
  }

  function setAltimeterCorrectionAbsolute(_fAltimeterCorrectionAbsolute) {  // [Pa]
    if(_fAltimeterCorrectionAbsolute == null) {
      _fAltimeterCorrectionAbsolute = 0.0f;
    }
    else if(_fAltimeterCorrectionAbsolute > 9999.0f) {
      _fAltimeterCorrectionAbsolute = 9999.0f;
    }
    else if(_fAltimeterCorrectionAbsolute < -9999.0f) {
      _fAltimeterCorrectionAbsolute = -9999.0f;
    }
    self.fAltimeterCorrectionAbsolute = _fAltimeterCorrectionAbsolute;
  }

  function setAltimeterCorrectionRelative(_fAltimeterCorrectionRelative) {
    if(_fAltimeterCorrectionRelative == null) {
      _fAltimeterCorrectionRelative = 1.0f;
    }
    else if(_fAltimeterCorrectionRelative > 1.9999f) {
      _fAltimeterCorrectionRelative = 1.9999f;
    }
    else if(_fAltimeterCorrectionRelative < 0.0001f) {
      _fAltimeterCorrectionRelative = 0.0001f;
    }
    self.fAltimeterCorrectionRelative = _fAltimeterCorrectionRelative;
  }

  function setAltimeterAlert(_fAltimeterAlert) {  // [m]
    if(_fAltimeterAlert == null) {
      _fAltimeterAlert = 1000.0f;
    }
    else if(_fAltimeterAlert > 9999.0f) {
      _fAltimeterAlert = 9999.0f;
    }
    else if(_fAltimeterAlert < 0.0f) {
      _fAltimeterAlert = 0.0f;
    }
    self.fAltimeterAlert = _fAltimeterAlert;
  }

  function setTemperatureISAOffset(_fTemperatureISAOffset) {  // [°K]
    if(_fTemperatureISAOffset == null) {
      _fTemperatureISAOffset = 0.0f;
    }
    else if(_fTemperatureISAOffset > 99.9f) {
      _fTemperatureISAOffset = 99.9f;
    }
    else if(_fTemperatureISAOffset < -99.9f) {
      _fTemperatureISAOffset = 99.9f;
    }
    self.fTemperatureISAOffset = _fTemperatureISAOffset;
  }

  function setTemperatureAuto(_bTemperatureAuto) {
    if(_bTemperatureAuto == null) {
      _bTemperatureAuto = false;
    }
    self.bTemperatureAuto = _bTemperatureAuto;
  }

  function setTemperatureAlert(_fTemperatureAlert) {  // [°K]
    if(_fTemperatureAlert == null) {
      _fTemperatureAlert = 298.15f;  // 25°C (ISA+10°C at sea level)
    }
    else if(_fTemperatureAlert > 372.15f) {
      _fTemperatureAlert = 372.2f;
    }
    else if(_fTemperatureAlert < 224.15f) {
      _fTemperatureAlert = 224.15f;
    }
    self.fTemperatureAlert = _fTemperatureAlert;
  }

  function setWindSpeed(_fWindSpeed) {  // [m/s]
    if(_fWindSpeed == null) {
      _fWindSpeed = 0.0f;
    }
    else if(_fWindSpeed > 99.9f) {
      _fWindSpeed = 99.9f;
    }
    else if(_fWindSpeed < 0.0f) {
      _fWindSpeed = 0.0f;
    }
    self.fWindSpeed = _fWindSpeed;
  }

  function setWindDirection(_fWindDirection) {  // [rad]
    if(_fWindDirection == null) {
      _fWindDirection = 0.0f;
    }
    else if(_fWindDirection > 6.28318530718f) {
      _fWindDirection = 6.28318530718f;
    }
    else if(_fWindDirection < 0.0f) {
      _fWindDirection = 0.0f;
    }
    self.fWindDirection = _fWindDirection;
  }

  function setTimerAutoLog(_bTimerAutoLog) {
    if(_bTimerAutoLog == null) {
      _bTimerAutoLog = false;
    }
    self.bTimerAutoLog = _bTimerAutoLog;
  }

  function setTimerAutoActivity(_bTimerAutoActivity) {
    if(_bTimerAutoActivity == null) {
      _bTimerAutoActivity = false;
    }
    self.bTimerAutoActivity = _bTimerAutoActivity;
  }

  function setTimerThresholdGround(_iTimerThresholdGround) {
    if(_iTimerThresholdGround == null or _iTimerThresholdGround < 5 or _iTimerThresholdGround > 300) {
      _iTimerThresholdGround = 30;
    }
    self.iTimerThresholdGround = _iTimerThresholdGround;
  }

  function setTimerThresholdAirborne(_iTimerThresholdAirborne) {
    if(_iTimerThresholdAirborne == null or _iTimerThresholdAirborne < 5 or _iTimerThresholdAirborne > 300) {
      _iTimerThresholdAirborne = 60;
    }
    self.iTimerThresholdAirborne = _iTimerThresholdAirborne;
  }

  function setNotificationsAltimeter(_bNotificationsAltimeter) {
    if(_bNotificationsAltimeter == null) {
      _bNotificationsAltimeter = false;
    }
    self.bNotificationsAltimeter = _bNotificationsAltimeter;
  }

  function setNotificationsTemperature(_bNotificationsTemperature) {
    if(_bNotificationsTemperature == null) {
      _bNotificationsTemperature = false;
    }
    self.bNotificationsTemperature = _bNotificationsTemperature;
  }

  function setNotificationsFuel(_bNotificationsFuel) {
    if(_bNotificationsFuel == null) {
      _bNotificationsFuel = false;
    }
    self.bNotificationsFuel = _bNotificationsFuel;
  }

  function setGeneralBackgroundColor(_iGeneralBackgroundColor) {
    if(_iGeneralBackgroundColor == null) {
      _iGeneralBackgroundColor = Gfx.COLOR_WHITE;
    }
    self.iGeneralBackgroundColor = _iGeneralBackgroundColor;
  }

  function setUnitDistance(_iUnitDistance) {
    if(_iUnitDistance == null or _iUnitDistance < 0 or _iUnitDistance > 2) {
      _iUnitDistance = -1;
    }
    self.iUnitDistance = _iUnitDistance;
    if(self.iUnitDistance < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :distanceUnits and oDeviceSettings.distanceUnits != null) {
        _iUnitDistance = oDeviceSettings.distanceUnits;
      }
      else {
        _iUnitDistance = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitDistance == 2) {  // ... nautical
      // ... [nm]
      self.sUnitDistance = "nm";
      self.fUnitDistanceCoefficient = 0.000539956803456f;  // ... m -> nm
      // ... [kt]
      self.sUnitHorizontalSpeed = "kt";
      self.fUnitHorizontalSpeedCoefficient = 1.94384449244f;  // ... m/s -> kt
    }
    else if(_iUnitDistance == Sys.UNIT_STATUTE) {  // ... statute
      // ... [sm]
      self.sUnitDistance = "sm";
      self.fUnitDistanceCoefficient = 0.000621371192237f;  // ... m -> sm
      // ... [mph]
      self.sUnitHorizontalSpeed = "mph";
      self.fUnitHorizontalSpeedCoefficient = 2.23693629205f;  // ... m/s -> mph
    }
    else {  // ... metric
      // ... [km]
      self.sUnitDistance = "km";
      self.fUnitDistanceCoefficient = 0.001f;  // ... m -> km
      // ... [km/h]
      self.sUnitHorizontalSpeed = "km/h";
      self.fUnitHorizontalSpeedCoefficient = 3.6f;  // ... m/s -> km/h
    }
  }

  function setUnitElevation(_iUnitElevation) {
    if(_iUnitElevation == null or _iUnitElevation < 0 or _iUnitElevation > 1) {
      _iUnitElevation = -1;
    }
    self.iUnitElevation = _iUnitElevation;
    if(self.iUnitElevation < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :elevationUnits and oDeviceSettings.elevationUnits != null) {
        _iUnitElevation = oDeviceSettings.elevationUnits;
      }
      else {
        _iUnitElevation = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitElevation == Sys.UNIT_STATUTE) {  // ... statute
      // ... [ft]
      self.sUnitElevation = "ft";
      self.fUnitElevationCoefficient = 3.280839895f;  // ... m -> ft
      // ... [ft/min]
      self.sUnitVerticalSpeed = "ft/m";
      self.fUnitVerticalSpeedCoefficient = 196.8503937f;  // ... m/s -> ft/min
    }
    else {  // ... metric
      // ... [m]
      self.sUnitElevation = "m";
      self.fUnitElevationCoefficient = 1.0f;  // ... m -> m
      // ... [m/s]
      self.sUnitVerticalSpeed = "m/s";
      self.fUnitVerticalSpeedCoefficient = 1.0f;  // ... m/s -> m/s
    }
  }

  function setUnitWeight(_iUnitWeight) {
    if(_iUnitWeight == null or _iUnitWeight < 0 or _iUnitWeight > 1) {
      _iUnitWeight = -1;
    }
    self.iUnitWeight = _iUnitWeight;
    if(self.iUnitWeight < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iUnitWeight = oDeviceSettings.weightUnits;
      }
      else {
        _iUnitWeight = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitWeight == Sys.UNIT_STATUTE) {  // ... statute
      // ... [lb]
      self.sUnitWeight = "lb";
      self.fUnitWeightCoefficient = 2.20462262185f;  // ... kg -> lb
    }
    else {  // ... metric
      // ... [kg]
      self.sUnitWeight = "kg";
      self.fUnitWeightCoefficient = 1.0f;  // ... kg -> kg
    }
  }

  function setUnitFuel(_iUnitFuel) {
    if(_iUnitFuel == null or _iUnitFuel < 0 or _iUnitFuel > 2) {
      _iUnitFuel = -1;
    }
    self.iUnitFuel = _iUnitFuel;
    if(self.iUnitFuel < 0) {  // ... auto
      // NOTE: assume weight units are a good indicator of preferred fuel units
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iUnitFuel = oDeviceSettings.weightUnits;
      }
      else {
        _iUnitFuel = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitFuel == 2) {  // ... electric
      // ... [kWh]
      self.sUnitFuel = "kWh";
      self.fUnitFuelCoefficient = 0.000000278f;  // ... J -> kWh
    }
    else if(_iUnitFuel == Sys.UNIT_STATUTE) {  // ... statute
      // ... [gal]
      self.sUnitFuel = "gal";
      self.fUnitFuelCoefficient = 264.172052358f;  // ... m3 -> gal
    }
    else {  // ... metric
      // ... [l]
      self.sUnitFuel = "l";
      self.fUnitFuelCoefficient = 1000.0f;  // ... m3 -> l
    }
  }

  function setUnitPressure(_iUnitPressure) {
    if(_iUnitPressure == null or _iUnitPressure < 0 or _iUnitPressure > 1) {
      _iUnitPressure = -1;
    }
    self.iUnitPressure = _iUnitPressure;
    if(self.iUnitPressure < 0) {  // ... auto
      // NOTE: assume weight units are a good indicator of preferred pressure units
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iUnitPressure = oDeviceSettings.weightUnits;
      }
      else {
        _iUnitPressure = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitPressure == Sys.UNIT_STATUTE) {  // ... statute
      // ... [inHg]
      self.sUnitPressure = "inHg";
      self.fUnitPressureCoefficient = 0.0002953f;  // ... Pa -> inHg
    }
    else {  // ... metric
      // ... [mb/hPa]
      self.sUnitPressure = "mb";
      self.fUnitPressureCoefficient = 0.01f;  // ... Pa -> mb/hPa
    }
  }

  function setUnitTemperature(_iUnitTemperature) {
    if(_iUnitTemperature == null or _iUnitTemperature < 0 or _iUnitTemperature > 1) {
      _iUnitTemperature = -1;
    }
    self.iUnitTemperature = _iUnitTemperature;
    if(self.iUnitTemperature < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :temperatureUnits and oDeviceSettings.temperatureUnits != null) {
        _iUnitTemperature = oDeviceSettings.temperatureUnits;
      }
      else {
        _iUnitTemperature = Sys.UNIT_METRIC;
      }
    }
    if(_iUnitTemperature == Sys.UNIT_STATUTE) {  // ... statute
      // ... [°F]
      self.sUnitTemperature = "°F";
      self.fUnitTemperatureCoefficient = 1.8f;  // ... °K -> °F
      self.fUnitTemperatureOffset = -459.67f;
    }
    else {  // ... metric
      // ... [°C]
      self.sUnitTemperature = "°C";
      self.fUnitTemperatureCoefficient = 1.0f;  // ... °K -> °C
      self.fUnitTemperatureOffset = -273.15f;
    }

  }

  function setUnitTimeUTC(_bUnitTimeUTC) {
    if(_bUnitTimeUTC == null) {
      _bUnitTimeUTC = false;
    }
    if(_bUnitTimeUTC) {
      self.bUnitTimeUTC = true;
      self.sUnitTime = "Z";
    }
    else {
      self.bUnitTimeUTC = false;
      self.sUnitTime = "LT";
    }
  }

}
