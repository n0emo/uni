#ifndef CPP_LAB_5_ALCOHOLDRINK_H
#define CPP_LAB_5_ALCOHOLDRINK_H


#include "BaseLiquid.h"

class AlcoholDrink : public BaseLiquid {
public:
    enum Type {
        Beer, Vodka, Wine, Whiskey, Martini, Cider
    };

    AlcoholDrink() = default;
    AlcoholDrink(std::string name, double density, Type type, double strength);

    void toStream(std::ostream& os) override;
    void setFromStream(std::istream & is) override;

    Type getType() { return m_type; }
    void setType(Type type) { m_type = type; }
    double getStrength() { return m_strength; }
    void setStrength(double strength) { m_strength = strength; }

private:
    double m_strength = 0;
    Type m_type = Beer;

    const char* getTypeStr();
};


#endif //CPP_LAB_5_ALCOHOLDRINK_H
