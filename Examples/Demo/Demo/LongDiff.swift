//
//  LongDiff.swift
//  Demo
//
//  Created by Jason van den Berg on 2025/12/19.
//

import SwiftUI
import MarkdownUI

struct LongDiffView: View {
    private let baseAgreement = """
        # Residential Lease Agreement

        **This Residential Lease Agreement** ("Agreement") is entered into as of the **[AGREEMENT_DATE]**, by and between the *Landlord* and the *Tenant* identified below.

        ## 1. Parties

        **Landlord:** John Smith Properties LLC, a registered property management company operating in the State of California, with a principal place of business at 123 Main Street, Los Angeles, CA 90001.

        **Tenant:** The individual(s) signing this Agreement who will occupy the Premises as their primary residence.

        ## 2. Premises

        The Landlord agrees to lease to the Tenant the property located at **456 Oak Avenue, Apartment 7B, San Francisco, CA 94102** (the "Premises"). The Premises includes all fixtures, appliances, and furnishings as listed in the attached inventory document.

        ## 3. Term of Lease

        The initial term of this Lease shall commence on **January 1, 2025** and shall terminate on **December 31, 2025**, unless renewed or extended in accordance with the terms herein. This constitutes a *twelve-month lease period*.

        ## 4. Rent Payment

        The Tenant agrees to pay monthly rent in the amount of **$2,500.00** (Two Thousand Five Hundred Dollars), due on the **1st day** of each calendar month. Rent shall be paid via electronic transfer to the designated account or by certified check delivered to the Landlord's office.

        ### 4.1 Late Fees

        Any rent payment received after the **5th day** of the month shall incur a late fee of **$75.00**. Additional late fees of *$10.00 per day* may apply for each subsequent day the rent remains unpaid, up to a maximum of **$200.00** per month.

        ## 5. Security Deposit

        Upon execution of this Agreement, the Tenant shall pay a security deposit in the amount of **$5,000.00** (Five Thousand Dollars). This deposit shall be held by the Landlord as security for the faithful performance of the Tenant's obligations.

        [ADDITIONAL_CLAUSE_PLACEHOLDER]

        ## 6. Utilities and Services

        The Tenant shall be responsible for payment of all utilities and services, including but not limited to: *electricity*, *gas*, *water*, *internet*, and *cable television*. The Landlord shall be responsible for **trash collection** and **building maintenance**.

        ## 7. Maintenance and Repairs

        The Tenant shall maintain the Premises in a clean and sanitary condition. The Tenant shall promptly notify the Landlord of any maintenance issues or necessary repairs. The Landlord shall complete all repairs within a `reasonable timeframe` not exceeding **14 business days** for non-emergency repairs.

        ### 7.1 Emergency Repairs

        For emergency repairs involving *flooding*, *fire damage*, or *loss of essential services*, the Landlord shall respond within **24 hours** of notification.

        ## 8. Rules and Regulations

        The Tenant agrees to comply with all rules and regulations set forth by the Landlord, including:

        - No smoking permitted inside the Premises or common areas
        - Quiet hours observed between **10:00 PM** and **8:00 AM**
        - No unauthorized alterations or modifications to the Premises
        - All guests must be accompanied by the Tenant
        - Pets are permitted only with prior written approval and additional deposit

        ## 9. Termination

        Either party may terminate this Agreement by providing **60 days** written notice prior to the intended termination date. Upon termination, the Tenant shall vacate the Premises and return all keys and access devices to the Landlord.

        ## 10. Governing Law

        This Agreement shall be governed by and construed in accordance with the laws of the **State of California**. Any disputes arising from this Agreement shall be resolved through *binding arbitration* in the county where the Premises is located.

        ---

        **IN WITNESS WHEREOF**, the parties have executed this Residential Lease Agreement as of the date first written above.

        > *This document constitutes a legally binding agreement. Both parties are advised to retain a copy for their records.*
        """

    private let additionalClause = """

        ## 5.1 Pet Deposit Addendum

        In addition to the standard security deposit, Tenants who have received approval to keep pets on the Premises shall pay a **non-refundable pet deposit** of **$500.00** per pet, up to a maximum of two pets. The Tenant shall also pay an additional monthly **pet rent** of *$50.00 per pet*. The Tenant assumes full responsibility for any damage caused by pets, including but not limited to: carpet stains, scratches to flooring or walls, and damage to landscaping. The Landlord reserves the right to revoke pet privileges if the pet causes repeated disturbances or damage to the property.

        """

    private var oldAgreement: String {
        baseAgreement
            .replacingOccurrences(of: "[AGREEMENT_DATE]", with: "1st day of January, 2025")
            .replacingOccurrences(of: "[ADDITIONAL_CLAUSE_PLACEHOLDER]", with: "")
    }

    private var newAgreement: String {
        baseAgreement
            .replacingOccurrences(of: "[AGREEMENT_DATE]", with: "15th day of March, 2025")
            .replacingOccurrences(of: "[ADDITIONAL_CLAUSE_PLACEHOLDER]", with: additionalClause)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Rental Agreement Comparison")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                styledMarkdownDiff(old: oldAgreement, new: newAgreement)
            }
            .padding()
        }
        .navigationTitle("Long Document Diff")
    }

    @ViewBuilder
    private func styledMarkdownDiff(old: String, new: String) -> some View {
        MarkdownDiff(old: old, new: new)
            .markdownBlockStyle(\.heading1) { configuration in
                configuration.label
                    .padding(.vertical, 4)
                    .markdownTextStyle {
                        FontWeight(.bold)
                        FontSize(15)
                    }
            }
            .markdownBlockStyle(\.heading2) { configuration in
                configuration.label
                    .padding(.vertical, 4)
                    .markdownTextStyle {
                        FontWeight(.bold)
                        FontSize(14.5)
                    }
            }
            .markdownBlockStyle(\.heading3) { configuration in
                configuration.label
                    .padding(.vertical, 4)
                    .markdownTextStyle {
                        FontWeight(.bold)
                        FontSize(14.4)
                    }
            }
            .markdownBlockStyle(\.heading4) { configuration in
                configuration.label
                    .padding(.vertical, 4)
                    .markdownTextStyle {
                        FontWeight(.bold)
                        FontSize(14.3)
                    }
            }
            .markdownBlockStyle(\.heading5) { configuration in
                configuration.label
                    .padding(.vertical, 4)
                    .markdownTextStyle {
                        FontWeight(.bold)
                        FontSize(14.2)
                    }
            }
            .markdownBlockStyle(\.heading6) { configuration in
                configuration.label
                    .padding(.vertical, 4)
                    .markdownTextStyle {
                        FontWeight(.bold)
                        FontSize(14.1)
                    }
            }
            .markdownBlockStyle(\.paragraph) { configuration in
                configuration.label
                    .markdownTextStyle {
                        FontSize(14)
                    }
            }
    }
}

#Preview {
    NavigationStack {
        LongDiffView()
    }
}
