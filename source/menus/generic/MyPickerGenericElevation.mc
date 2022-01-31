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
using Toybox.WatchUi as Ui;

class MyPickerGenericElevation extends PickerGenericElevation {

  //
  // FUNCTIONS: PickerGenericElevation (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextSettings) {
      if(_item == :itemAltimeterCalibration) {
        PickerGenericElevation.initialize(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationElevation),
                                          $.oMyAltimeter.fAltitudeActual,
                                          $.oMySettings.iUnitElevation,
                                          false);
      }
      else if(_item == :itemAltimeterAlert) {
        PickerGenericElevation.initialize(Ui.loadResource(Rez.Strings.titleAltimeterAlert),
                                          App.Properties.getValue("userAltimeterAlert"),
                                          $.oMySettings.iUnitElevation,
                                          false);
     }
    }
  }

}

class MyPickerGenericElevationDelegate extends Ui.PickerDelegate {

  //
  // VARIABLES
  //

  private var context;
  private var item;


  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize(_context, _item) {
    PickerDelegate.initialize();
    self.context = _context;
    self.item = _item;
  }

  function onAccept(_amValues) {
    var fValue = PickerGenericElevation.getValue(_amValues, $.oMySettings.iUnitElevation);
    if(self.context == :contextSettings) {
      if(self.item == :itemAltimeterCalibration) {
        $.oMyAltimeter.setAltitudeActual(fValue);
        App.Properties.setValue("userAltimeterCalibrationQNH", $.oMyAltimeter.fQNH);
      }
      else if(self.item == :itemAltimeterAlert) {
        App.Properties.setValue("userAltimeterAlert", fValue);
      }
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
