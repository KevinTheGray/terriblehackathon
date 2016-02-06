//
//  RandomEncounter.swift
//  terriblehackathon
//
//  Created by Louis Tur on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import Foundation

public protocol RandomEncounterDelegate {
  func didMakeDialogChoice(choice: EncounterDialogChoices)
}

public enum EncounterType {
  case NPCEntersElevator
}

public enum EncounterEvent {
  case PushesFloorButton
  case MakeSmallTalk
  case AudibleFart
}

public enum EncounterStage {
  case InitialInteraction
  case ResponseInteraction
  case ResolutionInteration
}


public class RandomEncounter {
  
  // MARK: - Variables
  private var encounterType: EncounterType = .NPCEntersElevator
  private var encounterEvent: EncounterEvent = .PushesFloorButton
  private var encounterNPC: EncounterNPC = EncounterNPC.cat()
  private var encounterStage: EncounterStage = .InitialInteraction
  private var delegate: RandomEncounterDelegate?
  
  private var fartDialogOptions: [String] = ["Stare intensely", " ", " ", " "]
  
  
  // MARK: - Initialization
  public class func createFartingCatEvent() -> RandomEncounter {
    return RandomEncounter.createEncounter(.NPCEntersElevator, event: .AudibleFart, withNPC: EncounterNPC.cat())
  }
  
  public class func createEncounter(type: EncounterType, event: EncounterEvent, withNPC npc: EncounterNPC) -> RandomEncounter {
    let randomEncounter: RandomEncounter = RandomEncounter()
    randomEncounter.encounterType = type
    randomEncounter.encounterEvent = event
    randomEncounter.encounterNPC = npc
    return randomEncounter
  }
  
  
  // MARK: - Dialog
  public func dialogOptionsForEvent(type: EncounterEvent) -> EncounterDialogChoices {
    var dialogOptions: EncounterDialogChoices = EncounterDialogChoices(awkwardChoice: "", angryChoice: "", neutralChoice: "", otherChoice: "")
    
    switch type{
    case .PushesFloorButton: dialogOptions = self.dialogOptionsForFartEvent()
    case .MakeSmallTalk: dialogOptions =  self.dialogOptionsForFartEvent()
    case .AudibleFart: dialogOptions =  self.dialogOptionsForFartEvent()
    }
    
    self.updateEncounterStage()
    return dialogOptions
  }
  
  private func dialogOptionsForFartEvent() -> EncounterDialogChoices {
    switch self.encounterStage {
    case .InitialInteraction: return EncounterDialogChoices(awkwardChoice: "Hey, that's a nice fragrance", angryChoice: "I wish I did that first",
      neutralChoice: "I dont feel very strongly about this", otherChoice: "*Stare Silently as the smell wafts")
    case .ResponseInteraction: return EncounterDialogChoices(awkwardChoice: "Maybe you didn't hear me. I said it was a nice fragrance", angryChoice: "You couldn't have held it in?",
      neutralChoice: "*Stare*", otherChoice: "*Excuse me, I need to make a call*")
    case .ResolutionInteration: return EncounterDialogChoices(awkwardChoice: "Hope to see you soon", angryChoice: "Jerk",
      neutralChoice: "Hmm... look at the time", otherChoice: "*Sit down*")
    }
  }
  
  
  // MARK: - Progress through events
  public func updateEncounterStage() {
    switch self.encounterStage {
    case .InitialInteraction: self.encounterStage = .ResponseInteraction
    case .ResponseInteraction: self.encounterStage = .ResolutionInteration
    default: self.encounterStage = .InitialInteraction
    }
  }
  
}