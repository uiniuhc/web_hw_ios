//
//  commonDataStructs.swift
//  HW9_MOBILE_CON
//
//  Created by Zhang.Hanqiu on 11/27/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import Foundation

struct OneLegi{
    var bioID:String = ""
    var firstName:String=""
    var lastName:String=""
    var state:String=""
    var birthDate:String=""
    var gender:String=""
    var chamber:String=""
    var faxNo:String=""
    var twitter:String=""
    var facebook:String=""
    var website:String=""
    var officeNo:String=""
    var termEndsOn:String=""
    var party:String=""
}
struct OneBill{
    var billID:String = ""
    var billType:String = ""
    var sponsor:String = ""
    var lastAction:String = ""
    var pdf:String = ""
    var chamber:String = ""
    var lastVote:String = ""
    var status: String = ""
    var officialTitle: String = ""
    var date: String = ""
}
struct OneComm{
    var name:String = ""
    var committeeID:String = ""
    var chamber:String = ""
    var office:String = ""
    var contact:String = ""
    var parentCommittee:String = ""
}
func changeDateFormat(mydate:String)->String{
    let df=DateFormatter()
    df.dateFormat = "yyyy-MM-dd";
    print("from date: \(mydate)")
    if let date=df.date(from: mydate){
        df.dateFormat = "MMM dd yyyy";
        print(df.string(from: date))
        return df.string(from: date)
    }
    return ""
}
var states = ["All",
            "Alabama",
              "Alaska",
              "Arizona",
              "Arkansas",
              "California",
              "Colorado",
              "Connecticut",
              "Delaware",
              "Florida",
              "Georgia",
              "Hawaii",
              "Idaho",
              "Illinois",
              "Indiana",
              "Iowa",
              "Kansas",
              "Kentucky",
              "Louisiana",
              "Maine",
              "Maryland",
              "Massachusetts",
              "Michigan",
              "Minnesota",
              "Mississippi",
              "Missouri",
              "Montana",
              "Nebraska",
              "Nevada",
              "New Hampshire",
              "New Jersey",
              "New Mexico",
              "New York",
              "North Carolina",
              "North Dakota",
              "Ohio",
              "Oklahoma",
              "Oregon",
              "Pennsylvania",
              "Rhode Island",
              "South Carolina",
              "South Dakota",
              "Tennessee",
              "Texas",
              "Utah",
              "Vermont",
              "Virginia",
              "Washington",
              "West Virginia",
              "Wisconsin",
              "Wyoming"]

var statesDictionary = ["Alabama": "AL",
                        "Alaska": "AK",
                        "Arizona": "AZ",
                        "Arkansas": "AR",
                        "California": "CA",
                        "Colorado": "CO",
                        "Connecticut": "CT",
                        "Delaware": "DE",
                        "Florida": "FL",
                        "Georgia": "GA",
                        "Hawaii": "HI",
                        "Idaho": "ID",
                        "Illinois": "IL",
                        "Indiana": "IN",
                        "Iowa": "IA",
                        "Kansas": "KS",
                        "Kentucky": "KY",
                        "Louisiana": "LA",
                        "Maine": "ME",
                        "Maryland": "MD",
                        "Massachusetts": "MA",
                        "Michigan": "MI",
                        "Minnesota": "MN",
                        "Mississippi": "MS",
                        "Missouri": "MO",
                        "Montana": "MT",
                        "Nebraska": "NE",
                        "Nevada": "NV",
                        "New Hampshire": "NH",
                        "New Jersey": "NJ",
                        "New Mexico": "NM",
                        "New York": "NY",
                        "North Carolina": "NC",
                        "North Dakota": "ND",
                        "Ohio": "OH",
                        "Oklahoma": "OK",
                        "Oregon": "OR",
                        "Pennsylvania": "PA",
                        "Rhode Island": "RI",
                        "South Carolina": "SC",
                        "South Dakota": "SD",
                        "Tennessee": "TN",
                        "Texas": "TX",
                        "Utah": "UT",
                        "Vermont": "VT",
                        "Virginia": "VA",
                        "Washington": "WA",
                        "West Virginia": "WV",
                        "Wisconsin": "WI",
                        "Wyoming": "WY"]
