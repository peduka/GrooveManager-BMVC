document.addEventListener("DOMContentLoaded", () => {
    console.log("[GrooveManager JS] Interface web inicializada com sucesso.");

    const botoesFiltro = document.querySelectorAll(".btn-filter");
    const campoBusca = document.getElementById("campo-busca");
    const linhasTabela = document.querySelectorAll("#tabela-acervo tr");
    const contadorItens = document.getElementById("contador-itens");
    const valorTotalEl = document.getElementById("valor-total");
    const mensagemVazia = document.getElementById("mensagem-vazia");
    const botoesDetalhe = document.querySelectorAll(".btn-detail");

    const botoesGrade = document.querySelectorAll(".btn-grade");
    const gradeTitulo = document.getElementById("grade-titulo");
    const gradeDescricao = document.getElementById("grade-descricao");
    const toast = document.getElementById("toast");

    let formatoAtivo = "Todos";
    let timerToast = null;

    const criteriosConservacao = {
        "Lacrado": {
            titulo: "Lacrado (Mint / Sealed)",
            descricao: "Mídia nunca aberta, mantendo o lacre original de fábrica e encartes intactos. Valorização máxima de referência (100%)."
        },
        "Excelente": {
            titulo: "Excelente (Near Mint / VG+)",
            descricao: "Mídia muito bem preservada, sem riscos audíveis ou empenamentos e com capa íntegra. Alta liquidez no acervo."
        },
        "Bom": {
            titulo: "Bom (Very Good)",
            descricao: "Apresenta sinais leves de manuseio ou marcas superficiais que não comprometem a reprodução sonora."
        },
        "Ruim": {
            titulo: "Ruim (Fair / Poor)",
            descricao: "Desgaste acentuado na mídia ou capa, indicado apenas para restauração ou reposição de encarte."
        }
    };

    function exibirToast(texto) {
        toast.textContent = texto;
        toast.classList.add("show");
        clearTimeout(timerToast);
        timerToast = setTimeout(() => {
            toast.classList.remove("show");
        }, 2800);
    }

    function atualizarCatalogo() {
        const termo = campoBusca.value.trim().toLowerCase();
        let visiveis = 0;
        let somaValores = 0;

        linhasTabela.forEach((linha) => {
            const formatoLinha = linha.dataset.formato;
            const valorLinha = parseFloat(linha.dataset.valor) || 0;
            const textoLinha = linha.textContent.toLowerCase();

            const bateFormato = formatoAtivo === "Todos" || formatoLinha === formatoAtivo;
            const bateBusca = termo === "" || textoLinha.includes(termo);

            if (bateFormato && bateBusca) {
                linha.classList.remove("hidden");
                visiveis += 1;
                somaValores += valorLinha;
            } else {
                linha.classList.add("hidden");
            }
        });

        contadorItens.textContent = visiveis;
        valorTotalEl.textContent = somaValores.toLocaleString("pt-BR", {
            style: "currency",
            currency: "BRL"
        });

        if (visiveis === 0) {
            mensagemVazia.classList.remove("hidden");
        } else {
            mensagemVazia.classList.add("hidden");
        }
    }

    botoesFiltro.forEach((botao) => {
        botao.addEventListener("click", () => {
            botoesFiltro.forEach((b) => b.classList.remove("active"));
            botao.classList.add("active");
            formatoAtivo = botao.dataset.formato;
            atualizarCatalogo();
            exibirToast(`Filtro aplicado: ${formatoAtivo}`);
        });
    });

    campoBusca.addEventListener("input", atualizarCatalogo);

    botoesDetalhe.forEach((botao) => {
        botao.addEventListener("click", () => {
            const infoAlbum = botao.dataset.album;
            exibirToast(`Ficha técnica: ${infoAlbum}`);
        });
    });

    botoesGrade.forEach((botao) => {
        botao.addEventListener("click", () => {
            botoesGrade.forEach((b) => b.classList.remove("active"));
            botao.classList.add("active");

            const chave = botao.dataset.grade;
            const info = criteriosConservacao[chave];
            gradeTitulo.textContent = info.titulo;
            gradeDescricao.textContent = info.descricao;
            exibirToast(`Critério selecionado: ${chave}`);
        });
    });
});