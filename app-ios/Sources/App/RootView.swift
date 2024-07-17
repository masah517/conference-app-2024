import AboutFeature
import ComposableArchitecture
import ContributorFeature
import FavoriteFeature
import LicenseList
import SponsorFeature
import StaffFeature
import SwiftUI
import TimetableDetailFeature
import TimetableFeature
import Theme

private enum Tab {
    case timetable
    case map
    case favorite
    case about
    case idCard
}

public struct RootView: View {
    @Bindable private var store: StoreOf<RootReducer>
    @State private var selection: Tab = .timetable

    public init(store: StoreOf<RootReducer>) {
        self.store = store
    }

    public var body: some View {
        TabView(selection: $selection) {
            timetableTab
                .tag(Tab.timetable)
                .tabItem {
                    Label(
                        title: { Text("Timetable") },
                        icon: { Image(.icTimetable).renderingMode(.template) }
                    )
                }

            Text("Map Feature")
                .tag(Tab.map)
                .tabItem {
                    Label(
                        title: { Text("Event Map") },
                        icon: { Image(.icMap).renderingMode(.template) }
                    )
                }

            FavoriteScreen(
                store: store.scope(
                    state: \.favorite,
                    action: \.favorite
                )
            )
            .tag(Tab.favorite)
            .tabItem {
                Label(
                    title: { Text("Favorite") },
                    icon: { Image(.icFav).renderingMode(.template) }
                )
            }

            aboutTab
                .tag(Tab.about)
                .tabItem {
                    Label(
                        title: { Text("About") },
                        icon: { Image(.icInfo).renderingMode(.template) }
                    )
                }

            Text("ID Card Feature")
                .tag(Tab.idCard)
                .tabItem {
                    Label(
                        title: { Text("ID Card") },
                        icon: { Image(.icProfileCard).renderingMode(.template) }
                    )
                }
        }
        .tint(AssetColors.Custom.arcticFox.swiftUIColor)
    }

    @MainActor
    private var timetableTab: some View {
        NavigationStack(
            path: $store.scope(
                state: \.paths.timetable,
                action: \.paths.timetable
            )
        ) {
            TimetableView(
                store: store.scope(
                    state: \.timetable,
                    action: \.timetable
                )
            )
        } destination: { store in
            switch store.case {
            case let .timetableDetail(store):
                TimetableDetailView(store: store)
            }
        }
    }

    @MainActor
    private var aboutTab: some View {
        NavigationStack(
            path: $store.scope(
                state: \.paths.about,
                action: \.paths.about
            )
        ) {
            AboutView(
                store: store.scope(
                    state: \.about,
                    action: \.about
                )
            )
        } destination: { store in
            switch store.case {
            case let .staff(store):
                StaffView(store: store)

            case let .contributor(store):
                ContributorView(store: store)

            case let .sponsor(store):
                SponsorView(store: store)

            case .acknowledgements:
                LicenseListView()
            }
        }
    }
}

#Preview {
    RootView(
        store: .init(
            initialState: .init(
                timetable: .init()
            ),
            reducer: {}
        )
    )
}
