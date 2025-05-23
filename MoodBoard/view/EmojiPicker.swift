//
//  EmojiPicker.swift
//  MoodBoard
//
//  Created by Milan Matejka on 5/23/25.
//

import SwiftUI
import Foundation

/// Vue affichant une liste horizontale d'emojis cliquables
/// Permet de sélectionner un emoji, qui sera lié à la variable `selectedEmoji`
struct EmojiPicker: View {
    @Binding var selectedEmoji: String          // Emoji actuellement sélectionné, liaison avec la vue parent

    // Liste d'emojis proposés à la sélection
    let emojis = [
        "😀", "😌", "😢", "😠", "😴", "😎", "🤯", "🥳", "😕", "😍",
        "🐶", "🐱", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐸", "🐵",
        "🍎", "🍌", "🍕", "🍔", "🍣", "🍩", "☕️", "🍺", "🥗", "🍰",
        "⚽️", "🏀", "🏓", "🏄‍♂️", "🚴‍♀️", "🎸", "🎮", "🎯", "🎲", "🎬",
        "📱", "💻", "⌚️", "🔑", "📚", "🕯️", "💡", "🔨", "✈️", "🚗",
        "❤️", "💔", "✨", "🔥", "⚡️", "🎉", "❄️", "🌈", "☀️", "🌙"
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                // Pour chaque emoji, on crée un Text cliquable avec un fond circulaire si sélectionné
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 40))
                        .padding(10)
                        // Fond bleu clair si emoji sélectionné, sinon transparent
                        .background(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                        .onTapGesture {
                            // Met à jour l'emoji sélectionné à celui cliqué
                            selectedEmoji = emoji
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
