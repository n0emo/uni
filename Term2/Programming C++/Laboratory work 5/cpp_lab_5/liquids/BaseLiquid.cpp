#include "BaseLiquid.h"
#include <sstream>


std::string BaseLiquid::to_string() {
    std::stringstream ss;
    ss << this;
    return ss.str();
}
