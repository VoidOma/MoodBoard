//
//  ImagePicker.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

import SwiftUI
import UIKit

/// Wrapper SwiftUI pour UIImagePickerController d’UIKit,
/// permettant de sélectionner une image depuis la bibliothèque photo.
/// Utilise UIViewControllerRepresentable pour intégrer un contrôleur UIKit dans SwiftUI.
struct ImagePicker: UIViewControllerRepresentable {
    /// Binding vers l’image sélectionnée, mise à jour lorsque l’utilisateur choisit une image.
    @Binding var selectedImage: UIImage?
    
    /// Environnement SwiftUI pour gérer la présentation/dismissal du contrôleur.
    @Environment(\.presentationMode) private var presentationMode

    /// Création du coordinateur qui agit comme délégué pour UIImagePickerController.
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    /// Création et configuration de l’UIImagePickerController.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary  // Source : bibliothèque photo
        return picker
    }

    /// Mise à jour du contrôleur UIKit (non utilisée ici).
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Pas besoin d'implémentation pour l'instant
    }

    /// Coordinator agit comme délégué UIImagePickerControllerDelegate et UINavigationControllerDelegate.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        /// Référence vers le parent ImagePicker pour mettre à jour l’image sélectionnée et fermer la vue.
        let parent: ImagePicker

        /// Initialisation avec la référence au parent.
        init(parent: ImagePicker) {
            self.parent = parent
        }

        /// Appelé quand l’utilisateur sélectionne une image.
        /// Met à jour la binding selectedImage et ferme le picker.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        /// Appelé quand l’utilisateur annule la sélection, ferme simplement le picker.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
