//
//  EncounterDialogChoices.swift
//  terriblehackathon
//
//  Created by Louis Tur on 2/6/16.
//  Copyright © 2016 terriblehackathon. All rights reserved.
//

import Foundation

public enum DialogChoiceType {
  case Awkward
  case Angry
  case Neutral
  case Other
}

public class EncounterDialogChoices {
  var awkward: String
  var angry: String
  var neutral: String
  var other: String
  
  var selectedChoiceType: DialogChoiceType?
  
  public init(awkwardChoice: String, angryChoice: String, neutralChoice: String, otherChoice: String) {
    self.awkward = awkwardChoice
    self.angry = angryChoice
    self.neutral = neutralChoice
    self.other = otherChoice
  }
  
  public func selectChoiceType(type: DialogChoiceType) {
    self.selectedChoiceType = type
  }
  
}
