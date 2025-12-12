//
//  AchievementDefaults.swift
//  Nicoboo
//
//  Created by Sabrina Jiang on 11/17/25.
//

import Foundation

struct AchievementDefaults {

    static let list: [Achievement] = [
        // — Cigarettes Avoided (1–50)
        Achievement(
            title: "Baby Steps",
            details: "1 cigarette avoided",
            requirement: 1,
            requirementType: .cigarettesAvoided,
            imageName: "image-a1",
            order: 1
        ),
        Achievement(
            title: "First Spark",
            details: "3 cigarettes avoided",
            requirement: 3,
            requirementType: .cigarettesAvoided,
            imageName: "image-a2",
            order: 2
        ),
        Achievement(
            title: "To Infinity and Beyond",
            details: "5 cigarettes avoided",
            requirement: 5,
            requirementType: .cigarettesAvoided,
            imageName: "image-a3",
            order: 3
        ),
        Achievement(
            title: "Smoke Houdini",
            details: "7 cigarettes avoided",
            requirement: 7,
            requirementType: .cigarettesAvoided,
            imageName: "image-a4",
            order: 4
        ),
        Achievement(
            title: "Saturday Night Fever",
            details: "10 cigarettes avoided",
            requirement: 10,
            requirementType: .cigarettesAvoided,
            imageName: "image-a5",
            order: 5
        ),
        Achievement(
            title: "Double Digits",
            details: "12 cigarettes avoided",
            requirement: 12,
            requirementType: .cigarettesAvoided,
            imageName: "image-a6",
            order: 6
        ),
        Achievement(
            title: "Clothes Off",
            details: "15 cigarettes avoided",
            requirement: 15,
            requirementType: .cigarettesAvoided,
            imageName: "image-a7",
            order: 7
        ),
        Achievement(
            title: "Jump Around",
            details: "20 cigarettes avoided",
            requirement: 20,
            requirementType: .cigarettesAvoided,
            imageName: "image-a8",
            order: 8
        ),
        Achievement(
            title: "Cloud Walker",
            details: "25 cigarettes avoided",
            requirement: 25,
            requirementType: .cigarettesAvoided,
            imageName: "image-a9",
            order: 9
        ),
        Achievement(
            title: "Fresh Air Fan",
            details: "30 cigarettes avoided",
            requirement: 30,
            requirementType: .cigarettesAvoided,
            imageName: "image-a10",
            order: 10
        ),
        Achievement(
            title: "Breathe Easy",
            details: "35 cigarettes avoided",
            requirement: 35,
            requirementType: .cigarettesAvoided,
            imageName: "image-a11",
            order: 11
        ),
        Achievement(
            title: "Sky Dancer",
            details: "40 cigarettes avoided",
            requirement: 40,
            requirementType: .cigarettesAvoided,
            imageName: "image-a12",
            order: 12
        ),
        Achievement(
            title: "Lungs Level Up",
            details: "45 cigarettes avoided",
            requirement: 45,
            requirementType: .cigarettesAvoided,
            imageName: "image-a13",
            order: 13
        ),
        Achievement(
            title: "Airbender",
            details: "50 cigarettes avoided",
            requirement: 50,
            requirementType: .cigarettesAvoided,
            imageName: "image-a14",
            order: 14
        ),
        
        // — Cigarettes Avoided (60–300)
        Achievement(
            title: "Fresh Start",
            details: "60 cigarettes avoided",
            requirement: 60,
            requirementType: .cigarettesAvoided,
            imageName: "image-a15",
            order: 15
        ),
        Achievement(
            title: "Breathe Again",
            details: "70 cigarettes avoided",
            requirement: 70,
            requirementType: .cigarettesAvoided,
            imageName: "image-a16",
            order: 16
        ),
        Achievement(
            title: "Clean Slate",
            details: "80 cigarettes avoided",
            requirement: 80,
            requirementType: .cigarettesAvoided,
            imageName: "image-a17",
            order: 17
        ),
        Achievement(
            title: "Odyssey",
            details: "90 cigarettes avoided",
            requirement: 90,
            requirementType: .cigarettesAvoided,
            imageName: "image-a18",
            order: 18
        ),
        Achievement(
            title: "Century Breaker",
            details: "100 cigarettes avoided",
            requirement: 100,
            requirementType: .cigarettesAvoided,
            imageName: "image-a19",
            order: 19
        ),
        Achievement(
            title: "Windrunner",
            details: "120 cigarettes avoided",
            requirement: 120,
            requirementType: .cigarettesAvoided,
            imageName: "image-a20",
            order: 20
        ),
        Achievement(
            title: "Skywhisper",
            details: "150 cigarettes avoided",
            requirement: 150,
            requirementType: .cigarettesAvoided,
            imageName: "image-a21",
            order: 21
        ),
        Achievement(
            title: "Dustless Path",
            details: "180 cigarettes avoided",
            requirement: 180,
            requirementType: .cigarettesAvoided,
            imageName: "image-a22",
            order: 22
        ),
        Achievement(
            title: "Sun of the Earth",
            details: "200 cigarettes avoided",
            requirement: 200,
            requirementType: .cigarettesAvoided,
            imageName: "image-a23",
            order: 23
        ),
        Achievement(
            title: "Airborne",
            details: "220 cigarettes avoided",
            requirement: 220,
            requirementType: .cigarettesAvoided,
            imageName: "image-a24",
            order: 24
        ),
        Achievement(
            title: "Freedom Rider",
            details: "250 cigarettes avoided",
            requirement: 250,
            requirementType: .cigarettesAvoided,
            imageName: "image-a25",
            order: 25
        ),
        Achievement(
            title: "The Big Clean",
            details: "300 cigarettes avoided",
            requirement: 300,
            requirementType: .cigarettesAvoided,
            imageName: "image-a26",
            order: 26
        ),

        // — Days Smoke-Free
        Achievement(
            title: "First Cross on the Calendar",
            details: "1 day without smoking",
            requirement: 1,
            requirementType: .daysSmokeFree,
            imageName: "image-a27",
            order: 27
        ),
        Achievement(
            title: "Weekend Warrior",
            details: "2 days smoke-free",
            requirement: 2,
            requirementType: .daysSmokeFree,
            imageName: "image-a28",
            order: 28
        ),
        Achievement(
            title: "Three's Company",
            details: "3 days smoke-free",
            requirement: 3,
            requirementType: .daysSmokeFree,
            imageName: "image-a29",
            order: 29
        ),
        Achievement(
            title: "Stayin' Alive",
            details: "4 days smoke-free",
            requirement: 4,
            requirementType: .daysSmokeFree,
            imageName: "image-a30",
            order: 30
        ),
        Achievement(
            title: "High Five",
            details: "5 days smoke-free",
            requirement: 5,
            requirementType: .daysSmokeFree,
            imageName: "image-a31",
            order: 31
        ),
        Achievement(
            title: "Almost a Week",
            details: "6 days smoke-free",
            requirement: 6,
            requirementType: .daysSmokeFree,
            imageName: "image-a32",
            order: 32
        ),
        Achievement(
            title: "One Week Wonder",
            details: "7 days smoke-free",
            requirement: 7,
            requirementType: .daysSmokeFree,
            imageName: "image-a33",
            order: 33
        ),
        Achievement(
            title: "Double Week Dash",
            details: "14 days smoke-free",
            requirement: 14,
            requirementType: .daysSmokeFree,
            imageName: "image-a34",
            order: 34
        ),
        Achievement(
            title: "Twenty-One Pilots",
            details: "21 days smoke-free",
            requirement: 21,
            requirementType: .daysSmokeFree,
            imageName: "image-a35",
            order: 35
        ),
        Achievement(
            title: "Smoke-Free Month",
            details: "30 days smoke-free",
            requirement: 30,
            requirementType: .daysSmokeFree,
            imageName: "image-a36",
            order: 36
        ),
        Achievement(
            title: "Six-Week Sage",
            details: "42 days smoke-free",
            requirement: 42,
            requirementType: .daysSmokeFree,
            imageName: "image-a37",
            order: 37
        ),
        Achievement(
            title: "Two-Month Titan",
            details: "60 days smoke-free",
            requirement: 60,
            requirementType: .daysSmokeFree,
            imageName: "image-a38",
            order: 38
        ),
        Achievement(
            title: "Quarter Year",
            details: "90 days smoke-free",
            requirement: 90,
            requirementType: .daysSmokeFree,
            imageName: "image-a39",
            order: 39
        ),
        Achievement(
            title: "The Clean 100",
            details: "100 days smoke-free",
            requirement: 100,
            requirementType: .daysSmokeFree,
            imageName: "image-a40",
            order: 40
        ),
        Achievement(
            title: "Season of Breath",
            details: "120 days smoke-free",
            requirement: 120,
            requirementType: .daysSmokeFree,
            imageName: "image-a41",
            order: 41
        ),
        Achievement(
            title: "Half-Year Halo",
            details: "180 days smoke-free",
            requirement: 180,
            requirementType: .daysSmokeFree,
            imageName: "image-a42",
            order: 42
        ),
        Achievement(
            title: "Year One",
            details: "365 days smoke-free",
            requirement: 365,
            requirementType: .daysSmokeFree,
            imageName: "image-a43",
            order: 43
        ),

        // — Life Regained (minutes converted to hours)
        Achievement(
            title: "Borrowed Time",
            details: "10 minutes of life regained",
            requirement: 10.0 / 60.0,  // Convert minutes to hours
            requirementType: .lifeRegained,
            imageName: "image-a44",
            order: 44
        ),
        Achievement(
            title: "Pocketful of Minutes",
            details: "30 minutes of life regained",
            requirement: 30.0 / 60.0,  // Convert minutes to hours
            requirementType: .lifeRegained,
            imageName: "image-a45",
            order: 45
        ),
        Achievement(
            title: "Superpowers",
            details: "1 hour of life regained",
            requirement: 1.0,
            requirementType: .lifeRegained,
            imageName: "image-a46",
            order: 46
        ),
        Achievement(
            title: "Time Traveler",
            details: "2 hours of life regained",
            requirement: 2.0,
            requirementType: .lifeRegained,
            imageName: "image-a47",
            order: 47
        ),
        Achievement(
            title: "Hourglass Hero",
            details: "3 hours of life regained",
            requirement: 3.0,
            requirementType: .lifeRegained,
            imageName: "image-a48",
            order: 48
        ),
        Achievement(
            title: "Clockmaster",
            details: "6 hours of life regained",
            requirement: 6.0,
            requirementType: .lifeRegained,
            imageName: "image-a49",
            order: 49
        ),
        Achievement(
            title: "Daylight Bonus",
            details: "12 hours of life regained",
            requirement: 12.0,
            requirementType: .lifeRegained,
            imageName: "image-a50",
            order: 50
        ),
        Achievement(
            title: "Time Bender",
            details: "18 hours of life regained",
            requirement: 18.0,
            requirementType: .lifeRegained,
            imageName: "image-a51",
            order: 51
        ),
        Achievement(
            title: "Day Reclaimed",
            details: "24 hours of life regained",
            requirement: 24.0,
            requirementType: .lifeRegained,
            imageName: "image-a52",
            order: 52
        ),
        Achievement(
            title: "Beyond Time",
            details: "48 hours of life regained",
            requirement: 48.0,
            requirementType: .lifeRegained,
            imageName: "image-a53",
            order: 53
        ),
        Achievement(
            title: "Immortality Patch",
            details: "72 hours of life regained",
            requirement: 72.0,
            requirementType: .lifeRegained,
            imageName: "image-a54",
            order: 54
        ),
        Achievement(
            title: "Eternal Engine",
            details: "120 hours of life regained",
            requirement: 120.0,
            requirementType: .lifeRegained,
            imageName: "image-a55",
            order: 55
        ),
        Achievement(
            title: "Time Overlord",
            details: "200 hours of life regained",
            requirement: 200.0,
            requirementType: .lifeRegained,
            imageName: "image-a56",
            order: 56
        ),

        // — Special Novel Achievements (fun extras)
        // Note: These have threshold 0 and will need special handling in the view model
        Achievement(
            title: "You vs. You",
            details: "First time opening the app",
            requirement: 0,
            requirementType: .daysSmokeFree,
            imageName: "image-a57",
            order: 57
        ),
        Achievement(
            title: "Reset Warrior",
            details: "First time restarting progress",
            requirement: 0,
            requirementType: .daysSmokeFree,
            imageName: "image-a58",
            order: 58
        ),
        Achievement(
            title: "Habit Hacker",
            details: "Used the app for 7 consecutive days",
            requirement: 7,
            requirementType: .daysSmokeFree,
            imageName: "image-a59",
            order: 59
        ),
        Achievement(
            title: "Mind Over Nicotine",
            details: "Reached a new personal best streak",
            requirement: 0,
            requirementType: .daysSmokeFree,
            imageName: "image-a60",
            order: 60
        )
    ]
}
