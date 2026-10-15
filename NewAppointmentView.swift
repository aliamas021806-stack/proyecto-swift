---
*** Begin Patch
*** Update File: NewAppointmentView.swift
@@
-import SwiftUI
-
-struct NewAppointmentView: View {
-    @Environment(\.dismiss) private var dismiss
-
-    @State private var selectedDay: Int = 24
-    @State private var selectedSlot: String? = "10:00"
-    @State private var modality: AppointmentModality = .presencial
-    @State private var reason: String = ""
-    @State private var reminderOn = true
-    @State private var fastingOn = false
-    @State private var isSaving = false
-    @State private var saved = false
+import SwiftUI
+import SwiftData
+
+struct NewAppointmentView: View {
+    @Environment(\.dismiss) private var dismiss
+    @Environment(\.modelContext) private var modelContext
+
+    @StateObject private var viewModel = NewAppointmentViewModel()
+
+    @State private var selectedDay: Int = 24
+    @State private var selectedSlot: String? = "10:00"
+    @State private var modality: AppointmentModality = .presencial
+    @State private var reason: String = ""
+    @State private var reminderOn = true
+    @State private var fastingOn = false
+    @State private var isSaving = false
+    @State private var saved = false
@@
     private var bottomBar: some View {
         HStack(spacing: 12) {
             Button { dismiss() } label: {
                 Text("Cancelar")
                     .font(AppFont.labelLG).foregroundStyle(AppColor.onSurface)
                     .frame(maxWidth: .infinity)
                     .padding(.vertical, 14)
                     .background(AppColor.surfaceContainer)
                     .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
             }.buttonStyle(.plain)
 
             Button {
-                saveAppointment()
+                Task {
+                    await performSave()
+                }
             } label: {
                 HStack(spacing: 8) {
                     if isSaving {
                         ProgressView().tint(.white)
                     } else {
                         Image(systemName: "checkmark.circle.fill").font(.system(size: 18))
                     }
                     Text(saved ? "¡Cita Reservada con Éxito!" : (isSaving ? "Guardando cita..." : "Confirmar y Reservar"))
                         .font(AppFont.labelLG)
                 }
                 .foregroundStyle(AppColor.onPrimary)
                 .frame(maxWidth: .infinity)
                 .padding(.vertical, 14)
                 .background(saved ? AppColor.secondary : AppColor.primaryContainer)
                 .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
             }
             .buttonStyle(.plain)
             .disabled(isSaving || saved)
             .frame(maxWidth: .infinity)
         }
         .padding(.horizontal, AppSpacing.marginSM)
         .padding(.vertical, 10)
         .background(.ultraThinMaterial)
     }
 
-    private func saveAppointment() {
-        isSaving = true
-        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
-            isSaving = false
-            withAnimation { saved = true }
-        }
-    }
+    private func performSave() async {
+        // Configure view model with the current context if needed
+        viewModel.configure(context: modelContext)
+        isSaving = true
+        // For this increment we use simplified mapping: patient and doctor from SampleData placeholders
+        let patientId: Int? = 1
+        let patientName = SampleData.mateoHernandez.name
+        let doctorName = SampleData.alejandro.name
+        let specialty = SampleData.alejandro.specialty
+        // appointmentDate: use now as placeholder; mapping proper date from selectedDay/slot will be implemented next
+        let appointmentDate = Date()
+        do {
+            _ = try await viewModel.createAppointment(patientId: patientId, patientName: patientName, doctorName: doctorName, specialty: specialty, description: reason, appointmentDate: appointmentDate, durationMinutes: 30)
+            isSaving = false
+            withAnimation { saved = true }
+        } catch {
+            isSaving = false
+            // show simple feedback; later we'll attach error near fields
+            // For now, set saved = false and error in viewModel
+        }
+    }
 }
*** End Patch
