//
//  Structs.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 6/24/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import Foundation

struct review
{
    var id : String
    var date : String
    var postedby : String
    var subject : String
}

struct lecturestruct
{
    var lecid :String
    var lecname : String
    var type : String
    var duration :String
    var uploadedby : String
    var uploadedon : String
    var url : String
    
}

struct recentlecturestruct
{
    var lectureitem :lecturestruct
    var duration : Int
}

struct question
{
    var qno : Int
    var question : String
    var mode : String
    var optiona : String
    var optionb : String
    var optionc : String
    var optiond : String
}

struct testallowed
{
    var id : String
    var allowed : Bool
}

struct test
{
    var id : String
    var expireson : String
    var mcq : Bool
    var subjectives : Bool
    var postedby : String
    var postedon : String
    var retest : Bool
    var subject : String
    var duration : String
    var topic : String
   
}

struct assessmentstruct
{
    var id : String
    var marks : Int
    var totalmarks : Int
    var remark : String
    var assessedby : String
    var resultpostedon : String
    var subject : String
    var testtakenon : String
    var topic : String
}
struct attendancestruct
{
    var date : String
    var status : String
}
struct attendancetaken
{
    var id : String
    var name : String
    var status : String
}

struct student {
    var name : String
    var progress : Int
    var classcode : String
    var classname : String
    var schoolname : String
    var assessments : [assessmentstruct]
    var attendance : [attendancestruct]
    var reviews : [review]
    var lecturesviewed : [lecturestruct]
    
}
struct studentforattendance {
    var name : String
    var profilepicture : String
    var id : String
}


struct classcodedetails
{
    var code : String
    var classname : String
    var taughtby : [String]
    var noofstudents : Int
    var testspermittedid : [String]
    var teachername : String
    var timetabletype : String
}

struct timetable
{
    var type : String
    var schedula : Dictionary<String,AnyObject>
}


struct timetablevariable
{
    var classnumber : String
    var begins : String
    var ends : String
    var reminders : String
    var room : String
    var subject : String
    var teacherid : String
    var teachername : String
}

struct timetablevariableholder
{
    var date : String
    var contents : [timetablevariable]
}


struct teacherstruct
{
    var id : String
    var name : String
    var profileimage : String
}

struct statictimetable
{
    var period : String
    var subject : String
}

struct attendanceperclasswise
{
    var begins : String
    var ends : String
    var room : String
    var subject : String
    var takenby : String
    var attendancestatus : String
}

struct news
{
    var postedby : String
    var postedon: Int
    var expireson : Int
    var content : String
}
