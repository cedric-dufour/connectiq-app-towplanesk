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
using Toybox.Graphics as Gfx;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class MyView extends Ui.View {

  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow as Boolean = false;

  // Resources
  // ... drawable
  private var oRezDrawableHeader as MyDrawableHeader?;
  protected var oRezDrawableGlobal as MyDrawableGlobal?;
  // ... header
  private var oRezValueBatteryLevel as Ui.Text?;
  private var oRezValueActivityStatus as Ui.Text?;
  // ... fields (labels)
  protected var oRezLabelLeft as Ui.Text?;
  protected var oRezLabelCenter as Ui.Text?;
  protected var oRezLabelRight as Ui.Text?;
  // ... fields (units)
  protected var oRezUnitLeft as Ui.Text?;
  protected var oRezUnitRight as Ui.Text?;
  // ... fields (values)
  protected var oRezValueTopLeft as Ui.Text?;
  protected var oRezValueTopRight as Ui.Text?;
  protected var oRezValueLeft as Ui.Text?;
  protected var oRezValueCenter as Ui.Text?;
  protected var oRezValueRight as Ui.Text?;
  protected var oRezValueBottomLeft as Ui.Text?;
  protected var oRezValueBottomRight as Ui.Text?;
  // ... footer
  protected var oRezValueFooter as Ui.Text?;
  // ... strings
  protected var sValueActivityStandby as String = "SBY";
  protected var sValueActivityRecording as String = "REC";
  protected var sValueActivityPaused as String = "PSD";
  protected var sLabelCallsignTowplane as String = "Towplane";
  protected var sLabelCallsignGlider as String = "Glider";

  // Internals
  protected var iColorText as Number = Gfx.COLOR_BLACK;
  // ... fields
  protected var bTitleShow as Boolean = true;
  protected var iFieldIndex as Number = 0;
  protected var iFieldEpoch as Number = -1;


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();

    // Internals
    // ... fields
    self.iFieldEpoch = Time.now().value();
  }

  function onLayout(_oDC) {
    //Sys.println("DEBUG: MyView.onLayout()");
    View.setLayout(Rez.Layouts.layoutGlobal(_oDC));

    // Load resources
    // ... drawable
    self.oRezDrawableHeader = View.findDrawableById("MyDrawableHeader") as MyDrawableHeader;
    self.oRezDrawableGlobal = View.findDrawableById("MyDrawableGlobal") as MyDrawableGlobal;
    // ... header
    self.oRezValueBatteryLevel = View.findDrawableById("valueBatteryLevel") as Ui.Text;
    self.oRezValueActivityStatus = View.findDrawableById("valueActivityStatus") as Ui.Text;
    // ... fields (labels)
    self.oRezLabelLeft = (View.findDrawableById("labelLeft") as Ui.Text) as Ui.Text;
    self.oRezLabelCenter = View.findDrawableById("labelCenter") as Ui.Text;
    self.oRezLabelRight = View.findDrawableById("labelRight") as Ui.Text;
    // ... fields (units)
    self.oRezUnitLeft = View.findDrawableById("unitLeft") as Ui.Text;
    self.oRezUnitRight = View.findDrawableById("unitRight") as Ui.Text;
    // ... fields (values)
    self.oRezValueTopLeft = View.findDrawableById("valueTopLeft") as Ui.Text;
    self.oRezValueTopRight = View.findDrawableById("valueTopRight") as Ui.Text;
    self.oRezValueLeft = View.findDrawableById("valueLeft") as Ui.Text;
    self.oRezValueCenter = View.findDrawableById("valueCenter") as Ui.Text;
    self.oRezValueRight = View.findDrawableById("valueRight") as Ui.Text;
    self.oRezValueBottomLeft = View.findDrawableById("valueBottomLeft") as Ui.Text;
    self.oRezValueBottomRight = View.findDrawableById("valueBottomRight") as Ui.Text;
    // ... footer
    self.oRezValueFooter = View.findDrawableById("valueFooter") as Ui.Text;
  }

  function onShow() {
    //Sys.println("DEBUG: MyView.onShow()");

    // Prepare view
    self.prepare();

    // Done
    self.bShow = true;
    $.oMyView = self;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: MyView.onUpdate()");

    // Update layout
    self.updateLayout(true);
    View.onUpdate(_oDC);
  }

  function onHide() {
    //Sys.println("DEBUG: MyView.onHide()");
    $.oMyView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function prepare() as Void {
    //Sys.println("DEBUG: MyView.prepare()");

    // Load resources
    // ... strings
    self.sValueActivityStandby = Ui.loadResource(Rez.Strings.valueActivityStandby) as String;
    self.sValueActivityRecording = Ui.loadResource(Rez.Strings.valueActivityRecording) as String;
    self.sValueActivityPaused = Ui.loadResource(Rez.Strings.valueActivityPaused) as String;
    self.sLabelCallsignTowplane = Ui.loadResource(Rez.Strings.labelCallsignTowplane) as String;
    self.sLabelCallsignGlider = Ui.loadResource(Rez.Strings.labelCallsignGlider) as String;

    // (Re)load settings
    (App.getApp() as MyApp).loadSettings();
    // ... colors
    self.iColorText = $.oMySettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
  }

  function updateUi() as Void {
    //Sys.println("DEBUG: MyView.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function updateLayout(_bUpdateTime as Boolean) as Void {
    //Sys.println("DEBUG: MyView.updateLayout()");

    // Set colors
    self.iColorText = $.oMySettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    // ... background
    (self.oRezDrawableHeader as MyDrawableHeader).setColorBackground($.oMySettings.iGeneralBackgroundColor);

    // Set header/footer values
    var sValue;

    // ... position accuracy
    (self.oRezDrawableHeader as MyDrawableHeader).setPositionAccuracy($.oMyProcessing.iAccuracy);

    // ... battery level
    (self.oRezValueBatteryLevel as Ui.Text).setColor(self.iColorText);
    (self.oRezValueBatteryLevel as Ui.Text).setText(format("$1$%", [Sys.getSystemStats().battery.format("%.0f")]));

    // ... activity status
    if($.oMyActivity == null) {  // ... stand-by
      (self.oRezValueActivityStatus as Ui.Text).setColor(Gfx.COLOR_LT_GRAY);
      sValue = self.sValueActivityStandby;
    }
    else if(($.oMyActivity as MyActivity).isRecording()) {  // ... recording
      (self.oRezValueActivityStatus as Ui.Text).setColor(Gfx.COLOR_RED);
      sValue = self.sValueActivityRecording;
    }
    else {  // ... paused
      (self.oRezValueActivityStatus as Ui.Text).setColor(Gfx.COLOR_YELLOW);
      sValue = self.sValueActivityPaused;
    }
    (self.oRezValueActivityStatus as Ui.Text).setText(sValue);

    // ... time
    if(_bUpdateTime) {
      var oTimeNow = Time.now();
      var oTimeInfo = $.oMySettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_SHORT) : Gregorian.info(oTimeNow, Time.FORMAT_SHORT);
      (self.oRezValueFooter as Ui.Text).setColor(self.iColorText);
      (self.oRezValueFooter as Ui.Text).setText(format("$1$$2$$3$ $4$", [oTimeInfo.hour.format("%02d"), oTimeNow.value() % 2 ? "." : ":", oTimeInfo.min.format("%02d"), $.oMySettings.sUnitTime]));
    }
  }

}

class MyViewDelegate extends Ui.BehaviorDelegate {

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: MyViewDelegate.onMenu()");
    Ui.pushView(new MyMenuGeneric(:menuGlobal),
                new MyMenuGenericDelegate(:menuGlobal),
                Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onSelect() {
    //Sys.println("DEBUG: MyViewDelegate.onSelect()");
    if($.oMyActivity == null) {
      Ui.pushView(new MyMenuGenericConfirm(:contextActivity, :actionStart),
                  new MyMenuGenericConfirmDelegate(:contextActivity, :actionStart, false),
                  Ui.SLIDE_IMMEDIATE);
    }
    else {
      Ui.pushView(new MyMenuGeneric(:menuActivity),
                  new MyMenuGenericDelegate(:menuActivity),
                  Ui.SLIDE_IMMEDIATE);
    }
    return true;
  }

  function onBack() {
    //Sys.println("DEBUG: MyViewDelegate.onBack()");
    if($.oMyActivity != null) {  // prevent activity data loss
      return true;
    }
    return false;
  }

}
