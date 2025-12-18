//
//  DiffView.swift
//  Demo
//
//  Created by Jason van den Berg on 2025/12/18.
//

import SwiftUI
import MarkdownUI

struct DiffView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Example 1: Long paragraph with scattered word additions
                Section("Embellishing Prose") {
                    MarkdownDiff(
                        old: """
                        # The Quick Brown Fox

                        *The* quick brown fox jumps over the lazy dog. This sentence contains every letter of the alphabet and has been used for typing practice for many years. It remains a popular choice among typists and designers who need to display fonts.
                        """,
                        new: """
                        # The Extremely Quick Brown Fox

                        *The* extremely quick brown fox gracefully jumps over the very lazy dog. This famous sentence contains every single letter of the alphabet and has been widely used for typing practice for many years. It still remains a popular choice among professional typists and graphic designers who need to display fonts effectively.
                        """
                    )
                }

                Divider()

                // Example 2: Long paragraph with words removed
                Section("Trimming the Fat") {
                    MarkdownDiff(
                        old: """
                        ## Genesis: The Very Beginning of Everything

                        In the beginning, there was *absolutely nothing* but **complete and utter darkness**. Then, suddenly and without any warning whatsoever, a ***brilliant and magnificent*** light appeared in the vast empty void. The light was incredibly beautiful, warm, and inviting to all who witnessed it.
                        """,
                        new: """
                        ## Genesis

                        In the beginning, there was *nothing* but **darkness**. Then, suddenly, a ***brilliant*** light appeared in the void. The light was beautiful and warm to all who witnessed it.
                        """
                    )
                }

                Divider()

                // Example 3: Mixed additions and removals in same paragraph
                Section("Reworded Throughout") {
                    MarkdownDiff(
                        old: """
                        ### Career Guide: Software Development

                        **Software development** is a *complex* and challenging field that requires `dedication`, patience, and continuous learning. Developers must stay updated with the latest technologies and best practices to remain competitive in the job market. Many companies now require **full-stack developers** who can work on both *frontend* and *backend* systems.
                        """,
                        new: """
                        ### Career Guide: Software Engineering

                        **Software engineering** is a *rewarding* and challenging discipline that requires `dedication`, creativity, and lifelong learning. Engineers must stay current with emerging technologies and industry standards to remain valuable in their careers. Most organizations now prefer **versatile developers** who can contribute to both *frontend* and *backend* systems.
                        """
                    )
                }

                Divider()

                // Example 4: Multiple long paragraphs with various changes
                Section("Article Revision") {
                    MarkdownDiff(
                        old: """
                        # Introduction to Machine Learning

                        **Machine learning** is a subset of *artificial intelligence* that focuses on building systems that can learn from data. These systems improve their performance over time without being explicitly programmed for each task.

                        There are three main types of machine learning: **supervised learning**, **unsupervised learning**, and **reinforcement learning**. Each type has its own use cases and algorithms that work best for specific problems.

                        *Supervised learning* uses labeled data to train models. The algorithm learns to map `inputs` to `outputs` based on example input-output pairs. Common applications include image classification and spam detection.
                        """,
                        new: """
                        # Introduction to Modern Machine Learning

                        **Machine learning** is an *exciting* subset of *artificial intelligence* that focuses on building intelligent systems that can learn from data. These ***powerful*** systems continuously improve their performance over time without being explicitly programmed for each specific task.

                        There are four main types of machine learning: **supervised learning**, **unsupervised learning**, **reinforcement learning**, and **self-supervised learning**. Each type has its own unique use cases and specialized algorithms that work best for specific real-world problems.

                        *Supervised learning* uses carefully labeled data to train predictive models. The algorithm learns to accurately map `inputs` to `outputs` based on many example input-output pairs. Common applications include image classification, spam detection, and medical diagnosis.
                        """
                    )
                }

                Divider()

                // Example 5: Technical documentation changes
                Section("API Docs Update") {
                    MarkdownDiff(
                        old: """
                        ## API Reference

                        The `fetchData` function retrieves data from the server. It accepts a URL parameter and returns a promise that resolves with the response data.

                        **Parameters:**
                        - `url` - The endpoint URL to fetch from
                        - `options` - Optional configuration object

                        **Returns:** A promise containing the response data.

                        **Example:**
                        ```javascript
                        const data = await fetchData('/api/users');
                        ```
                        """,
                        new: """
                        ## API Reference

                        The `fetchData` function asynchronously retrieves data from the remote server. It accepts a URL parameter and an optional configuration object, returning a promise that resolves with the parsed response data or rejects with an error.

                        **Parameters:**
                        - `url` (required) - The endpoint URL to fetch from
                        - `options` (optional) - Configuration object with timeout and headers
                        - `retryCount` (optional) - Number of retry attempts on failure

                        **Returns:** A promise containing the parsed JSON response data.

                        **Throws:** `NetworkError` if the request fails after all retries.

                        **Example:**
                        ```javascript
                        const data = await fetchData('/api/users', { timeout: 5000 });
                        ```
                        """
                    )
                }

                Divider()

                // Example 6: Story/narrative text changes
                Section("Novel Draft Revision") {
                    MarkdownDiff(
                        old: """
                        ## Chapter One: *The House*

                        The old house stood at the end of the street, its windows **dark** and unwelcoming. Nobody had lived there for years, and the garden had grown wild with weeds and thorns. Children in the neighborhood whispered stories about *ghosts* and *monsters*, though none had ever dared to enter.

                        One autumn evening, a young girl named **Sarah** decided she would be the first. She pushed open the rusted gate, which creaked loudly in protest. The path to the front door was barely visible beneath the overgrown grass.
                        """,
                        new: """
                        ## Chapter One: *The Abandoned House*

                        The abandoned Victorian house stood at the end of **Maple Street**, its shattered windows **dark** and deeply unwelcoming. Nobody had lived there for decades, and the once-beautiful garden had grown completely wild with weeds, thorns, and twisted vines. Children in the neighborhood whispered terrifying stories about *ghosts*, *monsters*, and ***things that lurked in shadows***, though none had ever actually dared to enter.

                        One cold autumn evening, a brave young girl named **Sarah** finally decided she would be the first to explore it. She pushed open the ancient rusted gate, which creaked loudly in protest against the intrusion. The cobblestone path to the imposing front door was barely visible beneath the overgrown grass and fallen leaves.
                        """
                    )
                }

                Divider()

                // Example 7: List with many item changes
                Section("Requirements Overhaul") {
                    MarkdownDiff(
                        old: """
                        ## Project Requirements

                        - **User authentication** system
                        - Dashboard with *analytics*
                        - File upload functionality
                        - Email notifications
                        - Admin panel
                        - Search functionality
                        - Mobile responsive design
                        - API documentation
                        """,
                        new: """
                        ## Project Requirements (Updated)

                        - **User authentication** system with `OAuth` support
                        - *Real-time* dashboard with *interactive analytics*
                        - **Secure** file upload functionality with virus scanning
                        - Email and ***push*** notifications
                        - Advanced admin panel with role-based access
                        - Full-text search functionality with filters
                        - Mobile-first responsive design
                        - Comprehensive API documentation with examples
                        - Rate limiting and `API` throttling
                        - ~~Audit logging for compliance~~ *Required for SOC2*
                        """
                    )
                }

                Divider()

                // Example 8: Sentence restructuring
                Section("Event Announcement") {
                    MarkdownDiff(
                        old: """
                        # Conference 2024

                        The conference will be held on **Monday**. All participants should register before *Friday*. Lunch will be provided. The keynote speaker is Dr. Smith.
                        """,
                        new: """
                        # Annual Technology Conference 2025

                        The annual technology conference will be held on **Monday, December 15th**. All participants must complete their registration before *Friday* to guarantee their spot. A ***complimentary*** lunch will be provided in the main hall. We are excited to announce that the keynote speaker is the renowned **Dr. Sarah Smith**.
                        """
                    )
                }

                Divider()

                // Example 9: Dense technical text
                Section("Algorithm Spec") {
                    MarkdownDiff(
                        old: """
                        #### MergeSort Implementation

                        The algorithm processes input data in `O(n log n)` time complexity. Memory usage is *linear* with respect to input size. The implementation uses a **divide-and-conquer** approach, recursively splitting the problem into smaller subproblems until they can be solved directly. Results are then merged to produce the final output.
                        """,
                        new: """
                        #### Optimized MergeSort Implementation

                        The optimized algorithm efficiently processes input data in `O(n log n)` average time complexity, with `O(n²)` worst-case performance. Memory usage remains *linear* with respect to input size, requiring approximately `2n` auxiliary space. The robust implementation uses an advanced **divide-and-conquer** approach, recursively splitting the problem into smaller independent subproblems until they can be solved directly in ***constant time***. Results are then carefully merged using a *two-pointer technique* to produce the correctly sorted final output.
                        """
                    )
                }

                Divider()

                // Example 10: Blockquote with long text
                Section("Inspirational Quote") {
                    MarkdownDiff(
                        old: """
                        > The only way to do **great work** is to *love* what you do. If you haven't found it yet, keep looking. Don't settle.
                        >
                        > — *Steve Jobs*
                        """,
                        new: """
                        > The only way to truly do **great and meaningful work** is to *genuinely love* what you do every single day. If you haven't found it yet, keep looking with persistence and determination. ***Don't settle*** for anything less than your passion.
                        >
                        > — *Steve Jobs, 2005*
                        """
                    )
                }

                Divider()

                // Example 11: Minimal changes in long text
                Section("Needle in Haystack") {
                    MarkdownDiff(
                        old: """
                        ##### Placeholder Text

                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
                        """,
                        new: """
                        ##### Placeholder Text (Extended)

                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.
                        """
                    )
                }

                Divider()

                // Example 12: Complete rewrite
                Section("Rejection Letter Makeover") {
                    MarkdownDiff(
                        old: """
                        ###### Application Status

                        We **regret** to inform you that your application has been *unsuccessful* on this occasion. We received many strong applications and the decision was difficult. We wish you the best in your ~~future endeavors~~.
                        """,
                        new: """
                        ###### Your Application Update

                        **Thank you** for your interest in joining our team. After *careful consideration*, we have decided to move forward with other candidates whose experience more closely matches our current needs. We encourage you to apply for [future positions](https://careers.example.com) that align with your skills.
                        """
                    )
                }

                Divider()

                // Example 13: Nested formatting changes
                Section("Rich Text Styling") {
                    MarkdownDiff(
                        old: """
                        ## Formatting Guide

                        This text has **bold words** and *italic words* and even ***bold italic*** mixed together. You can also have `inline code` and [links](https://example.com) within the same paragraph.
                        """,
                        new: """
                        ## Advanced Formatting Guide

                        This updated text has **strong bold words** and *emphasized italic words* and even ***strong bold italic emphasis*** carefully mixed together. You can also have `inline code snippets` and [useful links](https://example.com/updated) and ~~strikethrough~~ within the same paragraph.
                        """
                    )
                }

                Divider()

                // Example 14: Legal/formal text changes
                Section("Terms of Service") {
                    MarkdownDiff(
                        old: """
                        # Terms of Service

                        By using this service, you agree to the **terms and conditions** outlined in this document. The company reserves the right to modify these terms at any time. Users are responsible for reviewing updates to the terms regularly. See our [Privacy Policy](https://example.com/privacy) for more details.
                        """,
                        new: """
                        # Terms of Service (Revised January 2025)

                        By accessing or using this service, you *explicitly* agree to be bound by the **terms and conditions** outlined in this ***legally binding*** document. The company reserves the right to modify, update, or amend these terms at any time without prior notice. Users are solely responsible for periodically reviewing any updates or changes to the terms regularly and continued use constitutes acceptance. See our [Privacy Policy](https://example.com/privacy-2025) and [Cookie Policy](https://example.com/cookies) for more details.
                        """
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Markdown Diff")
    }
}

private struct Section<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            content
        }
    }
}

#Preview {
    NavigationStack {
        DiffView()
    }
}
