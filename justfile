[private]
@default:
    just --list

generate-recipes:
    python3 -m scripts.recipes

import? "reports/recipes.just"
