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
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

// NOTE: Since Ui.Confirmation does not allow to pre-select "Yes" as an answer,
//       let's us our own "confirmation" menu and save one key press
class MyMenuGenericConfirm extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize(_context as Symbol, _action as Symbol) {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleConfirm) as String);
    if(_context == :contextActivity) {

      if(_action == :actionStart) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleActivityStart)]), :menuNone);
      }
      else if(_action == :actionSave) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleActivitySave)]), :menuNone);
      }
      else if(_action == :actionDiscard) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleActivityDiscard)]), :menuNone);
      }

    }
    else if(_context == :contextTimer) {

      if(_action == :actionReset) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerReset)]), :menuNone);
      }
      else if(_action == :actionAddCycle) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerAddCycle)]), :menuNone);
      }
      else if(_action == :actionUndoCycle) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerUndoCycle)]), :menuNone);
      }
      else if(_action == :actionSave) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerSave)]), :menuNone);
      }
      else if(_action == :actionDiscard) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerDiscard)]), :menuNone);
      }

    }
    else if(_context == :contextStorage) {

      if(_action == :actionClearTowplanes) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleStorageClearTowplanes)]), :menuNone);
      }
      else if(_action == :actionClearGliders) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleStorageClearGliders)]), :menuNone);
      }
      else if(_action == :actionClearLogs) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleStorageClearLogs)]), :menuNone);
      }

    }
    else if(_context == :contextGlider) {

      if(_action == :actionClear) {
        Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleAircraftClear)]), :menuNone);
      }

    }
  }

}

class MyMenuGenericConfirmDelegate extends Ui.MenuInputDelegate {

  //
  // VARIABLES
  //

  private var context as Symbol = :contextNone;
  private var action as Symbol = :actionNone;
  private var popout as Boolean = true;


  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize(_context as Symbol, _action as Symbol, _popout as Boolean) {
    MenuInputDelegate.initialize();
    self.context = _context;
    self.action = _action;
    self.popout = _popout;
  }

  function onMenuItem(_item) {
    if(self.context == :contextActivity) {

      if(self.action == :actionStart) {
        if($.oMyActivity == null) {
          $.oMyActivity = new MyActivity();
          ($.oMyActivity as MyActivity).start();
        }
      }
      else if(self.action == :actionSave) {
        if($.oMyActivity != null) {
          ($.oMyActivity as MyActivity).stop(true);
          $.oMyActivity = null;
        }
      }
      else if(self.action == :actionDiscard) {
        if($.oMyActivity != null) {
          ($.oMyActivity as MyActivity).stop(false);
          $.oMyActivity = null;
        }
      }

    }
    else if(self.context == :contextTimer) {

      if(self.action == :actionReset) {
        $.oMyTimer.reset();
      }
      else if(self.action == :actionAddCycle) {
        $.oMyTimer.addCycle();
      }
      else if(self.action == :actionUndoCycle) {
        $.oMyTimer.undoCycle();
      }
      else if(self.action == :actionSave) {
        $.oMyTimer.log();
      }
      else if(self.action == :actionDiscard) {
        $.oMyTimer.reset();
      }

    }
    else if(self.context == :contextStorage) {

      if(self.action == :actionClearTowplanes) {
        (App.getApp() as MyApp).clearStorageTowplanes();
      }
      else if(self.action == :actionClearGliders) {
        (App.getApp() as MyApp).clearStorageGliders();
      }
      else if(self.action == :actionClearLogs) {
        (App.getApp() as MyApp).clearStorageLogs();
      }

    }
    else if(self.context == :contextGlider) {

      if(self.action == :actionClear) {
        App.Storage.deleteValue("storGliderInUse");
        $.oMyGlider = null;
      }

    }
    if(self.popout) {
      Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
  }

}
