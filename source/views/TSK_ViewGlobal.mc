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
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class TSK_ViewGlobal extends Ui.View {

  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow;

  // Resources
  // ... drawable
  private var oRezDrawableHeader;
  protected var oRezDrawableGlobal;
  // ... header
  private var oRezValueBatteryLevel;
  private var oRezValueActivityStatus;
  // ... fields (labels)
  protected var oRezLabelLeft;
  protected var oRezLabelCenter;
  protected var oRezLabelRight;
  // ... fields (units)
  protected var oRezUnitLeft;
  protected var oRezUnitRight;
  // ... fields (values)
  protected var oRezValueTopLeft;
  protected var oRezValueTopRight;
  protected var oRezValueLeft;
  protected var oRezValueCenter;
  protected var oRezValueRight;
  protected var oRezValueBottomLeft;
  protected var oRezValueBottomRight;
  // ... footer
  protected var oRezValueFooter;
  // ... strings
  private var sValueActivityStandby;
  private var sValueActivityRecording;
  private var sValueActivityPaused;

  // Internals
  protected var iColorText;


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();

    // Display mode
    // ... internal
    self.bShow = false;
  }

  function onLayout(_oDC) {
    //Sys.println("DEBUG: TSK_ViewGlobal.onLayout()");
    View.setLayout(Rez.Layouts.layoutGlobal(_oDC));

    // Load resources
    // ... drawable
    self.oRezDrawableHeader = View.findDrawableById("TSK_DrawableHeader");
    self.oRezDrawableGlobal = View.findDrawableById("TSK_DrawableGlobal");
    // ... header
    self.oRezValueBatteryLevel = View.findDrawableById("valueBatteryLevel");
    self.oRezValueActivityStatus = View.findDrawableById("valueActivityStatus");
    // ... fields (labels)
    self.oRezLabelLeft = View.findDrawableById("labelLeft");
    self.oRezLabelCenter = View.findDrawableById("labelCenter");
    self.oRezLabelRight = View.findDrawableById("labelRight");
    // ... fields (units)
    self.oRezUnitLeft = View.findDrawableById("unitLeft");
    self.oRezUnitRight = View.findDrawableById("unitRight");
    // ... fields (values)
    self.oRezValueTopLeft = View.findDrawableById("valueTopLeft");
    self.oRezValueTopRight = View.findDrawableById("valueTopRight");
    self.oRezValueLeft = View.findDrawableById("valueLeft");
    self.oRezValueCenter = View.findDrawableById("valueCenter");
    self.oRezValueRight = View.findDrawableById("valueRight");
    self.oRezValueBottomLeft = View.findDrawableById("valueBottomLeft");
    self.oRezValueBottomRight = View.findDrawableById("valueBottomRight");
    // ... footer
    self.oRezValueFooter = View.findDrawableById("valueFooter");

    // Done
    return true;
  }

  function onShow() {
    //Sys.println("DEBUG: TSK_ViewGlobal.onShow()");

    // Prepare view
    self.prepare();

    // Done
    self.bShow = true;
    $.TSK_oCurrentView = self;
    return true;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: TSK_ViewGlobal.onUpdate()");

    // Update layout
    self.updateLayout();
    View.onUpdate(_oDC);

    // Done
    return true;
  }

  function onHide() {
    //Sys.println("DEBUG: TSK_ViewGlobal.onHide()");
    $.TSK_oCurrentView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function prepare() {
    //Sys.println("DEBUG: TSK_ViewGlobal.prepare()");

    // Load resources
    // ... strings
    self.sValueActivityStandby = Ui.loadResource(Rez.Strings.valueActivityStandby);
    self.sValueActivityRecording = Ui.loadResource(Rez.Strings.valueActivityRecording);
    self.sValueActivityPaused = Ui.loadResource(Rez.Strings.valueActivityPaused);

    // (Re)load settings
    App.getApp().loadSettings();
    // ... colors
    self.iColorText = $.TSK_oSettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
  }

  function updateUi() {
    //Sys.println("DEBUG: TSK_ViewGlobal.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function updateLayout(_bUpdateTime) {
    //Sys.println("DEBUG: TSK_ViewGlobal.updateLayout()");

    // Set colors
    self.iColorText = $.TSK_oSettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    // ... background
    self.oRezDrawableHeader.setColorBackground($.TSK_oSettings.iGeneralBackgroundColor);

    // Set header/footer values
    var sValue;

    // ... position accuracy
    self.oRezDrawableHeader.setPositionAccuracy($.TSK_oProcessing.iAccuracy);

    // ... battery level
    self.oRezValueBatteryLevel.setColor(self.iColorText);
    self.oRezValueBatteryLevel.setText(Lang.format("$1$%", [Sys.getSystemStats().battery.format("%.0f")]));

    // ... activity status
    if($.TSK_oActivity == null) {  // ... stand-by
      self.oRezValueActivityStatus.setColor(Gfx.COLOR_LT_GRAY);
      sValue = self.sValueActivityStandby;
    }
    else if($.TSK_oActivity.isRecording()) {  // ... recording
      self.oRezValueActivityStatus.setColor(Gfx.COLOR_RED);
      sValue = self.sValueActivityRecording;
    }
    else {  // ... paused
      self.oRezValueActivityStatus.setColor(Gfx.COLOR_YELLOW);
      sValue = self.sValueActivityPaused;
    }
    self.oRezValueActivityStatus.setText(sValue);

    // ... time
    if(_bUpdateTime) {
      var oTimeNow = Time.now();
      var oTimeInfo = $.TSK_oSettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_SHORT) : Gregorian.info(oTimeNow, Time.FORMAT_SHORT);
      self.oRezValueFooter.setColor(self.iColorText);
      self.oRezValueFooter.setText(Lang.format("$1$$2$$3$ $4$", [oTimeInfo.hour.format("%02d"), oTimeNow.value() % 2 ? "." : ":", oTimeInfo.min.format("%02d"), $.TSK_oSettings.sUnitTime]));
    }
  }

}

class TSK_ViewGlobalDelegate extends Ui.BehaviorDelegate {

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: TSK_ViewGlobalDelegate.onMenu()");
    Ui.pushView(new TSK_MenuGeneric(:menuSettings), new TSK_MenuGenericDelegate(:menuSettings), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onSelect() {
    //Sys.println("DEBUG: TSK_ViewGlobalDelegate.onSelect()");
    if($.TSK_oActivity == null) {
      Ui.pushView(new TSK_MenuGenericConfirm(:contextActivity, :actionStart), new TSK_MenuGenericConfirmDelegate(:contextActivity, :actionStart, false), Ui.SLIDE_IMMEDIATE);
    }
    else {
      Ui.pushView(new TSK_MenuGeneric(:menuActivity), new TSK_MenuGenericDelegate(:menuActivity), Ui.SLIDE_IMMEDIATE);
    }
    return true;
  }

  function onBack() {
    //Sys.println("DEBUG: TSK_ViewGlobalDelegate.onBack()");
    if($.TSK_oActivity != null) {  // prevent activity data loss
      return true;
    }
    return false;
  }

}
