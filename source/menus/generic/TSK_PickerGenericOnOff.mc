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

class TSK_PickerGenericOnOff extends PickerGenericOnOff {

  //
  // FUNCTIONS: PickerGenericOnOff (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextSettings) {
      if(_item == :itemTimerAutoLog) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleTimerAutoLog), App.Properties.getValue("userTimerAutoLog"));
      }
      else if(_item == :itemNotificationsAltimeter) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleNotificationsAltimeter), App.Properties.getValue("userNotificationsAltimeter"));
      }
      else if(_item == :itemNotificationsTemperature) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleNotificationsTemperature), App.Properties.getValue("userNotificationsTemperature"));
      }
      else if(_item == :itemNotificationsFuel) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleNotificationsFuel), App.Properties.getValue("userNotificationsFuel"));
      }
    }
  }

}

class TSK_PickerGenericOnOffDelegate extends Ui.PickerDelegate {

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
    var bValue = PickerGenericOnOff.getValue(_amValues);
    if(self.context == :contextSettings) {
      if(self.item == :itemTimerAutoLog) {
        App.Properties.setValue("userTimerAutoLog", bValue);
      }
      else if(self.item == :itemNotificationsAltimeter) {
        App.Properties.setValue("userNotificationsAltimeter", bValue);
      }
      else if(self.item == :itemNotificationsTemperature) {
        App.Properties.setValue("userNotificationsTemperature", bValue);
      }
      else if(self.item == :itemNotificationsFuel) {
        App.Properties.setValue("userNotificationsFuel", bValue);
      }
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
