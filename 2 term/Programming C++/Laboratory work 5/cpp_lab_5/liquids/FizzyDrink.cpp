#include "FizzyDrink.h"

#include <utility>
#include <iostream>

FizzyDrink::FizzyDrink(std::string name, double density, FizzyDrink::Type type, double sugarConcentration) : BaseLiquid(std::move(name), density) {
    m_type = type;
    m_sugarConcentration = sugarConcentration;
}

void FizzyDrink::toStream(std::ostream &os) {
    os << getTypeStr() << " " << m_name << ". Sugar concentration: " << m_sugarConcentration;
}

void FizzyDrink::setFromStream(std::istream &is) {
    int enumNumber;
    is >> m_name >> m_density >> enumNumber >> m_sugarConcentration;
}

const char *FizzyDrink::getTypeStr() {
    switch (this->m_type) {
        case Cola: return "Cola";
        case Lemonade: return "Lemonade";
        case Tarragon: return "Tarragon";
        default: return "Unknown fizzy drink";
    }
}
