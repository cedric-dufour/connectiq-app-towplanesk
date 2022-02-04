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
  public var fAltimeterCalibrationQNH as Float = 101325.0f;
  public var fAltimeterCorrectionAbsolute as Float = 0.0f;
  public var fAltimeterCorrectionRelative as Float = 1.0f;
  public var fAltimeterAlert as Float = 1000.0f;
  // ... temperature
  public var fTemperatureISAOffset as Float = 0.0f;
  public var bTemperatureAuto as Boolean = false;
  public var fTemperatureAlert as Float = 298.15f;
  // ... wind
  public var fWindDirection as Float = 0.0f;
  public var fWindSpeed as Float = 0.0f;
  // ... timer
  public var bTimerAutoLog as Boolean = false;
  public var bTimerAutoActivity as Boolean = false;
  public var iTimerThresholdGround as Number = 30;
  public var iTimerThresholdAirborne as Number = 60;
  // ... notifications
  public var bNotificationsAltimeter as Boolean = false;
  public var bNotificationsTemperature as Boolean = false;
  public var bNotificationsFuel as Boolean = false;
  // ... general
  public var iGeneralBackgroundColor as Number = Gfx.COLOR_WHITE;
  // ... units
  public var iUnitDistance as Number = -1;
  public var iUnitElevation as Number = -1;
  public var iUnitWeight as Number = -1;
  public var iUnitFuel as Number = -1;
  public var iUnitPressure as Number = -1;
  public var iUnitTemperature as Number = -1;
  public var bUnitTimeUTC as Boolean = false;

  // Units
  // ... symbols
  public var sUnitDistance as String = "km";
  public var sUnitHorizontalSpeed as String = "km/h";
  public var sUnitElevation as String = "m";
  public var sUnitVerticalSpeed as String = "m/s";
  public var sUnitWeight as String = "kg";
  public var sUnitFuel as String = "l";
  public var sUnitPressure as String = "mb";
  public var sUnitTemperature as String = "°C";
  public var sUnitTime as String = "LT";
  // ... conversion coefficients
  public var fUnitDistanceCoefficient as Float = 0.001f;
  public var fUnitHorizontalSpeedCoefficient as Float = 3.6f;
  public var fUnitElevationCoefficient as Float = 1.0f;
  public var fUnitVerticalSpeedCoefficient as Float = 1.0f;
  public var fUnitWeightCoefficient as Float = 1.0f;
  public var fUnitFuelCoefficient as Float = 1000.0f;
  public var fUnitPressureCoefficient as Float = 0.01f;
  public var fUnitTemperatureCoefficient as Float = 1.0f;
  public var fUnitTemperatureOffset as Float = -273.15f;


  //
  // FUNCTIONS: self
  //

  function load() as Void {
    // Settings
    // ... altimeter
    self.setAltimeterCalibrationQNH(self.loadAltimeterCalibrationQNH());
    self.setAltimeterCorrectionAbsolute(self.loadAltimeterCorrectionAbsolute());
    self.setAltimeterCorrectionRelative(self.loadAltimeterCorrectionRelative());
    self.setAltimeterAlert(self.loadAltimeterAlert());
    // ... temperature
    self.setTemperatureISAOffset(self.loadTemperatureISAOffset());
    self.setTemperatureAuto(self.loadTemperatureAuto());
    self.setTemperatureAlert(self.loadTemperatureAlert());
    // ... wind
    self.setWindDirection(self.loadWindDirection());
    self.setWindSpeed(self.loadWindSpeed());
    // ... timer
    self.setTimerAutoLog(self.loadTimerAutoLog());
    self.setTimerAutoActivity(self.loadTimerAutoActivity());
    self.setTimerThresholdGround(self.loadTimerThresholdGround());
    self.setTimerThresholdAirborne(self.loadTimerThresholdAirborne());
    // ... notifications
    self.setNotificationsAltimeter(self.loadNotificationsAltimeter());
    self.setNotificationsTemperature(self.loadNotificationsTemperature());
    self.setNotificationsFuel(self.loadNotificationsFuel());
    // ... general
    self.setGeneralBackgroundColor(self.loadGeneralBackgroundColor());
    // ... units
    self.setUnitDistance(self.loadUnitDistance());
    self.setUnitElevation(self.loadUnitElevation());
    self.setUnitWeight(self.loadUnitWeight());
    self.setUnitFuel(self.loadUnitFuel());
    self.setUnitPressure(self.loadUnitPressure());
    self.setUnitTemperature(self.loadUnitTemperature());
    self.setUnitTimeUTC(self.loadUnitTimeUTC());
  }

  function loadAltimeterCalibrationQNH() as Float {  // [Pa]
    var fValue = App.Properties.getValue("userAltimeterCalibrationQNH") as Float?;
    return fValue != null ? fValue : 101325.0f;
  }
  function saveAltimeterCalibrationQNH(_fValue as Float) as Void {  // [Pa]
    App.Properties.setValue("userAltimeterCalibrationQNH", _fValue as App.PropertyValueType);
  }
  function setAltimeterCalibrationQNH(_fValue as Float) as Void {  // [Pa]
    // REF: https://en.wikipedia.org/wiki/Atmospheric_pressure#Records
    if(_fValue > 110000.0f) {
      _fValue = 110000.0f;
    }
    else if(_fValue < 85000.0f) {
      _fValue = 85000.0f;
    }
    self.fAltimeterCalibrationQNH = _fValue;
  }

  function loadAltimeterCorrectionAbsolute() as Float {  // [Pa]
    var fValue = App.Properties.getValue("userAltimeterCorrectionAbsolute") as Float?;
    return fValue != null ? fValue : 0.0f;
  }
  function saveAltimeterCorrectionAbsolute(_fValue as Float) as Void {  // [Pa]
    App.Properties.setValue("userAltimeterCorrectionAbsolute", _fValue as App.PropertyValueType);
  }
  function setAltimeterCorrectionAbsolute(_fValue as Float) as Void {  // [Pa]
    if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < -9999.0f) {
      _fValue = -9999.0f;
    }
    self.fAltimeterCorrectionAbsolute = _fValue;
  }

  function loadAltimeterCorrectionRelative() as Float {
    var fValue = App.Properties.getValue("userAltimeterCorrectionRelative") as Float?;
    return fValue != null ? fValue : 1.0f;
  }
  function saveAltimeterCorrectionRelative(_fValue as Float) as Void {
    App.Properties.setValue("userAltimeterCorrectionRelative", _fValue as App.PropertyValueType);
  }
  function setAltimeterCorrectionRelative(_fValue as Float) as Void {
    if(_fValue > 1.9999f) {
      _fValue = 1.9999f;
    }
    else if(_fValue < 0.0001f) {
      _fValue = 0.0001f;
    }
    self.fAltimeterCorrectionRelative = _fValue;
  }

  function loadAltimeterAlert() as Float {  // [m]
    var fValue = App.Properties.getValue("userAltimeterAlert") as Float?;
    return fValue != null ? fValue : 1000.0f;
  }
  function saveAltimeterAlert(_fValue as Float) as Void {  // [m]
    App.Properties.setValue("userAltimeterAlert", _fValue as App.PropertyValueType);
  }
  function setAltimeterAlert(_fValue as Float) as Void {  // [m]
    if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fAltimeterAlert = _fValue;
  }

  function loadTemperatureISAOffset() as Float {  // [°K]
    var fValue = App.Properties.getValue("userTemperatureISAOffset") as Float?;
    return fValue != null ? fValue : 0.0f;
  }
  function saveTemperatureISAOffset(_fValue as Float) as Void {  // [°K]
    App.Properties.setValue("userTemperatureISAOffset", _fValue as App.PropertyValueType);
  }
  function setTemperatureISAOffset(_fValue as Float) as Void {  // [°K]
    if(_fValue > 99.9f) {
      _fValue = 99.9f;
    }
    else if(_fValue < -99.9f) {
      _fValue = 99.9f;
    }
    self.fTemperatureISAOffset = _fValue;
  }

  function loadTemperatureAuto() as Boolean {
    var bValue = App.Properties.getValue("userTemperatureAuto") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveTemperatureAuto(_bValue as Boolean) as Void {
    App.Properties.setValue("userTemperatureAuto", _bValue as App.PropertyValueType);
  }
  function setTemperatureAuto(_bValue as Boolean) as Void {
    self.bTemperatureAuto = _bValue;
  }

  function loadTemperatureAlert() as Float {  // [°K]
    var fValue = App.Properties.getValue("userTemperatureAlert") as Float?;
    return fValue != null ? fValue : 298.15f;  // 25°C (ISA+10°C at sea level)
  }
  function saveTemperatureAlert(_fValue as Float) as Void {  // [°K]
    App.Properties.setValue("userTemperatureAlert", _fValue as App.PropertyValueType);
  }
  function setTemperatureAlert(_fValue as Float) as Void {  // [°K]
    if(_fValue > 372.15f) {
      _fValue = 372.2f;
    }
    else if(_fValue < 224.15f) {
      _fValue = 224.15f;
    }
    self.fTemperatureAlert = _fValue;
  }

  function loadWindDirection() as Float {  // [rad]
    var fValue = App.Properties.getValue("userWindDirection") as Float?;
    return fValue != null ? fValue : 0.0f;
  }
  function saveWindDirection(_fValue as Float) as Void {  // [rad]
    App.Properties.setValue("userWindDirection", _fValue as App.PropertyValueType);
  }
  function setWindDirection(_fValue as Float) as Void {  // [rad]
    if(_fValue > 6.28318530718f) {
      _fValue = 6.28318530718f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWindDirection = _fValue;
  }

  function loadWindSpeed() as Float {  // [m/s]
    var fValue = App.Properties.getValue("userWindSpeed") as Float?;
    return fValue != null ? fValue : 0.0f;
  }
  function saveWindSpeed(_fValue as Float) as Void {  // [m/s]
    App.Properties.setValue("userWindSpeed", _fValue as App.PropertyValueType);
  }
  function setWindSpeed(_fValue as Float) as Void {  // [m/s]
    if(_fValue > 99.9f) {
      _fValue = 99.9f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fWindSpeed = _fValue;
  }

  function loadTimerAutoLog() as Boolean {
    var bValue = App.Properties.getValue("userTimerAutoLog") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveTimerAutoLog(_bValue as Boolean) as Void {
    App.Properties.setValue("userTimerAutoLog", _bValue as App.PropertyValueType);
  }
  function setTimerAutoLog(_bValue as Boolean) as Void {
    self.bTimerAutoLog = _bValue;
  }

  function loadTimerAutoActivity() as Boolean {
    var bValue = App.Properties.getValue("userTimerAutoActivity") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveTimerAutoActivity(_bValue as Boolean) as Void {
    App.Properties.setValue("userTimerAutoActivity", _bValue as App.PropertyValueType);
  }
  function setTimerAutoActivity(_bValue as Boolean) as Void {
    self.bTimerAutoActivity = _bValue;
  }

  function loadTimerThresholdGround() as Number {  // [s]
    var iValue = App.Properties.getValue("userTimerThresholdGround") as Number?;
    return iValue != null ? iValue : 30;
  }
  function saveTimerThresholdGround(_iValue as Number) as Void {  // [s]
    App.Properties.setValue("userTimerThresholdGround", _iValue as App.PropertyValueType);
  }
  function setTimerThresholdGround(_iValue as Number) as Void {  // [s]
    if(_iValue < 5) {
      _iValue = 5;
    }
    else if (_iValue > 300) {
      _iValue = 300;
    }
    self.iTimerThresholdGround = _iValue;
  }

  function loadTimerThresholdAirborne() as Number {  // [s]
    var iValue = App.Properties.getValue("userTimerThresholdAirborne") as Number?;
    return iValue != null ? iValue : 60;
  }
  function saveTimerThresholdAirborne(_iValue as Number) as Void {  // [s]
    App.Properties.setValue("userTimerThresholdAirborne", _iValue as App.PropertyValueType);
  }
  function setTimerThresholdAirborne(_iValue as Number) as Void {  // [s]
    if(_iValue < 5) {
      _iValue = 5;
    }
    else if (_iValue > 300) {
      _iValue = 300;
    }
    self.iTimerThresholdAirborne = _iValue;
  }

  function loadNotificationsAltimeter() as Boolean {
    var bValue = App.Properties.getValue("userNotificationsAltimeter") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveNotificationsAltimeter(_bValue as Boolean) as Void {
    App.Properties.setValue("userNotificationsAltimeter", _bValue as App.PropertyValueType);
  }
  function setNotificationsAltimeter(_bValue as Boolean) as Void {
    self.bNotificationsAltimeter = _bValue;
  }

  function loadNotificationsTemperature() as Boolean {
    var bValue = App.Properties.getValue("userNotificationsTemperature") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveNotificationsTemperature(_bValue as Boolean) as Void {
    App.Properties.setValue("userNotificationsTemperature", _bValue as App.PropertyValueType);
  }
  function setNotificationsTemperature(_bValue as Boolean) as Void {
    self.bNotificationsTemperature = _bValue;
  }

  function loadNotificationsFuel() as Boolean {
    var bValue = App.Properties.getValue("userNotificationsFuel") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveNotificationsFuel(_bValue as Boolean) as Void {
    App.Properties.setValue("userNotificationsFuel", _bValue as App.PropertyValueType);
  }
  function setNotificationsFuel(_bValue as Boolean) as Void {
    self.bNotificationsFuel = _bValue;
  }

  function loadGeneralBackgroundColor() as Number {
    var iValue = App.Properties.getValue("userGeneralBackgroundColor") as Number?;
    return iValue != null ? iValue : Gfx.COLOR_WHITE;
  }
  function saveGeneralBackgroundColor(_iValue as Number) as Void {
    App.Properties.setValue("userGeneralBackgroundColor", _iValue as App.PropertyValueType);
  }
  function setGeneralBackgroundColor(_iValue as Number) as Void {
    self.iGeneralBackgroundColor = _iValue;
  }

  function loadUnitDistance() as Number {
    var iValue = App.Properties.getValue("userUnitDistance") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitDistance(_iValue as Number) as Void {
    App.Properties.setValue("userUnitDistance", _iValue as App.PropertyValueType);
  }
  function setUnitDistance(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 2) {
      _iValue = -1;
    }
    self.iUnitDistance = _iValue;
    if(self.iUnitDistance < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :distanceUnits and oDeviceSettings.distanceUnits != null) {
        _iValue = oDeviceSettings.distanceUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == 2) {  // ... nautical
      // ... [nm]
      self.sUnitDistance = "nm";
      self.fUnitDistanceCoefficient = 0.000539956803456f;  // ... m -> nm
      // ... [kt]
      self.sUnitHorizontalSpeed = "kt";
      self.fUnitHorizontalSpeedCoefficient = 1.94384449244f;  // ... m/s -> kt
    }
    else if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitElevation() as Number {
    var iValue = App.Properties.getValue("userUnitElevation") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitElevation(_iValue as Number) as Void {
    App.Properties.setValue("userUnitElevation", _iValue as App.PropertyValueType);
  }
  function setUnitElevation(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 1) {
      _iValue = -1;
    }
    self.iUnitElevation = _iValue;
    if(self.iUnitElevation < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :elevationUnits and oDeviceSettings.elevationUnits != null) {
        _iValue = oDeviceSettings.elevationUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitWeight() as Number {
    var iValue = App.Properties.getValue("userUnitWeight") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitWeight(_iValue as Number) as Void {
    App.Properties.setValue("userUnitWeight", _iValue as App.PropertyValueType);
  }
  function setUnitWeight(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 1) {
      _iValue = -1;
    }
    self.iUnitWeight = _iValue;
    if(self.iUnitWeight < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iValue = oDeviceSettings.weightUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitFuel() as Number {
    var iValue = App.Properties.getValue("userUnitFuel") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitFuel(_iValue as Number) as Void {
    App.Properties.setValue("userUnitFuel", _iValue as App.PropertyValueType);
  }
  function setUnitFuel(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 2) {
      _iValue = -1;
    }
    self.iUnitFuel = _iValue;
    if(self.iUnitFuel < 0) {  // ... auto
      // NOTE: assume weight units are a good indicator of preferred fuel units
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iValue = oDeviceSettings.weightUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == 2) {  // ... electric
      // ... [kWh]
      self.sUnitFuel = "kWh";
      self.fUnitFuelCoefficient = 0.000000278f;  // ... J -> kWh
    }
    else if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitPressure() as Number {
    var iValue = App.Properties.getValue("userUnitPressure") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitPressure(_iValue as Number) as Void {
    App.Properties.setValue("userUnitPressure", _iValue as App.PropertyValueType);
  }
  function setUnitPressure(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 1) {
      _iValue = -1;
    }
    self.iUnitPressure = _iValue;
    if(self.iUnitPressure < 0) {  // ... auto
      // NOTE: assume weight units are a good indicator of preferred pressure units
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iValue = oDeviceSettings.weightUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitTemperature() as Number {
    var iValue = App.Properties.getValue("userUnitTemperature") as Number?;
    return iValue != null ? iValue : -1;
  }
  function saveUnitTemperature(_iValue as Number) as Void {
    App.Properties.setValue("userUnitTemperature", _iValue as App.PropertyValueType);
  }
  function setUnitTemperature(_iValue as Number) as Void {
    if(_iValue < 0 or _iValue > 1) {
      _iValue = -1;
    }
    self.iUnitTemperature = _iValue;
    if(self.iUnitTemperature < 0) {  // ... auto
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :temperatureUnits and oDeviceSettings.temperatureUnits != null) {
        _iValue = oDeviceSettings.temperatureUnits;
      }
      else {
        _iValue = Sys.UNIT_METRIC;
      }
    }
    if(_iValue == Sys.UNIT_STATUTE) {  // ... statute
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

  function loadUnitTimeUTC() as Boolean {
    var bValue = App.Properties.getValue("userUnitTimeUTC") as Boolean?;
    return bValue != null ? bValue : false;
  }
  function saveUnitTimeUTC(_bValue as Boolean) as Void {
    App.Properties.setValue("userUnitTimeUTC", _bValue as App.PropertyValueType);
  }
  function setUnitTimeUTC(_bValue as Boolean) as Void {
    self.bUnitTimeUTC = _bValue;
    if(_bValue) {
      self.sUnitTime = "Z";
    }
    else {
      self.sUnitTime = "LT";
    }
  }

}
