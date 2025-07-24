//
//  DailyBrief.model.swift
//  john-task-mobile
//
//  Created by Milo Woodman on 7/23/25.
//


struct DailyBrief: Identifiable, Codable {
    let id: String;
    let symbol: String;
    let companyName: String;
    let icon: String?;
    let title: String;
    let text: String;
    let publishedDate: String;
    let inlineImage: String?;
    let site: String;
    let url: String;
}


