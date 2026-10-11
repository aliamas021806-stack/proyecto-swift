//
//  AppointmentDetailView.swift
//  GestorCitas
//
//  Pantalla 4 — Detalle de Cita: estado, snapshot del paciente, sala virtual,
//  expediente/recetas y notas médicas editables.
//

import SwiftUI

struct AppointmentDetailView: View {
    @State private var isEditingNote = false
    @State private var noteText: String = "Lesiones descamativas en retroflexuras reducidas en un 60%. Toleró bien pomada de hidrocortisona al 1%. Recomendar espaciar aplicación a días alternos y reforzar ceramidas diarias."
    @State private var savedNote: String = "Lesiones descamativas en retroflexuras reducidas en un 60%. Toleró bien pomada de hidrocortisona al 1%. Recomendar espaciar aplicación a días alternos y reforzar ceramidas diarias."

    /// Cita mostrada. Por defecto, la de Sofía Valdés (telemedicina).
    var appointment: Appointment = SampleData.dashboardAppointments[1]

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                statusHeader
                patientSnapshot
                consultationSection
                documentsSection
                notesSection
            }
            .padding(.horizontal, AppSpacing.marginSM)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, 140)
        }
        .background(AppColor.surface)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) { bottomBar }
        .navigationTitle("Detalle de Cita")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Cabecera de estado

    private var statusHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(AppColor.secondary).frame(width: 8, height: 8)
                    Text("Confirmada").font(AppFont.labelMD).foregroundStyle(AppColor.onSecondaryFixed)
                }
                .padding(.horizontal, 12).padding(.vertical, 5)
                .background(AppColor.secondaryFixed)
                .clipShape(Capsule())

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "video").font(.system(size: 12)).foregroundStyle(AppColor.primary)
                    Text("Cita #MD-8841").font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
                }
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(AppColor.surfaceContainerLow)
                .clipShape(Capsule())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Jueves 24 Octubre 2024").font(AppFont.headlineLGMobile).foregroundStyle(AppColor.onSurface)
                HStack(spacing: 6) {
                    Image(systemName: "clock").font(.system(size: 15)).foregroundStyle(AppColor.primary)
                    Text("10:00 - 10:45 AM (45 min)").font(AppFont.bodyMD).foregroundStyle(AppColor.onSurfaceVariant).monospacedDigit()
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Circle().fill(AppColor.secondaryFixed.opacity(0.3)).frame(width: 90, height: 90)
                .blur(radius: 20).offset(x: 20, y: -20)
        }
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    // MARK: Snapshot del paciente

    private var patientSnapshot: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                HStack(spacing: 12) {
                    ZStack(alignment: .bottomTrailing) {
                        AvatarView(name: appointment.patient.name, seed: appointment.patient.avatarSeed, size: 56)
                        Circle().fill(AppColor.secondaryFixed).frame(width: 14, height: 14)
                            .overlay(Circle().stroke(AppColor.surfaceContainerLowest, lineWidth: 2))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appointment.patient.name).font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                        Text("\(appointment.patient.age) años • DNI: \(appointment.patient.dni)")
                            .font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
                    }
                }
                Spacer()
                Text(appointment.patient.bloodType ?? "—")
                    .font(AppFont.labelMD).foregroundStyle(AppColor.primary)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(AppColor.surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            }

            // Marcadores de salud
            FlowTags(items: [
                InfoTag(icon: "exclamationmark.triangle", text: "Alergia: Penicilina",
                        fg: AppColor.onErrorContainer, bg: AppColor.errorContainer),
                InfoTag(icon: "checkmark.seal", text: "Seguro Sanitas Activo",
                        fg: AppColor.onSurfaceVariant, bg: AppColor.surfaceContainerLow),
                InfoTag(icon: "clock.arrow.circlepath", text: "4 consultas previas",
                        fg: AppColor.onSurfaceVariant, bg: AppColor.surfaceContainerLow),
            ])

            // Acciones directas
            HStack(spacing: 8) {
                Button {} label: {
                    HStack(spacing: 6) {
                        Image(systemName: "folder").font(.system(size: 15)).foregroundStyle(AppColor.primary)
                        Text("Ver Historial").font(AppFont.labelMD).foregroundStyle(AppColor.onSurface)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(AppColor.surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
                }.buttonStyle(.plain)

                Link(destination: URL(string: "tel:+34600123456")!) {
                    Image(systemName: "phone").font(.system(size: 16)).foregroundStyle(AppColor.secondary)
                        .frame(width: 48).padding(.vertical, 10)
                        .background(AppColor.surfaceContainer)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
                }
                Link(destination: URL(string: "https://wa.me/34600123456")!) {
                    Image(systemName: "message").font(.system(size: 16)).foregroundStyle(AppColor.onSecondaryFixed)
                        .frame(width: 48).padding(.vertical, 10)
                        .background(AppColor.secondaryFixed)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    // MARK: Consulta (especialista + telemedicina + motivo)

    private var consultationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                AvatarView(name: appointment.doctor.name, seed: appointment.doctor.avatarSeed, size: 48)
                VStack(alignment: .leading, spacing: 2) {
                    Text("ESPECIALISTA ASIGNADA").font(AppFont.labelSM).foregroundStyle(AppColor.primary)
                    Text(appointment.doctor.name).font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                    Text("Dermatología Clínica • Col. 28094")
                        .font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
                }
                Spacer()
            }

            // Tarjeta de telemedicina
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                                .fill(AppColor.primaryFixed)
                            Image(systemName: "video.fill").font(.system(size: 16)).foregroundStyle(AppColor.onPrimaryFixed)
                        }.frame(width: 32, height: 32)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Telemedicina - Videollamada HD").font(AppFont.labelMD).foregroundStyle(AppColor.onSurface)
                            Text("Sala encriptada de punto a punto").font(AppFont.bodySM).foregroundStyle(AppColor.onSurfaceVariant)
                        }
                    }
                    Spacer()
                    Circle().fill(AppColor.secondaryFixedDim).frame(width: 10, height: 10)
                }
                PrimaryButton(title: "Entrar a la Sala Virtual", icon: "play.circle.fill",
                              color: AppColor.primary, fullWidth: true) {}
            }
            .padding(16)
            .background(AppColor.surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))

            // Motivo de consulta
            VStack(alignment: .leading, spacing: 6) {
                Text("MOTIVO DE CONSULTA").font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
                Text("Revisión y seguimiento de dermatitis atópica en antebrazos. Paciente reporta mejoría tras tratamiento tópico con corticoides suaves e hidratación emoliente.")
                    .font(AppFont.bodyMD).foregroundStyle(AppColor.onSurface)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColor.surfaceContainerLow.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    // MARK: Expediente y recetas

    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text").font(.system(size: 16)).foregroundStyle(AppColor.primary)
                    Text("Expediente y Recetas").font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                }
                Spacer()
                Text("2 archivos").font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(AppColor.surfaceContainer)
                    .clipShape(Capsule())
            }
            DocumentRow(fileName: "Receta_Dermatologia_Sep2024.pdf", meta: "18 Sep 2024 • 420 KB",
                        icon: "pills.fill", tint: AppColor.primary)
            DocumentRow(fileName: "Analitica_Sangre_Reciente.pdf", meta: "02 Oct 2024 • 1.2 MB",
                        icon: "waveform.path.ecg", tint: AppColor.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    // MARK: Notas médicas

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.pencil").font(.system(size: 16)).foregroundStyle(AppColor.primary)
                    Text("Notas Médicas Rápidas").font(AppFont.headlineMD).foregroundStyle(AppColor.onSurface)
                }
                Spacer()
                if !isEditingNote {
                    Button { isEditingNote = true } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "pencil").font(.system(size: 13))
                            Text("Editar").font(AppFont.labelMD)
                        }.foregroundStyle(AppColor.primary)
                    }.buttonStyle(.plain)
                }
            }

            if isEditingNote {
                VStack(spacing: 8) {
                    TextEditor(text: $noteText)
                        .font(AppFont.bodyMD)
                        .foregroundStyle(AppColor.onSurface)
                        .scrollContentBackground(.hidden)
                        .frame(height: 90)
                        .padding(8)
                        .background(AppColor.surfaceContainerLow)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
                    HStack(spacing: 8) {
                        Spacer()
                        Button {
                            noteText = savedNote
                            isEditingNote = false
                        } label: {
                            Text("Cancelar").font(AppFont.labelMD).foregroundStyle(AppColor.onSurface)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(AppColor.surfaceContainer)
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                        }.buttonStyle(.plain)

                        Button {
                            savedNote = noteText
                            isEditingNote = false
                        } label: {
                            Text("Guardar Nota").font(AppFont.labelMD).foregroundStyle(AppColor.onPrimary)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(AppColor.primary)
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                        }.buttonStyle(.plain)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\"\(savedNote)\"")
                        .font(AppFont.bodyMD).foregroundStyle(AppColor.onSurface)
                    Text("Actualizado: 28 Sep 2024, Dra. Elena Morales")
                        .font(AppFont.labelSM).foregroundStyle(AppColor.onSurfaceVariant)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(12)
                .background(AppColor.surfaceContainerLow.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
        .shadow(color: AppShadow.cardColor, radius: 8, y: 2)
    }

    // MARK: Barra inferior

    private var bottomBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Button {} label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 15))
                        Text("Reprogramar").font(AppFont.labelMD)
                    }
                    .foregroundStyle(AppColor.onSurface)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(AppColor.surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
                }.buttonStyle(.plain)

                Button {} label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill").font(.system(size: 15))
                        Text("Iniciar Consulta").font(AppFont.labelMD)
                    }
                    .foregroundStyle(AppColor.onSecondaryFixed)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(AppColor.secondaryFixed)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
                }.buttonStyle(.plain)
            }
            Button {} label: {
                HStack(spacing: 5) {
                    Image(systemName: "xmark.circle").font(.system(size: 13))
                    Text("Cancelar Cita").font(AppFont.labelSM)
                }.foregroundStyle(AppColor.error)
            }.buttonStyle(.plain)
        }
        .padding(.horizontal, AppSpacing.marginSM)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }
}

// MARK: - InfoTag + FlowTags (envoltura de etiquetas)

struct InfoTag: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let fg: Color
    let bg: Color
}

/// Contenedor que envuelve etiquetas a varias líneas (equivalente a flex-wrap).
struct FlowTags: View {
    let items: [InfoTag]

    var body: some View {
        // Envoltorio sencillo: 2 filas máximas por simplicidad del layout.
        VStack(alignment: .leading, spacing: 6) {
            ForEach(items) { tag in
                HStack(spacing: 4) {
                    Image(systemName: tag.icon).font(.system(size: 12))
                    Text(tag.text).font(AppFont.labelSM)
                }
                .foregroundStyle(tag.fg)
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(tag.bg)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack { AppointmentDetailView() }
}
