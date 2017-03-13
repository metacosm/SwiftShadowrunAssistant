//
// Created by Christophe Laprun on 10/03/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import Foundation
import Kanna

class SkillsImporter {
   private static let chinaGreenElvisReference = "http://www.chinagreenelvis.com/gaming/tools/shadowrun/quickreference/skills.html"
   
   func importSkills(from: String, registry: SkillRegistry) {
      if let doc = HTML(url: URL(string: from)!, encoding: .utf8) {
         let skills = doc.css("h5")
         for skill in skills {
            guard let title = skill.text else {
               continue
            }

            let engine = registry.engine
            
            // name and linked attribute
            let skillNameAndAttribute = title.characters
            guard let attributeStartIndex = skillNameAndAttribute.index(of: "("),
                  let attributeEndIndex = skillNameAndAttribute.index(of: ")") else {
               print("No linked attribute in \(title)")
               continue
            }
            let name = title.substring(to: attributeStartIndex).trimmingCharacters(in: .whitespacesAndNewlines)
            let attributeName = title.substring(with: skillNameAndAttribute.index(after: attributeStartIndex)..<attributeEndIndex)
                  .trimmingCharacters(in: .whitespacesAndNewlines)
            guard let attribute = engine.attributeInfo(named: attributeName) else {
               print("Unknown attribute \(attributeName)")
               continue
            }

            // description
            let description = skill.at_xpath("following-sibling::p[1]")?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            // can default?
            var canDefault = false
            if let defaultDetail = skill.at_xpath("following-sibling::ul[1]/li[1]")?.text {
               let canDefaultString = defaultDetail.components(separatedBy: ":")[1]
               canDefault = canDefaultString.toBool() ?? false
            }
            print(canDefault)

            // specializations
            var specializations = [String]()
            if let specializationsDetail = skill.at_xpath("following-sibling::ul[1]/li[2]")?.text {
               let specializationsString = specializationsDetail.components(separatedBy: ":")[1]
               specializations = specializationsString.components(separatedBy: ",").map {
                  return $0.trimmingCharacters(in: .whitespacesAndNewlines)
               }
            }
            print(specializations)

            registry.createSkillInfo(named: name, description: description, linkedTo: attribute)
         }
      }
   }
}

extension String {
   func toBool() -> Bool? {
      switch self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
      case "True", "true", "yes", "1":
         return true
      case "False", "false", "no", "0":
         return false
      default:
         return nil
      }
   }
}

