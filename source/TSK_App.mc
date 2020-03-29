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
var TSK_oSettings = null;

// Sensors filter
var TSK_oFilter = null;

// Internal altimeter
var TSK_oAltimeter = null;

// Towplane parameters
var TSK_oTowplane = null;

// Glider parameters
var TSK_oGlider = null;

// Events processing
var TSK_oProcessing = null;

// Timer
var TSK_oTimer = null;

// Log
var TSK_iLogIndex = null;

// Activity session (recording)
var TSK_oActivity = null;

// Current view
var TSK_oCurrentView = null;


//
// CONSTANTS
//

// Storage slots
const TSK_STORAGE_SLOTS = 100;

// No-value strings
// NOTE: Those ought to be defined in the TSK_App class like other constants but code then fails with an "Invalid Value" error when called upon; BUG?
const TSK_NOVALUE_BLANK = "";
const TSK_NOVALUE_LEN2 = "--";
const TSK_NOVALUE_LEN3 = "---";
const TSK_NOVALUE_LEN4 = "----";


//
// CLASS
//

class TSK_App extends App.AppBase {

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
    $.TSK_oSettings = new TSK_Settings();

    // Sensors filter
    $.TSK_oFilter = new TSK_Filter();

    // Internal altimeter
    $.TSK_oAltimeter = new TSK_Altimeter();

    // Events processing
    $.TSK_oProcessing = new TSK_Processing();

    // Timer
    $.TSK_oTimer = new TSK_Timer();

    // Log
    var iLogEpoch = 0;
    for(var n=0; n<$.TSK_STORAGE_SLOTS; n++) {
      var s = n.format("%02d");
      var dictLog = App.Storage.getValue(Lang.format("storLog$1$", [s]));
      if(dictLog == null) {
        break;
      }
      var i = dictLog.get("timeOffBlock");
      if(i != null and i > iLogEpoch) {
        $.TSK_iLogIndex = n;
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
    //Sys.println("DEBUG: TSK_App.onStart()");

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
    //Sys.println("DEBUG: TSK_App.onStop()");

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
    if($.TSK_oTowplane != null) {
      App.Storage.setValue("storTowplaneInUse", $.TSK_oTowplane.export());
    }
    else {
      App.Storage.deleteValue("storTowplaneInUse");
    }
    // ... glider
    if($.TSK_oGlider != null) {
      App.Storage.setValue("storGliderInUse", $.TSK_oGlider.export());
    }
    else {
      App.Storage.deleteValue("storGliderInUse");
    }
  }

  function getInitialView() {
    //Sys.println("DEBUG: TSK_App.getInitialView()");

    return [new TSK_ViewTimer(), new TSK_ViewTimerDelegate()];
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: TSK_App.onSettingsChanged()");
    self.loadSettings();
    self.updateUi(Time.now().value());
  }


  //
  // FUNCTIONS: self
  //

  function loadSettings() {
    //Sys.println("DEBUG: TSK_App.loadSettings()");

    // Load settings
    $.TSK_oSettings.load();

    // Apply settings
    $.TSK_oAltimeter.importSettings();

    // ... towplane
    if($.TSK_oTowplane == null) {
      $.TSK_oTowplane = new TSK_Towplane(App.Storage.getValue("storTowplaneInUse"));
    }

    // ... glider
    if($.TSK_oGlider == null) {
      var dictGlider = App.Storage.getValue("storGliderInUse");
      if(dictGlider != null) {
        $.TSK_oGlider = new TSK_Glider(dictGlider);
      }
    }

    // ... log
    // if($.TSK_iLogIndex == null) {  // DEBUG
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
    //   $.TSK_iLogIndex = 0;
    // }
  }

  function onSensorEvent(_oInfo) {
    //Sys.println("DEBUG: TSK_App.onSensorEvent()");

    // Process altimeter data
    // ... temperature
    if($.TSK_oSettings.bTemperatureAuto) {
      if(_oInfo has :temperature and _oInfo.temperature != null) {
        $.TSK_oAltimeter.setTemperatureActual(_oInfo.temperature+273.15f);  // ... altimeter internals are °K
      }
    }
    else {
      $.TSK_oAltimeter.setTemperatureActual(null);
    }
    // ... pressure
    var oActivityInfo = Activity.getActivityInfo();  // ... we need *raw ambient* pressure
    if(oActivityInfo has :rawAmbientPressure and oActivityInfo.rawAmbientPressure != null) {
      $.TSK_oAltimeter.setQFE(oActivityInfo.ambientPressure);
    }

    // Process sensor data
    $.TSK_oProcessing.processSensorInfo(_oInfo, Time.now().value());

    // Save FIT fields
    if($.TSK_oActivity != null) {
      $.TSK_oActivity.setBarometricAltitude($.TSK_oProcessing.fAltitude);
      $.TSK_oActivity.setVerticalSpeed($.TSK_oProcessing.fVerticalSpeed);
    }
  }

  function onLocationEvent(_oInfo) {
    //Sys.println("DEBUG: TSK_App.onLocationEvent()");
    var iEpoch = Time.now().value();

    // Process position data
    $.TSK_oProcessing.processPositionInfo(_oInfo, iEpoch);
    // ... timer
    if($.TSK_oProcessing.bPositionStateful) {
      $.TSK_oProcessing.postProcessing();
      $.TSK_oTimer.onLocationEvent();
    }

    // UI update
    self.updateUi(iEpoch);
  }

  function onUpdateTimer_init() {
    //Sys.println("DEBUG: TSK_App.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    self.oUpdateTimer.start(method(:onUpdateTimer), 5000, true);
  }

  function onUpdateTimer() {
    //Sys.println("DEBUG: TSK_App.onUpdateTimer()");
    var iEpoch = Time.now().value();

    // Update UI
    if(iEpoch-self.iUpdateEpoch > 1) {
      self.updateUi(iEpoch);
    }

    // Notifications
    if($.TSK_oProcessing.bPositionStateful) {
      if(($.TSK_oProcessing.bAlertAltitude and $.TSK_oSettings.bNotificationsAltimeter)
         or ($.TSK_oProcessing.bAlertTemperature and $.TSK_oSettings.bNotificationsTemperature)
         or ($.TSK_oProcessing.bAlertFuel and $.TSK_oSettings.bNotificationsFuel)) {
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
    //Sys.println("DEBUG: TSK_App.updateUi()");

    // Check sensor data age
    if($.TSK_oProcessing.iSensorEpoch != null and _iEpoch-$.TSK_oProcessing.iSensorEpoch > 10) {
      $.TSK_oProcessing.resetSensorData();
      $.TSK_oAltimeter.reset();
    }

    // Check position data age
    if($.TSK_oProcessing.iPositionEpoch != null and _iEpoch-$.TSK_oProcessing.iPositionEpoch > 10) {
      $.TSK_oProcessing.resetPositionData();
    }

    // Update UI
    if($.TSK_oCurrentView != null) {
      $.TSK_oCurrentView.updateUi();
      self.iUpdateEpoch = _iEpoch;
    }
  }

  function importStorageData(_sFile) {
    //Sys.println(Lang.format("DEBUG: TSK_App.importStorageData($1$)", [_sFile]));

    Comm.makeWebRequest(Lang.format("$1$/$2$.json", [App.Properties.getValue("userStorageRepositoryURL"), _sFile]),
                        null,
                        { :method => Comm.HTTP_REQUEST_METHOD_GET, :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON },
                        method(:onStorageDataReceive));
  }

  function onStorageDataReceive(_iResponseCode, _dictData) {
    //Sys.println(Lang.format("DEBUG: TSK_App.onStorageDataReceive($1$, ...)", [_iResponseCode]));

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
      for(var n=0; n<$.TSK_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        if(dictTowplanes.hasKey(s)) {
          var oTowplane = new TSK_Towplane(dictTowplanes.get(s));  // <-> input validation
          App.Storage.setValue(Lang.format("storTowplane$1$", [s]), oTowplane.export());
        }
      }
    }

    // ... gliders
    if(_dictData.hasKey("gliders")) {
      var dictGliders = _dictData.get("gliders");
      for(var n=0; n<$.TSK_STORAGE_SLOTS; n++) {
        var s = n.format("%02d");
        if(dictGliders.hasKey(s)) {
          var oGlider = new TSK_Glider(dictGliders.get(s));  // <-> input validation
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
    //Sys.println("DEBUG: TSK_App.clearStorageData()");

    // Delete all storage data

    // ... towplanes and gliders (but not logs)
    for(var n=0; n<$.TSK_STORAGE_SLOTS; n++) {
      var s = n.format("%02d");
      App.Storage.deleteValue(Lang.format("storTowplane$1$", [s]));
      App.Storage.deleteValue(Lang.format("storGlider$1$", [s]));
    }
  }

}
