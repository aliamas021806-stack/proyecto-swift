---
*** Begin Patch
*** Update File: DashboardView.swift
@@
-import SwiftUI
-
-struct DashboardView: View {
-    @State private var period: PeriodFilter = .hoy
-    @State private var filter: QuickFilter = .todas
-    @State private var viewMode: ViewMode = .lista
-    @State private var searchText: String = ""
-
-    enum ViewMode { case lista, agenda }
-
-    private var appointments: [Appointment] { SampleData.dashboardAppointments }
-
-    var body: some View {
+import SwiftUI
+import SwiftData
+
+struct DashboardView: View {
+    @Environment(\.modelContext) private var modelContext
+    @StateObject private var viewModel = DashboardViewModel()
+
+    @State private var period: PeriodFilter = .hoy
+    @State private var filter: QuickFilter = .todas
+    @State private var viewMode: ViewMode = .lista
+    @State private var searchText: String = ""
+
+    enum ViewMode { case lista, agenda }
+
+    var body: some View {
         ScrollView {
             VStack(spacing: AppSpacing.md) {
                 greetingSection
                 searchSection
                 metricsCarousel
                 periodAndViewSection
                 filterChipsSection
-                appointmentsList
+                appointmentsList
             }
             .padding(.horizontal, AppSpacing.marginSM)
             .padding(.top, AppSpacing.sm)
             .padding(.bottom, 96)
         }
         .background(AppColor.surface)
         .scrollIndicators(.hidden)
+        .task {
+            await viewModel.configure(context: modelContext)
+        }
     }
@@
     private var appointmentsList: some View {
         VStack(spacing: AppSpacing.md) {
-            ForEach(appointments) { appointment in
-                AppointmentCard(appointment: appointment)
-            }
+            if viewModel.isLoading {
+                ProgressView().frame(maxWidth: .infinity)
+            } else if let error = viewModel.errorMessage {
+                VStack { Text("Error: \(error)") }
+            } else if viewModel.appointments.isEmpty {
+                Text("No hay citas").foregroundStyle(AppColor.onSurfaceVariant)
+            } else {
+                ForEach(viewModel.appointments, id: \.(id)) { model in
+                    AppointmentCard(appointment: uiAppointment(from: model))
+                }
+            }
         }
     }
 }
*** End Patch
