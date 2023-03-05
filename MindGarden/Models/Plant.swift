//
//  Plant.swift
//  MindGarden
//
//  Created by Dante Kim on 7/27/21.
//
import SwiftUI


struct Plant: Hashable {
    let id = UUID()
    let title: String
    let price: Int
    let selected: Bool
    let description: String
    let packetImage: Image
    let one: Image
    let two: Image
    let coverImage: Image
    let head: Image
    let badge: Image

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.title == rhs.title
    }
    // ADD TO WIDGET
    static var plants: [Plant] = [
        Plant(title: "Real Tree", price: 1000, selected: false, description: "🌳 Trees for the Future (TREES) trains communities on sustainable land use so that they can grow vibrant economies, thriving food systems, and a healthier planet.", packetImage: Img.treePacket, one: Img.sapling, two: Img.youngTree, coverImage: Img.realTree, head: Img.tree1, badge: Img.realTree),
        Plant(title: "White Daisy", price: 1000, selected: false, description: "🌼 With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.daisyPacket, one: Img.daisy1, two: Img.daisy2, coverImage: Img.daisy3, head: Img.daisyHead, badge: Img.daisyBadge),
        Plant(title: "Red Tulip", price: 900, selected: false, description: "🌷 Red Tulips are a genus of spring-blooming perennial herbaceous bulbiferous geophytes. Red tulips symbolize eternal love, undying love, perfect love, true love.", packetImage: Img.redTulipsPacket, one: Img.redTulips1, two: Img.redTulips2,  coverImage: Img.redTulips3, head: Img.redTulipsHead, badge: Img.redTulipsBadge),
        Plant(title: "Cactus", price: 1300, selected: false, description: "🌵 Cactuses are a type of desert plant that have thick, leafless stems covered in prickly spines or sharp spikes, some cacti are able to store hundreds of gallons of water. Cactus originates from the Greek name Kaktos.", packetImage: Img.cactusPacket, one: Img.cactus1, two: Img.cactus2, coverImage: Img.cactus3, head: Img.cactusHead, badge: Img.cactusBadge),
        Plant(title: "Blueberry", price: 1500, selected: false, description: "🫐 Blueberries are a crown forming, woody, perennial shrub in the flower family Ericaceae. They ranked number one in antioxidant health benefits in a comparison with more than 40 fresh fruits and vegetables.", packetImage: Img.blueberryPacket, one: Img.blueberry1, two: Img.blueberry2, coverImage: Img.blueberry3, head: Img.blueberryHead, badge: Img.blueberryBadge),
        Plant(title: "Lemons", price: 2000, selected: false, description: "🍋 Lemons are native to Asia, are a hybrid between a sour orange and a citron, rich in vitamin C and their trees can produce up to 600lbs of lemons every year.", packetImage: Img.lemonPacket, one: Img.lemon1, two: Img.lemon2, coverImage: Img.lemonTree, head: Img.lemonHead, badge: Img.lemonBadge),
        Plant(title: "Avocados", price: 2500, selected: false, description: "🥑 Native to the highland regions of south-central Mexico to Guatemala. An avocado contains more patassium then a banana!", packetImage: Img.avoacdoPacket, one: Img.avocado1, two: Img.avocado2, coverImage: Img.avocado3, head: Img.avocadoHead, badge: Img.avocadoBadge),
        Plant(title: "Monstera", price: 1600, selected: false, description: "🪴 The Monstera  also known as the swiss cheese plant is native to Central America. It is a climbing, evergreen perennial vine that is perhaps most noted for its large perforated leaves on thick plant stems and its long cord-like aerial roots", packetImage: Img.monsteraPacket, one: Img.monstera1, two: Img.monstera2, coverImage: Img.monstera3, head: Img.monsteraHead, badge: Img.monsteraBadge),
        Plant(title: "Daffodil", price: 1000, selected: false, description: "🌼 Daffodils are reliable spring-flowering bulbs. They symbolize new beginnings & friendships and were also named after a greek myth.", packetImage: Img.daffodilPacket, one: Img.daffodil1, two: Img.daffodil2, coverImage: Img.daffodil3, head: Img.daffodilHead, badge: Img.daffodilBadge),
        Plant(title: "Rose", price: 1400, selected: false, description: "🌹 Roses are woody perennial flowering plant of the genus Rosa, in the family Rosaceae. They're one of the oldest flowers & are commonly used in perfumes. They symbolize romance, love, beauty, and courage.", packetImage: Img.rosePacket, one: Img.daisy1, two: Img.rose2, coverImage: Img.rose3, head: Img.roseHead, badge: Img.roseBadge),
        Plant(title: "Lavender", price: 1000, selected: false, description: "💜 Lavenders are small, branching and spreading shrubs with grey-green leaves and long flowering shoots. They have a wonderful and aromatic smell and symbolize purity, silence, devotion, serenity, grace, and calmness", packetImage: Img.lavenderPacket, one: Img.lavender1, two: Img.lavender2, coverImage: Img.lavender3, head: Img.lavenderHead, badge: Img.lavenderBadge),
        Plant(title: "Sunflower", price: 1100, selected: false, description: "🌻 Sunflowers are annual plants, harvested after one growing season and can reach 1–3.5 m (3.3–11.5 ft) in height. They symbolize include happiness, optimism, honesty, longevity, peace, admiration, and devotion", packetImage: Img.sunflowerPacket, one: Img.sunflower1, two: Img.sunflower2, coverImage: Img.sunflower3, head: Img.sunflowerHead, badge: Img.sunflowerBadge),
        Plant(title: "Lily of the Valley", price: 1000, selected: false, description: "🏜 Lily of the valley is a woodland flowering plant with sweetly scented, pendent, bell-shaped white flowers borne in sprays in spring. This flower symbolizes absolute purity, youth, sincerity, and discretion. But most importantly, it symbolizes happiness.", packetImage: Img.lilyValleyPacket, one: Img.lilyValley1, two: Img.lilyValley2, coverImage: Img.lilyValley3, head: Img.lilyValleyHead, badge: Img.lilyValleyBadge),
        Plant(title: "Lily", price: 1000, selected: false, description: "🌱 Lilies are erect perennial plants with leafy stems, scaly bulbs, usually narrow leaves, and solitary or clustered flowers. They symbolize purity and fertility", packetImage: Img.lilyPacket, one: Img.lily1, two: Img.lily2, coverImage: Img.lily3, head: Img.lilyHead, badge: Img.lilyBadge),
        Plant(title: "Strawberry", price: 1500, selected: false, description: "🍓 The strawberry is widely appreciated for its characteristic aroma, bright red color, juicy texture, and sweetness. The average strawberry has 200 seeds.", packetImage: Img.strawberryPacket, one: Img.strawberry1, two: Img.strawberry2, coverImage: Img.strawberry3, head: Img.strawberryHead, badge: Img.strawberryBadge),
        //head
        Plant(title: "Aloe", price: 1600, selected: false, description: "🪴 Aloe sometimes described as a “wonder plant,” is a short-stemmed shrub. It is grown commercially for the health and moisturizing benefits found inside its leaves. Cleopatra applied aloe gel to her body as part of her beauty regimen!", packetImage: Img.aloePacket, one: Img.aloe1, two: Img.aloe2, coverImage: Img.aloe3, head: Img.aloeHead, badge: Img.aloeBadge),
        Plant(title: "Ice Flower", price: 0, selected: false, description: "", packetImage: Img.aloePacket, one: Img.aloe1, two: Img.aloe2, coverImage: Img.aloe3, head: Img.iceFlower, badge: Img.aloeBadge),

    ]
    static var packetPlants = Plant.plants.filter { plt in
        plt.title != "Ice Flower"
    }
    
    static var badgePlants: [Plant] = [
        // rate the app
        Plant(title: "Camellia", price: 6, selected: false, description: "💐 The flowers are large and conspicuous, from 1 to 12 centimeters in diameter, with 5 to 9 petals; color varies from white to pink and red. It is often used in religious and sacred ceremonies.", packetImage: Img.cameliaPacket, one: Img.camelia1, two: Img.camelia2, coverImage: Img.camelia3, head: Img.cameliaHead, badge: Img.cameliaBadge),
        // 30 day
        Plant(title: "Cherry Blossoms", price: 1, selected: false, description: "🌸 Cherry Blossoms also known as sakura in Japan, are the small, delicate pink flowers produced by cherry blossom trees. The springtime bloom is extremely short and beautiful; after only two weeks, they drop to the ground and wither, falling like snow", packetImage: Img.cherryBlossomPacket, one: Img.cherryBlossom1, two: Img.cherryBlossom2, coverImage: Img.cherryBlossom3, head: Img.cherryBlossomsHead, badge: Img.cherryBlossomBadge),
        // 7 day
        Plant(title: "Red Mushroom", price: 0, selected: false, description: "🍄 Also known as the Amanita muscaria, is one of the most recognizable and widely encountered mushroom in popular culture and used in the game Mario.", packetImage: Img.daisyPacket, one: Img.redMushroom1, two: Img.redMushroom2, coverImage: Img.redMushroom3, head: Img.redMushroomHead, badge: Img.redMushroomBadge),
        //pro member
        Plant(title: "Bonsai Tree", price: 3, selected: false, description: "⽊ A bonsai tree is a shrub which has been grown in a way which gives the impression of being a full-sized, mature tree. They originated from China over 1000 years ago and symbolize  harmony, balance, patience, or even luck", packetImage: Img.daisyPacket, one: Img.bonsai1, two: Img.bonsai2, coverImage: Img.bonsai3, head: Img.bonsaiHead, badge: Img.bonsaiBadge),
        // refer a friend
        Plant(title: "Venus Fly Trap", price: 4, selected: false, description: "👹 The Venus flytrap is a carnivorous plant native to subtropical wetlands on the East Coast of the United States in North Carolina and South Carolina. It gets some of its nutrients from the soil, but to supplement its diet, the plant eats insects and arachnids!", packetImage: Img.daisyPacket, one: Img.venus1, two: Img.venus2, coverImage: Img.venus3, head: Img.venusHead, badge: Img.venusBadge),
        Plant(title: "Apples", price: 7, selected: false, description: "🍎 Apples are not native to North America. They originated in Kazakhstan, in central Asia east of the Caspian Sea. The capital of Kazakhstan, Alma Ata, means “full of apples.”", packetImage: Img.applePacket, one: Img.apple1, two: Img.apple2, coverImage: Img.apple3, head: Img.appleHead, badge: Img.appleBadge),
        // Meditate on Christmas
        Plant(title: "Christmas Tree", price: 5, selected: false, description: "🎄 Evergreen trees are a popular type of Christmas tree because they keep their leaves throughout the year. Germany is credited with starting the Christmas Tree tradition in the 16th century.", packetImage: Img.daisyPacket, one: Img.christmas1, two: Img.christmas2, coverImage: Img.christmas3, head: Img.christmasHead, badge: Img.christmasBadge),
        // 30 Gratitudes
//        Plant(title: "Hydrangea", price: 6, selected: false, description: "There are around 70-75 species of hydrangea and can grow literally anywhere. Never eat them as they are moderately toxic. ", packetImage: Img.daisyPacket, one: Img.christmas1, two: Img.christmas2, coverImage: Img.christmas3, head: Img.christmasHead, badge: Img.christmasBadge)
    ]
    static var allPlants = plants + badgePlants
    static var badgeDict: [Int: String] = [
        3: "👨‍🌾 Become a pro user",
        4: "💌 Refer a friend",
        2: "⭐️ Rate the app",
        0: "7️⃣ Day Streak",
        1: "🌸 Finish Intro Course",
        5: "🎅 Meditate on Dec 25",
        6: "✏️ 30 Journal Entries",
        7: "👨‍👩‍👦‍👦 Join our Reddit"
    ]
}
