// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Generic ConnectIQ Helpers/Resources (CIQ Helpers)
// Copyright (C) 2017-2018 Cedric Dufour <http://cedric.dufour.name>
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is distributed in the hope
// that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class PickerGenericWeight extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_sTitle, _fValue, _iUnit, _bAllowNegative) {
    // Input validation
    // ... unit
    if(_iUnit == null or _iUnit < 0 or _iUnit > 1) {
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iUnit = oDeviceSettings.weightUnits;
      }
      else {
        _iUnit = Sys.UNIT_METRIC;
      }
    }
    // ... value
    if(_fValue == null) {
      _fValue = 0.0f;
    }

    // Use user-specified weight unit (NB: SI units are always used internally)
    // PRECISION: 0.1 (* 10)
    var sUnit;
    var iMaxSignificant;
    if(_iUnit == Sys.UNIT_STATUTE) {
      sUnit = "lb";
      iMaxSignificant = 19;
      _fValue *= 22.0462262185f;  // kg -> lb (* 10)
      if(_fValue > 199999.0f) {
        _fValue = 199999.0f;
      }
      else if(_fValue < -199999.0f) {
        _fValue = -199999.0f;
      }
    }
    else {
      sUnit = "kg";
      iMaxSignificant = 9;
      _fValue *= 10.0f;  // kg -> kg (* 10)
      if(_fValue > 99999.0f) {
        _fValue = 99999.0f;
      }
      else if(_fValue < -99999.0f) {
        _fValue = -99999.0f;
      }
    }
    if(!_bAllowNegative and _fValue < 0.0f) {
      _fValue = 0.0f;
    }

    // Split components
    var amValues = new [6];
    amValues[0] = _fValue < 0.0f ? 0 : 1;
    _fValue = _fValue.abs() + 0.05f;
    amValues[5] = _fValue.toNumber() % 10;
    _fValue = _fValue / 10.0f;
    amValues[4] = _fValue.toNumber() % 10;
    _fValue = _fValue / 10.0f;
    amValues[3] = _fValue.toNumber() % 10;
    _fValue = _fValue / 10.0f;
    amValues[2] = _fValue.toNumber() % 10;
    _fValue = _fValue / 10.0f;
    amValues[1] = _fValue.toNumber();

    // Initialize picker
    Picker.initialize({
      :title => new Ui.Text({ :text => Lang.format("$1$ [$2$]", [_sTitle, sUnit]), :font => Gfx.FONT_TINY, :locX=>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color => Gfx.COLOR_BLUE }),
      :pattern => [ _bAllowNegative ? new PickerFactoryDictionary([-1, 1], ["-", "+"], null) : new Ui.Text({}),
                    new PickerFactoryNumber(0, iMaxSignificant, { :langFormat => "$1$'" }),
                    new PickerFactoryNumber(0, 9, null),
                    new PickerFactoryNumber(0, 9, null),
                    new PickerFactoryNumber(0, 9, { :langFormat => "$1$." }),
                    new PickerFactoryNumber(0, 9, null) ],
      :defaults => amValues
    });
  }


  //
  // FUNCTIONS: self
  //

  function getValue(_amValues, _iUnit) {
    // Input validation
    // ... unit
    if(_iUnit == null or _iUnit < 0 or _iUnit > 1) {
      var oDeviceSettings = Sys.getDeviceSettings();
      if(oDeviceSettings has :weightUnits and oDeviceSettings.weightUnits != null) {
        _iUnit = oDeviceSettings.weightUnits;
      }
      else {
        _iUnit = Sys.UNIT_METRIC;
      }
    }

    // Assemble components
    var fValue = _amValues[1]*10000.0f + _amValues[2]*1000.0f + _amValues[3]*100.0f + _amValues[4]*10.0f + _amValues[5];
    if(_amValues[0] != null) {
      fValue *= _amValues[0];
    }

    // Use user-specified weight unit (NB: SI units are always used internally)
    if(_iUnit == Sys.UNIT_STATUTE) {
      fValue /= 22.0462262185f;  // lb (* 10) -> kg
    }
    else {
      fValue /= 10.0f;  // kg (* 10) -> kg
    }

    // Return value
    return fValue;
  }
}
