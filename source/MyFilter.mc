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
using Toybox.System as Sys;

//
// CLASS
//

// We use median filtering to filter-out sensors jitter
class MyFilter {

  //
  // CONSTANTS
  //

  // Filter size
  private const SIZE = 5;  // -> 2 seconds average delay
  private const INDEX = 2;  // index of the median value (floor(size/2))

  // Filters (<-> sensors)
  public const PRESSURE = 0;
  public const TEMPERATURE = 1;
  public const VERTICALSPEED = 2;
  public const GROUNDSPEED = 3;
  public const HEADING_X = 4;
  public const HEADING_Y = 5;
  private const FILTERS = 6;


  //
  // VARIABLES
  //

  // Filters
  private var aaFilters as Array<Array>;
  private var afSort as Array<Float?>;


  //
  // FUNCTIONS: self
  //

  function initialize() {
    // Initialize the filters container array
    aaFilters = new Array<Array>[self.FILTERS];
    afSort = new Array<Float?>[self.SIZE];

    // Loop through each filter
    for(var F=0; F<self.FILTERS; F++) {
      // Create the filter array, containing:
      // [0] current value index (starting from 0)
      // [1+] values history
      self.aaFilters[F] = new Array[self.SIZE+1];
      self.resetFilter(F);
    }
  }

  function resetFilter(_F as Number) as Void {
    //Sys.println(format("DEBUG: MyFilter.resetFilter($1$)", [_F]));

    // Reset the current value index
    self.aaFilters[_F][0] = 0;

    // Reset the values history
    for(var i=0; i<self.SIZE; i++) {
      self.aaFilters[_F][1+i] = null;
    }
  }

  function filterValue(_F as Number, _fValue as Float, _bStrict as Boolean) as Float {
    //Sys.println(format("DEBUG: MyFilter.filterValue($1$, $2$, $2$)", [_F, _fValue, _bStrict]));

    // Store the new value
    self.aaFilters[_F][1+self.aaFilters[_F][0]] = _fValue;

    // Increase the current value index
    self.aaFilters[_F][0] = (self.aaFilters[_F][0] + 1) % self.SIZE;

    // Return the median-filtered value
    // ... sort values; NOTE: we use Jon Bentley's optimized insertion sort algorithm; https://en.wikipedia.org/wiki/Insertion_sort
    var i;
    for(i=0; i<self.SIZE; i++) {
      self.afSort[i] = self.aaFilters[_F][1+i];
      if(self.afSort[i] == null) {
        return _bStrict ? NaN : _fValue;  // incomplete data
      }
    }
    i = 1;
    while(i<self.SIZE) {
      var mSwap = self.afSort[i] as Float;
      var j = i - 1;
      while(j >= 0 and (self.afSort[j] as Float) > mSwap) {
        self.afSort[j+1] = self.afSort[j];
        j--;
      }
      self.afSort[j+1] = mSwap;
      i++;
    }
    // ... return median
    return self.afSort[self.INDEX];
  }

}
