document.addEventListener("DOMContentLoaded", () => {
    console.log("[GrooveManager JS] Interface web inicializada com sucesso.");

    // Elementos do disco ilustrativo
    const discoEl = document.getElementById("disco-ilustrativo");
    const btnToggleDisco = document.getElementById("btn-toggle-disco");
    const seloAlbum = document.getElementById("selo-album");
    const seloArtista = document.getElementById("selo-artista");

    // Elementos de filtro e tabela
    const botoesFiltro = document.querySelectorAll(".btn-filter");
    const campoBusca = document.getElementById("campo-busca");
    const linhasTabela = document.querySelectorAll("#tabela-acervo tr");
    const contadorItens = document.getElementById("contador-itens");
    const valorTotalEl = document.getElementById("valor-total");
    const mensagemVazia = document.getElementById("mensagem-vazia");
    const botoesDetalhe = document.querySelectorAll(".btn-detail");

    // Elementos do cartão de ficha técnica
    const fichaFormato = document.getElementById("ficha-formato");
    const fichaTitulo = document.getElementById("ficha-titulo");
    const fichaPrensagem = document.getElementById("ficha-prensagem");
    const fichaValor = document.getElementById("ficha-valor");

    // Elementos do guia de conservação
    const botoesGrade = document.querySelectorAll(".btn-grade");
    const gradeTitulo = document.getElementById("grade-titulo");
    const gradePercent = document.getElementById("grade-percent");
    const gradeBar = document.getElementById("grade-bar");
    const gradeDescricao = document.getElementById("grade-descricao");
    const toast = document.getElementById("toast");

    let formatoAtivo = "Todos";
    let timerToast = null;

    const criteriosConservacao = {
        "Lacrado": {
            titulo: "Lacrado (Mint / Sealed)",
            percentual: "100%",
            descricao: "Mídia nunca aberta, mantendo o lacre original de fábrica e encartes intactos. Valorização máxima de referência."
        },
        "Excelente": {
            titulo: "Excelente (Near Mint / VG+)",
            percentual: "85%",
            descricao: "Mídia muito bem preservada, sem riscos audíveis ou empenamentos e com capa íntegra. Alta liquidez no acervo."
        },
        "Bom": {
            titulo: "Bom (Very Good)",
            percentual: "65%",
            descricao: "Apresenta sinais leves de manuseio ou marcas superficiais que não comprometem a reprodução sonora."
        },
        "Ruim": {
            titulo: "Ruim (Fair / Poor)",
            percentual: "30%",
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

    // Controle da animação do disco ilustrativo
    btnToggleDisco.addEventListener("click", () => {
        const girando = discoEl.classList.toggle("spinning");
        btnToggleDisco.textContent = girando ? "Pausar Rotação" : "Girar Disco";
        exibirToast(girando ? "Rotação do disco ativada" : "Rotação do disco pausada");
    });

    // Filtro por formato e busca textual
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

        mensagemVazia.classList.toggle("hidden", visiveis > 0);
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

    // Atualiza o cartão de ficha técnica e o selo do disco no topo
    botoesDetalhe.forEach((botao) => {
        botao.addEventListener("click", () => {
            const { titulo, artista, ano, formato, conservacao, prensagem, valor } = botao.dataset;

            fichaTitulo.textContent = `${titulo} — ${artista} (${ano})`;
            fichaPrensagem.textContent = prensagem;
            fichaValor.textContent = `${conservacao} • ${valor}`;

            fichaFormato.textContent = formato;
            fichaFormato.className = `tag tag-${formato.toLowerCase()}`;

            seloAlbum.textContent = titulo.toUpperCase();
            seloArtista.textContent = `${artista.toUpperCase()} • ${ano}`;

            exibirToast(`Carregado no prato: ${titulo}`);
        });
    });

    // Atualiza o guia de conservação e a barra visual
    botoesGrade.forEach((botao) => {
        botao.addEventListener("click", () => {
            botoesGrade.forEach((b) => b.classList.remove("active"));
            botao.classList.add("active");

            const chave = botao.dataset.grade;
            const info = criteriosConservacao[chave];
            gradeTitulo.textContent = info.titulo;
            gradePercent.textContent = info.percentual;
            gradeBar.style.width = info.percentual;
            gradeDescricao.textContent = info.descricao;
            exibirToast(`Critério selecionado: ${chave}`);
        });
    });
});