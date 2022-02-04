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
using Toybox.WatchUi as Ui;

class MyPickerGenericFuel extends PickerGenericFuel {

  //
  // FUNCTIONS: PickerGenericFuel (override/implement)
  //

  function initialize(_context as Symbol, _item as Symbol) {
    if(_context == :contextTowplane) {

      if(_item == :itemFuelQuantity) {
        PickerGenericFuel.initialize(Ui.loadResource(Rez.Strings.titleAircraftFuelQuantity) as String,
                                     $.oMyTowplane.fFuelQuantity,
                                     $.oMySettings.iUnitFuel,
                                     false);
      }
      else if(_item == :itemFuelAlert) {
        PickerGenericFuel.initialize(Ui.loadResource(Rez.Strings.titleAircraftFuelAlert) as String,
                                     $.oMyTowplane.fFuelAlert,
                                     $.oMySettings.iUnitFuel,
                                     false);
      }

    }
  }

}

class MyPickerGenericFuelDelegate extends Ui.PickerDelegate {

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
    var fValue = PickerGenericFuel.getValue(_amValues, $.oMySettings.iUnitFuel);
    if(self.context == :contextTowplane) {

      if(self.item == :itemFuelQuantity) {
        $.oMyTowplane.setFuelQuantity(fValue);
      }
      else if(self.item == :itemFuelAlert) {
        $.oMyTowplane.setFuelAlert(fValue);
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
