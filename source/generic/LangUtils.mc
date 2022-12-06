// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Generic ConnectIQ Helpers/Resources (CIQ Helpers)
// Copyright (C) 2017-2022 Cedric Dufour <http://cedric.dufour.name>
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Generic ConnectIQ Helpers/Resources (CIQ Helpers) is distributed in the hope
// that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;

module LangUtils {

  //
  // FUNCTIONS: data primitives
  //

  // NaN
  function isNaN(_nValue as Numeric?) as Boolean {
    return _nValue == null or _nValue != _nValue;
  }
  function notNaN(_nValue as Numeric?) as Boolean {
    return _nValue != null and _nValue == _nValue;
  }

  // Casting
  function asNumber(_oValue as Object or App.PropertyValueType or Null, _nDefault as Number) as Number {
    if(_oValue != null && !(_oValue instanceof Lang.Number)) {
      try {
        _oValue = (_oValue as String or Integer or Decimal).toNumber();
      }
      catch(e) {
        _oValue = null;
      }
    }
    return _oValue != null ? _oValue as Number : _nDefault;
  }

  function asFloat(_oValue as Object or App.PropertyValueType or Null, _fDefault as Float) as Float {
    if(_oValue != null && !(_oValue instanceof Lang.Float)) {
      try {
        _oValue = (_oValue as String or Integer or Decimal).toFloat();
      }
      catch(e) {
        _oValue = null;
      }
    }
    return _oValue != null ? _oValue as Float : _fDefault;
  }

  function asBoolean(_oValue as Object or App.PropertyValueType or Null, _bDefault as Boolean) as Boolean {
    if(_oValue != null && !(_oValue instanceof Lang.Boolean)) {
      try {
        _oValue = (_oValue as String or Integer or Decimal).toNumber() != 0;
      }
      catch(e) {
        _oValue = null;
      }
    }
    return _oValue != null ? _oValue as Boolean : _bDefault;
  }

  // Deep-copy the given object
  function copy(_oObject as Object) as Object {
    var oCopy = null;
    if(_oObject instanceof Lang.Array) {
      var iSize = _oObject.size();
      oCopy = new Array<Object>[iSize];
      for(var i=0; i<iSize; i++) {
        oCopy[i] = LangUtils.copy(_oObject[i] as Object);
      }
    }
    else if(_oObject instanceof Lang.Dictionary) {
      var amKeys = _oObject.keys();
      var iSize = amKeys.size();
      oCopy = {} as Dictionary<Object, Object>;
      for(var i=0; i<iSize; i++) {
        var mKey = amKeys[i];
        oCopy.put(mKey, LangUtils.copy(_oObject.get(mKey) as Object));
      }
    }
    else if(_oObject instanceof Lang.Exception) {
      throw new Lang.UnexpectedTypeException("Exception may not be deep-copied", null, null);
    }
    else if(_oObject instanceof Lang.Method) {
      throw new Lang.UnexpectedTypeException("Method may not be deep-copied", null, null);
    }
    else {
      oCopy = _oObject;
    }
    return oCopy;
  }


  //
  // FUNCTIONS: time formatting
  //

  function formatDate(_oTime as Time.Moment?, _bUTC as Boolean) as String {
    if(_oTime != null) {
      var oTimeInfo = _bUTC ? Gregorian.utcInfo(_oTime, Time.FORMAT_MEDIUM) : Gregorian.info(_oTime, Time.FORMAT_MEDIUM);
      return Lang.format("$1$ $2$", [oTimeInfo.month, oTimeInfo.day.format("%01d")]);
    }
    else {
      return "----";
    }
  }

  function formatTime(_oTime as Time.Moment?, _bUTC as Boolean, _bSecond as Boolean) as String {
    if(_oTime != null) {
      var oTimeInfo = _bUTC ? Gregorian.utcInfo(_oTime, Time.FORMAT_SHORT) : Gregorian.info(_oTime, Time.FORMAT_SHORT);
      if(_bSecond) {
        return Lang.format("$1$:$2$:$3$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d"), oTimeInfo.sec.format("%02d")]);
      }
      else {
        return Lang.format("$1$:$2$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d")]);
      }
    }
    else {
      return _bSecond ? "--:--:--" : "--:--";
    }
  }

  function formatElapsedTime(_oTimeFrom as Time.Moment?, _oTimeTo as Time.Moment?, _bSecond as Boolean) as String {
    if(_oTimeFrom != null and _oTimeTo != null) {
      if(_bSecond) {
        var oTimeInfo = Gregorian.utcInfo(new Time.Moment(_oTimeTo.subtract(_oTimeFrom).value()), Time.FORMAT_SHORT);
        return Lang.format("$1$:$2$:$3$", [oTimeInfo.hour.format("%01d"), oTimeInfo.min.format("%02d"), oTimeInfo.sec.format("%02d")]);
      }
      else {
        var oTimeInfo_from = Gregorian.utcInfo(_oTimeFrom, Time.FORMAT_SHORT);
        var oTimeInfo_to = Gregorian.utcInfo(_oTimeTo, Time.FORMAT_SHORT);
        var oTimeInfo = Gregorian.utcInfo(new Time.Moment((3600*oTimeInfo_to.hour+60*oTimeInfo_to.min) - (3600*oTimeInfo_from.hour+60*oTimeInfo_from.min)), Time.FORMAT_SHORT);
        return Lang.format("$1$:$2$", [oTimeInfo.hour.format("%01d"), oTimeInfo.min.format("%02d")]);
      }
    }
    else {
      return _bSecond ? "-:--:--" : "-:--";
    }
  }

  function formatElapsedDuration(_oDuration as Time.Duration?, _bSecond as Boolean) as String {
    if(_oDuration != null and (_oDuration as Time.Duration).value() > 0) {
      var oDurationInfo = Gregorian.utcInfo(new Time.Moment(_oDuration.value()), Time.FORMAT_SHORT);
      if(_bSecond) {
        return Lang.format("$1$:$2$:$3$", [oDurationInfo.hour.format("%01d"), oDurationInfo.min.format("%02d"), oDurationInfo.sec.format("%02d")]);
      }
      else {
        return Lang.format("$1$:$2$", [oDurationInfo.hour.format("%01d"), oDurationInfo.min.format("%02d")]);
      }
    }
    else {
      return _bSecond ? "-:--:--" : "-:--";
    }
  }

}
