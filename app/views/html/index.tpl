<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrooveManager Web — Vitrine Pública do Acervo</title>
    <link rel="stylesheet" href="/static/css/groovemanager.css">
</head>
<body>
    <header class="topbar">
        <div class="container topbar-content">
            <div class="brand">
                <span class="brand-badge">BMVC III • VITRINE PÚBLICA</span>
                <h1>GrooveManager</h1>
                <p>Gestão e catalogação de acervos de Vinil, CD e Fita Cassete</p>
            </div>
            <nav class="nav-links">
                <a href="#catalogo">Acervo Público</a>
                <a href="#guia-conservacao">Conservação</a>
                % if usuario:
                <a href="/acervo" class="nav-cta">Área Restrita ({{ usuario.username }})</a>
                <a href="/logout" class="nav-logout">Sair</a>
                % else:
                <a href="/login" class="nav-cta">Entrar / Gerenciar</a>
                % end
            </nav>
        </div>
    </header>

    <main class="container">
        <!-- Seção 1: Propósito + Vitrola Ilustrativa -->
        <section id="proposito" class="hero card">
            <div class="hero-split">
                <div class="hero-text">
                    <span class="eyebrow">ACESSO PÚBLICO • SOMENTE LEITURA</span>
                    <h2>Preserve a história física da sua coleção musical</h2>
                    <p>
                        O <strong>GrooveManager</strong> organiza discos de <strong>Vinil</strong>, <strong>CDs</strong> e
                        <strong>Fitas Cassete (K7)</strong> usando modelos orientados a objetos em Python.
                        Explore a vitrine pública abaixo ou faça login para acessar a <strong>área restrita de gerenciamento</strong>.
                    </p>
                    <div class="hero-actions">
                        % if usuario:
                        <a href="/acervo" class="btn-primary">Ir para Meu Acervo Restrito</a>
                        % else:
                        <a href="/login" class="btn-primary">Fazer Login para Editar Acervo</a>
                        % end
                        <button type="button" id="btn-toggle-disco" class="btn-secondary">Pausar Rotação</button>
                    </div>
                </div>

                <div class="turntable-stage" aria-label="Ilustração interativa de disco de vinil">
                    <div id="disco-ilustrativo" class="vinyl-disc spinning">
                        <div class="vinyl-grooves"></div>
                        <div class="vinyl-label">
                            <span class="label-top">GROOVEMANAGER</span>
                            <strong id="selo-album">{{ midias[0].titulo.upper() if midias else 'SEM DISCO' }}</strong>
                            <span id="selo-artista">{{ f"{midias[0].artista.nome.upper()} • {midias[0].ano_lancamento}" if midias else 'CATÁLOGO VAZIO' }}</span>
                            <div class="spindle-hole"></div>
                        </div>
                    </div>
                    <div class="tonearm"></div>
                    <span class="stage-caption">Clique em "Ficha" na tabela para trocar o disco no prato</span>
                </div>
            </div>

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

        <!-- Seção 2: Vitrine Somente Leitura -->
        <section id="catalogo" class="card">
            <div class="section-header">
                <div>
                    <h2>Vitrine Pública do Acervo</h2>
                    <p class="subtitle">Consulta aberta a visitantes. Para cadastrar, editar ou excluir mídias, acesse a <a href="/login" style="color: var(--accent);">Área Restrita</a>.</p>
                </div>
                <div class="summary-pills">
                    <span class="pill">Exibindo: <strong id="contador-itens">{{ len(midias) }}</strong> mídia(s)</span>
                    <span class="pill">Valor estimado: <strong id="valor-total">R$ {{ f"{valor_total:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".") }}</strong></span>
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
                            <th>Valor Estimado</th>
                            <th>Inspeção</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-acervo">
                        % for m in midias:
                        % valor_fmt = f"R$ {m.registro_compra.valor:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")
                        <tr data-formato="{{ m.formato }}" data-valor="{{ f'{m.registro_compra.valor:.2f}' }}">
                            <td><span class="tag tag-{{ m.formato.lower() }}">{{ m.formato }}</span></td>
                            <td>{{ m.titulo }}</td>
                            <td>{{ m.artista.nome }} ({{ m.artista.pais_origem }})</td>
                            <td>{{ m.ano_lancamento }}</td>
                            <td>{{ m.estado_conservacao }}</td>
                            <td>{{ valor_fmt }}</td>
                            <td>
                                <button type="button" class="btn-detail"
                                    data-titulo="{{ m.titulo }}"
                                    data-artista="{{ m.artista.nome }}"
                                    data-ano="{{ m.ano_lancamento }}"
                                    data-formato="{{ m.formato }}"
                                    data-espec="{{ m.detalhe_formato() }}"
                                    data-conservacao="{{ m.estado_conservacao }}"
                                    data-prensagem="{{ m.registro_compra.data_prensagem }} • {{ m.registro_compra.local_prensagem }}"
                                    data-valor="{{ valor_fmt }}">Ficha</button>
                            </td>
                        </tr>
                        % end
                    </tbody>
                </table>
            </div>

            <p id="mensagem-vazia" class="empty-state {{ 'hidden' if midias else '' }}">Nenhuma mídia encontrada.</p>

            % if midias:
            % primeira = midias[0]
            % primeira_valor = f"R$ {primeira.registro_compra.valor:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")
            <div class="inspector-box">
                <div class="inspector-header">
                    <span class="inspector-badge">FICHA TÉCNICA EM DESTAQUE</span>
                    <span id="ficha-formato" class="tag tag-{{ primeira.formato.lower() }}">{{ primeira.formato }}</span>
                </div>
                <div class="inspector-grid">
                    <div>
                        <small>Álbum &amp; Artista</small>
                        <p id="ficha-titulo">{{ primeira.titulo }} — {{ primeira.artista.nome }} ({{ primeira.ano_lancamento }})</p>
                    </div>
                    <div>
                        <small>Especificação &amp; Prensagem</small>
                        <p id="ficha-prensagem">{{ primeira.detalhe_formato() }} • {{ primeira.registro_compra.local_prensagem }} ({{ primeira.registro_compra.data_prensagem }})</p>
                    </div>
                    <div>
                        <small>Conservação &amp; Valor</small>
                        <p id="ficha-valor">{{ primeira.estado_conservacao }} • {{ primeira_valor }}</p>
                    </div>
                </div>
            </div>
            % end
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
            <p>GrooveManager • Projeto de Orientação a Objetos (UnB FGA) • Arquitetura BMVC III</p>
        </div>
    </footer>

    <div id="toast" class="toast" role="status" aria-live="polite"></div>

    <script src="/static/js/groovemanager.js"></script>
</body>
</html>