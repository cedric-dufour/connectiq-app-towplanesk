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

class MyPickerGenericText extends Ui.TextPicker {

  //
  // FUNCTIONS: Ui.TextPicker (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextTowplane) {
      var oTowplane = $.oMyTowplane != null ? $.oMyTowplane : new MyTowplane({});
      if(_item == :itemCallsign) {
        TextPicker.initialize(oTowplane.sCallsign);
      }
    }
    else if(_context == :contextGlider) {
      var oGlider = $.oMyGlider != null ? $.oMyGlider : new MyGlider({});
      if(_item == :itemCallsign) {
        TextPicker.initialize(oGlider.sCallsign);
      }
    }
    else if(_context == :contextStorage) {
      if(_item == :itemImportData) {
        TextPicker.initialize("");
      }
    }
  }

}

class MyPickerGenericTextDelegate extends Ui.TextPickerDelegate {

  //
  // VARIABLES
  //

  private var context;
  private var item;


  //
  // FUNCTIONS: Ui.TextPickerDelegate (override/implement)
  //

  function initialize(_context, _item) {
    TextPickerDelegate.initialize();
    self.context = _context;
    self.item = _item;
  }

  function onTextEntered(_sText, _bChanged) {
    if(self.context == :contextTowplane) {
      if($.oMyTowplane == null) {
        $.oMyTowplane = new MyTowplane({});
      }
      if(self.item == :itemCallsign) {
        $.oMyTowplane.setCallsign(_sText);
      }
    }
    else if(self.context == :contextGlider) {
      if($.oMyGlider == null) {
        $.oMyGlider = new MyGlider({});
      }
      if(self.item == :itemCallsign) {
        $.oMyGlider.setCallsign(_sText);
      }
    }
    else if(self.context == :contextStorage) {
      if(self.item == :itemImportData) {
        App.getApp().importStorageData(_sText);
      }
    }
  }

}
