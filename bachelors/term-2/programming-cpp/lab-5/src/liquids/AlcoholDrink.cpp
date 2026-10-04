#include "AlcoholDrink.h"

#include <utility>
#include <iostream>

AlcoholDrink::AlcoholDrink(std::string name, double density, Type type, double strength) : BaseLiquid(std::move(name), density) {
    m_type = type;
    m_strength = strength;
}


void AlcoholDrink::toStream(std::ostream &os) {
    os << getTypeStr() << " " << m_name << ". Strength: " << m_strength;
}

void AlcoholDrink::setFromStream(std::istream &is)  {
    int enumNumber;
    is >> m_name >> m_density >> enumNumber >> m_strength;
}

const char *AlcoholDrink::getTypeStr() {
    switch (this->m_type) {
        case Beer: return "Beer";
        case Vodka: return "Vodka";
        case Wine: return "Wine";
        case Whiskey: return "Whiskey";
        case Martini: return "Martini";
        case Cider: return "Cider";
        default: return "Unknown alcohol drink";
    }
}
