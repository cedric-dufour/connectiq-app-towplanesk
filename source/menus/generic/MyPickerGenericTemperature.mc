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
using Toybox.WatchUi as Ui;

class MyPickerGenericTemperature extends PickerGenericTemperature {

  //
  // FUNCTIONS: PickerGenericTemperature (override/implement)
  //

  function initialize(_context as Symbol, _item as Symbol) {
    if(_context == :contextSettings) {

      if(_item == :itemTemperatureCalibration) {
        PickerGenericTemperature.initialize(Ui.loadResource(Rez.Strings.titleTemperatureCalibration) as String,
                                            $.oMyAltimeter.fTemperatureActual,
                                            $.oMySettings.iUnitTemperature,
                                            true);
      }
      else if(_item == :itemTemperatureAlert) {
        PickerGenericTemperature.initialize(Ui.loadResource(Rez.Strings.titleTemperatureAlert) as String,
                                            $.oMySettings.loadTemperatureAlert(),
                                            $.oMySettings.iUnitTemperature,
                                            true);
      }

    }
  }

}

class MyPickerGenericTemperatureDelegate extends Ui.PickerDelegate {

  //
  // VARIABLES
  //

  private var context as Symbol = :contextNone;
  private var item as Symbol = :itemNone;


  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize(_context as Symbol, _item as Symbol) {
    PickerDelegate.initialize();
    self.context = _context;
    self.item = _item;
  }

  function onAccept(_amValues) {
    var fValue = PickerGenericTemperature.getValue(_amValues, $.oMySettings.iUnitTemperature);
    if(self.context == :contextSettings) {

      if(self.item == :itemTemperatureCalibration) {
        fValue -= $.oMyAltimeter.fTemperatureISA;
        $.oMySettings.saveTemperatureISAOffset(fValue);
      }
      else if(self.item == :itemTemperatureAlert) {
        $.oMySettings.saveTemperatureAlert(fValue);
      }

    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
