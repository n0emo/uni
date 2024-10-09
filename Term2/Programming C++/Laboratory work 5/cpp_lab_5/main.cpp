#include <iostream>
#include <vector>
#import "liquids/BaseLiquid.h"
#import "liquids/Petrol.h"
#import "liquids/FizzyDrink.h"
#import "liquids/AlcoholDrink.h"

int main() {
    system("color F0");

    std::vector<BaseLiquid*> liquids({
        new Petrol("Kazmunaygaz", 750, 95),
        new FizzyDrink("CoolCola", 1030, FizzyDrink::Cola, 10.6),
        new FizzyDrink("Buratino", 1030, FizzyDrink::Lemonade, 5.8),
        new AlcoholDrink("Eboshi", 1002, AlcoholDrink::Beer, 4.6),
        new AlcoholDrink("Vozduh", 970, AlcoholDrink::Vodka, 45),
    });

    for(auto liquid : liquids) {
        std::cout << liquid << "\n";
    }

    system("pause");
    return 0;
}
