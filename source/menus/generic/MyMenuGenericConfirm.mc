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

// NOTE: Since Ui.Confirmation does not allow to pre-select "Yes" as an answer,
//       let's us our own "confirmation" menu and save one key press
class MyMenuGenericConfirm extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize(_context, _action) {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleConfirm));
    if(_context == :contextActivity) {
      if(_action == :actionStart) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleActivityStart)]), 0);
      }
      else if(_action == :actionSave) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleActivitySave)]), 0);
      }
      else if(_action == :actionDiscard) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleActivityDiscard)]), 0);
      }
    }
    else if(_context == :contextTimer) {
      if(_action == :actionReset) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerReset)]), 0);
      }
      else if(_action == :actionAddCycle) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerAddCycle)]), 0);
      }
      else if(_action == :actionUndoCycle) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerUndoCycle)]), 0);
      }
      else if(_action == :actionSave) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerSave)]), 0);
      }
      else if(_action == :actionDiscard) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleTimerDiscard)]), 0);
      }
    }
    else if(_context == :contextStorage) {
      if(_action == :actionClear) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleStorageClear)]), 0);
      }
    }
    else if(_context == :contextGlider) {
      if(_action == :actionClear) {
        Menu.addItem(Lang.format("$1$ ?", [Ui.loadResource(Rez.Strings.titleAircraftClear)]), 0);
      }
    }
  }

}

class MyMenuGenericConfirmDelegate extends Ui.MenuInputDelegate {

  //
  // VARIABLES
  //

  private var context;
  private var action;
  private var popout;


  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize(_context, _action, _popout) {
    MenuInputDelegate.initialize();
    self.context = _context;
    self.action = _action;
    self.popout = _popout;
  }

  function onMenuItem(item) {
    if(self.context == :contextActivity) {
      if(self.action == :actionStart) {
        if($.oMyActivity == null) {
          $.oMyActivity = new MyActivity();
          $.oMyActivity.start();
        }
      }
      else if(self.action == :actionSave) {
        if($.oMyActivity != null) {
          $.oMyActivity.stop(true);
          $.oMyActivity = null;
        }
      }
      else if(self.action == :actionDiscard) {
        if($.oMyActivity != null) {
          $.oMyActivity.stop(false);
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
      if(self.action == :actionClear) {
        App.getApp().clearStorageData();
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
