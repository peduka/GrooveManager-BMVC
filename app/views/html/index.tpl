<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrooveManager Web — Catálogo de Mídias Físicas</title>
    <link rel="stylesheet" href="/static/css/groovemanager.css">
</head>
<body>
    <header class="topbar">
        <div class="container topbar-content">
            <div class="brand">
                <span class="brand-badge">BMVC I • WEB</span>
                <h1>GrooveManager</h1>
                <p>Gestão e catalogação de acervos de Vinil, CD e Fita Cassete</p>
            </div>
            <nav class="nav-links">
                <a href="#proposito">Propósito</a>
                <a href="#catalogo">Catálogo</a>
                <a href="#guia-conservacao">Conservação</a>
            </nav>
        </div>
    </header>

    <main class="container">
        <section id="proposito" class="hero card">
            <div class="hero-text">
                <h2>Preserve a história física da sua coleção musical</h2>
                <p>
                    O <strong>GrooveManager</strong> nasceu para ajudar colecionadores a organizar discos de
                    <strong>Vinil</strong>, <strong>CDs</strong> e <strong>Fitas Cassete (K7)</strong>,
                    registrando artista, ano de lançamento, estado de conservação e histórico de prensagem e compra.
                </p>
            </div>
            <div class="format-grid">
                <div class="format-box">
                    <span class="tag tag-vinil">VINIL</span>
                    <h3>LP &amp; Compactos</h3>
                    <p>Controle de prensagem, matriz, ano e conservação.</p>
                </div>
                <div class="format-box">
                    <span class="tag tag-cd">CD</span>
                    <h3>Compact Disc</h3>
                    <p>Catalogação de edições nacionais e importadas.</p>
                </div>
                <div class="format-box">
                    <span class="tag tag-k7">K7</span>
                    <h3>Fita Cassete</h3>
                    <p>Registro de fitas magnéticas e estado do estojo.</p>
                </div>
            </div>
        </section>

        <section id="catalogo" class="card">
            <div class="section-header">
                <div>
                    <h2>Acervo de Demonstração</h2>
                    <p class="subtitle">Filtre por formato ou pesquise por álbum e artista usando JavaScript em tempo real.</p>
                </div>
                <div class="summary-pills">
                    <span class="pill">Exibindo: <strong id="contador-itens">4</strong> mídia(s)</span>
                    <span class="pill">Valor estimado: <strong id="valor-total">R$ 590,00</strong></span>
                </div>
            </div>

            <div class="controls-bar">
                <div class="filter-buttons" role="group" aria-label="Filtrar por formato">
                    <button type="button" class="btn-filter active" data-formato="Todos">Todos</button>
                    <button type="button" class="btn-filter" data-formato="Vinil">Vinil</button>
                    <button type="button" class="btn-filter" data-formato="CD">CD</button>
                    <button type="button" class="btn-filter" data-formato="K7">K7</button>
                </div>
                <input
                    type="text"
                    id="campo-busca"
                    class="search-input"
                    placeholder="Buscar por título ou artista..."
                    autocomplete="off"
                >
            </div>

            <div class="table-wrapper">
                <table class="catalog-table">
                    <thead>
                        <tr>
                            <th>Formato</th>
                            <th>Título do Álbum</th>
                            <th>Artista</th>
                            <th>Ano</th>
                            <th>Conservação</th>
                            <th>Valor Pago</th>
                            <th>Ação</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-acervo">
                        <tr data-formato="Vinil" data-valor="180.00">
                            <td><span class="tag tag-vinil">Vinil</span></td>
                            <td>Doolittle</td>
                            <td>Pixies (EUA)</td>
                            <td>1989</td>
                            <td>Excelente</td>
                            <td>R$ 180,00</td>
                            <td><button type="button" class="btn-detail" data-album="Doolittle — Pixies (Prensagem Inglaterra, 1990)">Ficha</button></td>
                        </tr>
                        <tr data-formato="CD" data-valor="100.00">
                            <td><span class="tag tag-cd">CD</span></td>
                            <td>Surfer Rosa</td>
                            <td>Pixies (EUA)</td>
                            <td>1988</td>
                            <td>Bom</td>
                            <td>R$ 100,00</td>
                            <td><button type="button" class="btn-detail" data-album="Surfer Rosa — Pixies (Prensagem EUA, 2001)">Ficha</button></td>
                        </tr>
                        <tr data-formato="Vinil" data-valor="250.00">
                            <td><span class="tag tag-vinil">Vinil</span></td>
                            <td>Tim Maia</td>
                            <td>Tim Maia (Brasil)</td>
                            <td>1970</td>
                            <td>Bom</td>
                            <td>R$ 250,00</td>
                            <td><button type="button" class="btn-detail" data-album="Tim Maia — Tim Maia (Prensagem Brasil, 1970)">Ficha</button></td>
                        </tr>
                        <tr data-formato="K7" data-valor="60.00">
                            <td><span class="tag tag-k7">K7</span></td>
                            <td>The Dark Side of the Moon</td>
                            <td>Pink Floyd (Inglaterra)</td>
                            <td>1973</td>
                            <td>Excelente</td>
                            <td>R$ 60,00</td>
                            <td><button type="button" class="btn-detail" data-album="The Dark Side of the Moon — Pink Floyd (Prensagem Inglaterra, 1973)">Ficha</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <p id="mensagem-vazia" class="empty-state hidden">Nenhuma mídia encontrada para o filtro selecionado.</p>
        </section>

        <section id="guia-conservacao" class="card">
            <h2>Guia Rápido de Conservação &amp; Valorização</h2>
            <p class="subtitle">Selecione um estado de conservação para ver o critério de avaliação do catálogo:</p>

            <div class="grade-buttons">
                <button type="button" class="btn-grade active" data-grade="Lacrado">Lacrado</button>
                <button type="button" class="btn-grade" data-grade="Excelente">Excelente</button>
                <button type="button" class="btn-grade" data-grade="Bom">Bom</button>
                <button type="button" class="btn-grade" data-grade="Ruim">Ruim</button>
            </div>

            <div id="painel-grade" class="grade-panel">
                <h3 id="grade-titulo">Lacrado (Mint / Sealed)</h3>
                <p id="grade-descricao">Mídia nunca aberta, mantendo o lacre original de fábrica e encartes intactos. Valorização máxima de referência (100%).</p>
            </div>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <p>GrooveManager • Projeto de Orientação a Objetos (UnB FGA) • Arquitetura BMVC (Bottle + MVC)</p>
        </div>
    </footer>

    <div id="toast" class="toast" role="status" aria-live="polite"></div>

    <script src="/static/js/groovemanager.js"></script>
</body>
</html>