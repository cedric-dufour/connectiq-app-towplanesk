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

class MyPickerGenericSpeed extends PickerGenericSpeed {

  //
  // FUNCTIONS: PickerGenericSpeed (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextSettings) {
      if(_item == :itemWindSpeed) {
        PickerGenericSpeed.initialize(Ui.loadResource(Rez.Strings.titleWindSpeed),
                                      App.Properties.getValue("userWindSpeed"),
                                      $.oMySettings.iUnitDistance,
                                      false);
      }
    }
    else if(_context == :contextTowplane) {
      var oTowplane = $.oMyTowplane != null ? $.oMyTowplane : new MyTowplane({});
      if(_item == :itemSpeedOffBlock) {
        PickerGenericSpeed.initialize(Ui.loadResource(Rez.Strings.titleAircraftSpeedOffBlock),
                                      oTowplane.fSpeedOffBlock,
                                      $.oMySettings.iUnitDistance,
                                      false);
      }
      else if(_item == :itemSpeedTakeoff) {
        PickerGenericSpeed.initialize(Ui.loadResource(Rez.Strings.titleAircraftSpeedTakeoff),
                                      oTowplane.fSpeedTakeoff,
                                      $.oMySettings.iUnitDistance,
                                      false);
      }
      else if(_item == :itemSpeedLanding) {
        PickerGenericSpeed.initialize(Ui.loadResource(Rez.Strings.titleAircraftSpeedLanding),
                                      oTowplane.fSpeedLanding,
                                      $.oMySettings.iUnitDistance,
                                      false);
      }
      else if(_item == :itemSpeedMaxTowing) {
        PickerGenericSpeed.initialize(Ui.loadResource(Rez.Strings.titleAircraftSpeedMaxTowing),
                                      oTowplane.fSpeedMaxTowing,
                                      $.oMySettings.iUnitDistance,
                                      false);
      }
    }
    else if(_context == :contextGlider) {
      var oGlider = $.oMyGlider != null ? $.oMyGlider : new MyGlider({});
      if(_item == :itemSpeedTowing) {
        PickerGenericSpeed.initialize(Ui.loadResource(Rez.Strings.titleAircraftSpeedTowing),
                                      oGlider.fSpeedTowing,
                                      $.oMySettings.iUnitDistance,
                                      false);
      }
    }
  }

}

class MyPickerGenericSpeedDelegate extends Ui.PickerDelegate {

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
    var fValue = PickerGenericSpeed.getValue(_amValues, $.oMySettings.iUnitDistance);
    if(self.context == :contextSettings) {
      if(self.item == :itemWindSpeed) {
        App.Properties.setValue("userWindSpeed", fValue);
      }
    }
    else if(self.context == :contextTowplane) {
      if($.oMyTowplane == null) {
        $.oMyTowplane = new MyTowplane({});
      }
      if(self.item == :itemSpeedOffBlock) {
        $.oMyTowplane.setSpeedOffBlock(fValue);
      }
      else if(self.item == :itemSpeedTakeoff) {
        $.oMyTowplane.setSpeedTakeoff(fValue);
      }
      else if(self.item == :itemSpeedLanding) {
        $.oMyTowplane.setSpeedLanding(fValue);
      }
      else if(self.item == :itemSpeedMaxTowing) {
        $.oMyTowplane.setSpeedMaxTowing(fValue);
      }
    }
    else if(self.context == :contextGlider) {
      if($.oMyGlider == null) {
        $.oMyGlider = new MyGlider({});
      }
      if(self.item == :itemSpeedTowing) {
        $.oMyGlider.setSpeedTowing(fValue);
      }
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
