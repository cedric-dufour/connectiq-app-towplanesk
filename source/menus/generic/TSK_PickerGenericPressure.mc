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

class TSK_PickerGenericPressure extends PickerGenericPressure {

  //
  // FUNCTIONS: PickerGenericPressure (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextSettings) {
      if(_item == :itemAltimeterCalibration) {
        PickerGenericPressure.initialize(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationQNH), $.TSK_oAltimeter.fQNH, $.TSK_oSettings.iUnitPressure, false);
      }
      else if(_item == :itemAltimeterCorrection) {
        PickerGenericPressure.initialize(Ui.loadResource(Rez.Strings.titleAltimeterCorrectionAbsolute), App.Properties.getValue("userAltimeterCorrectionAbsolute"), $.TSK_oSettings.iUnitPressure, true);
      }
    }
  }

}

class TSK_PickerGenericPressureDelegate extends Ui.PickerDelegate {

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
    var fValue = PickerGenericPressure.getValue(_amValues, $.TSK_oSettings.iUnitPressure);
    if(self.context == :contextSettings) {
      if(self.item == :itemAltimeterCalibration) {
        $.TSK_oAltimeter.setQNH(fValue);
        App.Properties.setValue("userAltimeterCalibrationQNH", $.TSK_oAltimeter.fQNH);
      }
      else if(self.item == :itemAltimeterCorrection) {
        App.Properties.setValue("userAltimeterCorrectionAbsolute", fValue);
      }
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
