//
//  EncounterNPC.swift
//  terriblehackathon
//
//  Created by Louis Tur on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import Foundation

public class EncounterNPC {
  private var npcName: String = ""
  public class func cat() -> EncounterNPC {
    let encounterNPC: EncounterNPC = EncounterNPC()
    encounterNPC.npcName = "Tabby Cat"
    return encounterNPC
  }
  
  public func npcDialogResponseForType(type: DialogChoiceType) -> String {
    switch type {
    case .Awkward: return "*Stares at you blankly*"
    case .Angry: return "*Purrs intensly*"
    case .Neutral: return "*Stares at you blankly*"
    case .Other: return "*Stares off and meows slowly*"
    }
  }
}