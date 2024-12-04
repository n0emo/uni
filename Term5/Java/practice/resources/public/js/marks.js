const kindSelect = document.querySelector("#mark-kind");

const goToKindPage = () => {
    const kind = kindSelect.selectedOptions[0].value;
    const result = window.location.search.replace(/&?kind=[a-z]+/, "");
    window.location.search = result + `&kind=${kind}`;
};

kindSelect.addEventListener("change", goToKindPage);
