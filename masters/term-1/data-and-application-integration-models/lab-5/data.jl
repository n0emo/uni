# Модельные исходные данные. Столбцы матрицы рангов соответствуют экспертам.
const EXPERTS = ("Э1", "Э2", "Э3", "Э4", "Э5")
const CRITERIA = (
    "Экономия рабочего времени за год, ч",
    "Снижение риска ошибок, баллы",
    "Сокращение срока выполнения заказа, ч",
    "Стоимость внедрения, тыс. тенге",
)
const CRITERION_RANKS = [
    1 1 1 1 1
    2 2 2 3 4
    3 3 3 2 2
    4 4 4 4 3
]
const MINIMIZE = (false, false, false, true)

const PROJECTS = (
    "Учёт комплектации, съёмки и отправки видео",
    "Школьный портал выбора фотографий и утверждения макета",
    "Каталог дизайнов для частных клиентов",
)

const ORDERS_PER_YEAR = 1200
const ORDER_SHARE = (0.75, 0.20, 0.05)
# Для частных заказов библиотечные дизайны составляют 70%, индивидуальные — 30%.
const ELIGIBLE_SHARE = (1.00, 1.00, 0.70)
const SAVED_MINUTES_PER_ORDER = (6, 25, 15)

function project_values()
    annual_orders = ORDERS_PER_YEAR .* ORDER_SHARE
    eligible_orders = annual_orders .* ELIGIBLE_SHARE
    saved_hours = eligible_orders .* SAVED_MINUTES_PER_ORDER ./ 60

    # Остальные оценки относятся к проектам в порядке PROJECTS. 1 балл означает
    # минимальное снижение риска ошибки, 5 — максимальное.
    return [
        saved_hours[1] saved_hours[2] saved_hours[3]
        3              5              2
        8              24             12
        160            280            75
    ]
end
