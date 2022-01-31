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
var oMySettings = null;

// Sensors filter
var oMyFilter = null;

// Internal altimeter
var oMyAltimeter = null;

// Towplane parameters
var oMyTowplane = null;

// Glider parameters
var oMyGlider = null;

// Events processing
var oMyProcessing = null;

// Timer
var oMyTimer = null;

// Log
var iMyLogIndex = null;

// Activity session (recording)
var oMyActivity = null;

// Current view
var oMyView = null;


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
  private var oUpdateTimer;
  private var iUpdateEpoch;
  // ... notifications
  private var iNotificationsEpoch;


  //
  // FUNCTIONS: App.AppBase (override/implement)
  //

  function initialize() {
    AppBase.initialize();

    // Application settings
    $.oMySettings = new MySettings();

    // Sensors filter
    $.oMyFilter = new MyFilter();

    // Internal altimeter
    $.oMyAltimeter = new MyAltimeter();

    // Events processing
    $.oMyProcessing = new MyProcessing();

    // Timer
    $.oMyTimer = new MyTimer();

    // Log
    var iLogEpoch = 0;
    for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
      var s = n.format("%02d");
      var dictLog = App.Storage.getValue(Lang.format("storLog$1$", [s]));
      if(dictLog == null) {
        break;
      }
      var i = dictLog.get("timeOffBlock");
      if(i != null and i > iLogEpoch) {
        $.iMyLogIndex = n;
        iLogEpoch = i;
      }
    }

    // Timers
    // ... UI update
    self.oUpdateTimer = null;
    self.iUpdateEpoch = 0;
    // ... notifications
    self.iNotificationsEpoch = 0;
  }

  function onStart(state) {
    //Sys.println("DEBUG: MyApp.onStart()");

    // Load settings
    self.loadSettings();

    // Enable sensor events
    Sensor.setEnabledSensors([Sensor.SENSOR_TEMPERATURE]);
    Sensor.enableSensorEvents(method(:onSensorEvent));

    // Enable position events
    Pos.enableLocationEvents(Pos.LOCATION_CONTINUOUS, method(:onLocationEvent));

    // Start UI update timer (every multiple of 5 seconds, to save energy)
    // NOTE: in normal circumstances, UI update will be triggered by position events (every ~1 second)
    self.oUpdateTimer = new Timer.Timer();
    var iUpdateTimerDelay = (60-Sys.getClockTime().sec)%5;
    if(iUpdateTimerDelay > 0) {
      self.oUpdateTimer.start(method(:onUpdateTimer_init), 1000*iUpdateTimerDelay, false);
    }
    else {
      self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
    }
  }

  function onStop(state) {
    //Sys.println("DEBUG: MyApp.onStop()");

    // Stop timers
    // ... UI update
    if(self.oUpdateTimer != null) {
      self.oUpdateTimer.stop();
      self.oUpdateTimer = null;
    }

    // Disable position events
    Pos.enableLocationEvents(Pos.LOCATION_DISABLE, null);

    // Disable sensor events
    Sensor.enableSensorEvents(null);

    // Store objects in use
    // ... towplane
    if($.oMyTowplane != null) {
      App.Storage.setValue("storTowplaneInUse", $.oMyTowplane.export());
    }
    else {
      App.Storage.deleteValue("storTowplaneInUse");
    }
    // ... glider
    if($.oMyGlider != null) {
      App.Storage.setValue("storGliderInUse", $.oMyGlider.export());
    }
    else {
      App.Storage.deleteValue("storGliderInUse");
    }
  }

  function getInitialView() {
    //Sys.println("DEBUG: MyApp.getInitialView()");

    return [new MyViewTimer(), new MyViewTimerDelegate()];
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: MyApp.onSettingsChanged()");
    self.loadSettings();
    self.updateUi(Time.now().value());
  }


  //
  // FUNCTIONS: self
  //

  function loadSettings() {
    //Sys.println("DEBUG: MyApp.loadSettings()");

    // Load settings
    $.oMySettings.load();

    // Apply settings
    $.oMyAltimeter.importSettings();

    // ... towplane
    if($.oMyTowplane == null) {
      $.oMyTowplane = new MyTowplane(App.Storage.getValue("storTowplaneInUse"));
    }

    // ... glider
    if($.oMyGlider == null) {
      var dictGlider = App.Storage.getValue("storGliderInUse");
      if(dictGlider != null) {
        $.oMyGlider = new MyGlider(dictGlider);
      }
    }

    // ... log
    // if($.iMyLogIndex == null) {  // DEBUG
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

  function onSensorEvent(_oInfo) {
    //Sys.println("DEBUG: MyApp.onSensorEvent()");

    // Process altimeter data
    // ... temperature
    if($.oMySettings.bTemperatureAuto) {
      if(_oInfo has :temperature and _oInfo.temperature != null) {
        $.oMyAltimeter.setTemperatureActual(_oInfo.temperature+273.15f);  // ... altimeter internals are °K
      }
    }
    else {
      $.oMyAltimeter.setTemperatureActual(null);
    }
    // ... pressure
    var oActivityInfo = Activity.getActivityInfo();  // ... we need *raw ambient* pressure
    if(oActivityInfo has :rawAmbientPressure and oActivityInfo.rawAmbientPressure != null) {
      $.oMyAltimeter.setQFE(oActivityInfo.ambientPressure);
    }

    // Process sensor data
    $.oMyProcessing.processSensorInfo(_oInfo, Time.now().value());

    // Save FIT fields
    if($.oMyActivity != null) {
      $.oMyActivity.setBarometricAltitude($.oMyProcessing.fAltitude);
      $.oMyActivity.setVerticalSpeed($.oMyProcessing.fVerticalSpeed);
    }
  }

  function onLocationEvent(_oInfo) {
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

  function onUpdateTimer_init() {
    //Sys.println("DEBUG: MyApp.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
  }

  function onUpdateTimer() {
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
          if(Attn has :vibrate) {
            Attn.vibrate([new Attn.VibeProfile(100, 2000)]);
          }
          if(Attn has :playTone) {
            Attn.playTone(Attn.TONE_ALARM);
          }
          self.iNotificationsEpoch = iEpoch;
        }
      }
    }
  }

  function updateUi(_iEpoch) {
    //Sys.println("DEBUG: MyApp.updateUi()");

    // Check sensor data age
    if($.oMyProcessing.iSensorEpoch != null and _iEpoch-$.oMyProcessing.iSensorEpoch > 10) {
      $.oMyProcessing.resetSensorData();
      $.oMyAltimeter.reset();
    }

    // Check position data age
    if($.oMyProcessing.iPositionEpoch != null and _iEpoch-$.oMyProcessing.iPositionEpoch > 10) {
      $.oMyProcessing.resetPositionData();
    }

    // Update UI
    if($.oMyView != null) {
      $.oMyView.updateUi();
      self.iUpdateEpoch = _iEpoch;
    }
  }

  function importStorageData(_sFile) {
    //Sys.println(Lang.format("DEBUG: MyApp.importStorageData($1$)", [_sFile]));

    Comm.makeWebRequest(Lang.format("$1$/$2$.json", [App.Properties.getValue("userStorageRepositoryURL"), _sFile]),
                        null,
                        {:method => Comm.HTTP_REQUEST_METHOD_GET, :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON},
                        method(:onStorageDataReceive));
  }

  function onStorageDataReceive(_iResponseCode, _dictData) {
    //Sys.println(Lang.format("DEBUG: MyApp.onStorageDataReceive($1$, ...)", [_iResponseCode]));

    // Check response code
    if(_iResponseCode != 200) {
      if(Attn has :playTone) {
        Attn.playTone(Attn.TONE_FAILURE);
      }
      return;
    }

    // Validate (!) and store data

    // ... towplanes
    if(_dictData.hasKey("towplanes")) {
      var dictTowplanes = _dictData.get("towplanes");
      for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        if(dictTowplanes.hasKey(s)) {
          var oTowplane = new MyTowplane(dictTowplanes.get(s));  // <-> input validation
          App.Storage.setValue(Lang.format("storTowplane$1$", [s]), oTowplane.export());
        }
      }
    }

    // ... gliders
    if(_dictData.hasKey("gliders")) {
      var dictGliders = _dictData.get("gliders");
      for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        if(dictGliders.hasKey(s)) {
          var oGlider = new MyGlider(dictGliders.get(s));  // <-> input validation
          App.Storage.setValue(Lang.format("storGlider$1$", [s]), oGlider.export());
        }
      }
    }

    // Done
    if(Attn has :playTone) {
      Attn.playTone(Attn.TONE_SUCCESS);
    }
  }

  function clearStorageData() {
    //Sys.println("DEBUG: MyApp.clearStorageData()");

    // Delete all storage data

    // ... towplanes and gliders (but not logs)
    for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
      var s = n.format("%02d");
      App.Storage.deleteValue(Lang.format("storTowplane$1$", [s]));
      App.Storage.deleteValue(Lang.format("storGlider$1$", [s]));
    }
  }

}
