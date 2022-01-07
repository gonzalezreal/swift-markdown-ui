import MarkdownUI
import SwiftUI

struct BlockQuotesGroup: View {
  var body: some View {
    DemoSection(
      description: """
        To create a blockquote, start a line with greater than > followed by an optional space.

        Blockquotes can be nested, and can also contain other formatting.
        """
    ) {
      Markdown(
        #"""
        #### Groucho Marx quotes

        > “Well, art is art, isn't it? Still,
        > on the other hand, water is water!
        > And east is east and west is west and
        > if you take cranberries and stew them
        > like applesauce they taste much more
        > like prunes than rhubarb does. Now,
        > uh... now you tell me what you
        > know.”
        > > “I sent the club a wire stating,
        > > **PLEASE ACCEPT MY RESIGNATION. I DON'T
        > > WANT TO BELONG TO ANY CLUB THAT WILL ACCEPT ME AS A MEMBER**.”
        > > > “Outside of a dog, a book is man's best friend. Inside of a
        > > > dog it's too dark to read.”

        ― From [GoodReads](https://www.goodreads.com/author/quotes/43244.Groucho_Marx)
        """#
      )
    }
  }
}
