#ifndef CPP_LAB_5_PETROL_H
#define CPP_LAB_5_PETROL_H


#include "BaseLiquid.h"

class Petrol : public BaseLiquid {
public:
    Petrol() = default;
    Petrol(std::string name, double density, unsigned int octaveRating);

    unsigned int getOctaveRating() {return m_octaveRating; }
    void setOctaveRating(unsigned int rating) { m_octaveRating = rating; }

    void toStream(std::ostream& os) override;
    void setFromStream(std::istream & is) override;

private:
    unsigned int m_octaveRating = 0;
};


#endif //CPP_LAB_5_PETROL_H
