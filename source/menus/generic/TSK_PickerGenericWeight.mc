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

class TSK_PickerGenericWeight extends PickerGenericWeight {

  //
  // FUNCTIONS: PickerGenericWeight (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextTowplane) {
      var oTowplane = $.TSK_oTowplane != null ? $.TSK_oTowplane : new TSK_Towplane({});
      if(_item == :itemWeightEmpty) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty), oTowplane.fWeightEmpty, $.TSK_oSettings.iUnitWeight, false);
      }
      else if(_item == :itemWeightPayload) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload), oTowplane.fWeightPayload, $.TSK_oSettings.iUnitWeight, false);
      }
      else if(_item == :itemWeightMaxTakeoff) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff), oTowplane.fWeightMaxTakeoff, $.TSK_oSettings.iUnitWeight, false);
      }
      else if(_item == :itemWeightMaxTowing) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowing), oTowplane.fWeightMaxTowing, $.TSK_oSettings.iUnitWeight, false);
      }
      else if(_item == :itemWeightMaxTowed) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowed), oTowplane.fWeightMaxTowed, $.TSK_oSettings.iUnitWeight, false);
      }
    }
    else if(_context == :contextGlider) {
      var oGlider = $.TSK_oGlider != null ? $.TSK_oGlider : new TSK_Glider({});
      if(_item == :itemWeightEmpty) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty), oGlider.fWeightEmpty, $.TSK_oSettings.iUnitWeight, false);
      }
      else if(_item == :itemWeightPayload) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload), oGlider.fWeightPayload, $.TSK_oSettings.iUnitWeight, false);
      }
      else if(_item == :itemWeightBallast) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightBallast), oGlider.fWeightBallast, $.TSK_oSettings.iUnitWeight, false);
      }
      else if(_item == :itemWeightMaxTakeoff) {
        PickerGenericWeight.initialize(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff), oGlider.fWeightMaxTakeoff, $.TSK_oSettings.iUnitWeight, false);
      }
    }
  }

}

class TSK_PickerGenericWeightDelegate extends Ui.PickerDelegate {

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
    var fValue = PickerGenericWeight.getValue(_amValues, $.TSK_oSettings.iUnitWeight);
    if(self.context == :contextTowplane) {
      if($.TSK_oTowplane == null) {
        $.TSK_oTowplane = new TSK_Towplane({});
      }
      if(self.item == :itemWeightEmpty) {
        $.TSK_oTowplane.setWeightEmpty(fValue);
      }
      else if(self.item == :itemWeightPayload) {
        $.TSK_oTowplane.setWeightPayload(fValue);
      }
      else if(self.item == :itemWeightMaxTakeoff) {
        $.TSK_oTowplane.setWeightMaxTakeoff(fValue);
      }
      else if(self.item == :itemWeightMaxTowing) {
        $.TSK_oTowplane.setWeightMaxTowing(fValue);
      }
      else if(self.item == :itemWeightMaxTowed) {
        $.TSK_oTowplane.setWeightMaxTowed(fValue);
      }
    }
    else if(self.context == :contextGlider) {
      if($.TSK_oGlider == null) {
        $.TSK_oGlider = new TSK_Glider({});
      }
      if(self.item == :itemWeightEmpty) {
        $.TSK_oGlider.setWeightEmpty(fValue);
      }
      else if(self.item == :itemWeightPayload) {
        $.TSK_oGlider.setWeightPayload(fValue);
      }
      else if(self.item == :itemWeightBallast) {
        $.TSK_oGlider.setWeightBallast(fValue);
      }
      else if(self.item == :itemWeightMaxTakeoff) {
        $.TSK_oGlider.setWeightMaxTakeoff(fValue);
      }
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
