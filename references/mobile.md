# Mobile Development

Patterns for building iOS and Android applications. Apply when building
native or cross-platform mobile apps.

## When to Apply

- Building iOS app (Swift/SwiftUI)
- Building Android app (Kotlin/Jetpack Compose)
- Building cross-platform app (React Native, Flutter, etc.)
- Need offline-first capabilities
- Need push notifications
- Need device-specific features (camera, GPS, sensors)

## Architecture Patterns

### Offline-First

Mobile apps must work without constant connectivity.

**Patterns:**
- **Local database** (SQLite, Realm, WatermelonDB)
- **Sync engine** (background sync when online)
- **Conflict resolution** (last-write-wins, manual merge, CRDT)
- **Optimistic updates** (update UI immediately, sync later)

**Tools:**
- WatermelonDB (React Native, offline-first)
- Realm (cross-platform, sync built-in)
- Firestore (Google, offline support)
- Amplify DataStore (AWS, offline support)

### State Management

Mobile apps have complex state (network status, background/foreground, etc.)

**Patterns:**
- **Unidirectional data flow** (Redux, MobX, Zustand)
- **Reactive streams** (RxJS, Combine, Flow)
- **State machines** (XState) for complex flows

**Tools:**
- React Native: Zustand, Jotai, Redux Toolkit
- Flutter: Riverpod, BLoC, Provider
- iOS: Combine, TCA (The Composable Architecture)
- Android: Flow, LiveData, ViewModel

### Navigation

Mobile navigation is different from web (stack-based, deep linking, back button)

**Patterns:**
- **Stack navigation** (push/pop screens)
- **Tab navigation** (bottom tabs)
- **Deep linking** (URL schemes, universal links)
- **State restoration** (restore navigation state after app kill)

**Tools:**
- React Native: React Navigation, Expo Router
- Flutter: GoRouter, AutoRoute
- iOS: SwiftUI Navigation, UIKit UINavigationController
- Android: Jetpack Navigation, Compose Navigation

## Platform-Specific Concerns

### iOS

**Deployment:**
- App Store submission (review process: 1-7 days)
- TestFlight for beta testing
- App Store Connect for metadata/screenshots

**Constraints:**
- App size limit: 200MB (over cellular), 4GB (total)
- Background execution: limited (must declare background modes)
- Memory: ~1-2GB (varies by device)
- Battery: background tasks consume battery

**Testing:**
- Xcode Simulator (fast, not real device)
- TestFlight (real device beta testing)
- XCTest (unit/UI tests)

### Android

**Deployment:**
- Google Play Store (review process: hours to days)
- Internal testing track
- Production rollout (staged rollout: 10% → 50% → 100%)

**Constraints:**
- App size: no hard limit, but <150MB recommended
- Background execution: more flexible than iOS (but battery optimization)
- Memory: varies widely (512MB to 8GB+)
- Fragmentation: many screen sizes, OS versions

**Testing:**
- Android Emulator (fast, not real device)
- Firebase Test Lab (real device testing)
- Espresso (UI tests), JUnit (unit tests)

### Cross-Platform

**React Native:**
- Pros: JavaScript/TypeScript, large ecosystem, hot reload
- Cons: bridge overhead, native modules needed for some features
- Tools: Expo (managed workflow), bare React Native

**Flutter:**
- Pros: single codebase, high performance, custom UI
- Cons: Dart language (smaller ecosystem), larger app size
- Tools: Flutter SDK, Dart

**Comparison:**
- Choose React Native if: team knows JS/TS, need native modules, large ecosystem
- Choose Flutter if: need consistent UI, high performance, willing to learn Dart

## Device Constraints

### Performance

**60fps target:**
- Avoid expensive operations on main thread
- Use async/await for I/O
- Profile with platform tools (Instruments for iOS, Android Profiler)

**Memory:**
- iOS: ~1-2GB (app gets killed if exceeded)
- Android: varies (512MB to 8GB+)
- Use lazy loading, pagination, image compression

**Battery:**
- Background tasks consume battery
- Use efficient networking (batch requests, WebSocket)
- Respect Low Power Mode (iOS) / Doze Mode (Android)

### App Size

**Optimization:**
- Compress images (WebP, AVIF)
- Remove unused assets
- Use code splitting (lazy loading)
- ProGuard/R8 for Android (code shrinking)
- Bitcode for iOS (app thinning)

**Tools:**
- iOS: App Thinning Size Report (Xcode)
- Android: APK Analyzer (Android Studio)
- Cross-platform: bundlephobia (JS), asset-check (Flutter)

### Network

**Strategies:**
- **Offline-first** (local database, sync when online)
- **Background sync** (periodic sync, push notifications)
- **Efficient networking** (batch requests, WebSocket, GraphQL)
- **Caching** (HTTP cache, local cache)

**Tools:**
- React Native: React Query, SWR, Apollo Client
- Flutter: Dio, http, graphql_flutter
- iOS: URLSession, Alamofire
- Android: Retrofit, OkHttp

## Push Notifications

### Implementation

**iOS:**
- APNs (Apple Push Notification service)
- Requires Apple Developer account ($99/year)
- Provisioning profile with push notification capability

**Android:**
- FCM (Firebase Cloud Messaging)
- Free (Google Play Services)
- Firebase project setup

**Cross-platform:**
- OneSignal (free tier, easy setup)
- Pusher Beams (free tier)
- AWS SNS/SQS (pay-per-use)

### Best Practices

- Request permission at the right time (after user sees value)
- Use silent push for background sync (iOS)
- Handle notification tap (deep linking)
- Respect user preferences (notification settings)
- Test on real devices (simulators don't support push)

## App Store Optimization (ASO)

### Metadata

**App Store (iOS):**
- App name (30 chars)
- Subtitle (30 chars)
- Keywords (100 chars, comma-separated)
- Description (4000 chars)
- Screenshots (up to 10, 6.7" and 5.5")
- App preview video (optional, 30s)

**Google Play (Android):**
- App name (30 chars)
- Short description (80 chars)
- Full description (4000 chars)
- Screenshots (up to 8, phone + tablet)
- Feature graphic (1024x500)
- Promo graphic (180x120)

### Optimization

- Use relevant keywords in title/subtitle
- Write compelling description (benefits first)
- High-quality screenshots (show key features)
- Encourage reviews (prompt after positive experience)
- Respond to reviews (show you care)
- A/B test metadata (Apple: product page optimization, Google: store listing experiments)

## Testing

### Unit Tests

- Test business logic (models, services, utilities)
- Mock dependencies (network, database, device APIs)
- Fast execution (<1s per test)

**Tools:**
- React Native: Jest, React Native Testing Library
- Flutter: flutter_test, mockito
- iOS: XCTest
- Android: JUnit, Mockito

### Integration Tests

- Test screen flows (navigation, state changes)
- Test API integration (mock server)
- Test database operations (real database)

**Tools:**
- React Native: Detox, Maestro
- Flutter: integration_test, Patrol
- iOS: XCUITest
- Android: Espresso

### E2E Tests

- Test on real devices (simulators not enough)
- Test critical user journeys (signup, purchase, etc.)
- Test edge cases (no network, low battery, etc.)

**Tools:**
- Firebase Test Lab (Android + iOS)
- AWS Device Farm (Android + iOS)
- BrowserStack (Android + iOS)
- Maestro (cross-platform, easy setup)

## Deployment

### CI/CD

**Tools:**
- Fastlane (iOS + Android, open source)
- Bitrise (mobile-specific, commercial)
- Codemagic (mobile-specific, commercial)
- GitHub Actions (with Fastlane)
- Expo EAS (React Native, managed)

**Pipeline:**
1. Run tests (unit, integration)
2. Build app (iOS: .ipa, Android: .aab)
3. Upload to test track (TestFlight, Internal Testing)
4. Notify testers (Slack, email)
5. Promote to production (after approval)

### Beta Testing

**iOS:**
- TestFlight (up to 10,000 testers)
- Internal testing (up to 100 testers, no review)
- External testing (requires beta review)

**Android:**
- Google Play Internal Testing (up to 100 testers)
- Google Play Closed Testing (up to 1,000 testers)
- Google Play Open Testing (unlimited testers)
- Firebase App Distribution (cross-platform)

### Production Release

**iOS:**
- Submit to App Store (review: 1-7 days)
- Staged rollout not supported (all users get update)
- Can force update (but users can disable auto-update)

**Android:**
- Submit to Google Play (review: hours to days)
- Staged rollout (10% → 50% → 100%)
- Can force update (via in-app update API)

## Integration with Platform Builder

### Phase 1 (Blueprint)

- Decide platform strategy (iOS, Android, cross-platform)
- Choose architecture pattern (offline-first, state management)
- Define device constraints (app size, memory, battery)
- Document in `docs/ARCHITECTURE.md`

### Phase 3 (Implement)

- Implement offline-first patterns (local database, sync)
- Implement push notifications (APNs, FCM)
- Implement deep linking (URL schemes, universal links)
- Test on real devices (not just simulators)

### Phase 4 (Productionization)

- Set up CI/CD (Fastlane, Bitrise, Codemagic)
- Configure beta testing (TestFlight, Internal Testing)
- Prepare app store metadata (screenshots, description)
- Submit to app stores

### Phase 6 (Operations)

- Monitor crash reports (Sentry, Crashlytics)
- Monitor analytics (Firebase, Mixpanel, Amplitude)
- Monitor app store ratings/reviews
- Optimize app size and performance

## Anti-Patterns

- **Ignoring offline:** app doesn't work without network
- **No error handling:** crashes on network failure
- **Large app size:** users won't download >100MB apps
- **No deep linking:** can't open app from notification/web
- **Ignoring battery:** background tasks drain battery
- **No beta testing:** release without testing on real devices
- **Ignoring app store optimization:** poor discoverability
