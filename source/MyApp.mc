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
using Toybox.Activity;
using Toybox.Application as App;
using Toybox.Attention as Attn;
using Toybox.Communications as Comm;
using Toybox.Position as Pos;
using Toybox.Sensor;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Application settings
var oMySettings as MySettings = new MySettings();

// Sensors filter
var oMyFilter as MyFilter = new MyFilter();

// Internal altimeter
var oMyAltimeter as MyAltimeter = new MyAltimeter();

// Towplane parameters
var oMyTowplane as MyTowplane = new MyTowplane();

// Glider parameters
var oMyGlider as MyGlider?;

// Events processing
var oMyProcessing as MyProcessing = new MyProcessing();

// Timer
var oMyTimer as MyTimer = new MyTimer();

// Log
var iMyLogIndex as Number = -1;

// Activity session (recording)
var oMyActivity as MyActivity?;

// Current view
var oMyView as MyView?;


//
// CONSTANTS
//

// Storage slots
const MY_STORAGE_SLOTS = 100;

// No-value strings
// NOTE: Those ought to be defined in the MyApp class like other constants but code then fails with an "Invalid Value" error when called upon; BUG?
const MY_NOVALUE_BLANK = "";
const MY_NOVALUE_LEN2 = "--";
const MY_NOVALUE_LEN3 = "---";
const MY_NOVALUE_LEN4 = "----";


//
// CLASS
//

class MyApp extends App.AppBase {

  //
  // VARIABLES
  //

  // Timers
  // ... UI update
  private var oUpdateTimer as Timer.Timer?;
  private var iUpdateEpoch as Number = 0;
  // ... notifications
  private var iNotificationsEpoch as Number = 0;


  //
  // FUNCTIONS: App.AppBase (override/implement)
  //

  function initialize() {
    AppBase.initialize();

    // Log
    var iLogEpoch = 0;
    for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
      var s = n.format("%02d");
      var dictLog = App.Storage.getValue(format("storLog$1$", [s])) as Dictionary?;
      if(dictLog == null) {
        break;
      }
      else {
        var i = dictLog.get("timeOffBlock") as Number?;
        if(i != null and (i as Number) > iLogEpoch) {
          $.iMyLogIndex = n;
          iLogEpoch = i;
        }
      }
    }
  }

  function onStart(state) {
    //Sys.println("DEBUG: MyApp.onStart()");

    // Load settings
    self.loadSettings();

    // Load towplane
    var dictTowplane = App.Storage.getValue("storTowplaneInUse") as Dictionary?;
    if(dictTowplane != null) {
      $.oMyTowplane.load(dictTowplane);
    }

    // Load glider
    var dictGlider = App.Storage.getValue("storGliderInUse") as Dictionary?;
    if(dictGlider != null) {
      if($.oMyGlider == null) {
        $.oMyGlider = new MyGlider();
      }
      ($.oMyGlider as MyGlider).load(dictGlider);
    }

    // Enable sensor events
    Sensor.setEnabledSensors([Sensor.SENSOR_TEMPERATURE] as Array<Sensor.SensorType>);
    Sensor.enableSensorEvents(method(:onSensorEvent));

    // Enable position events
    Pos.enableLocationEvents(Pos.LOCATION_CONTINUOUS, method(:onLocationEvent));

    // Start UI update timer (every multiple of 5 seconds, to save energy)
    // NOTE: in normal circumstances, UI update will be triggered by position events (every ~1 second)
    self.oUpdateTimer = new Timer.Timer();
    var iUpdateTimerDelay = (60-Sys.getClockTime().sec)%5;
    if(iUpdateTimerDelay > 0) {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer_init), 1000*iUpdateTimerDelay, false);
    }
    else {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer), 5000, true);
    }
  }

  function onStop(state) {
    //Sys.println("DEBUG: MyApp.onStop()");

    // Stop timers
    // ... UI update
    if(self.oUpdateTimer != null) {
      (self.oUpdateTimer as Timer.Timer).stop();
      self.oUpdateTimer = null;
    }

    // Disable position events
    Pos.enableLocationEvents(Pos.LOCATION_DISABLE, method(:onLocationEvent));

    // Disable sensor events
    Sensor.enableSensorEvents(null);

    // Store objects in use
    // ... towplane
    App.Storage.setValue("storTowplaneInUse", $.oMyTowplane.export() as App.PropertyValueType);
    // ... glider
    if($.oMyGlider != null) {
      App.Storage.setValue("storGliderInUse", ($.oMyGlider as MyGlider).export() as App.PropertyValueType);
    }
    else {
      App.Storage.deleteValue("storGliderInUse");
    }
  }

  function getInitialView() {
    //Sys.println("DEBUG: MyApp.getInitialView()");

    return [new MyViewTimer(), new MyViewTimerDelegate()] as Array<Ui.Views or Ui.InputDelegates>;
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: MyApp.onSettingsChanged()");
    self.loadSettings();
    self.updateUi(Time.now().value());
  }


  //
  // FUNCTIONS: self
  //

  function loadSettings() as Void {
    //Sys.println("DEBUG: MyApp.loadSettings()");

    // Load settings
    $.oMySettings.load();

    // Apply settings
    $.oMyAltimeter.importSettings();

    // ... log
    // if($.iMyLogIndex < 0) {  // DEBUG
    //   var dictLog = {
    //     "towplane" => "P18",
    //     "glider" => "A21",
    //     "timeOffBlock" => 1557144000,
    //     "timeTakeoff" => 1557144300,
    //     "countCycles" => 1,
    //     "timeLanding" => 1557147300,
    //     "timeOnBlock" => 1557147600
    //   };
    //   App.Storage.setValue("storLog00", dictLog);
    //   $.iMyLogIndex = 0;
    // }
  }

  function onSensorEvent(_oInfo as Sensor.Info) as Void {
    //Sys.println("DEBUG: MyApp.onSensorEvent()");

    // Process altimeter data
    // ... temperature
    if($.oMySettings.bTemperatureAuto) {
      if(_oInfo has :temperature and _oInfo.temperature != null) {
        $.oMyAltimeter.setTemperatureActual((_oInfo.temperature as Float)+273.15f);  // ... altimeter internals are °K
      }
    }
    else {
      $.oMyAltimeter.setTemperatureActual(null);
    }
    // ... pressure
    var oActivityInfo = Activity.getActivityInfo();  // ... we need *raw ambient* pressure
    if(oActivityInfo != null) {
      if(oActivityInfo has :rawAmbientPressure and oActivityInfo.rawAmbientPressure != null) {
        $.oMyAltimeter.setQFE(oActivityInfo.ambientPressure as Float);
      }
    }

    // Process sensor data
    $.oMyProcessing.processSensorInfo(_oInfo, Time.now().value());

    // Save FIT fields
    if($.oMyActivity != null) {
      ($.oMyActivity as MyActivity).setBarometricAltitude($.oMyProcessing.fAltitude);
      ($.oMyActivity as MyActivity).setVerticalSpeed($.oMyProcessing.fVerticalSpeed);
    }
  }

  function onLocationEvent(_oInfo as Pos.Info) as Void {
    //Sys.println("DEBUG: MyApp.onLocationEvent()");
    var iEpoch = Time.now().value();

    // Process position data
    $.oMyProcessing.processPositionInfo(_oInfo, iEpoch);
    // ... timer
    if($.oMyProcessing.bPositionStateful) {
      $.oMyProcessing.postProcessing();
      $.oMyTimer.onLocationEvent();
    }

    // UI update
    self.updateUi(iEpoch);
  }

  function onUpdateTimer_init() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
  }

  function onUpdateTimer() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer()");
    var iEpoch = Time.now().value();

    // Update UI
    if(iEpoch-self.iUpdateEpoch > 1) {
      self.updateUi(iEpoch);
    }

    // Notifications
    if($.oMyProcessing.bPositionStateful) {
      if(($.oMyProcessing.bAlertAltitude and $.oMySettings.bNotificationsAltimeter)
         or ($.oMyProcessing.bAlertTemperature and $.oMySettings.bNotificationsTemperature)
         or ($.oMyProcessing.bAlertFuel and $.oMySettings.bNotificationsFuel)) {
        if(iEpoch-self.iNotificationsEpoch >= 60) {
          //Sys.println("DEBUG: vibrate");
          if(Toybox.Attention has :vibrate) {
            Attn.vibrate([new Attn.VibeProfile(100, 2000)] as Array<Attn.VibeProfile>);
          }
          if(Toybox.Attention has :playTone) {
            Attn.playTone(Attn.TONE_ALARM);
          }
          self.iNotificationsEpoch = iEpoch;
        }
      }
    }
  }

  function updateUi(_iEpoch as Number) as Void {
    //Sys.println("DEBUG: MyApp.updateUi()");

    // Check sensor data age
    if($.oMyProcessing.iSensorEpoch >= 0 and _iEpoch-$.oMyProcessing.iSensorEpoch > 10) {
      $.oMyProcessing.resetSensorData();
      $.oMyAltimeter.reset();
    }

    // Check position data age
    if($.oMyProcessing.iPositionEpoch >= 0 and _iEpoch-$.oMyProcessing.iPositionEpoch > 10) {
      $.oMyProcessing.resetPositionData();
    }

    // Update UI
    if($.oMyView != null) {
      ($.oMyView as MyView).updateUi();
      self.iUpdateEpoch = _iEpoch;
    }
  }

  function importStorageData(_sFile as String) as Void {
    //Sys.println(format("DEBUG: MyApp.importStorageData($1$)", [_sFile]));

    Comm.makeWebRequest(format("$1$/$2$.json", [App.Properties.getValue("userStorageRepositoryURL"), _sFile]),
                        null,
                        {:method => Comm.HTTP_REQUEST_METHOD_GET, :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON},
                        method(:onStorageDataReceive));
  }

  function onStorageDataReceive(_iResponseCode as Number, _dictData as Dictionary?) as Void {
    //Sys.println(format("DEBUG: MyApp.onStorageDataReceive($1$, ...)", [_iResponseCode]));

    // Check response code
    if(_iResponseCode != 200 or _dictData == null) {
      if(Toybox.Attention has :playTone) {
        Attn.playTone(Attn.TONE_FAILURE);
      }
      return;
    }

    // Validate (!) and store data

    // ... towplanes
    var dictItems = _dictData.get("towplanes") as Dictionary?;
    if(dictItems != null and dictItems instanceof Dictionary) {
      for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        var dictItem = dictItems.get(s) as Dictionary?;
        if(dictItem != null and dictItem instanceof Dictionary) {
          var oTowplane = new MyTowplane();
          oTowplane.load(dictItem);  // <-> input validation
          App.Storage.setValue(format("storTowplane$1$", [s]), oTowplane.export() as App.PropertyValueType);
        }
      }
    }

    // ... gliders
    dictItems = _dictData.get("gliders") as Dictionary?;
    if(dictItems != null and dictItems instanceof Dictionary) {
      for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        var dictItem = dictItems.get(s) as Dictionary?;
        if(dictItem != null and dictItem instanceof Dictionary) {
          var oGlider = new MyGlider();
          oGlider.load(dictItem);  // <-> input validation
          App.Storage.setValue(format("storGlider$1$", [s]), oGlider.export() as App.PropertyValueType);
        }
      }
    }

    // Done
    if(Toybox.Attention has :playTone) {
      Attn.playTone(Attn.TONE_SUCCESS);
    }
  }

  function clearStorageData() as Void {
    //Sys.println("DEBUG: MyApp.clearStorageData()");

    // Delete all storage data

    // ... towplanes and gliders (but not logs)
    for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
      var s = n.format("%02d");
      App.Storage.deleteValue(format("storTowplane$1$", [s]));
      App.Storage.deleteValue(format("storGlider$1$", [s]));
    }
  }

}
