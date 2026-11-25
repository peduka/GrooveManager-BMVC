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
                <span class="brand-badge">BMVC I • VITRINE WEB</span>
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
        <!-- Seção 1: Propósito + Ilustração Interativa de Disco de Vinil -->
        <section id="proposito" class="hero card">
            <div class="hero-split">
                <div class="hero-text">
                    <span class="eyebrow">COLEÇÃO FÍSICA ORGANIZADA</span>
                    <h2>Preserve a história física da sua coleção musical</h2>
                    <p>
                        O <strong>GrooveManager</strong> foi projetado para colecionadores organizarem discos de
                        <strong>Vinil</strong>, <strong>CDs</strong> e <strong>Fitas Cassete (K7)</strong>,
                        registrando artista, ano de lançamento, estado de conservação e histórico de prensagem e compra.
                    </p>
                    <div class="hero-actions">
                        <a href="#catalogo" class="btn-primary">Explorar Acervo Demo</a>
                        <button type="button" id="btn-toggle-disco" class="btn-secondary">Pausar Rotação</button>
                    </div>
                </div>

                <!-- Ilustração SVG + CSS do Disco de Vinil -->
                <div class="turntable-stage" aria-label="Ilustração interativa de disco de vinil">
                    <div id="disco-ilustrativo" class="vinyl-disc spinning">
                        <div class="vinyl-grooves"></div>
                        <div class="vinyl-label">
                            <span class="label-top">GROOVEMANAGER</span>
                            <strong id="selo-album">DOOLITTLE</strong>
                            <span id="selo-artista">PIXIES • 1989</span>
                            <div class="spindle-hole"></div>
                        </div>
                    </div>
                    <div class="tonearm"></div>
                    <span class="stage-caption">Clique em "Ficha" na tabela para trocar o disco no prato</span>
                </div>
            </div>

            <!-- Cards Ilustrativos dos 3 Formatos -->
            <div class="format-grid">
                <div class="format-box">
                    <div class="format-header">
                        <svg class="format-icon" viewBox="0 0 48 48" aria-hidden="true">
                            <circle cx="24" cy="24" r="21" fill="#18181f" stroke="#e5a93c" stroke-width="2.5"/>
                            <circle cx="24" cy="24" r="14" fill="none" stroke="#3c3c4e" stroke-width="1.2"/>
                            <circle cx="24" cy="24" r="7" fill="#e5a93c"/>
                            <circle cx="24" cy="24" r="2.2" fill="#121216"/>
                        </svg>
                        <span class="tag tag-vinil">VINIL</span>
                    </div>
                    <h3>LP &amp; Compactos</h3>
                    <p>Controle de prensagem, matriz, rotação, ano e estado da capa.</p>
                </div>

                <div class="format-box">
                    <div class="format-header">
                        <svg class="format-icon" viewBox="0 0 48 48" aria-hidden="true">
                            <circle cx="24" cy="24" r="21" fill="#1e293b" stroke="#60a5fa" stroke-width="2.5"/>
                            <circle cx="24" cy="24" r="8" fill="#121216" stroke="#60a5fa" stroke-width="1.5"/>
                            <circle cx="24" cy="24" r="3" fill="#60a5fa"/>
                            <path d="M12 12 L20 20 M28 28 L36 36" stroke="#93c5fd" stroke-width="1.5" stroke-linecap="round"/>
                        </svg>
                        <span class="tag tag-cd">CD</span>
                    </div>
                    <h3>Compact Disc</h3>
                    <p>Catalogação de tiragens nacionais, importadas e encartes.</p>
                </div>

                <div class="format-box">
                    <div class="format-header">
                        <svg class="format-icon" viewBox="0 0 48 48" aria-hidden="true">
                            <rect x="4" y="11" width="40" height="26" rx="4" fill="#162822" stroke="#4ade80" stroke-width="2.5"/>
                            <circle cx="16" cy="23" r="4.5" fill="none" stroke="#4ade80" stroke-width="2"/>
                            <circle cx="32" cy="23" r="4.5" fill="none" stroke="#4ade80" stroke-width="2"/>
                            <line x1="16" y1="23" x2="32" y2="23" stroke="#4ade80" stroke-width="1.5"/>
                            <polygon points="12,37 16,31 32,31 36,37" fill="#234237"/>
                        </svg>
                        <span class="tag tag-k7">K7</span>
                    </div>
                    <h3>Fita Cassete</h3>
                    <p>Registro de fitas magnéticas, cromo/ferro e estado do estojo.</p>
                </div>
            </div>
        </section>

        <!-- Seção 2: Acervo de Demonstração + Cartão de Inspeção -->
        <section id="catalogo" class="card">
            <div class="section-header">
                <div>
                    <h2>Acervo de Demonstração</h2>
                    <p class="subtitle">Filtre por formato, pesquise por texto ou clique em <strong>Ficha</strong> para inspecionar o item.</p>
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
                            <td>
                                <button type="button" class="btn-detail"
                                    data-titulo="Doolittle"
                                    data-artista="Pixies"
                                    data-ano="1989"
                                    data-formato="Vinil"
                                    data-conservacao="Excelente"
                                    data-prensagem="22/08/1990 • Inglaterra"
                                    data-valor="R$ 180,00">Ficha</button>
                            </td>
                        </tr>
                        <tr data-formato="CD" data-valor="100.00">
                            <td><span class="tag tag-cd">CD</span></td>
                            <td>Surfer Rosa</td>
                            <td>Pixies (EUA)</td>
                            <td>1988</td>
                            <td>Bom</td>
                            <td>R$ 100,00</td>
                            <td>
                                <button type="button" class="btn-detail"
                                    data-titulo="Surfer Rosa"
                                    data-artista="Pixies"
                                    data-ano="1988"
                                    data-formato="CD"
                                    data-conservacao="Bom"
                                    data-prensagem="30/10/2001 • EUA"
                                    data-valor="R$ 100,00">Ficha</button>
                            </td>
                        </tr>
                        <tr data-formato="Vinil" data-valor="250.00">
                            <td><span class="tag tag-vinil">Vinil</span></td>
                            <td>Tim Maia</td>
                            <td>Tim Maia (Brasil)</td>
                            <td>1970</td>
                            <td>Bom</td>
                            <td>R$ 250,00</td>
                            <td>
                                <button type="button" class="btn-detail"
                                    data-titulo="Tim Maia"
                                    data-artista="Tim Maia"
                                    data-ano="1970"
                                    data-formato="Vinil"
                                    data-conservacao="Bom"
                                    data-prensagem="10/11/1970 • Brasil"
                                    data-valor="R$ 250,00">Ficha</button>
                            </td>
                        </tr>
                        <tr data-formato="K7" data-valor="60.00">
                            <td><span class="tag tag-k7">K7</span></td>
                            <td>The Dark Side of the Moon</td>
                            <td>Pink Floyd (Inglaterra)</td>
                            <td>1973</td>
                            <td>Excelente</td>
                            <td>R$ 60,00</td>
                            <td>
                                <button type="button" class="btn-detail"
                                    data-titulo="The Dark Side of the Moon"
                                    data-artista="Pink Floyd"
                                    data-ano="1973"
                                    data-formato="K7"
                                    data-conservacao="Excelente"
                                    data-prensagem="01/03/1973 • Inglaterra"
                                    data-valor="R$ 60,00">Ficha</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <p id="mensagem-vazia" class="empty-state hidden">Nenhuma mídia encontrada para o filtro selecionado.</p>

            <!-- Cartão Ilustrativo de Ficha Técnica Selecionada -->
            <div class="inspector-box">
                <div class="inspector-header">
                    <span class="inspector-badge">FICHA TÉCNICA EM DESTAQUE</span>
                    <span id="ficha-formato" class="tag tag-vinil">Vinil</span>
                </div>
                <div class="inspector-grid">
                    <div>
                        <small>Álbum &amp; Artista</small>
                        <p id="ficha-titulo">Doolittle — Pixies (1989)</p>
                    </div>
                    <div>
                        <small>Registro de Prensagem</small>
                        <p id="ficha-prensagem">22/08/1990 • Inglaterra</p>
                    </div>
                    <div>
                        <small>Conservação &amp; Valor</small>
                        <p id="ficha-valor">Excelente • R$ 180,00</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Seção 3: Guia Interativo de Conservação -->
        <section id="guia-conservacao" class="card">
            <h2>Guia Rápido de Conservação &amp; Valorização</h2>
            <p class="subtitle">Clique nos estados abaixo para visualizar o critério técnico e a barra de integridade:</p>

            <div class="grade-buttons">
                <button type="button" class="btn-grade active" data-grade="Lacrado">Lacrado</button>
                <button type="button" class="btn-grade" data-grade="Excelente">Excelente</button>
                <button type="button" class="btn-grade" data-grade="Bom">Bom</button>
                <button type="button" class="btn-grade" data-grade="Ruim">Ruim</button>
            </div>

            <div id="painel-grade" class="grade-panel">
                <div class="grade-top">
                    <h3 id="grade-titulo">Lacrado (Mint / Sealed)</h3>
                    <span id="grade-percent" class="grade-percent">100%</span>
                </div>
                <div class="progress-track">
                    <div id="grade-bar" class="progress-fill" style="width: 100%;"></div>
                </div>
                <p id="grade-descricao">Mídia nunca aberta, mantendo o lacre original de fábrica e encartes intactos. Valorização máxima de referência.</p>
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