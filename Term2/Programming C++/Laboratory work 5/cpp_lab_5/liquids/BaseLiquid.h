#ifndef CPP_LAB_5_BASELIQUID_H
#define CPP_LAB_5_BASELIQUID_H

#include <string>
#include <utility>

class BaseLiquid {
public:
    BaseLiquid() = default;
    BaseLiquid(std::string name, double density) : m_name(std::move(name)), m_density(density) {};

    std::string getName() { return m_name; }
    void setName(std::string name) { m_name = std::move(name); }
    double getDensity() { return m_density; }
    void setDensity(double density) { m_density = density; }

    std::string to_string();
    friend std::ostream& operator <<(std::ostream& os, BaseLiquid* liquid) { liquid->toStream(os); return os; }
    friend std::istream& operator >>(std::istream& is, BaseLiquid* liquid) { liquid->setFromStream(is); return is; };
    virtual void toStream(std::ostream& os) = 0;
    virtual void setFromStream(std::istream & is) = 0;

protected:
    std::string m_name;
    double m_density = 0;
};


#endif //CPP_LAB_5_BASELIQUID_H
