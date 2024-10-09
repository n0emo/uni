#include "Petrol.h"
#include <utility>
#include <iostream>

Petrol::Petrol(std::string name, double density, unsigned int octaveRating) : BaseLiquid(std::move(name), density) {
    m_octaveRating = octaveRating;
}

void Petrol::toStream(std::ostream &os) {
    os << "Patrol " << m_name << ". Octave rating: " << m_octaveRating;
}

void Petrol::setFromStream(std::istream &is) {
    is >> m_name >> m_density >> m_octaveRating;
}


