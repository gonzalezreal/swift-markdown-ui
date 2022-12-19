import MarkdownUI
import SwiftUI

struct RepositoryReadmeView: View {
  private let about = """
    This screen demonstrates how **MarkdownUI** renders a
    GitHub repository's `README.md` file.
    """

  private let client = RepositoryReadmeClient()

  @State private var owner = "apple"
  @State private var repo = "swift-format"
  @State private var content = ""
  @State private var baseURL: URL?
  @State private var isRefreshing = false

  var body: some View {
    DemoView {
      self.about
    } content: {
      Section("Repository") {
        TextField("Owner", text: $owner)
        TextField("Repo", text: $repo)
        Button("Refresh") {
          self.refresh()
        }
        .disabled(self.isRefreshing)
      }

      Section("Readme") {
        // workaround to ignore the form row height limit
        ScrollView {
          Markdown(self.content, baseURL: self.baseURL)
        }
      }
    }
    .onAppear {
      self.refresh()
    }
    .navigationTitle("Repository README")
  }

  private func refresh() {
    self.isRefreshing = true
    Task {
      if let (content, baseURL) = try? await self.client.readme(
        owner: self.owner,
        repo: self.repo
      ) {
        self.content = content
        self.baseURL = baseURL
      } else {
        self.content = "Oops! Something went wrong while fetching the README file."
        self.baseURL = nil
      }
      self.isRefreshing = false
    }
  }
}

struct RepositoryReadmeView_Previews: PreviewProvider {
  static var previews: some View {
    RepositoryReadmeView()
  }
}

// MARK: - RepositoryReadmeClient

struct RepositoryReadmeClient {
  private struct Response: Codable {
    let content: String
    let downloadUrl: URL

    var decodedContent: String? {
      Data(base64Encoded: self.content, options: .ignoreUnknownCharacters)
        .flatMap { String(data: $0, encoding: .utf8) }
    }

    var baseURL: URL {
      self.downloadUrl.deletingLastPathComponent()
    }
  }

  private let decoder = JSONDecoder()

  init() {
    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  func readme(owner: String, repo: String) async throws -> (String, URL) {
    let (data, _) = try await URLSession.shared
      .data(from: URL(string: "https://api.github.com/repos/\(owner)/\(repo)/readme")!)
    let response = try self.decoder.decode(Response.self, from: data)

    return (response.decodedContent ?? "", response.baseURL)
  }
}
