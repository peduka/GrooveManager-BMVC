<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Área Restrita — Gerenciar Acervo | GrooveManager</title>
    <link rel="stylesheet" href="/static/css/groovemanager.css">
</head>
<body>
    <header class="topbar">
        <div class="container topbar-content">
            <div class="brand">
                <span class="brand-badge">BMVC III • ÁREA RESTRITA</span>
                <h1>GrooveManager</h1>
                <p>Painel privado de gestão do acervo</p>
            </div>
            <nav class="nav-links">
                <span class="user-pill">Olá, <strong>{{ usuario.nome }}</strong> (@{{ usuario.username }})</span>
                <a href="/">Vitrine Pública</a>
                <a href="/logout" class="nav-logout">Sair</a>
            </nav>
        </div>
    </header>

    <main class="container">
        % if aviso == 'bem_vindo':
        <div class="alert alert-success">Login realizado com sucesso! Bem-vindo(a) à área restrita, {{ usuario.nome }}.</div>
        % elif aviso == 'conta_criada':
        <div class="alert alert-success">Conta criada com sucesso! Você já está autenticado como {{ usuario.nome }}.</div>
        % elif aviso == 'cadastrado':
        <div class="alert alert-success">Mídia cadastrada com sucesso no banco de dados!</div>
        % elif aviso == 'atualizado':
        <div class="alert alert-success">Registro atualizado com sucesso!</div>
        % elif aviso == 'excluido':
        <div class="alert alert-warning">Mídia removida do acervo.</div>
        % elif aviso == 'erro':
        <div class="alert alert-danger">Preencha os campos obrigatórios (Título, Artista e Ano).</div>
        % end

        <!-- CREATE: Formulário Restrito -->
        <section id="cadastrar" class="card">
            <h2>Cadastrar Nova Mídia no Acervo</h2>
            <p class="subtitle">Acesso exclusivo para usuários autenticados. Instancia <code>Midia</code>, <code>Artista</code> e <code>RegistroCompra</code>.</p>

            <form action="/midias/criar" method="post" class="crud-form" id="form-cadastro">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="formato">Formato *</label>
                        <select id="formato" name="formato" required>
                            <option value="Vinil">Vinil</option>
                            <option value="CD">CD</option>
                            <option value="K7">K7</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="titulo">Título do Álbum *</label>
                        <input type="text" id="titulo" name="titulo" placeholder="Ex.: Racional Vol. 1" required>
                    </div>

                    <div class="form-group">
                        <label for="artista">Artista / Banda *</label>
                        <input type="text" id="artista" name="artista" placeholder="Ex.: Tim Maia" required>
                    </div>

                    <div class="form-group">
                        <label for="pais_origem">País de Origem *</label>
                        <input type="text" id="pais_origem" name="pais_origem" placeholder="Ex.: Brasil" required>
                    </div>

                    <div class="form-group">
                        <label for="ano_lancamento">Ano Lançamento *</label>
                        <input type="number" id="ano_lancamento" name="ano_lancamento" min="1900" max="2026" placeholder="1975" required>
                    </div>

                    <div class="form-group">
                        <label for="estado_conservacao">Conservação *</label>
                        <select id="estado_conservacao" name="estado_conservacao" required>
                            <option value="Lacrado">Lacrado</option>
                            <option value="Excelente" selected>Excelente</option>
                            <option value="Bom">Bom</option>
                            <option value="Ruim">Ruim</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="valor">Valor Pago (R$) *</label>
                        <input type="number" id="valor" name="valor" step="0.01" min="0" placeholder="150.00" required>
                    </div>

                    <div class="form-group">
                        <label for="data_prensagem">Data / Ano Prensagem</label>
                        <input type="text" id="data_prensagem" name="data_prensagem" placeholder="Ex.: 1975">
                    </div>

                    <div class="form-group">
                        <label for="local_prensagem">Local de Prensagem</label>
                        <input type="text" id="local_prensagem" name="local_prensagem" placeholder="Ex.: Brasil">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">Salvar Mídia no Banco</button>
                </div>
            </form>
        </section>

        <!-- READ / UPDATE / DELETE -->
        <section id="catalogo" class="card">
            <div class="section-header">
                <div>
                    <h2>Gerenciamento Completo do Acervo (CRUD)</h2>
                    <p class="subtitle">Filtre por formato, pesquise em tempo real, inspecione, edite ou exclua mídias.</p>
                </div>
                <div class="summary-pills">
                    <span class="pill">Exibindo: <strong id="contador-itens">{{ len(midias) }}</strong> mídia(s)</span>
                    <span class="pill">Valor total: <strong id="valor-total">R$ {{ f"{valor_total:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".") }}</strong></span>
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
                            <th>Ações CRUD</th>
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
                            <td class="actions-cell">
                                <button type="button" class="btn-detail"
                                    data-titulo="{{ m.titulo }}"
                                    data-artista="{{ m.artista.nome }}"
                                    data-ano="{{ m.ano_lancamento }}"
                                    data-formato="{{ m.formato }}"
                                    data-espec="{{ m.detalhe_formato() }}"
                                    data-conservacao="{{ m.estado_conservacao }}"
                                    data-prensagem="{{ m.registro_compra.data_prensagem }} • {{ m.registro_compra.local_prensagem }}"
                                    data-valor="{{ valor_fmt }}">Ficha</button>

                                <a href="/midias/editar/{{ m.id }}" class="btn-edit">Editar</a>

                                <form action="/midias/excluir/{{ m.id }}" method="post" class="inline-form form-excluir" data-titulo="{{ m.titulo }}">
                                    <button type="submit" class="btn-delete">Excluir</button>
                                </form>
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
    </main>

    <footer class="footer">
        <div class="container">
            <p>GrooveManager • Área Restrita Autenticada ({{ usuario.username }}) • BMVC III</p>
        </div>
    </footer>

    <div id="toast" class="toast" role="status" aria-live="polite"></div>

    <script src="/static/js/groovemanager.js"></script>
</body>
</html>