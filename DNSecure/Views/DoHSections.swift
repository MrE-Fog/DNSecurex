//
//  DoHSections.swift
//  DNSecure
//
//  Created by Kenta Kubo on 9/23/22.
//

import SwiftUI

struct DoHSections {
    @Binding var configuration: DoHConfiguration
}

extension DoHSections: View {
    var body: some View {
        Section {
            ForEach(0..<self.configuration.servers.count, id: \.self) { i in
                TextField(
                    "IP address",
                    text: .init(
                        get: { self.configuration.servers[i] },
                        set: {
                            self.configuration.servers[i] = $0
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    )
                )
                .textContentType(.URL)
                .keyboardType(.numbersAndPunctuation)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
            .onDelete { self.configuration.servers.remove(atOffsets: $0) }
            .onMove { self.configuration.servers.move(fromOffsets: $0, toOffset: $1) }
            Button("Add New Server") {
                self.configuration.servers.append("")
            }
        } header: {
            EditButton()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .overlay(alignment: .leading) {
                    Text("Servers")
                }
        } footer: {
            Text("The DNS server IP addresses.")
        }
        Section {
            HStack {
                Text("Server URL")
                TextField(
                    "Server URL",
                    text: .init(
                        get: {
                            self.configuration.serverURL?.absoluteString ?? ""
                        },
                        set: {
                            self.configuration.serverURL = URL(
                                string: $0.trimmingCharacters(in: .whitespacesAndNewlines)
                            )
                        }
                    )
                )
                .multilineTextAlignment(.trailing)
                .textContentType(.URL)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
        } header: {
            Text("DNS-over-HTTPS Settings")
        } footer: {
            Text("The URL of a DNS-over-HTTPS server.")
        }
    }
}

struct DoHSections_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            DoHSections(
                configuration: .constant(
                    .init(
                        servers: [
                            "1.1.1.1",
                            "1.0.0.1",
                            "2606:4700:4700::1111",
                            "2606:4700:4700::1001",
                        ],
                        serverURL: URL(string: "https://cloudflare-dns.com/dns-query")
                    )
                )
            )
        }
    }
}
