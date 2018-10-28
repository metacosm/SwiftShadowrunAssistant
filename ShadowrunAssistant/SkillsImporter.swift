//
// Created by Christophe Laprun on 10/03/2017.
// Copyright (c) 2017 Christophe Laprun. All rights reserved.
//

import Foundation
import SwiftSoup

class SkillsImporter {
   static let chinaGreenElvisReference = "http://www.chinagreenelvis.com/gaming/tools/shadowrun/quickreference/skills.html"
   
   func importSkills(from: String, registry: SkillRegistry) {
      guard let url = URL(string: from) else {
         print("Error: \(from) doesn't appear to be a valid URL")
         return
      }

      do {
         let html = try String(contentsOf: url, encoding: .utf8)
         let doc = try SwiftSoup.parse(html)

         let skills = try doc.select("h5")

         for skill: Element in skills.array() {
            let title = try skill.text()

            let engine = registry.engine

            // name and linked attribute
            guard let attributeStartIndex = title.index(of: "("),
                  let attributeEndIndex = title.index(of: ")") else {
               print("No linked attribute in \(title)")
               continue
            }
            let name = title.substring(to: attributeStartIndex).trimmingCharacters(in: .whitespacesAndNewlines)
            let attributeName = title.substring(with: title.index(after: attributeStartIndex)..<attributeEndIndex)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            guard let attribute = engine.attributeInfo(named: attributeName) else {
               print("Unknown attribute \(attributeName)")
               continue
            }

            // description
            let nextP: Element? = try skill.nextElementSibling()
            let description = try nextP.map {
               try $0.text().trimmingCharacters(in: .whitespacesAndNewlines)
            }

            if let nextUL: Element = try nextP?.nextElementSibling() {

               // can default?
               var canDefault = false
               let defaultDetail = try nextUL.child(0).text()
               let canDefaultString = defaultDetail.components(separatedBy: ":")[1]
               canDefault = canDefaultString.toBool() ?? false
               print(canDefault)

               // specializations
               var specializations = [String]()
               let specializationsDetail = try nextUL.child(1).text()
               let specializationsString = specializationsDetail.components(separatedBy: ":")[1]
               specializations = specializationsString.components(separatedBy: ",").map {
                  return $0.trimmingCharacters(in: .whitespacesAndNewlines)
               }
               print(specializations)
            }


            registry.createSkillInfo(named: name, description: description ?? "", linkedTo: attribute)
         }
      } catch let error {
         print("Error: \(error)")
         return
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

