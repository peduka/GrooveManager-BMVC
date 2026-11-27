document.addEventListener("DOMContentLoaded", () => {
    console.log("[GrooveManager JS] BMVC III inicializado.");

    // Controle do disco ilustrativo
    const discoEl = document.getElementById("disco-ilustrativo");
    const btnToggleDisco = document.getElementById("btn-toggle-disco");
    const seloAlbum = document.getElementById("selo-album");
    const seloArtista = document.getElementById("selo-artista");

    // Filtros e tabela
    const botoesFiltro = document.querySelectorAll(".btn-filter");
    const campoBusca = document.getElementById("campo-busca");
    const linhasTabela = document.querySelectorAll("#tabela-acervo tr");
    const contadorItens = document.getElementById("contador-itens");
    const valorTotalEl = document.getElementById("valor-total");
    const mensagemVazia = document.getElementById("mensagem-vazia");
    const botoesDetalhe = document.querySelectorAll(".btn-detail");
    const formsExcluir = document.querySelectorAll(".form-excluir");

    // Cartão de ficha técnica
    const fichaFormato = document.getElementById("ficha-formato");
    const fichaTitulo = document.getElementById("ficha-titulo");
    const fichaPrensagem = document.getElementById("ficha-prensagem");
    const fichaValor = document.getElementById("ficha-valor");

    // Guia de conservação
    const botoesGrade = document.querySelectorAll(".btn-grade");
    const gradeTitulo = document.getElementById("grade-titulo");
    const gradePercent = document.getElementById("grade-percent");
    const gradeBar = document.getElementById("grade-bar");
    const gradeDescricao = document.getElementById("grade-descricao");
    const toast = document.getElementById("toast");

    // Abas e senha da tela de Login/Cadastro (BMVC III)
    const authTabs = document.querySelectorAll(".btn-auth-tab");
    const authForms = document.querySelectorAll(".auth-form");
    const togglePassBtns = document.querySelectorAll(".btn-toggle-pass");

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
        if (!toast) return;
        toast.textContent = texto;
        toast.classList.add("show");
        clearTimeout(timerToast);
        timerToast = setTimeout(() => {
            toast.classList.remove("show");
        }, 2800);
    }

    // Alternância entre abas Login e Cadastro
    authTabs.forEach((tab) => {
        tab.addEventListener("click", () => {
            authTabs.forEach((t) => t.classList.remove("active"));
            tab.classList.add("active");

            const alvo = tab.dataset.tab;
            authForms.forEach((form) => {
                form.classList.toggle("hidden", form.id !== alvo);
            });
        });
    });

    // Botão Mostrar/Ocultar senha
    togglePassBtns.forEach((btn) => {
        btn.addEventListener("click", () => {
            const input = document.getElementById(btn.dataset.target);
            if (!input) return;
            const oculto = input.type === "password";
            input.type = oculto ? "text" : "password";
            btn.textContent = oculto ? "Ocultar" : "Mostrar";
        });
    });

    if (btnToggleDisco && discoEl) {
        btnToggleDisco.addEventListener("click", () => {
            const girando = discoEl.classList.toggle("spinning");
            btnToggleDisco.textContent = girando ? "Pausar Rotação" : "Girar Disco";
            exibirToast(girando ? "Rotação do disco ativada" : "Rotação do disco pausada");
        });
    }

    function atualizarCatalogo() {
        if (!campoBusca) return;
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

        if (contadorItens) contadorItens.textContent = visiveis;
        if (valorTotalEl) {
            valorTotalEl.textContent = somaValores.toLocaleString("pt-BR", {
                style: "currency",
                currency: "BRL"
            });
        }
        if (mensagemVazia) {
            mensagemVazia.classList.toggle("hidden", visiveis > 0);
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

    if (campoBusca) {
        campoBusca.addEventListener("input", atualizarCatalogo);
    }

    botoesDetalhe.forEach((botao) => {
        botao.addEventListener("click", () => {
            const { titulo, artista, ano, formato, espec, conservacao, prensagem, valor } = botao.dataset;

            if (fichaTitulo) fichaTitulo.textContent = `${titulo} — ${artista} (${ano})`;
            if (fichaPrensagem) fichaPrensagem.textContent = `${espec} • ${prensagem}`;
            if (fichaValor) fichaValor.textContent = `${conservacao} • ${valor}`;

            if (fichaFormato) {
                fichaFormato.textContent = formato;
                fichaFormato.className = `tag tag-${formato.toLowerCase()}`;
            }

            if (seloAlbum) seloAlbum.textContent = titulo.toUpperCase();
            if (seloArtista) seloArtista.textContent = `${artista.toUpperCase()} • ${ano}`;

            exibirToast(`Carregado no prato: ${titulo}`);
        });
    });

    formsExcluir.forEach((form) => {
        form.addEventListener("submit", (event) => {
            const titulo = form.dataset.titulo || "esta mídia";
            if (!confirm(`Tem certeza que deseja excluir "${titulo}" do acervo?`)) {
                event.preventDefault();
            }
        });
    });

    botoesGrade.forEach((botao) => {
        botao.addEventListener("click", () => {
            botoesGrade.forEach((b) => b.classList.remove("active"));
            botao.classList.add("active");

            const chave = botao.dataset.grade;
            const info = criteriosConservacao[chave];
            if (!info) return;
            gradeTitulo.textContent = info.titulo;
            gradePercent.textContent = info.percentual;
            gradeBar.style.width = info.percentual;
            gradeDescricao.textContent = info.descricao;
            exibirToast(`Critério selecionado: ${chave}`);
        });
    });
});