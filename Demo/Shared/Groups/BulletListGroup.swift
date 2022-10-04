import MarkdownUI
import SwiftUI

struct BulletListGroup: View {
  var body: some View {
    DemoSection(
      description: "Unordered lists can use either asterisks, plus, or hyphens as list markers."
    ) {
      Markdown(
        #"""
        List of humorous units of measurement:

        * Systems
          * FFF units
          * Great Underground Empire (Zork)
          * Potrzebie
        * Quantity
          * Sagan

            As a humorous tribute to **Carl Sagan** and his association with the catchphrase
            "billions and billions", a sagan has been defined as a large quantity of anything.
        * Length
          * Altuve
          * Attoparsec
          * Beard-second

        ― From Wikipedia, the free encyclopedia
        """#
      )
    }
  }
}
