import Foundation
import SwiftData

// 🧪 Données de test pour Yume
// Utilisez ces données pour tester l'app sans créer manuellement des rêves

extension Dream {
    static var samples: [Dream] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            Dream(
                title: "Vol au-dessus des montagnes",
                date: now,
                content: "Je me suis retrouvé sur une montagne, le ciel était dégagé et je pouvais voir toute la vallée. Soudain, j'ai réalisé que je rêvais et j'ai décidé de m'envoler. La sensation de liberté était incroyable.",
                isRemembered: true,
                dreamType: .lucid,
                emotions: ["Liberté", "Joie", "Émerveillement"],
                aiAnalysis: """
🌙 ATMOSPHÈRE
Ce rêve baigne dans une lumière cristalline, portée par l'énergie de l'éveil conscient. L'atmosphère y est vaste et légère, comme une aquarelle où le bleu du ciel se fond dans la joie pure de découvrir son propre pouvoir.

🔮 SYMBOLES CLÉS
La montagne représente l'élévation intérieure, ce désir d'atteindre des sommets spirituels. Le vol lucide symbolise la maîtrise consciente de sa propre réalité psychique, un pont entre contrôle et abandon. La vallée en contrebas incarne le regard panoramique sur sa vie, la prise de hauteur qui permet de voir plus loin.

✨ PISTE DE RÉFLEXION
Quel aspect de ta vie appelle à plus de légèreté et de liberté consciente ? Où pourrais-tu t'élever au-dessus des préoccupations quotidiennes pour retrouver cette perspective claire ?
""",
                aiModel: "Claude"
            ),
            
            Dream(
                title: "Une maison inconnue",
                date: calendar.date(byAdding: .day, value: -1, to: now)!,
                content: "J'explorais une grande maison que je ne connaissais pas. Chaque pièce était différente, certaines lumineuses et d'autres sombres. Je ressentais de la curiosité mais aussi un peu de peur.",
                isRemembered: true,
                dreamType: .normal,
                emotions: ["Peur", "Émerveillement"]
            ),
            
            Dream(
                title: "Retrouvailles",
                date: calendar.date(byAdding: .day, value: -3, to: now)!,
                content: "J'ai revu un ami d'enfance que je n'ai pas vu depuis des années. On était dans un jardin ensoleillé et on riait beaucoup. Ça m'a fait du bien de le revoir même si ce n'était qu'un rêve.",
                isRemembered: true,
                dreamType: .normal,
                emotions: ["Joie", "Sérénité"]
            ),
            
            Dream(
                title: "Rêve oublié",
                date: calendar.date(byAdding: .day, value: -5, to: now)!,
                content: "",
                isRemembered: false,
                dreamType: .normal,
                emotions: []
            ),
            
            Dream(
                title: "Océan lumineux",
                date: calendar.date(byAdding: .day, value: -7, to: now)!,
                content: "Je nageais dans un océan qui brillait de mille feux. L'eau était chaude et phosphorescente. J'ai su que je rêvais et j'ai décidé de plonger plus profond pour explorer les fonds marins.",
                isRemembered: true,
                dreamType: .lucid,
                emotions: ["Émerveillement", "Liberté", "Sérénité"]
            ),
            
            Dream(
                title: "Course poursuite",
                date: calendar.date(byAdding: .day, value: -10, to: now)!,
                content: "Je courais dans une ville sombre, poursuivi par quelque chose que je ne voyais pas. Mon cœur battait fort et je cherchais désespérément un endroit où me cacher.",
                isRemembered: true,
                dreamType: .nightmare,
                emotions: ["Peur"]
            ),
            
            Dream(
                title: "Bibliothèque infinie",
                date: calendar.date(byAdding: .day, value: -12, to: now)!,
                content: "Je me trouvais dans une immense bibliothèque avec des étagères qui montaient jusqu'au ciel. J'ai réalisé que je rêvais et j'ai commencé à lire des livres qui n'existaient pas dans la réalité.",
                isRemembered: true,
                dreamType: .lucid,
                emotions: ["Émerveillement", "Joie"],
                aiAnalysis: """
🌙 ATMOSPHÈRE
Ce rêve se déploie dans l'aura du savoir sans limite, teinté d'une joie contemplative. Il y règne un silence studieux mais vivant, comme si chaque livre murmurait ses secrets. L'espace vertical vertigineux évoque la quête infinie de connaissance.

🔮 SYMBOLES CLÉS
La bibliothèque infinie symbolise l'accès à la sagesse collective de l'inconscient, un réservoir de connaissances qui dépasse la mémoire personnelle. Les livres impossibles représentent les potentiels créatifs encore inexplorés, les idées qui n'attendent qu'à naître. La hauteur des étagères évoque l'ampleur de ce qui reste à découvrir en soi.

✨ PISTE DE RÉFLEXION
Quel savoir cherches-tu intuitivement, sans même en avoir conscience ? Quelle partie de toi demande à s'exprimer par l'écriture, la création ou la transmission ?
""",
                aiModel: "GPT"
            ),
            
            Dream(
                title: "Jardin magique",
                date: calendar.date(byAdding: .day, value: -15, to: now)!,
                content: "Un jardin extraordinaire avec des fleurs géantes et des papillons multicolores. Tout était paisible et beau.",
                isRemembered: true,
                dreamType: .normal,
                emotions: ["Sérénité", "Émerveillement"]
            ),
            
            Dream(
                title: "Rêve oublié",
                date: calendar.date(byAdding: .day, value: -18, to: now)!,
                content: "",
                isRemembered: false,
                dreamType: .normal,
                emotions: []
            ),
            
            Dream(
                title: "Concert cosmique",
                date: calendar.date(byAdding: .day, value: -20, to: now)!,
                content: "J'assistais à un concert dans l'espace, entouré d'étoiles. La musique était magnifique et je flottais en apesanteur. C'était un rêve lucide incroyable.",
                isRemembered: true,
                dreamType: .lucid,
                emotions: ["Joie", "Émerveillement", "Liberté"]
            )
        ]
    }
}

// Extension pour faciliter l'insertion dans SwiftData
extension Dream {
    static func insertSamples(into modelContext: ModelContext) {
        for dream in Dream.samples {
            modelContext.insert(dream)
        }
        
        do {
            try modelContext.save()
            print("✅ \(Dream.samples.count) rêves d'exemple insérés")
        } catch {
            print("❌ Erreur lors de l'insertion des exemples: \(error)")
        }
    }
}
