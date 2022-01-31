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

using Toybox.WatchUi as Ui;

class MyPickerGenericFuelFlow extends PickerGenericFuelFlow {

  //
  // FUNCTIONS: PickerGenericFuelFlow (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextTowplane) {
      var oTowplane = $.oMyTowplane != null ? $.oMyTowplane : new MyTowplane({});
      if(_item == :itemFuelFlowGround) {
        PickerGenericFuelFlow.initialize(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowGround),
                                         oTowplane.fFuelFlowGround,
                                         $.oMySettings.iUnitFuel,
                                         false);
      }
      else if(_item == :itemFuelFlowAirborne) {
        PickerGenericFuelFlow.initialize(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowAirborne),
                                         oTowplane.fFuelFlowAirborne,
                                         $.oMySettings.iUnitFuel,
                                         false);
      }
      else if(_item == :itemFuelFlowTowing) {
        PickerGenericFuelFlow.initialize(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowTowing),
                                         oTowplane.fFuelFlowTowing,
                                         $.oMySettings.iUnitFuel,
                                         false);
      }
    }
  }

}

class MyPickerGenericFuelFlowDelegate extends Ui.PickerDelegate {

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
    var fValue = PickerGenericFuelFlow.getValue(_amValues, $.oMySettings.iUnitFuel);
    if(self.context == :contextTowplane) {
      if($.oMyTowplane == null) {
        $.oMyTowplane = new MyTowplane({});
      }
      if(self.item == :itemFuelFlowGround) {
        $.oMyTowplane.setFuelFlowGround(fValue);
      }
      else if(self.item == :itemFuelFlowAirborne) {
        $.oMyTowplane.setFuelFlowAirborne(fValue);
      }
      else if(self.item == :itemFuelFlowTowing) {
        $.oMyTowplane.setFuelFlowTowing(fValue);
      }
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
