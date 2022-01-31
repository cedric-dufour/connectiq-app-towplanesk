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

class MyPickerGenericWeight extends PickerGenericWeight {

  //
  // FUNCTIONS: PickerGenericWeight (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextTowplane) {
      var oTowplane = $.oMyTowplane != null ? $.oMyTowplane : new MyTowplane({});
      if(_item == :itemWeightEmpty) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty),
                                       oTowplane.fWeightEmpty,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
      else if(_item == :itemWeightPayload) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload),
                                       oTowplane.fWeightPayload,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
      else if(_item == :itemWeightMaxTakeoff) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff),
                                       oTowplane.fWeightMaxTakeoff,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
      else if(_item == :itemWeightMaxTowing) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowing),
                                       oTowplane.fWeightMaxTowing,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
      else if(_item == :itemWeightMaxTowed) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowed),
                                       oTowplane.fWeightMaxTowed,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
    }
    else if(_context == :contextGlider) {
      var oGlider = $.oMyGlider != null ? $.oMyGlider : new MyGlider({});
      if(_item == :itemWeightEmpty) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty),
                                       oGlider.fWeightEmpty,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
      else if(_item == :itemWeightPayload) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload),
                                       oGlider.fWeightPayload,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
      else if(_item == :itemWeightBallast) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightBallast),
                                       oGlider.fWeightBallast,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
      else if(_item == :itemWeightMaxTakeoff) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff),
                                       oGlider.fWeightMaxTakeoff,
                                       $.oMySettings.iUnitWeight,
                                       false);
      }
    }
  }

}

class MyPickerGenericWeightDelegate extends Ui.PickerDelegate {

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
    var fValue = PickerGenericWeight.getValue(_amValues, $.oMySettings.iUnitWeight);
    if(self.context == :contextTowplane) {
      if($.oMyTowplane == null) {
        $.oMyTowplane = new MyTowplane({});
      }
      if(self.item == :itemWeightEmpty) {
        $.oMyTowplane.setWeightEmpty(fValue);
      }
      else if(self.item == :itemWeightPayload) {
        $.oMyTowplane.setWeightPayload(fValue);
      }
      else if(self.item == :itemWeightMaxTakeoff) {
        $.oMyTowplane.setWeightMaxTakeoff(fValue);
      }
      else if(self.item == :itemWeightMaxTowing) {
        $.oMyTowplane.setWeightMaxTowing(fValue);
      }
      else if(self.item == :itemWeightMaxTowed) {
        $.oMyTowplane.setWeightMaxTowed(fValue);
      }
    }
    else if(self.context == :contextGlider) {
      if($.oMyGlider == null) {
        $.oMyGlider = new MyGlider({});
      }
      if(self.item == :itemWeightEmpty) {
        $.oMyGlider.setWeightEmpty(fValue);
      }
      else if(self.item == :itemWeightPayload) {
        $.oMyGlider.setWeightPayload(fValue);
      }
      else if(self.item == :itemWeightBallast) {
        $.oMyGlider.setWeightBallast(fValue);
      }
      else if(self.item == :itemWeightMaxTakeoff) {
        $.oMyGlider.setWeightMaxTakeoff(fValue);
      }
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
