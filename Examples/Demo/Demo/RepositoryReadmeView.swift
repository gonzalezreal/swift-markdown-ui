import MarkdownUI
import SwiftUI

struct RepositoryReadmeView: View {
  private let about = """
    This screen demonstrates how **MarkdownUI** renders a GitHub repository's
    `README.md` file and how to implement a custom `OpenURLAction` that
    scrolls to the corresponding heading when the user taps on an anchor
    link.
    """

  @State private var owner = "apple"
  @State private var repo = "swift-format"

  var body: some View {
    Form {
      DisclosureGroup("About this demo") {
        Markdown {
          self.about
        }
      }

      Section("Repository") {
        TextField("Owner", text: $owner)
        TextField("Repo", text: $repo)
        NavigationLink {
          ReadmeView(owner: self.owner, repo: self.repo)
        } label: {
          Text("README.md")
        }
      }
      .autocapitalization(.none)
      .disableAutocorrection(true)
    }
    .navigationTitle("Repository README")
  }
}

struct RepositoryReadmeView_Previews: PreviewProvider {
  static var previews: some View {
    RepositoryReadmeView()
  }
}

// MARK: - ReadmeView

private struct ReadmeView: View {
  let owner: String
  let repo: String

  private let client = RepositoryReadmeClient()

  @State private var response: RepositoryReadmeClient.Response?
  @State private var isLoading = true

  var body: some View {
    Group {
      if self.isLoading {
        ProgressView()
      } else {
        ScrollViewReader { proxy in
          ScrollView {
            Group {
              if let response, let content = response.decodedContent {
                Markdown(content, baseURL: response.baseURL, imageBaseURL: response.imageBaseURL)
              } else {
                Markdown("Oops! Something went wrong while fetching the README file.")
              }
            }
            .padding()
            .background(Theme.gitHub.textBackgroundColor)
            .markdownTheme(.gitHub)
            .scrollToMarkdownHeadings(using: proxy)
          }
        }
      }
    }
    .onAppear {
      self.loadContent()
    }
  }

  private func loadContent() {
    self.isLoading = true
    Task {
      self.response = try? await self.client.readme(owner: self.owner, repo: self.repo)
      self.isLoading = false
    }
  }
}

// MARK: - Heading anchor scrolling

extension View {
  func scrollToMarkdownHeadings(using scrollViewProxy: ScrollViewProxy) -> some View {
    self.environment(
      \.openURL,
      OpenURLAction { url in
        guard let fragment = url.fragment?.lowercased() else {
          return .systemAction
        }
        withAnimation {
          scrollViewProxy.scrollTo(fragment, anchor: .top)
        }
        return .handled
      }
    )
  }
}

// MARK: - RepositoryReadmeClient

private struct RepositoryReadmeClient {
  struct Response: Codable {
    private enum CodingKeys: String, CodingKey {
      case content
      case htmlURL = "html_url"
      case downloadURL = "download_url"
    }

    let content: String
    let htmlURL: URL
    let downloadURL: URL

    var decodedContent: MarkdownContent? {
      Data(base64Encoded: self.content, options: .ignoreUnknownCharacters)
        .flatMap { String(decoding: $0, as: UTF8.self) }
        .map(MarkdownContent.init)
    }

    var baseURL: URL {
      self.htmlURL.deletingLastPathComponent()
    }

    var imageBaseURL: URL {
      self.downloadURL.deletingLastPathComponent()
    }
  }

  private let decoder = JSONDecoder()

  func readme(owner: String, repo: String) async throws -> Response {
    let (data, _) = try await URLSession.shared
      .data(from: URL(string: "https://api.github.com/repos/\(owner)/\(repo)/readme")!)
    return try self.decoder.decode(Response.self, from: data)
  }
}
