
[private]
@default:
    just --list

generate-recipes:
    python3 scripts/generate_recipes.py

import? "reports/recipes.just"
