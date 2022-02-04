// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Towplane Swiss Knife (TowplaneSK)
// Copyright (C) 2019-2022 Cedric Dufour <http://cedric.dufour.name>
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
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class MyPickerGenericOnOff extends PickerGenericOnOff {

  //
  // FUNCTIONS: PickerGenericOnOff (override/implement)
  //

  function initialize(_context as Symbol, _item as Symbol) {
    if(_context == :contextSettings) {

      if(_item == :itemTimerAutoLog) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleTimerAutoLog) as String,
                                      $.oMySettings.loadTimerAutoLog());
      }
      else if(_item == :itemTimerAutoActivity) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleTimerAutoActivity) as String,
                                      $.oMySettings.loadTimerAutoActivity());
      }
      else if(_item == :itemNotificationsAltimeter) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleNotificationsAltimeter) as String,
                                      $.oMySettings.loadNotificationsAltimeter());
      }
      else if(_item == :itemNotificationsTemperature) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleNotificationsTemperature) as String,
                                      $.oMySettings.loadNotificationsTemperature());
      }
      else if(_item == :itemNotificationsFuel) {
        PickerGenericOnOff.initialize(Ui.loadResource(Rez.Strings.titleNotificationsFuel) as String,
                                      $.oMySettings.loadNotificationsFuel());
      }

    }
  }

}

class MyPickerGenericOnOffDelegate extends Ui.PickerDelegate {

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
    var bValue = PickerGenericOnOff.getValue(_amValues);
    if(self.context == :contextSettings) {

      if(self.item == :itemTimerAutoLog) {
        $.oMySettings.saveTimerAutoLog(bValue);
      }
      else if(self.item == :itemTimerAutoActivity) {
        $.oMySettings.saveTimerAutoActivity(bValue);
      }
      else if(self.item == :itemNotificationsAltimeter) {
        $.oMySettings.saveNotificationsAltimeter(bValue);
      }
      else if(self.item == :itemNotificationsTemperature) {
        $.oMySettings.saveNotificationsTemperature(bValue);
      }
      else if(self.item == :itemNotificationsFuel) {
        $.oMySettings.saveNotificationsFuel(bValue);
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
