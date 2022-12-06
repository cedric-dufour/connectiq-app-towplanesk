// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Generic ConnectIQ Helpers/Resources (CIQ Helpers)
// Copyright (C) 2017-2022 Cedric Dufour <http://cedric.dufour.name>
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

import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class PickerGenericHeading extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_sTitle as String, _fValue as Float?, _iUnit as Number?, _bAllowNegative as Boolean) {
    // Input validation
    // ... unit
    var iUnit = _iUnit != null ? _iUnit : -1;
    if(iUnit < 0 or iUnit > 1) {
      iUnit = 0;
    }
    // ... value
    var fValue = (_fValue != null and LangUtils.notNaN(_fValue)) ? _fValue : 0.0f;

    // Use user-specified heading unit (NB: radians are always used internally)
    // PRECISION: 1.0
    var sUnit = "°";
    var iMaxSignificant = 3;
    if(iUnit == 1) {  // mil
      sUnit = "mil";
      iMaxSignificant = 9;
      fValue *= 159.154943092f;  // rad -> mil
      if(fValue > 999.0f) {
        fValue = 999.0f;
      }
      else if(fValue < -999.0f) {
        fValue = -999.0f;
      }
    }
    else {  // degrees
      fValue *= 57.2957795131f;  // rad -> deg
      if(fValue > 359.0f) {
        fValue = 359.0f;
      }
      else if(fValue < -359.0f) {
        fValue = -359.0f;
      }
    }
    if(!_bAllowNegative and fValue < 0.0f) {
      fValue = 0.0f;
    }

    // Split components
    var aiValues = new Array<Number>[4];
    aiValues[0] = fValue < 0.0f ? 0 : 1;
    fValue = fValue.abs() + 0.05f;
    aiValues[3] = fValue.toNumber() % 10;
    fValue = fValue / 10.0f;
    aiValues[2] = fValue.toNumber() % 10;
    fValue = fValue / 10.0f;
    aiValues[1] = fValue.toNumber();

    // Initialize picker
    Picker.initialize({
        :title => new Ui.Text({
            :text => format("$1$ [$2$]", [_sTitle, sUnit]),
            :font => Gfx.FONT_TINY,
            :locX => Ui.LAYOUT_HALIGN_CENTER,
            :locY => Ui.LAYOUT_VALIGN_BOTTOM,
            :color => Gfx.COLOR_BLUE}),
        :pattern => [_bAllowNegative ? new PickerFactoryDictionary([-1, 1], ["-", "+"], null) : new Ui.Text({}),
                     new PickerFactoryNumber(0, iMaxSignificant, null),
                     new PickerFactoryNumber(0, 9, null),
                     new PickerFactoryNumber(0, 9, null)],
        :defaults => aiValues});
  }


  //
  // FUNCTIONS: self
  //

  function getValue(_amValues as Array, _iUnit as Number?) as Float {
    // Input validation
    // ... unit
    var iUnit = _iUnit != null ? _iUnit : -1;
    if(iUnit < 0 or iUnit > 1) {
      iUnit = 0;
    }

    // Assemble components
    var aiValues = _amValues as Array<Number?>;
    var fValue =
      LangUtils.asNumber(aiValues[1], 0)*100.0f
      + LangUtils.asNumber(aiValues[2], 0)*10.0f
      + LangUtils.asNumber(aiValues[3], 0);
    fValue *= LangUtils.asNumber(aiValues[0], 1);

    // Use user-specified heading unit (NB: radians are always used internally)
    if(iUnit == 1) {  // mil
      fValue /= 159.154943092f;  // mil -> rad
    }
    else {  // degrees
      fValue /= 57.2957795131f;  // deg -> rad
    }

    // Return value
    return fValue;
  }
}
