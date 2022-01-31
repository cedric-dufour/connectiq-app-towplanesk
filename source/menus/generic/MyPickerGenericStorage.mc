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
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class MyPickerGenericStorage extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_storage, _action) {
    // Retrieve object from storage <-> Picker
    var oPickerDictionary = null;
    var aiStorageKeys = new [$.MY_STORAGE_SLOTS];
    var asStorageValues = new [$.MY_STORAGE_SLOTS];
    var iStorageUsed = 0;
    // ... storage specifics
    var sStorageName = null;
    var sObjectName = null;
    if(_storage == :storageTowplane) {
      sStorageName = "Towplane";
      sObjectName = "callsign";
    }
    else if(_storage == :storageGlider) {
      sStorageName = "Glider";
      sObjectName = "callsign";
    }
    // ... action specifics
    var sStorageAction = null;
    if(_action == :actionSave) {
      sStorageAction = Ui.loadResource(Rez.Strings.titleStorageSave);
      // ... populate all slots
      for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        var d = App.Storage.getValue(Lang.format("stor$1$$2$", [sStorageName, s]));
        aiStorageKeys[n] = n;
        if(d != null) {
          asStorageValues[n] = Lang.format("[$1$]\n$2$", [s, d.get(sObjectName)]);
        }
        else {
          asStorageValues[n] = Lang.format("[$1$]\n---", [s]);
        }
        iStorageUsed++;
      }
      oPickerDictionary = new PickerFactoryDictionary(aiStorageKeys, asStorageValues, {:font => Gfx.FONT_TINY});
    }
    else if(_action == :actionLoad or _action == :actionDelete) {
      sStorageAction =
        _action == :actionLoad
        ? Ui.loadResource(Rez.Strings.titleStorageLoad)
        : Ui.loadResource(Rez.Strings.titleStorageDelete);
      // ... pick existing objects/slots
      for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        var d = App.Storage.getValue(Lang.format("stor$1$$2$", [sStorageName, s]));
        if(d != null) {
          aiStorageKeys[iStorageUsed] = n;
          asStorageValues[iStorageUsed] = Lang.format("[$1$]\n$2$", [s, d.get(sObjectName)]);
          iStorageUsed++;
        }
      }
      if(iStorageUsed > 0) {
        aiStorageKeys = aiStorageKeys.slice(0, iStorageUsed);
        asStorageValues = asStorageValues.slice(0, iStorageUsed);
        oPickerDictionary = new PickerFactoryDictionary(aiStorageKeys, asStorageValues, {:font => Gfx.FONT_TINY});
      }
      else {
        oPickerDictionary = new PickerFactoryDictionary([null], ["-"], {:color => Gfx.COLOR_DK_GRAY});
      }
    }

    // Initialize picker
    if(oPickerDictionary != null) {
      Picker.initialize({
          :title => new Ui.Text({
              :text => sStorageAction,
              :font => Gfx.FONT_TINY,
              :locX => Ui.LAYOUT_HALIGN_CENTER,
              :locY => Ui.LAYOUT_VALIGN_BOTTOM,
              :color => Gfx.COLOR_BLUE}),
          :pattern => [oPickerDictionary]});
    }
  }

}

class MyPickerGenericStorageDelegate extends Ui.PickerDelegate {

  //
  // VARIABLES
  //

  private var storage;
  private var action;


  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize(_storage, _action) {
    PickerDelegate.initialize();
    self.storage = _storage;
    self.action = _action;
  }

  function onAccept(_amValues) {
    // Save/load/delete object to/from storage
    if(_amValues[0] != null) {
      var s = _amValues[0].format("%02d");
      // ... storage specifics
      var sStorageName = null;
      if(self.storage == :storageTowplane) {
        sStorageName = "Towplane";
        if(self.action == :actionSave) {
          var o = $.oMyTowplane != null ? $.oMyTowplane : new MyTowplane({});
          App.Storage.setValue(Lang.format("stor$1$$2$", [sStorageName, s]), o.export());
        }
        else if(self.action == :actionLoad) {
          if($.oMyTowplane == null) {
            $.oMyTowplane = new MyTowplane({});
          }
          $.oMyTowplane.import(App.Storage.getValue(Lang.format("stor$1$$2$", [sStorageName, s])));
        }
        else if(self.action == :actionDelete) {
          App.Storage.deleteValue(Lang.format("stor$1$$2$", [sStorageName, s]));
        }
      }
      else if(self.storage == :storageGlider) {
        sStorageName = "Glider";
        if(self.action == :actionSave) {
          var o = $.oMyGlider != null ? $.oMyGlider : new MyGlider({});
          App.Storage.setValue(Lang.format("stor$1$$2$", [sStorageName, s]), o.export());
        }
        else if(self.action == :actionLoad) {
          if($.oMyGlider == null) {
            $.oMyGlider = new MyGlider({});
          }
          $.oMyGlider.import(App.Storage.getValue(Lang.format("stor$1$$2$", [sStorageName, s])));
        }
        else if(self.action == :actionDelete) {
          App.Storage.deleteValue(Lang.format("stor$1$$2$", [sStorageName, s]));
        }
      }
    }

    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
