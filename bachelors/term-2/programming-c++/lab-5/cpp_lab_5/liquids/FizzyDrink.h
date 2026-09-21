#ifndef CPP_LAB_5_FIZZYDRINK_H
#define CPP_LAB_5_FIZZYDRINK_H


#include "BaseLiquid.h"

class FizzyDrink : public BaseLiquid{
public:
    enum Type {
        Cola, Lemonade, Tarragon
    };

    FizzyDrink() = default;
    FizzyDrink(std::string name, double density, Type type, double sugarConcentration);

    void toStream(std::ostream& os) override;
    void setFromStream(std::istream & is) override;

    Type getType() { return m_type; }
    void setType(Type type) { m_type = type; }
    double getSugarConcentration() { return  m_sugarConcentration; }
    void setSugarConcentration(double sugarConcentration) { m_sugarConcentration = sugarConcentration; }

private:
    Type m_type = Cola;
    double m_sugarConcentration = 0;
    const char* getTypeStr();
};


#endif //CPP_LAB_5_FIZZYDRINK_H
